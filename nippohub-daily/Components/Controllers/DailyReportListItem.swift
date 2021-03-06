//
//  DailyReportListItem.swift
//  nippohub-daily
//
//  Created by うさきち on 2019/03/27.
//  Copyright © 2019 うーぴょん. All rights reserved.
//

import UIKit

final class DailyReportListItem: UITableViewCell {
    @IBOutlet private weak var labelTitle: UILabel!
    var title: String? {
        didSet {
            self.labelTitle.text = title
        }
    }
}
