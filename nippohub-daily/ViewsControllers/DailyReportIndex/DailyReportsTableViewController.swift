//
//  DailyReportIndexViewController.swift
//  nippohub-daily
//
//  Created by うさきち on 2019/03/26.
//  Copyright © 2019 うーぴょん. All rights reserved.
//

import UIKit
import Firebase
import XLPagerTabStrip

final class DailyReportsTableViewController: UITableViewController {
    private var dailyReports: [DailyReport] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentUser = AccountRepository.instance.currentUser
        let dailyReportRepository = DailyReportRepository.instance

        tableView.register(UINib(nibName: "DailyReportListItem", bundle: nil), forCellReuseIdentifier: "DailyReportListItem")

        if let user = currentUser {
            dailyReportRepository.fetch(user: user) { [unowned self] in
                self.dailyReports = $0
                self.tableView.reloadData()
            }
        }
    }
    
    // 日報に更新があった時日報一覧を最新にする
    func updateDailyReports(dailyReport: DailyReport) {
        let index = dailyReports.firstIndex { $0.id == dailyReport.id }
        
        if let index = index {
            dailyReports[index] = dailyReport
            dailyReports.sort { $0.date >= $1.date }
        } else {
            let indexToInsert = dailyReports.firstIndex { $0.date <= dailyReport.date }
            
            if let indexToInsert = indexToInsert {
                dailyReports.insert(dailyReport, at: indexToInsert)
            } else {
                dailyReports.append(dailyReport)
            }
        }
        
        tableView.reloadData()
    }

    @objc @IBAction func transitToNewDailyReport() {
        let viewController = DailyReportNewViewController.instantiate()

        navigationController?.pushViewController(viewController, animated: true)
    }

    @IBAction func transitToSettings() {
        let viewController = SettingViewController.instantiate()

        navigationController?.pushViewController(viewController, animated: true)
    }
    
    static func instantiate() -> DailyReportIndexViewController {
        return UIStoryboard(name: "DailyReportIndex", bundle: nil).instantiateInitialViewController() as! DailyReportIndexViewController
    }
}

extension DailyReportsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyReports.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailyReportListItem") as! DailyReportListItem
        let dailyReport = dailyReports[indexPath.row]
        
        cell.title = "\(DateConverter.converter.toString(from: dailyReport.date)) \(dailyReport.title)" // TODO: Date追加
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = DailyReportShowViewController.instantiate(dailyReport: dailyReports[indexPath.row])

        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension DailyReportsTableViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "My Child title")
    }
}
