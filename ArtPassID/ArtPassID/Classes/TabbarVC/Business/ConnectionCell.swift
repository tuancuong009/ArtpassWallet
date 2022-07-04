//
//  ConnectionCell.swift
//  ArtPassID
//
//  Created by QTS Coder on 4/2/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit

class ConnectionCell: UITableViewCell {

    @IBOutlet weak var imgAvatar: UIImageViewX!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var viewCCDReport: UIView!
    @IBOutlet weak var viewNotification: UIViewX!
    var tapViewConnect: (() ->())?
    var tapRemoveConnect: (() ->())?
    var tapDeclineCDDReport: (() ->())?
    var tapCCDReport: (() ->())?
    var tapRevoke: (() ->())?
    var tapViewCDDReport: (() ->())?
    var tapAccept: (() ->())?
    var tapInspection: (() ->())?
    @IBOutlet weak var viewAccept: UIView!
    @IBOutlet weak var viewDieclineReport: UIView!
    @IBOutlet weak var btnCDD: UIButton!
    @IBOutlet weak var bgCDD: UIViewX!
    @IBOutlet weak var viewRevoke: UIView!
    @IBOutlet weak var viewCDDReport: UIView!
    @IBOutlet weak var spaceViewArt: UIView!
    @IBOutlet weak var spaceViewCDD: UIView!
    @IBOutlet weak var spaceDeline: UIView!
    @IBOutlet weak var spaceAcept: UIView!
    @IBOutlet weak var spaceRequestCDD: UIView!
    @IBOutlet weak var spaceRemove: UIView!
    @IBOutlet weak var viewArt: UIViewX!
    @IBOutlet weak var viewInspection: UIView!
    @IBOutlet weak var spaceInpec: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func doViewConnect(_ sender: Any) {
        self.tapViewConnect?()
    }
    @IBAction func doRemoveConnect(_ sender: Any) {
        self.tapRemoveConnect?()
    }
    @IBAction func doCCDReport(_ sender: Any) {
        self.tapCCDReport?()
    }
    @IBAction func doDeliceShareCDD(_ sender: Any) {
        self.tapDeclineCDDReport?()
    }
    @IBAction func doRevoke(_ sender: Any) {
        self.tapRevoke?()
    }
    @IBAction func doAccept(_ sender: Any) {
        self.tapAccept?()
        
    }
    @IBAction func doViewCDDReport(_ sender: Any) {
        self.tapViewCDDReport?()
    }
    @IBAction func doInspection(_ sender: Any) {
        self.tapInspection?()
    }
}
