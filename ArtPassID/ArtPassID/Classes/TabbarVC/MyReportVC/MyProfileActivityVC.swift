//
//  MyProfileActivityVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 3/3/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit
import SafariServices
import Alamofire
class MyProfileActivityVC: UIViewController {
    var tapNotification: (() ->())?
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    var userBuyer = ""
    var textJoinBuyer = ""
    var dictItem = NSDictionary.init()
    var isSent = false
    @IBOutlet weak var lblNameTag: UILabel!
    @IBOutlet weak var viewSuccess: UIView!
    @IBOutlet weak var lbltype: UILabel!
    @IBOutlet weak var lblNavi: UILabel!
    @IBOutlet weak var viewReject: UIView!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var viewAccept: UIView!
    var _id = ""
    @IBOutlet weak var lblOpenReport: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgAvatar.layer.cornerRadius = self.imgAvatar.frame.size.width/2
        self.imgAvatar.layer.masksToBounds = true
        //self.callAPI()
        self.lblNameTag.text = "\(self.userBuyer) HAS BEEN"
        viewSuccess.isHidden = true
        self.lblNavi.text = "\(self.textJoinBuyer) PROFILE".uppercased()
        self.viewReject.isHidden = false
        self.viewAccept.isHidden = true
        if self.textJoinBuyer == "seller" {
            if let status = dictItem.object(forKey: "status") as? String
            {
                if status == STATUS_ACTIVITY.PEDDING {
                    self.viewAccept.isHidden = false
                    self.btnAccept.setTitle("PROCEED", for: .normal)
                }
                else{
                    self.lblNavi.text = "CHECK \(self.textJoinBuyer) PROFILE".uppercased()
                     self.btnAccept.setTitle("ACCEPT PROFILE", for: .normal)
                }
            }
            if let seller = dictItem.object(forKey: "seller") as? NSDictionary
            {
                print("seller--->",seller)
                if let username = seller.object(forKey: "username") as? String
                {
                    self.lblUserName.text = "@\(username)"
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
                   // self.imgAvatar.image = Common.convertBase64ToImage(avatar)
                    Common.loadAvatarFromServer(avatar, self.imgAvatar)
                }
                _id = seller.object(forKey: "_id") as? String ?? ""
            }
            self.lbltype.text = "\(self.textJoinBuyer)".lowercased()
        }
        else{
            if let status = dictItem.object(forKey: "status") as? String
            {
                if status == STATUS_ACTIVITY.ACCEPT_BUYER {
                    self.viewAccept.isHidden = false
                    self.lblNavi.text = "CHECK \(self.textJoinBuyer) PROFILE".uppercased()
                    self.btnAccept.setTitle("ACCEPT PROFILE", for: .normal)
                }
            }
            if let seller = dictItem.object(forKey: "buyer") as? NSDictionary
            {
                print("buyer--->",seller)
                if let username = seller.object(forKey: "username") as? String
                {
                    self.lblUserName.text = "@\(username)"
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
                    print("avatar--->",avatar)
                    //self.imgAvatar.image = Common.convertBase64ToImage(avatar)
                    Common.loadAvatarFromServer(avatar, self.imgAvatar)
                }
                _id = seller.object(forKey: "_id") as? String ?? ""
            }
            self.lbltype.text = "\(self.textJoinBuyer)".lowercased()
            
        }
        self.lblOpenReport.text = "VIEW \(self.textJoinBuyer.uppercased()) REPORT"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           Common.hideBusy()
       }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func doOpenReport(_ sender: Any) {
        if self.textJoinBuyer == "seller" {
            if let seller = dictItem.object(forKey: "seller") as? NSDictionary
            {
                if let reportFile = seller.object(forKey: "reportFile") as? String
                {
                    let url = "\(URL_AVARTA)/\(reportFile)"
                     print("URL --->",url)
                    let vc = SFSafariViewController.init(url: URL.init(string: url)!)
                    self.present(vc, animated: true) {
                        
                    }
                }
            }
        }
        else{
            if let buyer = dictItem.object(forKey: "buyer") as? NSDictionary
            {
                if let reportFile = buyer.object(forKey: "reportFile") as? String
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
    @IBAction func doAccepptProfile(_ sender: Any) {
        if self.textJoinBuyer == "seller" {
            if let status = dictItem.object(forKey: "status") as? String
            {
                if status == STATUS_ACTIVITY.PEDDING {
                    // CALL API CONFIRM
                    let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "PaymentDetailVC") as! PaymentDetailVC
                    vc.username = self.lblUserName.text!.replacingOccurrences(of: "@", with: "")
                    vc.dictItem = self.dictItem
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }else{
            if let status = dictItem.object(forKey: "status") as? String
            {
                if status == STATUS_ACTIVITY.ACCEPT_BUYER {
                   // CLICL PROCESS
                    ApiHelper.shared.sellerProcess(self.callAPISellerProccess()) { (success, error) in
                        if success
                        {
                            self.tapNotification?()
                            self.navigationController?.popViewController(animated: true)
                        }
                        else{
                            if error != nil {
                                APP_DELEGATE.showAlert(error!.msg!)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func redirectAccept()
    {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doback(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func doDecine(_ sender: Any) {
        if let transacId = dictItem.object(forKey: "transacId") as? String
        {
//            ApiHelper.shared.decineActivity(transacId) { (success, error) in
//                if success
//                {
//                    self.navigationController?.popViewController(animated: true)
//                }
//                else{
//                    if error != nil {
//                        APP_DELEGATE.showAlert(error!.msg!)
//                    }
//                }
//            }
            ApiHelper.shared.rejectProfile(transacId, "direct") { (success, error) in
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
    }
    
    func callAPISellerProccess()-> Parameters
    {
        var param: Parameters = [:]
        param["transacId"] = self.dictItem.object(forKey: "transacId") as? String ?? ""
        param["seller"] = self.dictItem.object(forKey: "seller") as? NSDictionary ??  NSDictionary.init()
        param["buyer"] = self.dictItem.object(forKey: "buyer") as? NSDictionary ??  NSDictionary.init()
        return param
    }
}

extension MyProfileActivityVC
{
    func callAPI()
    {
        //self.lblUserName.text = "With \(self.textJoinBuyer) @\(self.userBuyer)"
        print("self.userBuyer--->",self.userBuyer)
        ApiHelper.shared.getDetailAcitivity(self.userBuyer) { (success, val, dict, error) in
            if let profileObj = val
            {
               // self.dictU = dict!
               // self.profileObj = profileObj
                if profileObj.avatar.count > 0
                {
                        Common.loadAvatarFromServer(profileObj.avatar, self.imgAvatar)
                       //self.imgAvatar.image = Common.convertBase64ToImage(profileObj.avatar)
//                     self.imgAvatar.sd_setImage(with: URL.init(string: "\(URL_AVARTA)\(profileObj.avatar)")) { (image, eror, type, url) in
//
//                    }
                }
            }
        }
    }
}
