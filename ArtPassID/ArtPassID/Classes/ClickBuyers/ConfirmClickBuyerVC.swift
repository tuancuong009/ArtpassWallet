//
//  ConfirmClickBuyerVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 6/29/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit
import SafariServices
import Alamofire
class ConfirmClickBuyerVC: UIViewController {

    @IBOutlet weak var lblPayment: UILabel!
    @IBOutlet weak var lblInforBuyer: UILabel!
    var linkQrcode = ""
    var dictAMP: NSDictionary?
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.callAPII()
        self.getUserInfo()
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
    @IBAction func doOptionPurchase(_ sender: Any) {
        if let dict = self.dictAMP
        {
            if let ampuser = dict.object(forKey: "ampuser") as? NSDictionary
            {
                if let reportFile = ampuser.object(forKey: "buyer_purchase_rpFile") as? String
                {
                    let url = "\(URL_AVARTA)/\(reportFile)"
                     print("URL --->",url)
                    let vc = SFSafariViewController.init(url: URL.init(string: url)!)
                    self.present(vc, animated: true) {
                        
                    }
                }
            }
        }
    }
    @IBAction func doConfirm(_ sender: Any) {
        if self.dictAMP != nil
        {
            ApiHelper.shared.adduser(self.paramAPI()) { (success, error) in
                if success
                {
                    Common.savetransacId(self.dictAMP?.object(forKey: "transacId") as? String ?? "")
                    APP_DELEGATE.isRedirectActivity = true
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
    
    func paramAPI()-> Parameters
    {
        var param:Parameters = [:]
        param["transId"] = self.dictAMP?.object(forKey: "transacId") as? String ?? ""
        param["buyer"] = self.paramUser()
        return param
    }
    
    func paramUser()-> Parameters
    {
        var param:Parameters = [:]
        if let profileObj = APP_DELEGATE.profileObj
        {
            param["_id"] = profileObj._id
            param["fname"] = profileObj.fname
            param["lname"] = profileObj.lname
            if profileObj.company_info != nil {
                param["company_info"] = profileObj.company_info ?? NSDictionary.init()
            }
            param["kycAmlInfo"] = profileObj.kycAmlInfo
            param["amlReport"] = profileObj.amlReport ?? NSDictionary.init()
            param["connectRp"] = profileObj.connectRp ?? NSDictionary.init()
            param["addedTime"] = Date().timeIntervalSince1970
            param["status"] = "declared:buyer"
            param["username"] = profileObj.username
            param["payments"] = profileObj.payment ?? NSDictionary.init()
            param["avatar"] = profileObj.avatar
            param["createdAt"] = profileObj.createdAt
            param["esign"] = profileObj.dict?.object(forKey: "esign") as? String ?? ""
        }
       
        return param
    }
}

extension ConfirmClickBuyerVC
{
    
    
    private func getUserInfo()
    {
       // ApiHelper.shared.getUserInfo { (success,obj, error) in
            //if let profileObj = obj
            //{
                //APP_DELEGATE.profileObj = profileObj
                self.showInforUser()
            //}
            
        //}
    }
    
    func showInforUser()
    {
        
        if let profileObj = APP_DELEGATE.profileObj {
            print("profileObj.dict--->",profileObj.dict)
            if let seller = profileObj.dict
            {
                var textSeller = ""
                 if let roles = seller.object(forKey: "roles") as? [String]
               {
                   for role in roles
                   {
                       if role == "fOpts" {
                           textSeller = "\(textSeller)√ To purchase the work as the principal owner\n"
                       }
                       else if role == "sOpts" {
                           textSeller = "\(textSeller)√ To have the authority to purchase the work\n"
                       }
                       else{
                           textSeller = "\(textSeller)√ To purchase as the sole Ultimate Beneficial Owner (UBO)\n"
                       }
                   }
               }
               textSeller = "\(textSeller)Buyer's e-signature: \(seller.object(forKey: "esign") as? String ?? "")\n"
               if let signtime = seller.object(forKey: "verifyPhoneTime") as? Double
               {
                   let timeInterval = Double(signtime/1000)

                   // May 31, 2020 4:42:19 PM
                   let myNSDate = Date(timeIntervalSince1970: timeInterval)
                   let format = DateFormatter.init()
                   format.dateFormat = "EEE dd, yyyy hh:mm:ss a"
                   textSeller = "\(textSeller)Signed on: \(format.string(from: myNSDate))"
               }
                self.lblInforBuyer.text = textSeller
            }
            
            var bankBuyer = ""
            if let payments = profileObj.payment
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
                    else if method == "crypto" {
                        bankBuyer = "\(bankBuyer)\(payments.object(forKey: "cryptoName") as? String ?? "")\n"
                           bankBuyer = "\(bankBuyer)\(payments.object(forKey: "cryptoKey") as? String ?? "")\n"
                    }
                    else{
                        bankBuyer = "\(bankBuyer)\(payments.object(forKey: "cardIssuer") as? String ?? "")\n"
                           bankBuyer = "\(bankBuyer)\(payments.object(forKey: "cardName") as? String ?? "")\n"
                           bankBuyer = "\(bankBuyer)\(payments.object(forKey: "cardNumber") as? String ?? "")\n"
                           bankBuyer = "\(bankBuyer)\(payments.object(forKey: "cardDate") as? String ?? "")"
                    }
                }
            }
            self.lblPayment.text = bankBuyer
            self.lblInforBuyer.textColor = UIColor.white.withAlphaComponent(0.8)
            self.lblPayment.textColor = UIColor.white.withAlphaComponent(0.8)
        }
        
    }
}
