//
//  ProfileVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 4/19/19.
//  Copyright © 2019 QTS Coder. All rights reserved.
//

import UIKit
import LGSideMenuController
class ProfileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func doMenu(_ sender: Any) {
        sideMenuController?.showRightViewAnimated()
    }
}
