//
//  SettingPasswordVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 2/26/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit

class SettingPasswordVC: UIViewController {
    @IBOutlet weak var txfNumber1: UITextField!
    @IBOutlet weak var txfNumber2: UITextField!
    @IBOutlet weak var txfNumber3: UITextField!
    @IBOutlet weak var txfNumber4: UITextField!
    @IBOutlet weak var txfNumber5: UITextField!
    @IBOutlet weak var txfNumber6: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        txfNumber1.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    
    func joinPassword()-> String
    {
        return "\(txfNumber1.text!.trim())" + "\(txfNumber2.text!.trim())" + "\(txfNumber3.text!.trim())" + "\(txfNumber4.text!.trim())" + "\(txfNumber5.text!.trim())" + "\(txfNumber6.text!.trim())"
    }

    func callAPI()
    {
        Common.showBusy()
        let param = ["old_pin": APP_DELEGATE.profileObj!.pinCode, "new_pin": self.joinPassword()] as [String : Any]
       ApiHelper.shared.changePin(param) { (success, error) in
           Common.hideBusy()
           if success
           {
            self.readNotification()
               APP_DELEGATE.showAlertComeback("You successfully changed your PIN!") { (success) in
                   UserDefaults.standard.set(self.joinPassword(), forKey: kPasswordLogin)
                    UserDefaults.standard.set(false, forKey: KEY_NOTIFICATION_SETTING)
                       if UserDefaults.standard.bool(forKey: KEY_NOTIFICATION_SETTING) {
                                                            
                         if APP_DELEGATE.notificationChangeUserName != nil && APP_DELEGATE.notificationChangeProfilePic != nil {
                             self.tabBarController?.tabBar.items![3].badgeValue = "3"
                         }
                         else{
                             if APP_DELEGATE.notificationChangeUserName != nil{
                                 self.tabBarController?.tabBar.items![3].badgeValue = "2"
                             }
                             else  if APP_DELEGATE.notificationChangeProfilePic != nil{
                                 self.tabBarController?.tabBar.items![3].badgeValue = "2"
                             }
                             else{
                                 self.tabBarController?.tabBar.items![3].badgeValue = "1"
                             }
                         }
                         
                         
                     }
                     else{
                         if APP_DELEGATE.notificationChangeUserName != nil && APP_DELEGATE.notificationChangeProfilePic != nil {
                             self.tabBarController?.tabBar.items![3].badgeValue = "2"
                         }
                         else{
                             if APP_DELEGATE.notificationChangeUserName != nil{
                                 self.tabBarController?.tabBar.items![3].badgeValue = "1"
                             }
                             else  if APP_DELEGATE.notificationChangeProfilePic != nil{
                                 self.tabBarController?.tabBar.items![3].badgeValue = "1"
                             }
                             else{
                                 self.tabBarController?.tabBar.items![3].badgeValue = nil
                             }
                         }
                     }
                    self.navigationController?.popViewController(animated: true)
                }
           
           }
           else{
               if error != nil {
                   APP_DELEGATE.showAlert(error!.msg!)
               }
           }
       }
    }
    
    func readNotification(){
        if let notiObj = APP_DELEGATE.notificationChangePin{
            ApiHelper.shared.addReadNotification(notiObj.notifyId, "pin_changing", notiObj.id) { (success, error) in
                                  
            }
            APP_DELEGATE.notificationChangePin = nil
        }
       
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
    @IBAction func doSubmit(_ sender: Any) {
        if txfNumber1.text!.trim().isEmpty || txfNumber2.text!.trim().isEmpty || txfNumber3.text!.trim().isEmpty || txfNumber4.text!.trim().isEmpty || txfNumber5.text!.trim().isEmpty || txfNumber6.text!.trim().isEmpty{
            APP_DELEGATE.showAlert(MSG_ERROR.ERROR_LOGIN_CODE)
            return
        }
         self.callAPI()
    }
}
extension SettingPasswordVC: UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                           replacementString string: String) -> Bool
    {
        if textField.text!.count < 1  && string.count > 0{
            textField.text = ""
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
               
               // self.view.endEditing(true)
            }
            textField.text = string
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
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
