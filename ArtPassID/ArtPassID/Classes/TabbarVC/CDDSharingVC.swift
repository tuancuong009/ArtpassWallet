//
//  CDDSharingVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 02/11/2021.
//  Copyright © 2021 QTS Coder. All rights reserved.
//

import UIKit
import SwiftyJSON
class CDDSharingVC: UIViewController {
    var isShareCDD = false
    @IBOutlet weak var btnSwith: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isShareCDD = APP_DELEGATE.profileObj?.is_sharing_ccd ?? false
        
        self.btnSwith.isOn = isShareCDD
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

    @IBAction func changeSwitch(_ sender: Any) {
        self.callAPIUpdateCDD()
    }
    @IBAction func doBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func callAPIUpdateCDD(){
        
        let param = ["is_sharing_cdd": self.btnSwith.isOn]
        APP_DELEGATE.profileObj?.is_sharing_ccd = self.btnSwith.isOn
        ApiHelper.shared.updateShareCDDReport(param) { success, errer in
            print(success)
            
        }
    }
    
    
}
