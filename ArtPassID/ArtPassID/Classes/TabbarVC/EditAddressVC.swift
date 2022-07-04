//
//  EditAddressVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 2/24/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit
import SKCountryPicker
class EditAddressVC: UIViewController {

    @IBOutlet weak var txfStreetName: UITextField!
    @IBOutlet weak var txfCity: UITextField!
    @IBOutlet weak var txfZipCode: UITextField!
    @IBOutlet weak var txfState: UITextField!
    @IBOutlet weak var txfCountry: UITextField!
    var countryCode = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func doBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func doCountry(_ sender: Any) {
        CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in

          guard let self = self else { return }
            self.txfCountry.text = country.countryName
            self.countryCode = country.countryCode
        }
    }
    @IBAction func doUpdate(_ sender: Any) {
        let mes = self.msgError()
        if mes.count == 0
        {
            Common.showBusy()
            let param = ["location": self.paramWS(), "userState": self.txfState.text!.trim()] as [String : Any]
            ApiHelper.shared.updateProfile(param) { (success, error) in
                Common.hideBusy()
                if success
                {
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
    
}
extension EditAddressVC
{
    func updateUI()
    {
        if let profileObj = APP_DELEGATE.profileObj
        {
            if let street = profileObj.location.object(forKey: "street") as? NSDictionary
            {
                self.txfStreetName.text = street.object(forKey: "name") as? String
            }
            self.txfCity.text = profileObj.location.object(forKey: "city") as? String
            if let country = profileObj.location.object(forKey: "country") as? NSDictionary
            {
                self.txfCountry.text = country.object(forKey: "name") as? String
                self.countryCode = country.object(forKey: "code") as? String ?? ""
            }
            self.txfZipCode.text = profileObj.location.object(forKey: "zipcode") as? String
            self.txfState.text = profileObj.userState
        }
    }
    
    func paramWS()-> [String:Any]
    {
        var param = [String: Any]()
        param["city"] = self.txfCity.text!.trim()
        param["zipcode"] = self.txfZipCode.text!.trim()
        param["country"] = ["code": self.countryCode, "name": txfCountry.text!]
        param["street"] = ["name": self.txfStreetName.text!.trim(), "number": ""]
        return param
    }
}
/*
 city = "Da Nang";
     country =         {
         code = VN;
         name = Vietnam;
     };
     street =         {
         name = "Dong Bai 3";
         number = " ";
     };
     zipcode = 59000;
 };
 */
extension EditAddressVC: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txfStreetName {
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
        if self.txfStreetName.text!.trim().isEmpty {
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
