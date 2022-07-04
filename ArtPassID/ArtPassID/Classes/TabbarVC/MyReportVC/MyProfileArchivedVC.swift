//
//  MyProfileArchivedVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 3/3/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit
import SafariServices
class MyProfileArchivedVC: UIViewController {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    var userBuyer = ""
    var dictItem = NSDictionary.init()
    var profileObj = ProfileObj.init(NSDictionary.init())
    var isSent = false
    var isAmpBuyerAndSeller = false
    var isAmpAsBuyer = false
    var typeActivity = ""
    @IBOutlet weak var lblTranstion: UILabel!
    @IBOutlet weak var imgCell: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgAvatar.layer.cornerRadius = self.imgAvatar.frame.size.width/2
        self.imgAvatar.layer.masksToBounds = true
        //self.callAPI()
        print(dictItem)
        if self.isAmpAsBuyer
        {
            if let buyer = self.dictItem.object(forKey: "ampuser") as? NSDictionary
            {
                
                if let username = buyer.object(forKey: "username") as? String
                {
                    self.lblUserName.text = "With AMP @\(username)"
                }
                else{
                    self.lblUserName.text = ""
                }
                if let company_info = buyer.object(forKey: "company") as? NSDictionary {
                    self.lblName.text = company_info.object(forKey: "name") as? String
                }
                else{
                    let firstName = buyer.object(forKey: "fname") as? String ?? ""
                    let lastName = buyer.object(forKey: "lname") as? String ?? ""
                    self.lblName.text = firstName + " " + lastName
                }
                if let avatar = buyer.object(forKey: "avatar") as? String {
                    //self.imgAvatar.image = Common.convertBase64ToImage(avatar)
                    Common.loadAvatarFromServer(avatar, self.imgAvatar)
                }
            }
        }
        else if self.isAmpBuyerAndSeller {
            if let seller = dictItem.object(forKey: "ampuser") as? NSDictionary
           {
               if let username = seller.object(forKey: "username") as? String
               {
                    if self.typeActivity == TAG_ARRAY.ampAsBuyer {
                         self.lblUserName.text = "With AMP @\(username)"
                    }
                    else{
                         self.lblUserName.text = "With AMP @\(username)"
                    }
               }
               else{
                   self.lblUserName.text = "@"
               }
            if let company_info = seller.object(forKey: "company") as? NSDictionary {
                 self.lblName.text = company_info.object(forKey: "name") as? String
              }
              else{
                    let firstName = seller.object(forKey: "fname") as? String ?? ""
                    let lastName = seller.object(forKey: "lname") as? String ?? ""
                    self.lblName.text = firstName + " " + lastName
              }
               
               if let avatar = seller.object(forKey: "avatar") as? String {
                   //self.imgAvatar.image = Common.convertBase64ToImage(avatar)
                    Common.loadAvatarFromServer(avatar, self.imgAvatar)
               }
           }
        }
        else{
            if !self.isSent {
                
                if let seller = dictItem.object(forKey: "seller") as? NSDictionary
                {
                    if let username = seller.object(forKey: "username") as? String
                    {
                        self.lblUserName.text = "With seller @\(username)"
                    }
                    else{
                        self.lblUserName.text = "@"
                    }
                    let firstName = seller.object(forKey: "fname") as? String ?? ""
                    let lastName = seller.object(forKey: "lname") as? String ?? ""
                    self.lblName.text = firstName + " " + lastName
                    if let avatar = seller.object(forKey: "avatar") as? String {
                        //self.imgAvatar.image = Common.convertBase64ToImage(avatar)
                        Common.loadAvatarFromServer(avatar, self.imgAvatar)
                    }
                }
            }
            else{
               
                if let seller = dictItem.object(forKey: "buyer") as? NSDictionary
                {
                    if let username = seller.object(forKey: "username") as? String
                    {
                        self.lblUserName.text = "With buyer @\(username)"
                    }
                    else{
                        self.lblUserName.text = "@"
                    }
                    let firstName = seller.object(forKey: "fname") as? String ?? ""
                    let lastName = seller.object(forKey: "lname") as? String ?? ""
                    self.lblName.text = firstName + " " + lastName
                    if let avatar = seller.object(forKey: "avatar") as? String {
                        //self.imgAvatar.image = Common.convertBase64ToImage(avatar)
                        Common.loadAvatarFromServer(avatar, self.imgAvatar)
                    }
                }
              }
        }
        
