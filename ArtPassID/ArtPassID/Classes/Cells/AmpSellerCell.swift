//
//  AmpSellerCell.swift
//  ArtPassID
//
//  Created by QTS Coder on 6/9/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit

class AmpSellerCell: UITableViewCell {

    var tapAddProspect: (() ->())?
    var tapViewProspect: (() ->())?
    var tapViewSeller: (() ->())?
    @IBOutlet weak var imgCell: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var viewBGAdd: UIViewX!
    @IBOutlet weak var viewGBView: UIViewX!
    @IBOutlet weak var viewNotification: UIViewX!
    @IBOutlet weak var lblNumberActivity: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func doViewSpospect(_ sender: Any) {
        self.tapViewProspect?()
    }
    @IBAction func doAddProspect(_ sender: Any) {
        self.tapAddProspect?()
    }
    @IBAction func doViewSeller(_ sender: Any) {
        self.tapViewSeller?()
    }
}
