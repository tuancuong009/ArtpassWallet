//
//  ActivityReportCell.swift
//  ArtPassID
//
//  Created by QTS Coder on 3/2/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit

class ActivityReportCell: UITableViewCell {
    var tapViewProfile: (() ->())?
    var tapAccept: (() ->())?
    var tapDecine: (() ->())?
    @IBOutlet weak var btnReview: UIButton!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var imgCell: UIImageView!
    @IBOutlet weak var widthPercent: NSLayoutConstraint!
    @IBOutlet weak var lblPercent: UILabel!
    @IBOutlet weak var subBG: UIViewX!
    @IBOutlet weak var viewAction: UIViewX!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnDecine: UIButton!
    @IBOutlet weak var viewProfile: UIView!
    @IBOutlet weak var viewNotification: UIViewX!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var lblTransation: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func doDecine(_ sender: Any) {
        self.tapDecine?()
    }
    
    @IBAction func doAccept(_ sender: Any) {
        self.tapAccept?()
    }
    @IBAction func doReview(_ sender: Any) {
        self.tapViewProfile?()
    }
}
