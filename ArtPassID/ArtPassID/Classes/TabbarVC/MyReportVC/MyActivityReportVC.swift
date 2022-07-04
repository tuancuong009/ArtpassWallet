//
//  MyActivityReportVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 3/2/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit
import Alamofire
import SafariServices
class MyActivityReportVC: UIViewController {

    @IBOutlet weak var tblActivity: UITableView!
    var arrDatas = [ActivityObj]()
    var arrNotifications = [NotificationObj]()
    var arrIDNotification = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tblActivity.register(UINib.init(nibName: "AmpSellerCell", bundle: nil), forCellReuseIdentifier: "AmpSellerCell")
        self.saveNotification()
        // Do any additional setup after loading the view.
    }
    
    
    func saveNotification()
    {
        arrIDNotification.removeAll()
        for item in self.arrNotifications
        {
            arrIDNotification.append(item.notifyId)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tblActivity.reloadData()
        self.callWSGetActivity()
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
    
    func openSafari(_ url: String)
    {
        let vc = SFSafariViewController.init(url: URL.init(string: "\(URL_AVARTA)/\(url)")!)
        self.present(vc, animated: true) {
            
        }
    }
}
extension MyActivityReportVC
{
    func sorterForFileIDASC(this:ActivityObj, that:ActivityObj) -> Bool {
      let thisDict = this.dict
      let thatDis = that.dict
      let updatedTimeThis = thisDict.object(forKey: "createdTime") as? Double ?? 0.0
      let updatedTimeThat = thatDis.object(forKey: "createdTime") as? Double ?? 0.0
      return updatedTimeThis > updatedTimeThat
    }
    
    func callWSGetActivity()
    {
        ApiHelper.shared.getActivity { (success, recs, sents, ampAsAmp ,ampAsBuyer , ampAsSeller , error) in
            self.arrDatas.removeAll()
            if let arrRecs = recs
            {
                for item in arrRecs
                {
                    let obj = ActivityObj.init()
                    obj.dict = item as! NSDictionary
                    //transacAsBuyer
                    obj.typeActivity = TAG_ARRAY.transacAsBuyer
                    if let status = obj.dict.object(forKey: "status") as? String {
                        if status == STATUS_ACTIVITY.ACCEPT_SELLER {
                            if let transacId = obj.dict.object(forKey: "transacId") as? String
                            {
                                self.readNotificationNoRemove(transacId)
                            }
                        }
                    }
                    self.arrDatas.append(obj)
                }
            }
            if let arrSents = sents
            {
                for item in arrSents
                {
                   let obj = ActivityObj.init()
                    obj.dict = item as! NSDictionary
                    obj.typeActivity = TAG_ARRAY.transacAsSeller
                    self.arrDatas.append(obj)
                }
            }
            if let arrampAsBuyer = ampAsBuyer
            {
                for item in arrampAsBuyer
                {
                    let dict = item as! NSDictionary
                   let obj = ActivityObj.init()
                    obj.dict = item as! NSDictionary
                    
                    if let buyers = dict.object(forKey: "buyers") as? [NSDictionary]
                    {
                        for buyer in buyers
                        {
                            let emailBuyer = buyer.object(forKey: "email") as? String ?? ""
                            let username =  buyer.object(forKey: "username") as? String ?? ""
                            if emailBuyer == APP_DELEGATE.profileObj?.email || username == APP_DELEGATE.profileObj?.username{
                                obj.dictAmpAsBuyer = buyer
                            }
                        }
                    }
                    obj.typeActivity = TAG_ARRAY.ampAsBuyer
                    self.arrDatas.append(obj)
                }
            }
            if let arrampAsSeller = ampAsSeller
            {
                for item in arrampAsSeller
                {
                   let obj = ActivityObj.init()
                    obj.dict = item as! NSDictionary
                    obj.typeActivity = TAG_ARRAY.ampAsSeller
                    self.arrDatas.append(obj)
                }
            }
            if let arrampAsAmp = ampAsAmp
           {
           
               for item in arrampAsAmp
               {
                  let obj = ActivityObj.init()
                   obj.dict = item as! NSDictionary
                   obj.typeActivity = TAG_ARRAY.ampAsAmp
                    self.arrDatas.append(obj)
               }
           }
            self.arrDatas = self.arrDatas.sorted(by: self.sorterForFileIDASC(this:that:))
            self.tblActivity.reloadData()
        }
    }
    
    
    func numerberNotification(_ id: String)-> Int
    {
        var number = 0
        for item in self.arrNotifications
        {
            if id == item.notifyId
            {
                number = number + 1
            }
        }
        return number
        
    }
    
}

extension MyActivityReportVC: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrDatas.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let obj = self.arrDatas[indexPath.row]
        let dict = self.arrDatas[indexPath.row].dict
        if obj.typeActivity == TAG_ARRAY.ampAsAmp {
            let status = dict.object(forKey: "status") as? String ?? ""
            
            if status == STATUS_AMPASAMP.AMPASAMP_60 || status == STATUS_AMPASAMP.AMPASAMP_DECLARING_BUYER_40 || status == STATUS_AMPASAMP.AMPASAMP_BUYER_60 || status == STATUS_AMPASAMP.AMPASAMP_BUYER_20
            {
                return 325
            }
        }
        return 295
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let obj = self.arrDatas[indexPath.row]
        if obj.typeActivity == TAG_ARRAY.ampAsAmp {
           //transacId
            let dict = self.arrDatas[indexPath.row].dict
            print("ID--->",dict.object(forKey: "_id") as? String ?? "")
            let status = dict.object(forKey: "status") as? String ?? ""
            if status == STATUS_AMPASAMP.AMPASAMP_60
            {
                let cell = self.tblActivity.dequeueReusableCell(withIdentifier: "AmpSellerCell") as! AmpSellerCell
                self.configCellAmpViewSeller(cell, self.arrDatas[indexPath.row].dict, self.arrDatas[indexPath.row])
                cell.tapAddProspect = { [] in
                   
                    let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "AddProspectBuyerVC") as! AddProspectBuyerVC
                    vc.dictItem = dict
                    vc.tapNotifications = { [] in
                        if let transacId = obj.dict.object(forKey: "transacId") as? String
                       {
                           self.readNotification(transacId)
                       }
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                cell.tapViewSeller = { [] in
                    if let transacId = obj.dict.object(forKey: "transacId") as? String
                    {
                        self.readNotification(transacId)
                    }
                    if let seller = dict.object(forKey: "seller") as? NSDictionary
                    {
                        if let reportFile = seller.object(forKey: "reportFile") as? String
                        {
                            self.openSafari(reportFile)
                        }
                    }
                }
                if let transacId = dict.object(forKey: "transacId") as? String
                {
                    if self.arrIDNotification.contains(transacId)
                    {
                        cell.viewNotification.isHidden = false
                        cell.lblNumberActivity.text = "\(self.numerberNotification(transacId))"
                    }
                    else{
                        cell.viewNotification.isHidden = true
                    }
                }
                return cell
            }
            else if status == STATUS_AMPASAMP.AMPASAMP_DECLARING_BUYER_40 || status == STATUS_AMPASAMP.AMPASAMP_BUYER_60 || status == STATUS_AMPASAMP.AMPASAMP_BUYER_20
            {
                let cell = self.tblActivity.dequeueReusableCell(withIdentifier: "AmpSellerCell") as! AmpSellerCell
                self.configCellAmpViewSeller(cell, self.arrDatas[indexPath.row].dict, self.arrDatas[indexPath.row])
                cell.tapAddProspect = { [] in
                    
                    let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "AddProspectBuyerVC") as! AddProspectBuyerVC
                    vc.dictItem = dict
                    vc.tapNotifications = { [] in
                        if let transacId = obj.dict.object(forKey: "transacId") as? String
                        {
                            self.readNotification(transacId)
                        }
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                 cell.tapViewProspect = { [] in
                   
                   let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "BuyerActivityVC") as! BuyerActivityVC
                   vc.dictItem = dict
                    vc.arrNotification = self.arrNotifications
                   self.navigationController?.pushViewController(vc, animated: true)
               }
                cell.tapViewSeller = { [] in
                   if let seller = dict.object(forKey: "seller") as? NSDictionary
                   {
                       if let reportFile = seller.object(forKey: "reportFile") as? String
                       {
                            if let transacId = obj.dict.object(forKey: "transacId") as? String
                            {
                                self.readNotification(transacId)
                            }
                           self.openSafari(reportFile)
                       }
                   }
               }
                if let transacId = dict.object(forKey: "transacId") as? String
                {
                    if self.arrIDNotification.contains(transacId)
                    {
                        cell.viewNotification.isHidden = false
                         cell.lblNumberActivity.text = "\(self.numerberNotification(transacId))"
                    }
                    else{
                        cell.viewNotification.isHidden = true
                    }
                }
                return cell
            }
            else{
                let cell = self.tblActivity.dequeueReusableCell(withIdentifier: "ActivityReportCell") as! ActivityReportCell
                self.configCellampAsAmp(cell, self.arrDatas[indexPath.row].dict, self.arrDatas[indexPath.row])
                cell.tapViewProfile = { [] in
                    if status == STATUS_AMPASAMP.AMPASAMP_20
                    {

                    }
                    else if status == STATUS_AMPASAMP.AMPASAMP_BUYER_20 {
                        
                    }
                    
                    else if status == STATUS_AMPASAMP.AMPASAMP_40
                    {
                          
                          let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "ViewAmpReportVC") as! ViewAmpReportVC
                          vc.itemBuyer = dict
                          vc.tapNotifications = { [] in
                            if let transacId = obj.dict.object(forKey: "transacId") as? String
                            {
                                self.readNotification(transacId)
                            }
                          }
                          self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                if let transacId = dict.object(forKey: "transacId") as? String
                {
                    if self.arrIDNotification.contains(transacId)
                    {
                        cell.viewNotification.isHidden = false
                    }
                    else{
                        cell.viewNotification.isHidden = true
                    }
                }
                return cell
            }
                
        }
        else{
            print("ID--->",obj.dict.object(forKey: "_id") as? String ?? "")
            let cell = self.tblActivity.dequeueReusableCell(withIdentifier: "ActivityReportCell") as! ActivityReportCell
               if obj.typeActivity == TAG_ARRAY.ampAsBuyer {
                   self.configCellampAsBuyer(cell, self.arrDatas[indexPath.row].dict, self.arrDatas[indexPath.row])
                   cell.tapViewProfile = { [] in
                       let dict = self.arrDatas[indexPath.row].dictAmpAsBuyer
                       if let status = dict.object(forKey: "status") as? String {
                           if status == STATUS_AMPASBUYER.AMPASBUYER_20
                           {
                              if let transacId = obj.dict.object(forKey: "transacId") as? String
                              {
                                    APP_DELEGATE.tracsationID = transacId
                                    APP_DELEGATE.actype = self.getValueActype(transacId)
                                APP_DELEGATE.notificationID = self.getValueNotificationID(transacId)
                                  //self.readNotification(transacId)
                              }
                            
                              let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "AmpAsBuyerVC") as! AmpAsBuyerVC
                                vc.itemBuyer = self.arrDatas[indexPath.row].dict
                              self.navigationController?.pushViewController(vc, animated: true)
                           }
                           else if status == STATUS_AMPASBUYER.AMPASBUYER_40
                           {
                               
                           }
                           else{
                              if let transacId = obj.dict.object(forKey: "transacId") as? String
                              {
                                  self.readNotification(transacId)
                              }
                            if let reportFile = obj.dictAmpAsBuyer.object(forKey: "reportFile") as? String
                            {
                                self.openSafari(reportFile)
                            }
                           }
                       }
                   }
               }
               else if obj.typeActivity == TAG_ARRAY.ampAsSeller {
                   self.configCellampAsSeller(cell, self.arrDatas[indexPath.row].dict, self.arrDatas[indexPath.row])
                   cell.tapViewProfile = { [] in
                       let dict = self.arrDatas[indexPath.row].dict
                       if let status = dict.object(forKey: "status") as? String {
                           if status == STATUS_AMPASSELLER.AMPASSELLER_20
                           {
//                                if let transacId = obj.dict.object(forKey: "transacId") as? String
//                                {
//                                    self.readNotification(transacId)
//                                }
                                if let transacId = obj.dict.object(forKey: "transacId") as? String
                                {
                                      APP_DELEGATE.tracsationID = transacId
                                      APP_DELEGATE.actype = self.getValueActype(transacId)
                                    APP_DELEGATE.notificationID = self.getValueNotificationID(transacId)
                                    //self.readNotification(transacId)
                                }
                              let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "AmpAsBuyerVC") as! AmpAsBuyerVC
                              vc.itemBuyer = dict
                               vc.isAmpAsSeller = true
                              self.navigationController?.pushViewController(vc, animated: true)
                           }
                            else if  status == STATUS_AMPASSELLER.AMPASSELLER_BUYER_20
                           {
                            
                           }
                           else if status == STATUS_AMPASSELLER.AMPASSELLER_40
                           {
                               
                           }
                           else{
                                if let transacId = obj.dict.object(forKey: "transacId") as? String
                                {
                                    self.readNotification(transacId)
                                }
                              if let seller = dict.object(forKey: "seller") as? NSDictionary
                              {
                                  if let reportFile = seller.object(forKey: "reportFile") as? String
                                  {
                                      self.openSafari(reportFile)
                                  }
                              }
                           }
                       }
                   }
               }
               else{
                   self.configCell(cell, self.arrDatas[indexPath.row].dict, self.arrDatas[indexPath.row])
                   cell.tapViewProfile = { [] in
                       if let status = obj.dict.object(forKey: "status") as? String {
                          if obj.typeActivity == TAG_ARRAY.transacAsSeller {
                              if status == STATUS_ACTIVITY.PEDDING {
                                  //cell.btnReview.setTitle("PENDING ACCEPTANCE", for: .normal)
                                  //cell.subBG.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_XANH)
                              }
                              else if status == STATUS_ACTIVITY.ACCEPT_BUYER {
                                    
                                    if let transacId = obj.dict.object(forKey: "transacId") as? String
                                    {
                                          APP_DELEGATE.tracsationID = transacId
                                          APP_DELEGATE.actype = self.getValueActype(transacId)
                                        APP_DELEGATE.notificationID = self.getValueNotificationID(transacId)
                                    }
                                   if let buyerId = obj.dict.object(forKey: "buyer") as? NSDictionary
                                   {
                                      let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "MyProfileActivityVC") as! MyProfileActivityVC
                                      vc.userBuyer = buyerId.object(forKey: "username") as? String ?? ""
                                      vc.dictItem = obj.dict
                                      vc.textJoinBuyer = "buyer"
                                      vc.isSent = true
                                        vc.tapNotification = { [] in
                                              if let transacId = obj.dict.object(forKey: "transacId") as? String
                                             {
                                                 self.readNotification(transacId)
                                             }
                                        }
                                      self.navigationController?.pushViewController(vc, animated: true)
                                   }
                              }
                              else if status == STATUS_ACTIVITY.ACCEPT_SELLER {
                                 
                                    if let transacId = obj.dict.object(forKey: "transacId") as? String
                                    {
                                        APP_DELEGATE.tracsationID = transacId
                                        APP_DELEGATE.actype = self.getValueActype(transacId)
                                        APP_DELEGATE.notificationID = self.getValueNotificationID(transacId)
                                    }
                                        let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "PriceTransationVC") as! PriceTransationVC
                                        vc.dictItem = obj.dict
                                        self.navigationController?.pushViewController(vc, animated: true)
                                    }
                              
                          }
                          // NGUOC LAI
                          else{
                              
                              if status == STATUS_ACTIVITY.PEDDING {
                                   if let transacId = obj.dict.object(forKey: "transacId") as? String
                                   {
                                         APP_DELEGATE.tracsationID = transacId
                                         APP_DELEGATE.actype = self.getValueActype(transacId)
                                        APP_DELEGATE.notificationID = self.getValueNotificationID(transacId)
                                   }
                                   if let seller = obj.dict.object(forKey: "seller") as? NSDictionary
                                   {
                                       let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "MyProfileActivityVC") as! MyProfileActivityVC
                                      vc.userBuyer = seller.object(forKey: "username") as? String ?? ""
                                       vc.dictItem = obj.dict
                                      vc.textJoinBuyer = "seller"
                                      vc.isSent = false
                                      vc.tapNotification = { [] in
                                            if let transacId = obj.dict.object(forKey: "transacId") as? String
                                           {
                                               self.readNotification(transacId)
                                           }
                                      }
                                       self.navigationController?.pushViewController(vc, animated: true)
                                   }
                                  
                              }
                              else if status == STATUS_ACTIVITY.ACCEPT_BUYER {
                                 
                              }
                              else if status == STATUS_ACTIVITY.ACCEPT_SELLER {
                                  
                              }
                          }
                      }
                  }
                  cell.tapDecine = { [] in
                      if let transacId = obj.dict.object(forKey: "transacId") as? String
                      {
                          ApiHelper.shared.decineActivity(transacId) { (success, error) in
                              if success
                              {
                                  self.arrDatas.remove(at: indexPath.row)
                                  self.tblActivity.reloadData()
                              }
                              else{
                                  if error != nil {
                                      APP_DELEGATE.showAlert(error!.msg!)
                                  }
                              }
                          }
                      }
                  }
                  cell.tapAccept = { [] in
                      
                  }
               }
            if let transacId = obj.dict.object(forKey: "transacId") as? String
            {
                if obj.typeActivity == TAG_ARRAY.ampAsBuyer
                {
                    if let status = obj.dict.object(forKey: "status") as? String {
                        if status == STATUS_AMPASBUYER.AMPASBUYER_40
                        {
                            cell.viewNotification.isHidden = true
                        }
                        else{
                            if self.arrIDNotification.contains(transacId)
                            {
                                cell.viewNotification.isHidden = false
                            }
                            else{
                                cell.viewNotification.isHidden = true
                            }
                        }
                    }
                }
                else{
                    if self.arrIDNotification.contains(transacId)
                    {
                        cell.viewNotification.isHidden = false
                    }
                    else{
                        cell.viewNotification.isHidden = true
                    }
                }
               
            }
           return cell
        }
    }
    func readNotification(_ id: String)
    {
        var indexP = 0
        for item in self.arrIDNotification
        {
            if item == id
            {
                self.arrIDNotification.remove(at: indexP)
                break
            }
            indexP = indexP + 1
        }
        if self.arrIDNotification.count > 0
        {
            self.tabBarController?.tabBar.items![2].badgeValue = "\(self.arrIDNotification.count)"
        }
        else{
             self.tabBarController?.tabBar.items![2].badgeValue = nil
        }
        if !self.getValueActype(id).isEmpty {
            ApiHelper.shared.addReadNotification(id, self.getValueActype(id), self.getValueNotificationID(id)) { (success, error) in
                
            }
        }
        
    }
    
    func readNotificationNoRemove(_ id: String)
    {
        if !self.getValueActype(id).isEmpty {
            ApiHelper.shared.addReadNotification(id, self.getValueActype(id), self.getValueNotificationID(id)) { (success, error) in
                
            }
        }
        
    }
    
    func getValueActype(_ id: String)-> String
    {
        for item in self.arrNotifications
        {
            if  item.notifyId == id {
                return item.actType
            }
        }
        return ""
    }
    
    func getValueNotificationID(_ id: String)-> String
    {
        for item in self.arrNotifications
        {
            if  item.notifyId == id {
                return item.id
            }
        }
        return ""
    }
    func configCell(_ cell: ActivityReportCell, _ dict: NSDictionary, _ activityObj: ActivityObj)
    {
        if activityObj.typeActivity == TAG_ARRAY.transacAsSeller {
            cell.lblTransation.text = "Transaction as seller"
        }
        else{
            cell.lblTransation.text = "Transaction as buyer"
        }
        
        if let attachments = dict.object(forKey: "attachments") as? NSDictionary
        {
            if let iPath = attachments.object(forKey: "iPath") as? String
            {
                cell.indicator.isHidden = false
                cell.indicator.startAnimating()
                let url = "\(URL_AVARTA)/\(iPath)"
                let replaceUrl  = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                cell.imgCell.sd_setImage(with: URL.init(string: replaceUrl ?? "")) { (image, error, type, url) in
                    cell.indicator.stopAnimating()
                    cell.indicator.isHidden = true
                }
            }
            else{
                cell.indicator.stopAnimating()
                cell.imgCell.image = nil
                cell.indicator.isHidden = true
            }
        }
        if let status = dict.object(forKey: "status") as? String {
            if activityObj.typeActivity == TAG_ARRAY.transacAsSeller {
                if let buyer = dict.object(forKey: "buyer") as? NSDictionary
                {
                    
                    if let username = buyer.object(forKey: "username") as? String
                    {
                        cell.lblUsername.text = "With buyer @\(username)"
                    }
                    else{
                        cell.lblUsername.text = "@"
                    }
                    if let company_info = buyer.object(forKey: "company") as? NSDictionary {
                        cell.lblFullName.text = company_info.object(forKey: "name") as? String
                    }
                    else{
                        let firstName = buyer.object(forKey: "fname") as? String ?? ""
                        let lastName = buyer.object(forKey: "lname") as? String ?? ""
                        cell.lblFullName.text = firstName + " " + lastName
                    }
                    
                }
                
                if status == STATUS_ACTIVITY.PEDDING {
                    cell.lblPercent.text = "25%"
                    cell.widthPercent.constant = (UIScreen.main.bounds.size.width - 80)/4
                    cell.viewProfile.isHidden = false
                    cell.viewAction.isHidden = true
                    cell.btnReview.setTitle("PENDING BUYER UPDATE", for: .normal)
                    cell.subBG.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_XAM)
                    cell.viewNotification.isHidden = true
                    
                }
                else if status == STATUS_ACTIVITY.ACCEPT_BUYER {
                    cell.lblPercent.text = "50%"
                    cell.widthPercent.constant = (UIScreen.main.bounds.size.width - 80)/4 * 2
                    cell.viewProfile.isHidden = false
                    cell.viewAction.isHidden = true
                    cell.btnReview.setTitle("VIEW BUYER PROFILE", for: .normal)
                    cell.subBG.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_TIM)
                    cell.viewNotification.isHidden = true
                   
                }
                else if status == STATUS_ACTIVITY.ACCEPT_SELLER {
                    cell.lblPercent.text = "75%"
                    cell.widthPercent.constant = (UIScreen.main.bounds.size.width - 80)/4 * 3
                    cell.viewProfile.isHidden = false
                    cell.viewAction.isHidden = true
                    cell.btnReview.setTitle("COMPLETE TRANSACTION REPORT", for: .normal)
                    cell.subBG.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_TIM)
                    cell.viewNotification.isHidden = true
                }
                else{
                    cell.lblPercent.text = "100%"
                    cell.widthPercent.constant =  UIScreen.main.bounds.size.width - 80
                    cell.viewProfile.isHidden = true
                    cell.viewAction.isHidden = true
                    cell.viewNotification.isHidden = true
                }
            }
            // NGUOC LAI
            else{
                if let seller = dict.object(forKey: "seller") as? NSDictionary
                {
                    
                    if let username = seller.object(forKey: "username") as? String
                    {
                        cell.lblUsername.text = "With seller @\(username)"
                    }
                    else{
                        cell.lblUsername.text = "@"
                    }
                    if let company_info = seller.object(forKey: "company") as? NSDictionary {
                        cell.lblFullName.text = company_info.object(forKey: "name") as? String
                    }
                    else{
                        let firstName = seller.object(forKey: "fname") as? String ?? ""
                        let lastName = seller.object(forKey: "lname") as? String ?? ""
                        cell.lblFullName.text = firstName + " " + lastName
                    }
                    
                }
               
                if status == STATUS_ACTIVITY.PEDDING {
                    cell.lblPercent.text = "25%"
                    cell.widthPercent.constant = (UIScreen.main.bounds.size.width - 80)/4
                    cell.viewProfile.isHidden = false
                    cell.viewAction.isHidden = true
                    cell.btnReview.setTitle("VIEW SELLER PROFILE", for: .normal)
                    cell.subBG.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_TIM)
                    cell.viewNotification.isHidden = true
                    
                }
                else if status == STATUS_ACTIVITY.ACCEPT_BUYER {
                    cell.lblPercent.text = "50%"
                    cell.widthPercent.constant = (UIScreen.main.bounds.size.width - 80)/4 * 2
                    cell.viewProfile.isHidden = false
                    cell.viewAction.isHidden = true
                    cell.btnReview.setTitle("PENDING SELLER UPDATE", for: .normal)
                    cell.subBG.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_XAM)
                    cell.viewNotification.isHidden = true
                   
                }
                else if status == STATUS_ACTIVITY.ACCEPT_SELLER {
                    cell.lblPercent.text = "75%"
                    cell.widthPercent.constant = (UIScreen.main.bounds.size.width - 80)/4 * 3
                    cell.viewProfile.isHidden = false
                    cell.viewAction.isHidden = true
                    cell.btnReview.setTitle("PENDING SELLER UPDATE", for: .normal)
                    cell.subBG.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_XAM)
                    cell.viewNotification.isHidden = true
                }
                else{
                    cell.lblPercent.text = "100%"
                    cell.widthPercent.constant =  UIScreen.main.bounds.size.width - 80
                    cell.viewProfile.isHidden = true
                    cell.viewAction.isHidden = true
                    cell.viewNotification.isHidden = true
                }
            }
        }
    }
  
    func configCellampAsBuyer(_ cell: ActivityReportCell, _ dict: NSDictionary, _ activityObj: ActivityObj)
    {
        cell.lblTransation.text = "Transaction as buyer"
        if let attachments = dict.object(forKey: "attachments") as? NSDictionary
        {
            if let iPath = attachments.object(forKey: "iPath") as? String
            {
                cell.indicator.isHidden = false
                cell.indicator.startAnimating()
                let url = "\(URL_AVARTA)/\(iPath)"
                let replaceUrl  = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                cell.imgCell.sd_setImage(with: URL.init(string: replaceUrl ?? "")) { (image, error, type, url) in
                    cell.indicator.stopAnimating()
                    cell.indicator.isHidden = true
                }
            }
            else{
                cell.indicator.stopAnimating()
                cell.imgCell.image = nil
                cell.indicator.isHidden = true
            }
        }
        if let buyer = dict.object(forKey: "ampuser") as? NSDictionary
        {
            
            print("buyer--->")
            if let username = buyer.object(forKey: "username") as? String
            {
                cell.lblUsername.text = "With AMP @\(username)"
            }
            else{
                cell.lblUsername.text = "@"
            }
            if let company_info = buyer.object(forKey: "company") as? NSDictionary {
                cell.lblFullName.text = company_info.object(forKey: "name") as? String
            }
            else{
                let firstName = buyer.object(forKey: "fname") as? String ?? ""
                let lastName = buyer.object(forKey: "lname") as? String ?? ""
                cell.lblFullName.text = firstName + " " + lastName
            }
            
        }
        cell.viewNotification.isHidden = true
        cell.viewAction.isHidden = true
        if let status = activityObj.dictAmpAsBuyer.object(forKey: "status") as? String {
            if status == STATUS_AMPASBUYER.AMPASBUYER_20
            {
                cell.lblPercent.text = "20%"
                cell.widthPercent.constant = (UIScreen.main.bounds.size.width - 80)/5
              
                cell.btnReview.setTitle(" COMPLETE BUYER REPORT", for: .normal)
                cell.subBG.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_TIM)
            }
            else if status == STATUS_AMPASBUYER.AMPASBUYER_40
            {
                cell.lblPercent.text = "40%"
                  cell.widthPercent.constant = (UIScreen.main.bounds.size.width - 80)/5 * 2
                
                  cell.btnReview.setTitle(" PENDING AMP ACCEPTANCE", for: .normal)
                  cell.subBG.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_XAM)
            }
            else{
                cell.lblPercent.text = "60%"
                  cell.widthPercent.constant = (UIScreen.main.bounds.size.width - 80)/5 * 3
                
                  cell.btnReview.setTitle(" PENDING AMP TRANSACTION", for: .normal)
                  cell.subBG.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_XANH)
            }
        }
    }
    
    func configCellampAsSeller(_ cell: ActivityReportCell, _ dict: NSDictionary, _ activityObj: ActivityObj)
    {
        cell.lblTransation.text = "Transaction as seller"
        if let attachments = dict.object(forKey: "attachments") as? NSDictionary
        {
            if let iPath = attachments.object(forKey: "iPath") as? String
            {
                cell.indicator.isHidden = false
                cell.indicator.startAnimating()
                let url = "\(URL_AVARTA)/\(iPath)"
                let replaceUrl  = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                cell.imgCell.sd_setImage(with: URL.init(string: replaceUrl ?? "")) { (image, error, type, url) in
                    cell.indicator.stopAnimating()
                    cell.indicator.isHidden = true
                }
            }
            else{
                cell.indicator.stopAnimating()
                cell.imgCell.image = nil
                cell.indicator.isHidden = true
            }
        }
        if let buyer = dict.object(forKey: "ampuser") as? NSDictionary
        {
            
            print("buyer--->")
            if let username = buyer.object(forKey: "username") as? String
            {
                cell.lblUsername.text = "With AMP @\(username)"
            }
            else{
                cell.lblUsername.text = "@"
            }
            if let company_info = buyer.object(forKey: "company") as? NSDictionary {
                cell.lblFullName.text = company_info.object(forKey: "name") as? String
            }
            else{
                let firstName = buyer.object(forKey: "fname") as? String ?? ""
                let lastName = buyer.object(forKey: "lname") as? String ?? ""
                cell.lblFullName.text = firstName + " " + lastName
            }
            
        }
        cell.viewNotification.isHidden = true
        cell.viewAction.isHidden = true
        if let status = dict.object(forKey: "status") as? String {
            if status == STATUS_AMPASSELLER.AMPASSELLER_20
            {
                cell.lblPercent.text = "20%"
                cell.widthPercent.constant = (UIScreen.main.bounds.size.width - 80)/5
              
                cell.btnReview.setTitle("COMPLETE SELLER REPORT", for: .normal)
                cell.subBG.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_TIM)
            }
            else if status == STATUS_AMPASSELLER.AMPASSELLER_BUYER_20
            {
                cell.lblPercent.text = "60%"
                 cell.widthPercent.constant = (UIScreen.main.bounds.size.width - 80)/5 * 3
               
                 cell.btnReview.setTitle(" PENDING AMP TRANSACTION", for: .normal)
                 cell.subBG.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_XAM)
            }
            else if status == STATUS_AMPASSELLER.AMPASSELLER_40
            {
                cell.lblPercent.text = "40%"
                  cell.widthPercent.constant = (UIScreen.main.bounds.size.width - 80)/5 * 2
                
                  cell.btnReview.setTitle("PENDING AMP ACCEPTANCE", for: .normal)
                  cell.subBG.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_XAM)
            }
           
            else{
                cell.lblPercent.text = "60%"
                  cell.widthPercent.constant = (UIScreen.main.bounds.size.width - 80)/5 * 3
                
                  cell.btnReview.setTitle("VIEW SELLER REPORT", for: .normal)
                  cell.subBG.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_XANH)
            }
        }
    }
    
    func configCellampAsAmp(_ cell: ActivityReportCell, _ dict: NSDictionary, _ activityObj: ActivityObj)
       {
           cell.lblTransation.text = "Transaction as AMP"
           if let attachments = dict.object(forKey: "attachments") as? NSDictionary
           {
               if let iPath = attachments.object(forKey: "iPath") as? String
               {
                   cell.indicator.isHidden = false
                   cell.indicator.startAnimating()
                   let url = "\(URL_AVARTA)/\(iPath)"
                   let replaceUrl  = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                   cell.imgCell.sd_setImage(with: URL.init(string: replaceUrl ?? "")) { (image, error, type, url) in
                       cell.indicator.stopAnimating()
                       cell.indicator.isHidden = true
                   }
               }
               else{
                   cell.indicator.stopAnimating()
                   cell.imgCell.image = nil
                   cell.indicator.isHidden = true
               }
           }
           if let buyer = dict.object(forKey: "seller") as? NSDictionary
           {
               
               print("buyer--->", buyer)
               if let username = buyer.object(forKey: "username") as? String
               {
                   cell.lblUsername.text = "With seller @\(username)"
               }
               else{
                   cell.lblUsername.text = "@"
               }
               if let company_info = buyer.object(forKey: "company") as? NSDictionary {
                   cell.lblFullName.text = company_info.object(forKey: "name") as? String
               }
               else{
                   let firstName = buyer.object(forKey: "fname") as? String ?? ""
                   let lastName = buyer.object(forKey: "lname") as? String ?? ""
                   cell.lblFullName.text = firstName + " " + lastName
               }
               
           }
           cell.viewNotification.isHidden = true
           cell.viewAction.isHidden = true
           if let status = dict.object(forKey: "status") as? String {
            if status == STATUS_AMPASAMP.AMPASAMP_20 || status == STATUS_AMPASAMP.AMPASAMP_BUYER_20
               {
                   cell.lblPercent.text = "20%"
                   cell.widthPercent.constant = (UIScreen.main.bounds.size.width - 80)/5
                 
                   cell.btnReview.setTitle("PENDING SELLER REPLY", for: .normal)
                   cell.subBG.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_XAM)
               }
               else if status == STATUS_AMPASAMP.AMPASAMP_40
               {
                   cell.lblPercent.text = "40%"
                     cell.widthPercent.constant = (UIScreen.main.bounds.size.width - 80)/5 * 2
                   
                     cell.btnReview.setTitle("VIEW SELLER REPORT", for: .normal)
                     cell.subBG.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_TIM)
               }
                else if status == STATUS_AMPASAMP.AMPASAMP_DECLARING_BUYER_40
                {
                    cell.lblPercent.text = "40%"
                      cell.widthPercent.constant = (UIScreen.main.bounds.size.width - 80)/5 * 2
                    
                      cell.btnReview.setTitle("VIEW BUYER REPORT", for: .normal)
                      cell.subBG.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_TIM)
                }
               else{
                   cell.lblPercent.text = "60%"
                     cell.widthPercent.constant = (UIScreen.main.bounds.size.width - 80)/5 * 3
                   
                     cell.btnReview.setTitle(" PENDING AMP TRANSACTION", for: .normal)
                     cell.subBG.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_XAM)
               }
           }
       }
    
    func configCellAmpViewSeller(_ cell: AmpSellerCell, _ dict: NSDictionary, _ activityObj: ActivityObj)
    {
        if let attachments = dict.object(forKey: "attachments") as? NSDictionary
        {
            if let iPath = attachments.object(forKey: "iPath") as? String
            {
                cell.indicator.isHidden = false
                cell.indicator.startAnimating()
                let url = "\(URL_AVARTA)/\(iPath)"
                let replaceUrl  = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                cell.imgCell.sd_setImage(with: URL.init(string: replaceUrl ?? "")) { (image, error, type, url) in
                    cell.indicator.stopAnimating()
                    cell.indicator.isHidden = true
                }
            }
            else{
                cell.indicator.stopAnimating()
                cell.imgCell.image = nil
                cell.indicator.isHidden = true
            }
        }
        let status = dict.object(forKey: "status") as? String ?? ""
        if  status == STATUS_AMPASAMP.AMPASAMP_DECLARING_BUYER_40 || status == STATUS_AMPASAMP.AMPASAMP_BUYER_60 || status == STATUS_AMPASAMP.AMPASAMP_BUYER_20 || status == STATUS_AMPASAMP.AMPASAMP_60 {
            if let buyer = dict.object(forKey: "seller") as? NSDictionary
            {
                
                print("buyer--->", buyer)
                if let username = buyer.object(forKey: "username") as? String
                {
                    cell.lblUserName.text = "With seller @\(username)"
                }
                else{
                    cell.lblUserName.text = "@"
                }
                if let company_info = buyer.object(forKey: "company") as? NSDictionary {
                    cell.lblName.text = company_info.object(forKey: "name") as? String
                }
                else{
                    let firstName = buyer.object(forKey: "fname") as? String ?? ""
                    let lastName = buyer.object(forKey: "lname") as? String ?? ""
                    cell.lblName.text = firstName + " " + lastName
                }
                
            }
        }
        else{
            print("status--->",status)
            if let buyer = dict.object(forKey: "ampuser") as? NSDictionary
            {
                
                print("buyer--->", buyer)
                if let username = buyer.object(forKey: "username") as? String
                {
                    cell.lblUserName.text = "With seller @\(username)"
                }
                else{
                    cell.lblUserName.text = "@"
                }
                if let company_info = buyer.object(forKey: "company") as? NSDictionary {
                    cell.lblName.text = company_info.object(forKey: "name") as? String
                }
                else{
                    let firstName = buyer.object(forKey: "fname") as? String ?? ""
                    let lastName = buyer.object(forKey: "lname") as? String ?? ""
                    cell.lblName.text = firstName + " " + lastName
                }
                
            }
        }
        cell.viewBGAdd.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_XANH)
        cell.viewGBView.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_XANH)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
    }
}
