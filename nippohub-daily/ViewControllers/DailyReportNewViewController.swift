//
//  DailyReportNewViewController.swift
//  nippohub-daily
//
//  Created by うさきち on 2019/03/30.
//  Copyright © 2019 うーぴょん. All rights reserved.
//

import UIKit
import Firebase

class DailyReportNewViewController: UIViewController {
    @IBOutlet var formDate: UIDatePicker!
    @IBOutlet var formTitle: UITextField!
    @IBOutlet var formContent: UITextView!
    
    @IBAction
    func sendDailyReport() {
        let date = DateConverter.converter.toString(from: formDate.date)
        let title = formTitle.text!
        let content = formContent.text!
        let currentUser = Auth.auth().currentUser // TODO: 確実に取得できていることを担保する
        
        if let user = currentUser {
            let ref: DatabaseReference! = Database.database().reference()

            ref.child("daily_reports").childByAutoId().setValue([
                "date": date,
                "title": title,
                "content": content,
                "userId": user.uid,
                "createdAt": Int(Date().timeIntervalSince1970 * 1000)
            ])
        }
    }
}