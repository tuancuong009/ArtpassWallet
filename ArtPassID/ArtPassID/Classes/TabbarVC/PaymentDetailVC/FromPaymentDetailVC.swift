//
//  FromPaymentDetailVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 5/14/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit
import SKCountryPicker
import Alamofire
class FromPaymentDetailVC: UIViewController {

    @IBOutlet weak var btnBank: UIButton!
    @IBOutlet weak var txfName: UITextField!
    @IBOutlet weak var txfAccountNumber: UITextField!
    @IBOutlet weak var txfAddress: UITextField!
    @IBOutlet weak var txfCity: UITextField!
    @IBOutlet weak var txfZip: UITextField!
    @IBOutlet weak var txfCountry: UITextField!
    @IBOutlet weak var btnCreateCard: UIButton!
    @IBOutlet weak var txfNameCard: UITextField!
    @IBOutlet weak var txfCardNumber: UITextField!
    @IBOutlet weak var txfTypeCard: UITextField!
    @IBOutlet weak var txfDate: UITextField!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var viewSuccess: UIView!
    @IBOutlet weak var btnCrypro: UIButton!
    @IBOutlet weak var txfCry: UITextField!
    @IBOutlet weak var txfPublicKey: UITextField!
    @IBOutlet weak var viewSelectCry: UIView!
    @IBOutlet weak var viewPublicKey: UIViewX!
    @IBOutlet weak var viewCry: UIViewX!
    @IBOutlet weak var spaceBtn: NSLayoutConstraint!
    var isBank = true
    var isCreateCard = false
    var isCry = false
    var username = ""
    var dictItem = NSDictionary.init()
    var arrRoles = [String]()
    var signature = ""
    var provenanceWork = ""
    var countryObj: Country?
    var isAmpAsBuyer = false
    var isMoreSetting = false
    var isSelectPay = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSuccess.isHidden = true
        self.selectBank()
        self.selectCreateCard()
        self.selectCry()
        print("DICT-->",self.dictItem)
        if !self.isMoreSetting {
             self.lblUserName.text = "\(username) HAS RECEIVED"
//            self.spaceBtn.constant = -140
//            self.viewCry.isHidden = true
//            self.viewSelectCry.isHidden = true
//            self.viewPublicKey.isHidden = true
        }
        
        
    }
    
    func selectBank()
    {
        
        if self.isBank {
            self.btnBank.setImage(UIImage.init(named: "ic_radio_selected"), for: .normal)
            self.txfName.isEnabled = true
            self.txfAccountNumber.isEnabled = true
            self.txfAddress.isEnabled = true
            self.txfCity.isEnabled = true
            self.txfZip.isEnabled = true
        }
        else{
            self.btnBank.setImage(UIImage.init(named: "ic_radio"), for: .normal)
            self.txfName.isEnabled = false
            self.txfAccountNumber.isEnabled = false
            self.txfAddress.isEnabled = false
            self.txfCity.isEnabled = false
            self.txfZip.isEnabled = false
        }
    }
    func selectCreateCard()
    {
        if self.isCreateCard {
            self.btnCreateCard.setImage(UIImage.init(named: "ic_radio_selected"), for: .normal)
            self.txfTypeCard.isEnabled = true
            self.txfCardNumber.isEnabled = true
            self.txfNameCard.isEnabled = true
            self.txfDate.isEnabled = true
        }
        else{
            self.btnCreateCard.setImage(UIImage.init(named: "ic_radio"), for: .normal)
            self.txfTypeCard.isEnabled = false
            self.txfCardNumber.isEnabled = false
            self.txfNameCard.isEnabled = false
            self.txfDate.isEnabled = false
        }
    }
    
    func selectCry(){
        if self.isCry {
            self.btnCrypro.setImage(UIImage.init(named: "ic_radio_selected"), for: .normal)
            self.txfPublicKey.isEnabled = true
           
        }
        else{
            self.btnCrypro.setImage(UIImage.init(named: "ic_radio"), for: .normal)
            self.txfPublicKey.isEnabled = false
        }
    }
    @IBAction func doCry(_ sender: Any) {
        self.isCry = true
        self.isCreateCard = false
        self.isBank = false
        self.selectBank()
        self.selectCreateCard()
        self.selectCry()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
     
     */
    @IBAction func doSelectCry(_ sender: Any) {
       
        if !self.isCry {
            return
        }
        DPPickerManager.shared.showPicker(title: "Crypto Name", selected: self.txfCry.text!, strings: ["Bitcoin", "Ether", "Tezos"]) { (val, index, success) in
            if !success
            {
                self.txfCry.text = val
            }
        }
    }
    
    @IBAction func doBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func doBank(_ sender: Any) {
        self.isCreateCard = false
        self.isBank = true
        self.isCry = false
        self.selectCry()
        self.selectBank()
        self.selectCreateCard()
    }
    @IBAction func doCountry(_ sender: Any) {
        if self.isBank {
            CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in

                 guard let self = self else { return }
                    self.countryObj = country
                   self.txfCountry.text = country.countryName

               }
        }
    }
    @IBAction func doCreateCard(_ sender: Any) {
        self.isCreateCard = true
        self.isBank = false
        self.isCry = false
        self.selectCry()
        self.selectBank()
        self.selectCreateCard()
    }
    @IBAction func doConfirm(_ sender: Any) {
        if self.isMoreSetting {
            // SAVE SETTING PAYMENT
            var msg = ""
            if self.isBank {
                msg = self.validateBankTransfer()
            }
            else if self.isCreateCard {
                msg = self.validateCreditCard()
            }
            else{
                msg = self.validateCry()
            }
            if msg.isEmpty
            {
                if self.isCry {
                    Common.showBusy()
                    ApiHelper.shared.updateProfileSettingCryCurreny(self.paramAPIMoreSettingCry()) { (success, error) in
                        Common.hideBusy()
                        if success
                        {
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                        else{
                            if error != nil {
                                APP_DELEGATE.showAlert(error!.msg!)
                            }
                        }
                    }
                 }
                else{
                    Common.showBusy()
                    ApiHelper.shared.updateProfile(self.paramAPIMoreSetting()) { (success, error) in
                        Common.hideBusy()
                        if success
                        {
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                        else{
                            if error != nil {
                                APP_DELEGATE.showAlert(error!.msg!)
                            }
                        }
                    }
                 }
            }
            else{
                    APP_DELEGATE.showAlert(msg)
                }
        }
        else{
            if self.isAmpAsBuyer {
                var msg = ""
                if self.isBank {
                    msg = self.validateBankTransfer()
                }
                else if self.isCreateCard {
                    msg = self.validateCreditCard()
                }
                else{
                    msg = self.validateCry()
                }
                if msg.isEmpty
                {
                    ApiHelper.shared.updatetransactionAmpAsBuyer(self.paramCallAmpAsBuyerAPI()) { (success, error) in
                        if success
                        {
                            if !APP_DELEGATE.actype.isEmpty {
                                ApiHelper.shared.addReadNotification(APP_DELEGATE.tracsationID, APP_DELEGATE.actype, APP_DELEGATE.notificationID) { (success, error) in
                                    self.viewSuccess.isHidden = false
                                   self.tabBarController?.tabBar.isHidden = true
                                   self.perform(#selector(self.redirectHome), with: nil, afterDelay: TIME_OUT)
                                }
                            }
                            else{
                                self.viewSuccess.isHidden = false
                               self.tabBarController?.tabBar.isHidden = true
                               self.perform(#selector(self.redirectHome), with: nil, afterDelay: TIME_OUT)
                            }
                           
                        }
                        else{
                            if error != nil {
                                APP_DELEGATE.showAlert(error!.msg!)
                            }
                        }
                    }
                    
                }
                else{
                    APP_DELEGATE.showAlert(msg)
                }
            }
            else{
                var msg = ""
                if self.isBank {
                    msg = self.validateBankTransfer()
                }
                else if self.isCreateCard {
                    msg = self.validateCreditCard()
                }
                else{
                    msg = self.validateCry()
                }
                if msg.isEmpty
                {
                    
                    ApiHelper.shared.updatetransaction(self.paramCallAPI()) { (success, error) in
                        if success
                        {
                            if !APP_DELEGATE.actype.isEmpty {
                                ApiHelper.shared.addReadNotification(APP_DELEGATE.tracsationID, APP_DELEGATE.actype,APP_DELEGATE.notificationID) { (success, error) in
                                    self.viewSuccess.isHidden = false
                                    self.tabBarController?.tabBar.isHidden = true
                                    //self.navigationController?.popToRootViewController(animated: true)
                                    self.perform(#selector(self.redirectHome), with: nil, afterDelay: TIME_OUT)
                                }
                            }
                            else{
                                    self.viewSuccess.isHidden = false
                                    self.tabBarController?.tabBar.isHidden = true
                                //self.navigationController?.popToRootViewController(animated: true)
                                    self.perform(#selector(self.redirectHome), with: nil, afterDelay: TIME_OUT)
                            }
                            
                        }
                        else{
                            if error != nil {
                                APP_DELEGATE.showAlert(error!.msg!)
                            }
                        }
                    }
                }
                else{
                    APP_DELEGATE.showAlert(msg)
                }
            }
        }
        
    }
    
    @objc func redirectHome()
    {
        APP_DELEGATE.isRedirectActivity = true
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func validateBankTransfer()-> String
    {
        var msg = ""
        if txfName.text!.trim().isEmpty
        {
            msg = "Name of the bank is required"
        }
        else if txfAccountNumber.text!.trim().isEmpty
        {
            msg = "Account number is required"
        }
        else if txfAddress.text!.trim().isEmpty
        {
            msg = "Address is required"
        }
        else if txfCity.text!.trim().isEmpty
        {
            msg = "City is required"
        }
        else if txfZip.text!.trim().isEmpty
        {
            msg = "Zip is required"
        }
        else if txfCountry.text!.trim().isEmpty
        {
            msg = "Country is required"
        }
        return msg
    }
    
    func validateCreditCard()-> String
    {
        var msg = ""
        if txfTypeCard.text!.trim().isEmpty
        {
            msg = "Name of the card issuer is required"
        }
        else if txfCardNumber.text!.trim().isEmpty
        {
            msg = "Card number is required"
        }
        else if txfNameCard.text!.trim().isEmpty
        {
            msg = "Name card is required"
        }
        else if txfDate.text!.trim().isEmpty
        {
            msg = "Expiration date is required"
        }
        return msg
    }
    func validateCry()-> String
    {
        var msg = ""
        if txfCry.text!.trim().isEmpty
        {
            msg = "Crypto Name is required"
        }
        else if txfPublicKey.text!.trim().isEmpty
        {
            msg = "Public Key is required"
        }
       
        return msg
    }
    
    func paramBank()-> Parameters
    {
        var param:Parameters = [:]
        param["method"] = "bank"
        param["bankName"] = self.txfName.text!.trim()
        param["accountNumber"] = self.txfAccountNumber.text!.trim()
        param["addr"] = self.txfAddress.text!.trim()
        param["city"] = self.txfCity.text!.trim()
        param["zipcode"] = self.txfZip.text!.trim()
        param["country"] = ["name": self.countryObj!.countryName, "iso2code": Common.listAllIos3(self.countryObj!.countryCode)]
        return param
    }
    
    func paramCreateCard()-> Parameters
    {
        var param:Parameters = [:]
        param["method"] = "cc"
        param["cardIssuer"] = self.txfTypeCard.text!.trim()
        param["cardNumber"] = self.txfCardNumber.text!.trim()
        param["cardName"] = self.txfNameCard.text!.trim()
        param["cardDate"] = self.txfDate.text!.trim()
        return param
    }
    
    func paramCallAPI()-> Parameters
    {
        if self.isBank
        {
            var param:Parameters = [:]
            param["transacId"] = self.dictItem.object(forKey: "transacId") as? String ?? ""
            param["buyerEsign"] = self.signature
            param["payments"] = self.paramBank()
            param["seller"] = self.dictItem.object(forKey: "seller") as? NSDictionary ??  NSDictionary.init()
            param["buyer"] = self.dictItem.object(forKey: "buyer") as? NSDictionary ??  NSDictionary.init()
            param["roles"] = self.arrRoles
            param["attachments"] = self.dictItem.object(forKey: "attachments") as? NSDictionary ??  NSDictionary.init()
            param["refnum"] = self.dictItem.object(forKey: "refnum") as? String ?? ""
            param["desc"] = self.dictItem.object(forKey: "desc") as? String ?? ""
            param["artist"] = self.dictItem.object(forKey: "artist") as? String ?? ""
            param["title"] = self.dictItem.object(forKey: "title") as? String ?? ""
            param["medium"] = self.dictItem.object(forKey: "medium") as? String ?? ""
            param["materials"] = self.dictItem.object(forKey: "materials") as? String ?? ""
            param["workCreatedTime"] = self.dictItem.object(forKey: "workCreatedTime") as? String ?? ""
            param["edition"] = self.dictItem.object(forKey: "edition") as? String ?? ""
            param["duration"] = self.dictItem.object(forKey: "duration") as? String ?? ""
            param["watermark"] = self.dictItem.object(forKey: "watermark") as? String ?? ""

            return param
        } else if self.isCry
        {
            var param:Parameters = [:]
            param["transacId"] = self.dictItem.object(forKey: "transacId") as? String ?? ""
            param["buyerEsign"] = self.signature
            param["payments"] = self.paramObjectCryCurreny()
            param["seller"] = self.dictItem.object(forKey: "seller") as? NSDictionary ??  NSDictionary.init()
            param["buyer"] = self.dictItem.object(forKey: "buyer") as? NSDictionary ??  NSDictionary.init()
            param["roles"] = self.arrRoles
            param["attachments"] = self.dictItem.object(forKey: "attachments") as? NSDictionary ??  NSDictionary.init()
            param["refnum"] = self.dictItem.object(forKey: "refnum") as? String ?? ""
            param["desc"] = self.dictItem.object(forKey: "desc") as? String ?? ""
            param["artist"] = self.dictItem.object(forKey: "artist") as? String ?? ""
            param["title"] = self.dictItem.object(forKey: "title") as? String ?? ""
            param["medium"] = self.dictItem.object(forKey: "medium") as? String ?? ""
            param["materials"] = self.dictItem.object(forKey: "materials") as? String ?? ""
            param["workCreatedTime"] = self.dictItem.object(forKey: "workCreatedTime") as? String ?? ""
            param["edition"] = self.dictItem.object(forKey: "edition") as? String ?? ""
            param["duration"] = self.dictItem.object(forKey: "duration") as? String ?? ""
            param["watermark"] = self.dictItem.object(forKey: "watermark") as? String ?? ""

            return param
        }
        else{
            var param:Parameters = [:]
            param["transacId"] = self.dictItem.object(forKey: "transacId") as? String ?? ""
            param["buyerEsign"] = self.signature
            param["payments"] = self.paramCreateCard()
            param["seller"] = self.dictItem.object(forKey: "seller") as? NSDictionary ??  NSDictionary.init()
            param["buyer"] = self.dictItem.object(forKey: "buyer") as? NSDictionary ??  NSDictionary.init()
            param["roles"] = self.arrRoles
            param["attachments"] = self.dictItem.object(forKey: "attachments") as? NSDictionary ??  NSDictionary.init()
            param["refnum"] = self.dictItem.object(forKey: "refnum") as? String ?? ""
            param["desc"] = self.dictItem.object(forKey: "desc") as? String ?? ""
            param["artist"] = self.dictItem.object(forKey: "artist") as? String ?? ""
            param["title"] = self.dictItem.object(forKey: "title") as? String ?? ""
            param["medium"] = self.dictItem.object(forKey: "medium") as? String ?? ""
            param["materials"] = self.dictItem.object(forKey: "materials") as? String ?? ""
            param["workCreatedTime"] = self.dictItem.object(forKey: "workCreatedTime") as? String ?? ""
            param["edition"] = self.dictItem.object(forKey: "edition") as? String ?? ""
            param["duration"] = self.dictItem.object(forKey: "duration") as? String ?? ""
            param["watermark"] = self.dictItem.object(forKey: "watermark") as? String ?? ""
            return param
        }
    }
    
    func paramCallAmpAsBuyerAPI()-> Parameters
    {
        if self.isBank
        {
            var param:Parameters = [:]
            param["transacId"] = self.dictItem.object(forKey: "transacId") as? String ?? ""
            param["buyerEsign"] = self.signature
            param["payments"] = self.paramBank()
            param["ampuser"] = self.dictItem.object(forKey: "ampuser") as? NSDictionary ??  NSDictionary.init()
            param["buyerInfo"] = APP_DELEGATE.inforUser ??  NSDictionary.init()
            param["roles"] = self.arrRoles
            param["attachments"] = self.dictItem.object(forKey: "attachments") as? NSDictionary ??  NSDictionary.init()
            param["refnum"] = self.dictItem.object(forKey: "refnum") as? String ?? ""
            param["desc"] = self.dictItem.object(forKey: "desc") as? String ?? ""
            param["artist"] = self.dictItem.object(forKey: "artist") as? String ?? ""
            param["title"] = self.dictItem.object(forKey: "title") as? String ?? ""
            param["medium"] = self.dictItem.object(forKey: "medium") as? String ?? ""
            param["materials"] = self.dictItem.object(forKey: "materials") as? String ?? ""
            param["workCreatedTime"] = self.dictItem.object(forKey: "workCreatedTime") as? String ?? ""
            param["edition"] = self.dictItem.object(forKey: "edition") as? String ?? ""
            param["duration"] = self.dictItem.object(forKey: "duration") as? String ?? ""
            param["watermark"] = self.dictItem.object(forKey: "watermark") as? String ?? ""
            param["actionCode"] = "5"
            param["buyerStatus"] = "declared:buyer"
            //param["provenanceWork"] = provenanceWork
            return param
        } else if self.isCry{
            var param:Parameters = [:]
            param["transacId"] = self.dictItem.object(forKey: "transacId") as? String ?? ""
            param["buyerEsign"] = self.signature
            param["payments"] = self.paramObjectCryCurreny()
            param["ampuser"] = self.dictItem.object(forKey: "ampuser") as? NSDictionary ??  NSDictionary.init()
            param["buyerInfo"] = APP_DELEGATE.inforUser ??  NSDictionary.init()
            param["roles"] = self.arrRoles
            param["attachments"] = self.dictItem.object(forKey: "attachments") as? NSDictionary ??  NSDictionary.init()
            param["refnum"] = self.dictItem.object(forKey: "refnum") as? String ?? ""
            param["desc"] = self.dictItem.object(forKey: "desc") as? String ?? ""
            param["artist"] = self.dictItem.object(forKey: "artist") as? String ?? ""
            param["title"] = self.dictItem.object(forKey: "title") as? String ?? ""
            param["medium"] = self.dictItem.object(forKey: "medium") as? String ?? ""
            param["materials"] = self.dictItem.object(forKey: "materials") as? String ?? ""
            param["workCreatedTime"] = self.dictItem.object(forKey: "workCreatedTime") as? String ?? ""
            param["edition"] = self.dictItem.object(forKey: "edition") as? String ?? ""
            param["duration"] = self.dictItem.object(forKey: "duration") as? String ?? ""
            param["watermark"] = self.dictItem.object(forKey: "watermark") as? String ?? ""
            param["actionCode"] = "5"
            param["buyerStatus"] = "declared:buyer"
            //param["provenanceWork"] = provenanceWork
            return param
        }
        
        else{
            var param:Parameters = [:]
            param["transacId"] = self.dictItem.object(forKey: "transacId") as? String ?? ""
            param["buyerEsign"] = self.signature
            param["payments"] = self.paramCreateCard()
            param["ampuser"] = self.dictItem.object(forKey: "ampuser") as? NSDictionary ??  NSDictionary.init()
            param["buyerInfo"] = APP_DELEGATE.inforUser ??  NSDictionary.init()
            param["roles"] = self.arrRoles
            param["attachments"] = self.dictItem.object(forKey: "attachments") as? NSDictionary ??  NSDictionary.init()
            param["refnum"] = self.dictItem.object(forKey: "refnum") as? String ?? ""
            param["desc"] = self.dictItem.object(forKey: "desc") as? String ?? ""
            param["artist"] = self.dictItem.object(forKey: "artist") as? String ?? ""
            param["title"] = self.dictItem.object(forKey: "title") as? String ?? ""
            param["medium"] = self.dictItem.object(forKey: "medium") as? String ?? ""
            param["materials"] = self.dictItem.object(forKey: "materials") as? String ?? ""
            param["workCreatedTime"] = self.dictItem.object(forKey: "workCreatedTime") as? String ?? ""
            param["edition"] = self.dictItem.object(forKey: "edition") as? String ?? ""
            param["duration"] = self.dictItem.object(forKey: "duration") as? String ?? ""
            param["watermark"] = self.dictItem.object(forKey: "watermark") as? String ?? ""
            param["actionCode"] = "5"
            param["buyerStatus"] = "declared:buyer"
           //  param["provenanceWork"] = provenanceWork
            return param
        }
    }
   
    func paramAPIMoreSetting()-> Parameters
    {
        var param:Parameters = [:]
        param["esign"] = self.signature
        param["roles"] = self.arrRoles
        if self.isBank
        {
            param["payments"] = self.paramBank()
        }
        else{
            param["payments"] = self.paramCreateCard()
        }
        return param
    }

    func paramAPIMoreSettingCry()-> Parameters
    {
        var param:Parameters = [:]
        param["payments"] = self.paramObjectCryCurreny()
        
        return param
    }
    
    func paramObjectCryCurreny() -> Parameters{
        var param:Parameters = [:]
        param["method"] = "crypto"
        param["cryptoName"] = self.txfCry.text!
        param["cryptoKey"] = self.txfPublicKey.text!
        
        
        return param
    }
}


extension FromPaymentDetailVC: UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txfCardNumber {
            let maxLength = 16
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
    }
}
