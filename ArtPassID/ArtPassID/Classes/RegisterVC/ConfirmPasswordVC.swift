//
//  ConfirmPasswordVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 2/25/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit

class ConfirmPasswordVC: UIViewController {
    @IBOutlet weak var txfNumber1: UITextField!
    @IBOutlet weak var txfNumber2: UITextField!
    @IBOutlet weak var txfNumber3: UITextField!
    @IBOutlet weak var txfNumber4: UITextField!
    @IBOutlet weak var txfNumber5: UITextField!
    @IBOutlet weak var txfNumber6: UITextField!
    @IBOutlet weak var viewSuccess: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSuccess.isHidden = true
        self.txfNumber1.becomeFirstResponder()
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
    func joinPassword()-> String
    {
        return "\(txfNumber1.text!.trim())" + "\(txfNumber2.text!.trim())" + "\(txfNumber3.text!.trim())" + "\(txfNumber4.text!.trim())" + "\(txfNumber5.text!.trim())" + "\(txfNumber6.text!.trim())"
    }
    
    func callAPI()
    {
        if let obj = APP_DELEGATE.profileObj
        {
            let phoneRe = obj.phone
//            let first  = String(phoneRe.prefix(1))
//            if first == "0" {
//                phoneRe = phoneRe.substring(from: 1)
//            }
            let param = ["phoneNum": phoneRe, "pincode": self.joinPassword(), "phoneCode": obj.phoneCode.replacingOccurrences(of: "+", with: "")]
            Common.showBusy()
            ApiHelper.shared.loginUser(param) { (success, error) in
                Common.hideBusy()
                if success
                {
                    UserDefaults.standard.set(phoneRe, forKey: kPhoneLogin)
                    UserDefaults.standard.set(self.joinPassword(), forKey: kPasswordLogin)
                    UserDefaults.standard.set(obj.phoneCode.replacingOccurrences(of: "+", with: ""), forKey: kPhoneCode)
                    self.viewSuccess.isHidden = false
                    self.perform(#selector(self.redirectTabbar), with: nil, afterDelay: 2.0)
                }
                else{
                    if error != nil {
                        let alert = UIAlertController.init(title: APP_NAME, message: error?.msg, preferredStyle: .alert)
                        let ok = UIAlertAction.init(title: "OK", style: .cancel) { (action) in
                            self.txfNumber1.text = ""
                            self.txfNumber2.text = ""
                            self.txfNumber3.text = ""
                            self.txfNumber4.text = ""
                            self.txfNumber5.text = ""
                            self.txfNumber6.text = ""
                            self.txfNumber1.becomeFirstResponder()
                        }
                        alert.addAction(ok)
                        self.present(alert, animated: true, completion: nil)
                        
                        
                    }
                }
            }
        }
        
    }
    
    @objc func redirectTabbar()
    {
        let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension ConfirmPasswordVC: UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                           replacementString string: String) -> Bool
    {
        if textField.text!.count < 1  && string.count > 0{
            textField.text = string
            if textField == txfNumber1
            {
                txfNumber2.becomeFirstResponder()
            }
            else if textField == txfNumber2
            {
               txfNumber3.becomeFirstResponder()
            }else if textField == txfNumber3
            {
               txfNumber4.becomeFirstResponder()
            }else if textField == txfNumber4
            {
               txfNumber5.becomeFirstResponder()
            }else if textField == txfNumber5
            {
               txfNumber6.becomeFirstResponder()
            }
            else{
                self.view.endEditing(true)
                self.callAPI()
               // self.view.endEditing(true)
            }
            return false
        }
        else if textField.text!.count >= 1  && string.count == 0{
            textField.text = ""
            if textField == txfNumber6
            {
                txfNumber5.becomeFirstResponder()
            }
            else if textField == txfNumber5
            {
               txfNumber4.becomeFirstResponder()
            }else if textField == txfNumber4
            {
               txfNumber3.becomeFirstResponder()
            }else if textField == txfNumber3
            {
               txfNumber2.becomeFirstResponder()
            }else if textField == txfNumber2
            {
               txfNumber1.becomeFirstResponder()
            }
            return false
        }
        return true
       
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
}
