//
//  MyReportCell.swift
//  ArtPassID
//
//  Created by QTS Coder on 3/3/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit

class MyReportCell: UITableViewCell {
    var tapViewReport: (() ->())?
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnReview: UIButton!
    @IBOutlet weak var bgReview: UIViewX!
    @IBOutlet weak var subNotification: UIViewX!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func doReview(_ sender: Any) {
        self.tapViewReport?()
    }
    
}
