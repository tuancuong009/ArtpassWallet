//
//  ArchivedAmpCell.swift
//  ArtPassID
//
//  Created by QTS Coder on 6/10/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit

class ArchivedAmpCell: UITableViewCell {
    var tapReportSeller: (() ->())?
    var tapReportBuyer: (() ->())?
    @IBOutlet weak var lblSellerUserName: UILabel!
    @IBOutlet weak var lblSellerName: UILabel!
    @IBOutlet weak var imgCell: UIImageView!
    @IBOutlet weak var lblBuyerUserName: UILabel!
    @IBOutlet weak var lblBuyerName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func doSeller(_ sender: Any) {
        self.tapReportSeller?()
    }
    @IBAction func doBuyer(_ sender: Any) {
        self.tapReportBuyer?()
    }
}
