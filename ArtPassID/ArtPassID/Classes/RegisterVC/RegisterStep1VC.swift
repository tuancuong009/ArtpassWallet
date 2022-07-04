//
//  RegisterStep1VC.swift
//  ArtPassID
//
//  Created by QTS Coder on 4/19/19.
//  Copyright © 2019 QTS Coder. All rights reserved.
//

import UIKit
import SKCountryPicker
class RegisterStep1VC: UIViewController {

    @IBOutlet weak var txfEmail: UITextField!
    @IBOutlet weak var txfCode: UITextField!
    @IBOutlet weak var txfPhoneNumber: UITextField!
    @IBOutlet weak var txfFName: UITextField!
    @IBOutlet weak var txfLName: UITextField!
    @IBOutlet weak var viewError: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
        self.viewError.isHidden = true
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
    @IBAction func doContine(_ sender: Any) {
        if txfEmail.text!.trim().isEmpty {
            APP_DELEGATE.showAlert(MSG_ERROR.ERROR_EMAIL)
            return
        }
        if !txfEmail.text!.trim().isValidEmail() {
            APP_DELEGATE.showAlert(MSG_ERROR.ERROR_EMAIL_INVALID)
            return
        }
        if txfPhoneNumber.text!.trim().isEmpty {
            APP_DELEGATE.showAlert(MSG_ERROR.ERROR_PHONE)
            return
        }
        if txfFName.text!.trim().isEmpty {
            APP_DELEGATE.showAlert(MSG_ERROR.ERROR_FNAME)
            return
        }
        if txfLName.text!.trim().isEmpty {
            APP_DELEGATE.showAlert(MSG_ERROR.ERROR_LNAME)
            return
        }
        let phoneRe = txfPhoneNumber.text!
//        let first  = String(phoneRe.prefix(1))
//        if first == "0" {
//            phoneRe = phoneRe.substring(from: 1)
//        }
        let phone = self.txfCode.text! + phoneRe
        ApiHelper.shared.checkUser(param: ["email": txfEmail.text!.trim(), "phone": phoneRe]) { (success, mess) in
            if let message = mess
            {
                if message == "true" {
                   let param = ["phoneNumber": phone.replacingOccurrences(of: "+", with: "")]
                   ApiHelper.shared.phoneCheck(param) { (success, request_id, error) in
                       if success
                       {
                           self.view.endEditing(true)
                           APP_DELEGATE.userObj.email = self.txfEmail.text!.trim()
                           APP_DELEGATE.userObj.fname = self.txfFName.text!.trim()
                           APP_DELEGATE.userObj.lname = self.txfLName.text!.trim()
                           APP_DELEGATE.userObj.phoneCode = self.txfCode.text!
                           APP_DELEGATE.userObj.phoneNumber = self.txfPhoneNumber.text!.trim()
                           APP_DELEGATE.userObj.phoneAPI = phone.replacingOccurrences(of: "+", with: "")
                           let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "RegisterStep2VC") as! RegisterStep2VC
                           vc.requestID = request_id ?? ""
                           self.navigationController?.pushViewController(vc, animated: true)
                       }
                       else{
                           if error != nil {
                               APP_DELEGATE.showAlert(error!.msg!)
                           }
                       }
                   }
                }
                else{
                     self.viewError.isHidden = false
                    self.perform(#selector(self.hideError), with: nil, afterDelay: TIME_OUT)
                     //APP_DELEGATE.showAlert(message)
                }
            }
        }
    }
    @objc func hideError()
    {
        self.viewError.isHidden = true
    }
    @IBAction func doCode(_ sender: Any) {
        let countryController =  CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in

          guard let self = self else { return }

            self.txfCode.text = country.dialingCode

        }
        countryController.modalPresentationStyle = .fullScreen
    }
}

extension RegisterStep1VC
{
    func updateUI()
    {
        guard let country = CountryManager.shared.currentCountry else {
            return
        }
        txfCode.text = country.dialingCode
    }
}

extension RegisterStep1VC: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txfFName
        {
            txfLName.becomeFirstResponder()
        }
        else{
            txfLName.resignFirstResponder()
        }
        return true
    }
}
