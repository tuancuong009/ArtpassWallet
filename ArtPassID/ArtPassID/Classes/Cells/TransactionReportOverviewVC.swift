//
//  TransactionReportOverviewVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 6/10/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit
import Alamofire
import SafariServices
class TransactionReportOverviewVC: UIViewController {

    @IBOutlet weak var imgCell: UIImageView!
    @IBOutlet weak var lblArticeName: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var lblInfoSeller: UILabel!
    @IBOutlet weak var lblInfoBuyer: UILabel!
    @IBOutlet weak var lblPaymentMethod: UILabel!
    @IBOutlet weak var txfPrice: UITextField!
    @IBOutlet weak var txfCurrency: UITextField!
    var dictItem = NSDictionary.init()
    var dictBuyer = NSDictionary.init()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
        // Do any additional setup after loading the view.
    }
    

    func updateUI()
    {
        if let attachments = self.dictItem.object(forKey: "attachments") as? NSDictionary
       {
           if let iPath = attachments.object(forKey: "iPath") as? String
           {
               let url = "\(URL_AVARTA)/\(iPath)"
               let replaceUrl  = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            self.imgCell.sd_setImage(with: URL.init(string: replaceUrl ?? "")) { (image, error, type, url) in
            
               }
           }
       }
        self.lblArticeName.text = dictItem.object(forKey: "artist") as? String
        self.lblName.text = dictItem.object(forKey: "title") as? String
        let medium = self.dictItem.object(forKey: "medium") as? String ?? ""
        let signed = self.dictItem.object(forKey: "watermark") as? String ?? ""
        let duration = self.dictItem.object(forKey: "duration") as? String ?? ""
        let workCreatedTime = self.dictItem.object(forKey: "workCreatedTime") as? String ?? ""
        self.lblInfo.text = "\(signed)\n\(medium)\n\(duration)\n\(workCreatedTime)"
        
        var textSeller = ""
        if let seller = self.dictItem.object(forKey: "seller") as? NSDictionary
        {
            
            if let roles = seller.object(forKey: "roles") as? [String]
            {
                for role in roles
                {
                    if role == "fOpts" {
                        textSeller = "\(textSeller)√ To be the principal owner of the work\n"
                    }
                    else if role == "sOpts" {
                        textSeller = "\(textSeller)√ To have the authority to sell the work\n"
                    }
                    else{
                        textSeller = "\(textSeller)√ To be the sole Ultimate Beneficial Owner (UBO) of the work\n"
                    }
                }
            }
            textSeller = "\(textSeller)Seller's e-signature: \(seller.object(forKey: "esign") as? String ?? "")\n"
            if let signtime = seller.object(forKey: "signtime") as? Double
            {
                let timeInterval = Double(signtime/1000)

                // May 31, 2020 4:42:19 PM
                let myNSDate = Date(timeIntervalSince1970: timeInterval)
                let format = DateFormatter.init()
                format.dateFormat = "EEE dd, yyyy hh:mm:ss a"
                textSeller = "\(textSeller)Signed on: \(format.string(from: myNSDate))"
            }
            //textSeller = "\(textSeller)\(seller.object(forKey: "reportFile") as? String ?? "")"
        }
        self.lblInfoSeller.text = textSeller
        var textBuyer = ""

        if let roles = self.dictBuyer.object(forKey: "roles") as? [String]
        {
            for role in roles
            {
                if role == "fOpts" {
                    textBuyer = "\(textBuyer)√ To be the principal owner of the work\n"
                }
                else if role == "sOpts" {
                    textBuyer = "\(textBuyer)√ To have the authority to sell the work\n"
                }
                else{
                    textBuyer = "\(textBuyer)√ To be the sole Ultimate Beneficial Owner (UBO) of the work\n"
                }
            }
        }
        textBuyer = "\(textBuyer)Seller's e-signature: \(self.dictBuyer.object(forKey: "esign") as? String ?? "")\n"
        if let signtime = self.dictBuyer.object(forKey: "signtime") as? Double
        {
            let timeInterval = Double(signtime/1000)

            // May 31, 2020 4:42:19 PM
            let myNSDate = Date(timeIntervalSince1970: timeInterval)
            let format = DateFormatter.init()
            format.dateFormat = "EEE dd, yyyy hh:mm:ss a"
            textBuyer = "\(textBuyer)Signed on: \(format.string(from: myNSDate))"
        }
       // textBuyer = "\(textBuyer)\(self.dictBuyer.object(forKey: "reportFile") as? String ?? "")"
        self.lblInfoBuyer.text = textBuyer
        
        var bankBuyer = ""
        if let payments = self.dictBuyer.object(forKey: "payments") as? NSDictionary
        {
            if let method = payments.object(forKey: "method") as? String
            {
                if method == "bank" {
                    bankBuyer = "\(bankBuyer)\(payments.object(forKey: "bankName") as? String ?? "")\n"
                    bankBuyer = "\(bankBuyer)\(payments.object(forKey: "accountNumber") as? String ?? "")\n"
                    bankBuyer = "\(bankBuyer)\(payments.object(forKey: "addr") as? String ?? "")\n"
                    bankBuyer = "\(bankBuyer)\(payments.object(forKey: "city") as? String ?? "")\n"
                    if let country = payments.object(forKey: "country") as? NSDictionary {
                        bankBuyer = "\(bankBuyer)\(country.object(forKey: "name") as? String ?? "")"
                    }
                }
                else{
                    bankBuyer = "\(bankBuyer)\(payments.object(forKey: "cardIssuer") as? String ?? "")\n"
                       bankBuyer = "\(bankBuyer)\(payments.object(forKey: "cardName") as? String ?? "")\n"
                       bankBuyer = "\(bankBuyer)\(payments.object(forKey: "cardNumber") as? String ?? "")\n"
                       bankBuyer = "\(bankBuyer)\(payments.object(forKey: "cardDate") as? String ?? "")"
                }
            }
        }
        self.lblPaymentMethod.text = bankBuyer
    }
    
    @IBAction func doSellerReport(_ sender: Any) {
        if let seller = self.dictItem.object(forKey: "seller") as? NSDictionary
        {
          if let file = seller.object(forKey: "reportFile") as? String {
            print("file --->",file)
              self.openSafari(file)
          }
            
        }
    }
    
    @IBAction func doBuyerReport(_ sender: Any) {
        print(self.dictBuyer)
        if let file = self.dictBuyer.object(forKey: "reportFile") as? String {
            print("doBuyerReport --->",file)
            self.openSafari(file)
        }
    }
    func openSafari(_ url: String)
    {
        let vc = SFSafariViewController.init(url: URL.init(string: "\(URL_AVARTA)/\(url)")!)
        self.present(vc, animated: true) {
            
        }
    }
    @IBAction func doCurency(_ sender: Any) {
        DPPickerManager.shared.showPicker(title: "CURRTENCY", selected: self.txfCurrency.text!, strings: ["EURO", "USD", "GBP", "CHF"]) { (val, index, success) in
            if !success
            {
                self.txfCurrency.text = val
            }
        }
    }
    @IBAction func doback(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func doCreate(_ sender: Any) {
        if self.txfPrice.text!.trim().isEmpty {
           APP_DELEGATE.showAlert("Sales price is required")
           return
       }
       if self.txfCurrency.text!.trim().isEmpty {
           APP_DELEGATE.showAlert("Currency price is required")
           return
       }
       self.view.endEditing(true)
        ApiHelper.shared.updatetransactionAmpAsBuyer(self.paramCallAPI()) { (success, error) in
            if success
            {
                if !APP_DELEGATE.actype.isEmpty {
                     ApiHelper.shared.addReadNotification(APP_DELEGATE.tracsationID, APP_DELEGATE.actype, APP_DELEGATE.notificationID) { (success, error) in
                        APP_DELEGATE.isRedirectArchived = true
                                       self.navigationController?.popToRootViewController(animated: true)
                    }
                }
                else{
                    APP_DELEGATE.isRedirectArchived = true
                    self.navigationController?.popToRootViewController(animated: true)
                }
               
            }
            else{
                if error != nil {
                    APP_DELEGATE.showAlert(error!.msg!)
                }
            }
        }
    }
    
    func paramCallAPI()-> Parameters
    {
         var param:Parameters = [:]
           param["transacId"] = self.dictItem.object(forKey: "transacId") as? String ?? ""
            param["step"] =  "complete"
        param["price"] = self.txfPrice.text!
        param["currency"] = self.txfCurrency.text!
           param["seller"] = self.dictItem.object(forKey: "seller") as? NSDictionary ??  NSDictionary.init()
        param["buyer"] = self.dictBuyer
         param["status"] =  "archived:amp"
         param["ampuser"] = self.dictItem.object(forKey: "ampuser") as? NSDictionary ??  NSDictionary.init()
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

