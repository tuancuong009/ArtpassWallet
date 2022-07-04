//
//  RequestConnectionCell.swift
//  ArtPassID
//
//  Created by QTS Coder on 4/2/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit

class RequestConnectionCell: UITableViewCell {

    @IBOutlet weak var imgCell: UIImageViewX!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblFullName: UILabel!
    var tapAcceptConnect: (() ->())?
    var tapViewConnect: (() ->())?
    var tapDelineConnect: (() ->())?
    @IBOutlet weak var btnDecline: UIButton!
    @IBOutlet weak var lblRequest: UILabel!
    @IBOutlet weak var viewNotification: UIViewX!
    @IBOutlet weak var btnAccessConnect: UIButton!
    @IBOutlet weak var viewBGDecline: UIViewX!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func doAcceptConnect(_ sender: Any) {
        self.tapAcceptConnect?()
    }
    @IBAction func doViewConnectReport(_ sender: Any) {
        self.tapViewConnect?()
    }
    @IBAction func doDeclineConnect(_ sender: Any) {
        self.tapDelineConnect?()
    }
}
