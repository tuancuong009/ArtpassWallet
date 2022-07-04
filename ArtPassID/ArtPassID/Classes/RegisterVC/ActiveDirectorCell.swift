//
//  ActiveDirectorCell.swift
//  ArtPassID
//
//  Created by QTS Coder on 5/4/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit

class ActiveDirectorCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblBirthday: UILabel!
    @IBOutlet weak var lblNational: UILabel!
     var tapUBO: (() ->())?
    @IBOutlet weak var subUBO: UIView!
    @IBOutlet weak var heightUBO: NSLayoutConstraint!
    @IBOutlet weak var spaceTopUBO: NSLayoutConstraint!
    @IBOutlet weak var imgTick: UIImageView!
    @IBOutlet weak var lblIamUbo: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @IBAction func doIBO(_ sender: Any) {
        self.tapUBO?()
    }
}
