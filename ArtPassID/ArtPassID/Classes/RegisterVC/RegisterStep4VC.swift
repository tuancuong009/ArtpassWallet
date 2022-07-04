//
//  RegisterStep4VC.swift
//  ArtPassID
//
//  Created by QTS Coder on 4/19/19.
//  Copyright © 2019 QTS Coder. All rights reserved.
//

import UIKit

class RegisterStep4VC: UIViewController {

    @IBOutlet weak var txfNumber1: UITextField!
    @IBOutlet weak var txfNumber2: UITextField!
    @IBOutlet weak var txfNumber3: UITextField!
    @IBOutlet weak var txfNumber4: UITextField!
    @IBOutlet weak var txfNumber5: UITextField!
    @IBOutlet weak var txfNumber6: UITextField!
    @IBOutlet weak var heightNumber1: NSLayoutConstraint!
    @IBOutlet weak var spaceTop: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func doKeyPad(_ sender: Any) {
        if let btn = sender as? UIButton
        {
            let value = "\(btn.tag)"
            if (txfNumber1.text?.isEmpty)!
            {
                txfNumber1.text = value
            }
            else if (txfNumber2.text?.isEmpty)!
            {
                txfNumber2.text = value
            }
            else if (txfNumber3.text?.isEmpty)!
            {
                txfNumber3.text = value
            }
            else if (txfNumber4.text?.isEmpty)!
            {
                txfNumber4.text = value
            }
            else if (txfNumber5.text?.isEmpty)!
            {
                txfNumber5.text = value
            }
            else if (txfNumber6.text?.isEmpty)!
            {
                txfNumber6.text = value
               APP_DELEGATE.userObj.password = txfNumber1.text!.trim() +  txfNumber2.text!.trim() + txfNumber3.text!.trim() + txfNumber4.text!.trim() + txfNumber5.text!.trim() + txfNumber6.text!.trim()
               let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterInforVC") as! RegisterInforVC
               self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func updateUI()
    {
        if UIScreen.main.bounds.size.width == 320 {
            heightNumber1.constant = 35
            self.spaceTop.constant = 20
            self.view.layoutIfNeeded()
        }
        else if UIScreen.main.bounds.size.width == 375 {
            heightNumber1.constant = 50
            self.view.layoutIfNeeded()
        }
    }
    @IBAction func doContine(_ sender: Any) {
        if txfNumber1.text!.trim().isEmpty || txfNumber2.text!.trim().isEmpty || txfNumber3.text!.trim().isEmpty || txfNumber4.text!.trim().isEmpty || txfNumber5.text!.trim().isEmpty || txfNumber6.text!.trim().isEmpty{
            APP_DELEGATE.showAlert(MSG_ERROR.ERROR_PASSWORD)
            return
        }
        APP_DELEGATE.userObj.password = txfNumber1.text!.trim() +  txfNumber2.text!.trim() + txfNumber3.text!.trim() + txfNumber4.text!.trim() + txfNumber5.text!.trim() + txfNumber6.text!.trim()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterInforVC") as! RegisterInforVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func doDel(_ sender: Any) {
        if !(txfNumber6.text?.isEmpty)! {
            txfNumber6.text = ""
        }
        else if !(txfNumber5.text?.isEmpty)! {
            txfNumber5.text = ""
        } else if !(txfNumber4.text?.isEmpty)! {
            txfNumber4.text = ""
        }else if !(txfNumber3.text?.isEmpty)! {
            txfNumber3.text = ""
        }else if !(txfNumber2.text?.isEmpty)! {
            txfNumber2.text = ""
        }else if !(txfNumber1.text?.isEmpty)! {
            txfNumber1.text = ""
        }
    }
}

