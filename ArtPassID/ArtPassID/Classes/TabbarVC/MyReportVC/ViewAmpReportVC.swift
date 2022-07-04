//
//  ViewAmpReportVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 6/9/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit
import SafariServices
import Alamofire
class ViewAmpReportVC: UIViewController {
var tapNotifications: (() ->())?
  @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    var itemBuyer = NSDictionary.init()
    var transationID = ""
    @IBOutlet weak var lblNavi: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblTitleFile: UILabel!
    @IBOutlet weak var btnAccess: UIButton!
    @IBOutlet weak var btnReject: UIButton!
    @IBOutlet weak var imgAvatar: UIImageView!
    var isAmpAsAmp = false
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

    @IBAction func doBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func doViewFile(_ sender: Any) {
        if self.isAmpAsAmp {
            if let reportFile = self.itemBuyer.object(forKey: "reportFile") as? String
            {
                let url = "\(URL_AVARTA)/\(reportFile)"
                 print("URL --->",url)
                let vc = SFSafariViewController.init(url: URL.init(string: url)!)
                self.present(vc, animated: true) {
                    
                }
            }
        }
        else{
          if let seller = itemBuyer.object(forKey: "seller") as? NSDictionary
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
       
    }
    
    @IBAction func doProceess(_ sender: Any) {
        if self.isAmpAsAmp {
            ApiHelper.shared.updatetransactionAmpAsBuyer(self.paramCallAmpAsAmp()) { (success, error) in
                if success
                {
                    if !APP_DELEGATE.actype.isEmpty {
                        ApiHelper.shared.addReadNotification(APP_DELEGATE.tracsationID, APP_DELEGATE.actype, APP_DELEGATE.notificationID) { (success, error) in
                           APP_DELEGATE.isRedirectActivity = true
                            self.navigationController?.popToRootViewController(animated: true)
                       }
                   }
                   else{
                        APP_DELEGATE.isRedirectActivity = true
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
        else{
            ApiHelper.shared.updatetransactionAmpAsBuyer(self.paramCallAPI()) { (success, error) in
                if success
                {
                    self.tapNotifications?()
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
    //POST: /api/kycaml/rejectRq/{ transacId }
    @IBAction func doRejectSeller(_ sender: Any) {
        if self.isAmpAsAmp
        {
            ApiHelper.shared.rejectTransaction(self.transationID) { (success, error) in
                if success
                {
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
        else{
            ApiHelper.shared.rejectProfile(self.itemBuyer.object(forKey: "transacId") as? String ?? "", "amp") { (success, error) in
                 if success
               {
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
    
    func updateUI()
    {
        
        imgAvatar.layer.cornerRadius = imgAvatar.frame.size.width/2
        imgAvatar.layer.masksToBounds = true
        if self.isAmpAsAmp {
            print("self.itemBuyer--->",self.itemBuyer)
            self.lblNavi.text = "VIEW BUYER REPORT"
            self.lblType.text = "Buyer"
            self.lblTitleFile.text = "VIEW BUYER REPORT"
            self.btnAccess.setTitle("ACCEPT BUYER REPORT", for: .normal)
            self.btnReject.setTitle("REJECT BUYER REPORT", for: .normal)
            if let username = self.itemBuyer.object(forKey: "username") as? String
            {
                self.lblUserName.text = "@\(username)"
            }
            else{
                self.lblUserName.text = ""
            }
            if let company_info = self.itemBuyer.object(forKey: "company") as? NSDictionary {
                self.lblName.text = company_info.object(forKey: "name") as? String
            }
            else{
                let firstName = self.itemBuyer.object(forKey: "fname") as? String ?? ""
                let lastName = self.itemBuyer.object(forKey: "lname") as? String ?? ""
                self.lblName.text = firstName + " " + lastName
            }
            if let avatar = self.itemBuyer.object(forKey: "avatar") as? String {
                //self.imgAvatar.image = Common.convertBase64ToImage(avatar)
                 Common.loadAvatarFromServer(avatar, self.imgAvatar)
            }
        }
        else{
            if let buyer = self.itemBuyer.object(forKey: "seller") as? NSDictionary
            {
                print("self.itemBuyer--->",buyer)
                
                if let username = buyer.object(forKey: "username") as? String
                {
                    self.lblUserName.text = "@\(username)"
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
    }

    func paramCallAPI()-> Parameters
    {
        var param:Parameters = [:]
        param["transacId"] = self.itemBuyer.object(forKey: "transacId") as? String ?? ""
      
        param["seller"] = self.itemBuyer.object(forKey: "seller") as? NSDictionary ??  NSDictionary.init()
        param["ampuser"] = self.itemBuyer.object(forKey: "ampuser") as? NSDictionary ??  NSDictionary.init()
        param["attachments"] = self.itemBuyer.object(forKey: "attachments") as? NSDictionary ??  NSDictionary.init()
        param["refnum"] = self.itemBuyer.object(forKey: "refnum") as? String ?? ""
        param["desc"] = self.itemBuyer.object(forKey: "desc") as? String ?? ""
        param["artist"] = self.itemBuyer.object(forKey: "artist") as? String ?? ""
        param["title"] = self.itemBuyer.object(forKey: "title") as? String ?? ""
        param["medium"] = self.itemBuyer.object(forKey: "medium") as? String ?? ""
        param["materials"] = self.itemBuyer.object(forKey: "materials") as? String ?? ""
        param["workCreatedTime"] = self.itemBuyer.object(forKey: "workCreatedTime") as? String ?? ""
        param["edition"] = self.itemBuyer.object(forKey: "edition") as? String ?? ""
        param["duration"] = self.itemBuyer.object(forKey: "duration") as? String ?? ""
        param["watermark"] = self.itemBuyer.object(forKey: "watermark") as? String ?? ""
        param["status"] = self.itemBuyer.object(forKey: "status") as? String ?? ""
        return param
    }
  
    func paramCallAmpAsAmp()-> Parameters
    {
        var param:Parameters = [:]
        param["transacId"] = self.transationID
        param["buyerStatus"] = "reviewed:amp"
        param["actionCode"] = "6"
        param["ampuser"] = self.itemBuyer.object(forKey: "ampuser") as? NSDictionary ??  NSDictionary.init()
        param["buyerId"] = self.itemBuyer.object(forKey: "_id") as? String ?? ""
        param["buyerInfo"] = self.itemBuyer
        return param
    }
}

