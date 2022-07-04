//
//  ConnectionVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 3/17/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit
import SafariServices
class ConnectionVC: BaseVC {
     var arrDatas = [ActivityObj]()
    @IBOutlet weak var tblConnect: UITableView!
    var arrIDNotificationRequest = [NotificationObj]()
    var arrIDNotification = [String]()
    var numerRequest = 0
    @IBOutlet weak var viewCCDSuccess: UIView!
    @IBOutlet weak var viewError: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.saveNotification()
        self.callAPI()
        self.viewCCDSuccess.isHidden = true
        self.viewError.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    func saveNotification()
    {
        arrIDNotification.removeAll()
        for item in self.arrIDNotificationRequest
        {
            arrIDNotification.append(item.notifyId)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tblConnect.reloadData()
        super.viewWillAppear(animated)
    }
    @IBAction func doback(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func sorterForFileIDASC(this:ActivityObj, that:ActivityObj) -> Bool {
      let thisDict = this.dict
      let thatDis = that.dict
      let updatedTimeThis = thisDict.object(forKey: "requestedTime") as? Double ?? 0.0
      let updatedTimeThat = thatDis.object(forKey: "requestedTime") as? Double ?? 0.0
      return updatedTimeThis > updatedTimeThat
    }
    
    func callAPI()
    {
        ApiHelper.shared.getListConnection("connected") { (success, connections, error) in
            self.arrDatas.removeAll()
            // print("connections--->",connections)
            if let connections = connections
            {
                for item in connections
                {
                    let obj = ActivityObj.init()
                    obj.dict = item as! NSDictionary
                    var isCheck = false
                    if let connectFrom = obj.dict.object(forKey: "connectFrom") as? NSDictionary
                    {
                        if let _id = connectFrom.object(forKey: "_id") as? String
                        {
                           
                            if APP_DELEGATE.profileObj!._id == _id {
                                isCheck = true
                            }
                        }
                    }
                    if isCheck
                    {
                       obj.sentRqs = true
                    }
                    else{
                        obj.sentRqs = false
                    }
                    if  obj.dict.object(forKey: "exchangedCDD") == nil{
                        self.arrDatas.append(obj)
                    }
                    
                }
            }
            self.arrDatas = self.arrDatas.sorted(by: self.sorterForFileIDASC(this:that:))
            self.tblConnect.reloadData()
        }
    
        updateBadgeNotificaiton()
    }
    
    func openSafari(_ url: String)
    {
        print("url---->",url)
        let vc = SFSafariViewController.init(url: URL.init(string: url)!)
        self.present(vc, animated: true) {
            
        }
    }
    func callAPIRemoveConnect(_ id: String, _ status: String)
    {
        let param = ["cid":id, "action": status]
        ApiHelper.shared.removeConnect(param) { (success, error) in
            if success
            {
                self.callAPI()
            }
            else{
                if error != nil {
                    APP_DELEGATE.showAlert(error!.msg!)
                }
            }
        }
    }
    
    func userSharecdd(_ id: String, _ rid: String)
    {
        let param = ["cid":id, "uid": APP_DELEGATE.profileObj!._id, "side":rid]
        ApiHelper.shared.usersharecdd(param) { (success, error) in
            if success
            {
                self.callAPI()
            }
            else{
                if error != nil {
                    APP_DELEGATE.showAlert(error!.msg!)
                }
            }
        }
    }
    
    func revokeAccess(_ id: String, _ rid: String)
    {
         let param = ["cid":id, "uid": APP_DELEGATE.profileObj!._id, "side":rid]
        ApiHelper.shared.revokeAccess(param) { (success, error) in
            if success
            {
                self.callAPI()
            }
            else{
                if error != nil {
                    APP_DELEGATE.showAlert(error!.msg!)
                }
            }
        }
    }
    
    func requestCDDReport(_ id: String)
    {
         let param = ["cid":id]
        ApiHelper.shared.requestCDDReport(param) { (success, error, code) in
            if success
            {
                 self.tabBarController?.tabBar.isHidden = true
                self.viewCCDSuccess.isHidden = false
                self.perform(#selector(self.hideSuccess), with: nil, afterDelay: TIME_OUT)
                self.callAPI()
                Common.hideBusy()
            }
            else{
                if code != nil{
                    if code! == 501 {
                        self.tabBarController?.tabBar.isHidden = true
                       self.viewError.isHidden = false
                       self.perform(#selector(self.hideError), with: nil, afterDelay: TIME_OUT)
                    }
                    else{
                        if error != nil {
                           APP_DELEGATE.showAlert(error!.msg!)
                       }
                    }
                }
                else{
                    if error != nil {
                       APP_DELEGATE.showAlert(error!.msg!)
                   }
                }
               
            }
        }
    }
    @objc func hideSuccess()
    {
        self.tabBarController?.tabBar.isHidden = false
         self.viewCCDSuccess.isHidden = true
    }
    @objc func hideError()
       {
           self.tabBarController?.tabBar.isHidden = false
            self.viewError.isHidden = true
       }
    func acceptCDDRequest(_ id: String)
    {
         let param = ["cid":id]
        ApiHelper.shared.AcceptCDDRequest(param) { (success, error) in
            if success
            {
                self.callAPI()
            }
            else{
                if error != nil {
                    APP_DELEGATE.showAlert(error!.msg!)
                }
            }
        }
    }
    
    func revokeCDDRequest(_ id: String)
    {
         let param = ["cid":id]
        ApiHelper.shared.RevokeCDDRequest(param) { (success, error) in
            if success
            {
                self.callAPI()
            }
            else{
                if error != nil {
                    APP_DELEGATE.showAlert(error!.msg!)
                }
            }
        }
    }
}

extension ConnectionVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblConnect.dequeueReusableCell(withIdentifier: "ConnectionCell") as! ConnectionCell
        let obj = self.arrDatas[indexPath.row]
        self.configCell(cell, obj.dict, obj)
        cell.tapViewConnect = { [] in
            if let _id = obj.dict.object(forKey: "_id") as? String
            {
                let actType = self.getValueActype(_id)
                if self.arrIDNotification.contains(_id) && !actType.isEmpty
                {
                    self.readNotification(_id)
                }
               
            }
            var dictInfo: NSDictionary?
            if obj.sentRqs {
                if let connectTo = obj.dict.object(forKey: "connectTo") as? NSDictionary
                {
                    dictInfo = connectTo
                }
            }
            else{
                if let connectTo = obj.dict.object(forKey: "connectFrom") as? NSDictionary
                {
                    dictInfo = connectTo
                }
            }
            if let dict = dictInfo {
                if let connectRp = dict.object(forKey: "connectRp") as? NSDictionary
                {
                    if let fileUrl = connectRp.object(forKey: "fileUrl") as? String {
                         self.openSafari("\(URL_AVARTA)/\(fileUrl)")
                    }
                    else{
                        APP_DELEGATE.showAlert("No connect report")
                    }
                }
                else{
                    APP_DELEGATE.showAlert("No connect report")
                }
            }
            else{
                APP_DELEGATE.showAlert("No connect report")
            }
        }
        cell.tapRemoveConnect = { [] in
                 
                if let _id = obj.dict.object(forKey: "_id") as? String
                {
                    let actType = self.getValueActype(_id)
                    if self.arrIDNotification.contains(_id) && !actType.isEmpty
                    {
                        self.readNotification(_id)
                    }
                   
                }
             self.callAPIRemoveConnect(obj.dict.object(forKey: "_id") as? String ?? "", "remove")
        }
        //POST: /api/user/sharecdd'
        //data: , { cid: cid, uid: current_user_id, side: 'share side' }
        //side should be 'connectFrom' if current user is connectFrom, 'connectTo' if current user id is connectTo ( user received request)
        cell.tapCCDReport = { [] in
           
            if let exchangedCDD = obj.dict.object(forKey: "exchangedCDD") as? NSDictionary{
                if obj.dict.object(forKey: "accessToken") == nil{
                    let requestedId = exchangedCDD.object(forKey: "requestedId") as? String ?? ""
                    if requestedId == APP_DELEGATE.profileObj?._id {
//                        cell.viewDieclineReport.isHidden = true
//                        cell.btnCDD.setTitle("CDD REQUEST PENDING", for: .normal)
//                        cell.bgCDD.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_XAM)
                    }
                    else{
//                        cell.viewDieclineReport.isHidden = false
//                        cell.btnCDD.setTitle("ACCEPT TO SHARE CDD REPOR", for: .normal)
//                        cell.bgCDD.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_TIM)
                        if let _id = obj.dict.object(forKey: "_id") as? String
                        {
                            let actType = self.getValueActype(_id)
                            if self.arrIDNotification.contains(_id) && !actType.isEmpty
                            {
                                self.readNotification(_id)
                            }
                           
                        }
                        self.acceptCDDRequest(obj.dict.object(forKey: "_id") as? String ?? "")
                    }
                }
                else{
//                    cell.viewDieclineReport.isHidden = true
//                    cell.btnCDD.setTitle("VIEW CDD REPORT", for: .normal)
//                    cell.bgCDD.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_XANH)
                    if let _id = obj.dict.object(forKey: "_id") as? String
                    {
                        let actType = self.getValueActype(_id)
                        if self.arrIDNotification.contains(_id) && !actType.isEmpty
                        {
                            self.readNotification(_id)
                        }
                       
                    }
                    let access = obj.dict.object(forKey: "accessToken") as! String
                    self.openSafari("\(URL_SERVER)sharedcdd/\(access)")
                    
                }
            }
            else{
                if let _id = obj.dict.object(forKey: "_id") as? String
                {
                    let actType = self.getValueActype(_id)
                    if self.arrIDNotification.contains(_id) && !actType.isEmpty
                    {
                        self.readNotification(_id)
                    }
                   
                }
                self.requestCDDReport(obj.dict.object(forKey: "_id") as? String ?? "")
                
            }
        }
       
        cell.tapDeclineCDDReport = { [] in
            if let _id = obj.dict.object(forKey: "_id") as? String
            {
                let actType = self.getValueActype(_id)
                if self.arrIDNotification.contains(_id) && !actType.isEmpty
                {
                    self.readNotification(_id)
                }
               
            }
            self.requestCDDReport(obj.dict.object(forKey: "_id") as? String ?? "")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let activityObj = self.arrDatas[indexPath.row]
        
        if let exchangedCDD = activityObj.dict.object(forKey: "exchangedCDD") as? NSDictionary{
            if activityObj.dict.object(forKey: "accessToken") == nil{
                let requestedId = exchangedCDD.object(forKey: "requestedId") as? String ?? ""
                if requestedId == APP_DELEGATE.profileObj?._id {
                   return 343
                }
                else{
                    return 408
                }
            }
            else{
               return 343
            }
        }
        else{
            return 343
            
        }
        //return 335
    }
    func configCell(_ cell: ConnectionCell,_ dict: NSDictionary ,_ activityObj: ActivityObj)
    {
       if activityObj.sentRqs {
            if let connectTo = dict.object(forKey: "connectTo") as? NSDictionary
            {
                if let utype = connectTo.object(forKey: "utype") as? String {
                    if utype == UTYPE_USER.BUSINESS {
                         if let company_info = connectTo.object(forKey: "company") as? NSDictionary {
                            cell.lblFullName.text = company_info.object(forKey: "name") as? String
                            cell.lblUserName.text = "@\(connectTo.object(forKey: "username") as? String ?? "")"
                            if let avatar = connectTo.object(forKey: "avatar") as? String
                           {
                              // cell.imgAvatar.image = Common.convertBase64ToImage(avatar)
                                Common.loadAvatarFromServer(avatar, cell.imgAvatar)
                           }
                           else{
                               cell.imgAvatar.image = nil
                           }
                        }
                    }
                    else{
                        if let avatar = connectTo.object(forKey: "avatar") as? String
                        {
                            //cell.imgAvatar.image = Common.convertBase64ToImage(avatar)
                            Common.loadAvatarFromServer(avatar,cell.imgAvatar)
                        }
                        else{
                            cell.imgAvatar.image = nil
                        }
                        let fname = connectTo.object(forKey: "fname") as? String ?? ""
                        let lname = connectTo.object(forKey: "lname") as? String ?? ""
                        cell.lblFullName.text = "\(fname) \(lname)"
                        cell.lblUserName.text = "@\(connectTo.object(forKey: "username") as? String ?? "")"
                    }
                }
            }
        }
        else{
            if let connectFrom = dict.object(forKey: "connectFrom") as? NSDictionary
            {
                if let utype = connectFrom.object(forKey: "utype") as? String {
                   if utype == UTYPE_USER.BUSINESS {
                       if let company_info = connectFrom.object(forKey: "company") as? NSDictionary {
                           cell.lblFullName.text = company_info.object(forKey: "name") as? String
                           cell.lblUserName.text = "@\(connectFrom.object(forKey: "username") as? String ?? "")"
                           if let avatar = connectFrom.object(forKey: "avatar") as? String
                          {
                              //cell.imgAvatar.image = Common.convertBase64ToImage(avatar)
                            Common.loadAvatarFromServer(avatar, cell.imgAvatar)
                          }
                          else{
                              cell.imgAvatar.image = nil
                          }
                       }
                   }
                   else{
                       if let avatar = connectFrom.object(forKey: "avatar") as? String
                       {
                          //cell.imgAvatar.image = Common.convertBase64ToImage(avatar)
                          Common.loadAvatarFromServer(avatar, cell.imgAvatar)
                      }
                      else{
                          cell.imgAvatar.image = nil
                      }
                      let fname = connectFrom.object(forKey: "fname") as? String ?? ""
                      let lname = connectFrom.object(forKey: "lname") as? String ?? ""
                      cell.lblFullName.text = "\(fname) \(lname)"
                      cell.lblUserName.text = "@\(connectFrom.object(forKey: "username") as? String ?? "")"
                   }
               }
               
            }
        }
        if let requestedTime = activityObj.dict.object(forKey: "requestedTime") as? Double
        {
            let format = DateFormatter.init()
            format.dateFormat = "MM/dd/yyyy"
            let date = format.string(from: Date.init(milliseconds: Int64(requestedTime)))
            cell.lblTime.text = "Connected on \(date)"
        }
        
       
        if let _id = dict.object(forKey: "_id") as? String
        {
        
            let actType = self.getValueActype(_id)
            print("actType 2--->",actType)
            if self.arrIDNotification.contains(_id) && !actType.isEmpty
            {
                cell.viewNotification.isHidden = false
            }
            else{
                cell.viewNotification.isHidden = true
            }
        }
        
       
        if let exchangedCDD = activityObj.dict.object(forKey: "exchangedCDD") as? NSDictionary{
            if activityObj.dict.object(forKey: "accessToken") == nil{
                let requestedId = exchangedCDD.object(forKey: "requestedId") as? String ?? ""
                if requestedId == APP_DELEGATE.profileObj?._id {
                    cell.viewDieclineReport.isHidden = true
                    cell.btnCDD.setTitle("CDD REQUEST PENDING", for: .normal)
                    cell.bgCDD.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_XAM)
                }
                else{
                    cell.viewDieclineReport.isHidden = false
                    cell.btnCDD.setTitle("ACCEPT TO SHARE CDD REPOR", for: .normal)
                    cell.bgCDD.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_TIM)
                }
            }
            else{
                cell.viewDieclineReport.isHidden = true
                cell.btnCDD.setTitle("VIEW CDD REPORT", for: .normal)
                cell.bgCDD.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_XANH)
            }
        }
        else{
            cell.viewDieclineReport.isHidden = true
            cell.btnCDD.setTitle("REQUEST CDD REPORT", for: .normal)
            cell.bgCDD.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_XANH)
            
        }
    }
   
    
    func readNotification(_ id: String)
       {
        if !self.getValueActype(id).isEmpty {
            ApiHelper.shared.addReadNotification(id, self.getValueActype(id), self.getValueNotificationID(id)) { (success, error) in
                
            }
        }
           var indexP = 0
        
           for item in self.arrIDNotification
           {
               if item == id
               {
                   self.arrIDNotification.remove(at: indexP)
                   self.arrIDNotificationRequest.remove(at: indexP)
                   break
               }
               indexP = indexP + 1
           }
           if self.arrIDNotification.count + numerRequest > 0
           {
               self.tabBarController?.tabBar.items![1].badgeValue = "\(self.arrIDNotification.count + numerRequest)"
           }
           else{
                self.tabBarController?.tabBar.items![1].badgeValue = nil
           }
           
           
       }
       
    func readNotificationCCD(_ id: String, _ Actype: String)
        {
            ApiHelper.shared.addReadNotification(id, Actype, self.getValueNotificationIDCDD(id)) { (success, error) in
                
            }
            
            var indexP = 0
            
            for notification in self.arrIDNotificationRequest
            {
                if notification.notifyId == id && notification.actType == "shared_cdd" {
                    self.arrIDNotificationRequest.remove(at: indexP)
                    break
                }
                indexP = indexP + 1
            }
            self.arrIDNotification.removeAll()
            self.saveNotification()
            
            if self.arrIDNotification.count + numerRequest > 0
            {
                self.tabBarController?.tabBar.items![1].badgeValue = "\(self.arrIDNotification.count + numerRequest)"
            }
            else{
                 self.tabBarController?.tabBar.items![1].badgeValue = nil
            }
            
        
      }
    
       func getValueActype(_ id: String)-> String
       {
           for item in self.arrIDNotificationRequest
           {
                let shared_cdd = item.actType
               if  item.notifyId == id && shared_cdd != "shared_cdd"{
                   return item.actType
               }
           }
           return ""
       }
       
        func getValueActypeSharredCCD(_ id: String)-> String
       {
          for item in self.arrIDNotificationRequest
          {
            let shared_cdd = item.actType
              if  item.notifyId == id  && shared_cdd == "shared_cdd"{
                  return item.actType
              }
          }
          return ""
       }
    
       func getValueNotificationID(_ id: String)-> String
       {
           for item in self.arrIDNotificationRequest
           {
                 let shared_cdd = item.actType
               if  item.notifyId == id  && shared_cdd != "shared_cdd" {
                   return item.id
               }
           }
           return ""
       }
        func getValueNotificationIDCDD(_ id: String)-> String
        {
            for item in self.arrIDNotificationRequest
            {
                let shared_cdd = item.actType
                if  item.notifyId == id && shared_cdd == "shared_cdd"{
                    return item.id
                }
            }
            return ""
        }
}

