//
//  LoginVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 4/19/19.
//  Copyright © 2019 QTS Coder. All rights reserved.
//

import UIKit
import SKCountryPicker
class LoginVC: UIViewController {

     @IBOutlet weak var txfNumber1: UITextField!
     @IBOutlet weak var txfNumber2: UITextField!
    @IBOutlet weak var txfNumber3: UITextField!
    @IBOutlet weak var txfNumber4: UITextField!
    @IBOutlet weak var txfNumber5: UITextField!
    @IBOutlet weak var txfNumber6: UITextField!
    @IBOutlet weak var txfCode: UITextField!
    @IBOutlet weak var txfPhoneNumber: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
        //+32 484775183     112358
        // Do any additional setup after loading the view.
        
        /*
       
         dreweatts AMP
         32484775184   112358

        App
         +32 471101325
         112358
         */
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
    func joinPassword()-> String
    {
        return "\(txfNumber1.text!.trim())" + "\(txfNumber2.text!.trim())" + "\(txfNumber3.text!.trim())" + "\(txfNumber4.text!.trim())" + "\(txfNumber5.text!.trim())" + "\(txfNumber6.text!.trim())"
    }
    
    @IBAction func doContine(_ sender: Any) {
        if self.txfNumber1.text!.isEmpty || self.txfNumber2.text!.isEmpty || self.txfNumber3.text!.isEmpty || self.txfNumber4.text!.isEmpty || self.txfNumber5.text!.isEmpty || self.txfNumber6.text!.isEmpty{
            APP_DELEGATE.showAlert(MSG_ERROR.ERROR_PASSWORD)
            return
        }
        if txfPhoneNumber.text!.trim().isEmpty {
            APP_DELEGATE.showAlert(MSG_ERROR.ERROR_PHONE)
            return
        }
        let phoneRe = txfPhoneNumber.text!
//        let first  = String(phoneRe.prefix(1))
//        if first == "0" {
//            phoneRe = phoneRe.substring(from: 1)
//        }
        let param = ["phoneNum": phoneRe, "pincode": self.joinPassword(), "phoneCode": self.txfCode.text!.replacingOccurrences(of: "+", with: "")]
        Common.showBusy()
        ApiHelper.shared.loginUser(param) { (success, error) in
            Common.hideBusy()
            if success
            {
                UserDefaults.standard.set(phoneRe, forKey: kPhoneLogin)
                UserDefaults.standard.set(self.joinPassword(), forKey: kPasswordLogin)
                UserDefaults.standard.set(self.txfCode.text!.replacingOccurrences(of: "+", with: ""), forKey: kPhoneCode)
                UserDefaults.standard.removeObject(forKey: arrtransacId)
                UserDefaults.standard.synchronize()
                let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else{
                if error != nil {
                    APP_DELEGATE.showAlert(error!.msg!)
                }
            }
        }
       
    }
    @IBAction func doCode(_ sender: Any) {
         CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in

          guard let self = self else { return }

            self.txfCode.text = country.dialingCode

        }
    }
}

extension LoginVC
{
    func updateUI()
    {
        guard let country = CountryManager.shared.currentCountry else {
            return
        }
        txfCode.text = country.dialingCode
    }
}
extension LoginVC: UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                           replacementString string: String) -> Bool
    {
        if textField == txfPhoneNumber {
            return true
        }
        else{
            
            if (textField.text!.count < 1  && string.count > 0){
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
                   // self.view.endEditing(true)
                }
                textField.text = string
                return false
            }
             else if (textField.text!.count >= 1  && string.count == 0){
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
                textField.text = ""
                return false
            }
            else if (textField.text!.count >= 1  )
            {
                textField.text = string
                return false
            }
            return true
        }
       
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txfPhoneNumber {
        }
        else{
             textField.text = ""
        }
       
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txfPhoneNumber {
            txfNumber1.becomeFirstResponder()
        }
        return true
    }
}