        let refNumer = dictItem.object(forKey: "refnum") as? String ?? ""
        let updatedTime = dictItem.object(forKey: "updatedTime") as? Double ?? 0.0
        self.lblTranstion.text = "Transaction Nr: \(refNumer)\nCompleted on: \(self.convertDateTimeFromDouble(updatedTime))"

        if let attachments = dictItem.object(forKey: "attachments") as? NSDictionary
        {
            if let iPath = attachments.object(forKey: "iPath") as? String
            {
                let url = "\(URL_AVARTA)/\(iPath)"
                let replaceUrl  = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                self.imgCell.sd_setImage(with: URL.init(string: replaceUrl ?? "")) { (image, error, type, url) in
                    
                }
            }
            else{
                self.imgCell.image = nil
            }
        }
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
    @IBAction func doProfileReport(_ sender: Any) {
        if self.isAmpBuyerAndSeller {
            if self.typeActivity == TAG_ARRAY.ampAsBuyer {
                guard let transacId = dictItem.value(forKey: "transacId") as? String else {return}
                let url = "\(URL_TRANSACTION_BUYERANDSELLER_REPORT)\(transacId)/buyer"
                 print("URL --->",url)
                let vc = SFSafariViewController.init(url: URL.init(string: url)!)
                self.present(vc, animated: true) {
                    
                }
            }
            else{
                guard let transacId = dictItem.value(forKey: "transacId") as? String else {return}
                let url = "\(URL_TRANSACTION_BUYERANDSELLER_REPORT)\(transacId)/seller"
                 print("URL --->",url)
                let vc = SFSafariViewController.init(url: URL.init(string: url)!)
                self.present(vc, animated: true) {
                    
                }
            }
        }
        else{
            print(self.typeActivity)
            if self.typeActivity.isEmpty
            {
                guard let transacId = dictItem.value(forKey: "transacId") as? String else {return}
               let url = "\(URL_TRANSACTION_ARCHIVED)\(transacId)"
                print("URL --->",url)
               let vc = SFSafariViewController.init(url: URL.init(string: url)!)
               self.present(vc, animated: true) {
                   
               }
            }
            else{
                var role = ""
               if self.typeActivity == TAG_ARRAY.ampAsBuyer {
                   role = "buyer"
               }
               else{
                   role = "seller"
               }
               guard let transacId = dictItem.value(forKey: "transacId") as? String else {return}
                let url = "\(URL_TRANSACTION_BUYERANDSELLER_REPORT)\(transacId)/\(role)"
                 print("URL --->",url)
                let vc = SFSafariViewController.init(url: URL.init(string: url)!)
                self.present(vc, animated: true) {
                    
                }
            }
           
        }
       
    }
    
    @IBAction func doback(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func convertDateTimeFromDouble(_ time: Double) -> String
    {
        let date = Date.init(timeIntervalSince1970: TimeInterval(time)/1000)
        print("date - \(date)")
        let format = DateFormatter.init()
        format.dateFormat = "MM-dd-yyyy hh:mm:ss"
        return format.string(from: date)
    }
}
extension MyProfileArchivedVC
{
    func callAPI()
    {
//        if self.isSent {
//            self.lblUserName.text = "With buyer @\(self.userBuyer)"
//        }
//        else{
//            self.lblUserName.text = "With seller @\(self.userBuyer)"
//        }
        ApiHelper.shared.getDetailAcitivity(self.userBuyer) { (success, val, dict, error) in
            if let profileObj = val
            {
                self.profileObj = profileObj
                if profileObj.avatar.count > 0
                {
                      //self.imgAvatar.image = Common.convertBase64ToImage(profileObj.avatar)
                    Common.loadAvatarFromServer(profileObj.avatar, self.imgAvatar)
//                     self.imgAvatar.sd_setImage(with: URL.init(string: "\(URL_AVARTA)\(profileObj.avatar)")) { (image, eror, type, url) in
//
//                    }
                }
                self.lblName.text = profileObj.fname + " " + profileObj.lname
            }
        }
    }
}
