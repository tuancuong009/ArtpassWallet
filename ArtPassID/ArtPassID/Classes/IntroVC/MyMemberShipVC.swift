//
//  MyMemberShipVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 10/6/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit
import SwiftyStoreKit
class MyMemberShipVC: UIViewController {

    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblEndDate: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.getInfoInApp()
        if let start = UserDefaults.standard.value(forKey: dateStartInApp) as? String{
            self.lblStartDate.text = "Start Date: " + start
        }
        if let end = UserDefaults.standard.value(forKey: dateEndInApp) as? String{
            self.lblEndDate.text = "End Date: " + end
        }
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

   
    
    
    @IBAction func doBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
