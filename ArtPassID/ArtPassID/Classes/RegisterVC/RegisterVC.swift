//
//  RegisterVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 2/14/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {

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

    @IBAction func doPrivatePerson(_ sender: Any) {
        APP_DELEGATE.userObj.utype = UTYPE_USER.PATRON
       let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "RegisterFinalVC") as! RegisterFinalVC
       self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func doBusiness(_ sender: Any) {
        APP_DELEGATE.userObj.utype = UTYPE_USER.BUSINESS
        let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "BusinessStep1VC") as! BusinessStep1VC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
