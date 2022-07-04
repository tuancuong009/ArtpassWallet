//
//  RegisterInforVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 2/14/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit
import SKCountryPicker
import Alamofire
class RegisterInforVC: UIViewController {

    @IBOutlet weak var txfAddress: UITextField!
    @IBOutlet weak var txfCity: UITextField!
    @IBOutlet weak var txfZipCode: UITextField!
    @IBOutlet weak var txfState: UITextField!
    @IBOutlet weak var txfCountry: UITextField!
    var nameCodeCountry = ""
    @IBOutlet weak var viewSuccess: UIView!
    @IBOutlet weak var viewError: UIView!
    @IBOutlet weak var lblError: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSuccess.isHidden = true
        viewError.isHidden = true
        self.showAlertFail()
        print("APP_DELEGATE.acuantObj.data --->",APP_DELEGATE.acuantObj.data)
        // Do any additional setup after loading the view.
    }
    func showAuthenticationResult() -> String
    {
        if let arrs = APP_DELEGATE.acuantObj.data
        {
            for item in arrs {
                if item.contains("Authentication Result") {
                    let arrFirstName = item.components(separatedBy: ":")
                    if arrFirstName.count  > 1 {
                        return arrFirstName[1]
                    }
                }
            }
        }
        return " "
    }
    
    func getBirthdayAcuant() -> String
      {
          if let arrs = APP_DELEGATE.acuantObj.data
          {
              for item in arrs {
                  if item.contains("Birth Date") {
                      let arrFirstName = item.components(separatedBy: ":")
                      if arrFirstName.count  > 1 {
                          return arrFirstName[1]
                      }
                  }
              }
          }
          return " "
      }
    
    func showIsFaceLive() -> String
   {
       if let arrs = APP_DELEGATE.acuantObj.data
       {
           for item in arrs {
               if item.contains("Is live Face") {
                   let arrFirstName = item.components(separatedBy: ":")
                   if arrFirstName.count  > 1 {
                       return arrFirstName[1]
                   }
               }
           }
       }
       return " "
   }

    func showIsFaceMatch() -> String
    {
        if let arrs = APP_DELEGATE.acuantObj.data
        {
            for item in arrs {
                if item.contains("Face matched") {
                    let arrFirstName = item.components(separatedBy: ":")
                    if arrFirstName.count  > 1 {
                        return arrFirstName[1]
                    }
                }
            }
        }
        return " "
    }
    func formatStringBirthday(_ date: String)-> String
    {
        if date.trim().count == 0 {
            return " "
        }
        let format = DateFormatter.init()
        format.dateFormat = "d MMM yyyy"
        if let dateFormat = format.date(from: date)
        {
            let format1 = DateFormatter.init()
            format1.dateFormat = "yyyy-MM-dd"
            return format1.string(from: dateFormat)
        }
        else
        {
            let format = DateFormatter.init()
            format.dateFormat = "MM-dd-yyyy"
            if let dateFormat = format.date(from: date)
            {
                let format1 = DateFormatter.init()
                format1.dateFormat = "yyyy-MM-dd"
                return format1.string(from: dateFormat)
            }
            return " "
        }
    }
    
    func showAlertFail()
    {
        print("VALUE --->",self.showAuthenticationResult().trim())
        print("BIRTHDAY --->",self.formatStringBirthday(self.getBirthdayAcuant()).trim())
        //var textError = ""
        if self.showAuthenticationResult().trim().lowercased() == "Failed".lowercased() || self.showAuthenticationResult().trim().isEmpty {
            viewError.isHidden = false
            //textError = "Authentication Result: Fail"
            //APP_DELEGATE.showAlert(textError)
        }
        else if self.formatStringBirthday(self.getBirthdayAcuant()).trim().isEmpty
        {
            viewError.isHidden = false
            // textError = "Birthday: Fail"
           // APP_DELEGATE.showAlert(textError)
        }
        else if self.showIsFaceLive().trim() == "false" || self.showIsFaceLive().trim().isEmpty {
             viewError.isHidden = false
             //textError = "Face Live: Fail"
           // APP_DELEGATE.showAlert(textError)
        }
        else if self.showIsFaceMatch().trim() == "false" || self.showIsFaceMatch().trim().isEmpty {
             viewError.isHidden = false
            //textError = "Face Match: Fail"
            //APP_DELEGATE.showAlert(textError)
        }
        else{
            self.viewSuccess.isHidden = false
            self.perform(#selector(hideSuccess), with: nil, afterDelay: TIME_OUT)
        }
        
    }
    
    @IBAction func doRedo(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        APP_DELEGATE.isRedoScan = true
    }
    
    @objc func hideSuccess()
    {
        self.viewSuccess.isHidden = true
    }
    
    @IBAction func doCountry(_ sender: Any) {
        CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in

          guard let self = self else { return }

            self.nameCodeCountry = country.countryCode
            self.txfCountry.text = country.countryName
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
    @IBAction func doContine(_ sender: Any) {
        
        
        // Register Final
        let msg = self.msgError()
        if msg.isEmpty {
            self.view.endEditing(true)
            APP_DELEGATE.userObj.city = self.txfCity.text!.trim()
            APP_DELEGATE.userObj.street_address = self.txfAddress.text!.trim()
            APP_DELEGATE.userObj.zipcode = self.txfZipCode.text!.trim()
            APP_DELEGATE.userObj.state = self.txfState.text!.trim()
            APP_DELEGATE.userObj.country = self.txfCountry.text!.trim()
            APP_DELEGATE.userObj.countryCode = self.nameCodeCountry
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else{
            APP_DELEGATE.showAlert(msg)
        }
    }
    
}

extension RegisterInforVC: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txfAddress {
            txfCity.becomeFirstResponder()
        }
        else if textField == txfCity
        {
            txfZipCode.becomeFirstResponder()
        }
        else if textField == txfZipCode
        {
            txfState.becomeFirstResponder()
        }
        else{
            txfState.resignFirstResponder()
        }
        return true
    }
    
    func msgError()-> String
    {
        var msg = ""
        if self.txfAddress.text!.trim().isEmpty {
            msg = MSG_ERROR.ERROR_STREET_ADDRESS
        }
        else if self.txfCity.text!.trim().isEmpty {
            msg = MSG_ERROR.ERROR_CITY
        }
        else if self.txfZipCode.text!.trim().isEmpty {
            msg = MSG_ERROR.ERROR_ZIPCODE
        }
        else if self.txfState.text!.trim().isEmpty {
            msg = MSG_ERROR.ERROR_STATE
        }
        else if self.txfCountry.text!.trim().isEmpty {
            msg = MSG_ERROR.ERROR_COUNTRY
        }
        return msg
    }
    
}
