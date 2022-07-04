//
//  EditProfileVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 2/24/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit
import SKCountryPicker
class EditProfileVC: UIViewController {

    @IBOutlet weak var txfLastName: UITextField!
    @IBOutlet weak var txfFirsName: UITextField!
    @IBOutlet weak var txfEmail: UITextField!
    @IBOutlet weak var txfCode: UITextField!
    @IBOutlet weak var txfPhone: UITextField!
    @IBOutlet weak var txfUserName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
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
    @IBAction func doback(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func doUpdate(_ sender: Any) {
        let mes = self.msgError()
        if mes.count == 0
        {
            Common.showBusy()
            ApiHelper.shared.updateProfile(self.paramWS()) { (success, error) in
                Common.hideBusy()
                if success
                {
                    self.readNotification()
                    self.navigationController?.popViewController(animated: true)
                }
                else{
                    if error != nil {
                        APP_DELEGATE.showAlert(error!.msg!)
                    }
                }
            }
        }
        else{
            APP_DELEGATE.showAlert(mes)
        }
    }
    
    func paramWS()-> [String:Any]
    {
        var param = [String: Any]()
        param["email"] = self.txfEmail.text!.trim()
        param["fname"] = self.txfFirsName.text!.trim()
        param["lname"] = self.txfLastName.text!.trim()
        param["phone"] = self.txfPhone.text!.trim()
        param["phoneCode"] = self.txfCode.text!.trim().replacingOccurrences(of: "+", with: "")
        param["username"] =  txfUserName.text!.trim()
        return param
    }
    
    @IBAction func doCountryCode(_ sender: Any) {
        CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in

          guard let self = self else { return }

            self.txfCode.text = country.dialingCode

        }
    }
}

extension EditProfileVC
{
    func updateUI()
    {
        if let profileObj = APP_DELEGATE.profileObj
        {
            self.txfFirsName.text = profileObj.fname
            self.txfLastName.text = profileObj.lname
            self.txfEmail.text = profileObj.email
            self.txfPhone.text = profileObj.phone
            self.txfCode.text = "+" + profileObj.phoneCode
            self.txfUserName.text = profileObj.username
        }
    }
}
extension EditProfileVC: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txfFirsName {
            txfLastName.becomeFirstResponder()
        }
        else if textField == txfLastName
        {
            txfEmail.becomeFirstResponder()
        }
        else if textField == txfEmail
        {
            txfPhone.becomeFirstResponder()
        }
        else if textField == txfPhone
        {
            txfUserName.becomeFirstResponder()
        }
        else{
            txfUserName.resignFirstResponder()
        }
        return true
    }
    
    func msgError()-> String
    {
        var msg = ""
        if self.txfFirsName.text!.trim().isEmpty {
            msg = MSG_ERROR.ERROR_FNAME
        }
        else if self.txfLastName.text!.trim().isEmpty {
            msg = MSG_ERROR.ERROR_LNAME
        }
        else if self.txfEmail.text!.trim().isEmpty {
            msg = MSG_ERROR.ERROR_EMAIL
        }
        else if !self.txfEmail.text!.trim().isValidEmail() {
            msg = MSG_ERROR.ERROR_EMAIL_INVALID
        }
        else if self.txfPhone.text!.trim().isEmpty {
            msg = MSG_ERROR.ERROR_PHONE
        }
        else if self.txfUserName.text!.trim().isEmpty {
            msg = MSG_ERROR.ERROR_USERNAME
        }
        return msg
    }
    func readNotification(){
           if let notiObj = APP_DELEGATE.notificationChangeUserName{
               ApiHelper.shared.addReadNotification(notiObj.notifyId, "username_changing", notiObj.id) { (success, error) in
                                     
               }
               APP_DELEGATE.notificationChangeUserName = nil
           }
          
       }
}
