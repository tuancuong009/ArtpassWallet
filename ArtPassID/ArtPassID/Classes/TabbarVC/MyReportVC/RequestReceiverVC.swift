//
//  RequestReceiverVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 3/17/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit
import SafariServices
class RequestReceiverVC: BaseVC {
    var arrDatas = [ActivityObj]()
    var arrIDNotificationRequest = [NotificationObj]()
    var arrIDNotification = [String]()
    @IBOutlet weak var tblRequest: UITableView!
    var isTradeConnect = false
    var numberConnection = 0
    @IBOutlet weak var lblNavi: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.saveNotification()
        self.callAPI()
        if self.isTradeConnect {
            self.lblNavi.text = "MY TRADE CONNECT REQUESTS"
        }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
        if self.isTradeConnect{
            ApiHelper.shared.getListConnection("connected") { (success, connects, error) in
                Common.hideBusy()
                self.arrDatas.removeAll()
                if let connects = connects
                {
                    for item in connects
                    {
                        let obj = ActivityObj.init()
                        obj.dict = item as! NSDictionary
                        var isCheck = false

                        if let exchangedCDD = obj.dict.object(forKey: "exchangedCDD") as? NSDictionary{
                            let requestedId = exchangedCDD.object(forKey: "requestedId") as? String ?? ""
                            if APP_DELEGATE.profileObj!._id == requestedId {
                                isCheck = true
                            }
                        }
                        if isCheck
                        {
                           obj.sentRqs = true
                        }
                        else{
                            obj.sentRqs = false
                        }
                        if  obj.dict.object(forKey: "exchangedCDD") != nil{
                            self.arrDatas.append(obj)
                        }
                        
                    }
                }
                
                self.arrDatas = self.arrDatas.sorted(by: self.sorterForFileIDASC(this:that:))
                self.tblRequest.reloadData()
            }
        }
        else{
            ApiHelper.shared.getListRequest() { (success, connects, error) in
                self.arrDatas.removeAll()
                Common.hideBusy()
                if let connects = connects
                {
                    for item in connects
                    {
                        let obj = ActivityObj.init()
                        obj.dict = item as! NSDictionary
                        var isCheck = false
                        if let connectTo = obj.dict.object(forKey: "receiver") as? NSDictionary
                        {
                            if let _id = connectTo.object(forKey: "_id") as? String
                            {
                                if APP_DELEGATE.profileObj!._id != _id {
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
                         self.arrDatas.append(obj)
                        
                    }
                }
                
                self.arrDatas = self.arrDatas.sorted(by: self.sorterForFileIDASC(this:that:))
                self.tblRequest.reloadData()
            }
        }
        updateBadgeNotificaiton()
    }
}
extension RequestReceiverVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let activityObj = self.arrDatas[indexPath.row]
        if self.isTradeConnect {
            if activityObj.sentRqs {
               let cell = self.tblRequest.dequeueReusableCell(withIdentifier: "RequestConnectionSentCell") as! RequestConnectionCell
              self.configCellReuestTrande(cell, activityObj.dict, activityObj)
               
               return cell
           }
           else{
               let cell = self.tblRequest.dequeueReusableCell(withIdentifier: "RequestConnectionCell") as! RequestConnectionCell
               self.configCellReuestTrande(cell, activityObj.dict, activityObj)
               return cell
           }
        }
        else{
            if activityObj.sentRqs {
               let cell = self.tblRequest.dequeueReusableCell(withIdentifier: "RequestConnectionSentCell") as! RequestConnectionCell
               self.configCell(cell, activityObj.dict, activityObj)
               
               return cell
           }
           else{
               let cell = self.tblRequest.dequeueReusableCell(withIdentifier: "RequestConnectionCell") as! RequestConnectionCell
               self.configCell(cell, activityObj.dict, activityObj)
               return cell
           }
        }
       
         
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.isTradeConnect {
            let activityObj = self.arrDatas[indexPath.row]
           if !activityObj.sentRqs {
               return 430
           }
           return 360
        }
        else{
            let activityObj = self.arrDatas[indexPath.row]
           if activityObj.sentRqs {
               return 440
           }
           return 440
        }
        
    }
    
    
    func configCell(_ cell: RequestConnectionCell,_ dict: NSDictionary ,_ activityObj: ActivityObj)
    {
       if activityObj.sentRqs {
            cell.btnDecline.setTitle("CANCEL CONNECTION REQUEST", for: .normal)
            cell.lblRequest.text = "Request to"
            if let connectTo = dict.object(forKey: "receiver") as? NSDictionary
            {
                if let avatar = connectTo.object(forKey: "avatar") as? String
                {
                    //cell.imgCell.image = Common.convertBase64ToImage(avatar)
                     Common.loadAvatarFromServer(avatar, cell.imgCell)
                }
                else{
                    cell.imgCell.image = nil
                }
                let fname = connectTo.object(forKey: "fname") as? String ?? ""
                let lname = connectTo.object(forKey: "lname") as? String ?? ""
                cell.lblFullName.text = "\(fname) \(lname)"
                cell.lblUserName.text = "@\(connectTo.object(forKey: "username") as? String ?? "")"
                cell.tapViewConnect = { [] in
                    print(connectTo)
                    if let connectRp = connectTo.object(forKey: "connectRp") as? NSDictionary
                    {
                        print("connectRp --->",connectRp)
                        if let fileUrl = connectRp.object(forKey: "fileUrl") as? String {
                            let vc = SFSafariViewController.init(url: URL.init(string: "\(URL_AVARTA)/\(fileUrl)")!)
                            self.present(vc, animated: true) {
                                
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
                
                // ACCEPT CONNECT
                cell.tapAcceptConnect = { [] in
                    if let _id = dict.object(forKey: "_id") as? String
                    {
                        self.readNotification(_id)
                    }
                    self.callAPIAccept(dict.object(forKey: "req_id") as? String ?? "")
                }
                cell.tapDelineConnect = { [] in
                    if let _id = dict.object(forKey: "_id") as? String
                    {
                        self.readNotification(_id)
                    }
                     self.callAPIRemoveConnect(dict.object(forKey: "req_id") as? String ?? "", "cancel")
                }
            }
        }
        else{
            if let _id = dict.object(forKey: "_id") as? String
            {
                if self.arrIDNotification.contains(_id)
                {
                    cell.viewNotification.isHidden = false
                }
                else{
                    cell.viewNotification.isHidden = true
                }
            }
            cell.btnDecline.setTitle("DECLINE CONNECTION REQUEST", for: .normal)
            cell.lblRequest.text = "Request from"
            if let connectFrom = dict.object(forKey: "sender") as? NSDictionary
            {
                if let avatar = connectFrom.object(forKey: "avatar") as? String
                {
                    //cell.imgCell.image = Common.convertBase64ToImage(avatar)
                     Common.loadAvatarFromServer(avatar, cell.imgCell)
                }
                else{
                    cell.imgCell.image = nil
                }
                let fname = connectFrom.object(forKey: "fname") as? String ?? ""
                let lname = connectFrom.object(forKey: "lname") as? String ?? ""
                cell.lblFullName.text = "\(fname) \(lname)"
                cell.lblUserName.text = "@\(connectFrom.object(forKey: "username") as? String ?? "")"
                cell.tapViewConnect = { [] in
                    if let connectRp = connectFrom.object(forKey: "connectRp") as? NSDictionary
                    {
                        if let fileUrl = connectRp.object(forKey: "fileUrl") as? String {
                            let vc = SFSafariViewController.init(url: URL.init(string: "\(URL_AVARTA)/\(fileUrl)")!)
                            self.present(vc, animated: true) {
                                
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
            }
            cell.tapAcceptConnect = { [] in
                if let _id = dict.object(forKey: "_id") as? String
                {
                    self.readNotification(_id)
                }
                self.callAPIAccept(dict.object(forKey: "req_id") as? String ?? "")
            }
            cell.tapDelineConnect = { [] in
                if let _id = dict.object(forKey: "_id") as? String
                {
                    self.readNotification(_id)
                }
                 self.callAPIRemoveConnect(dict.object(forKey: "req_id") as? String ?? "", "decline")
            }
        
        }
        
    }
   
    //if current user is user that requested CDD so you should show button CDD REQUESTING,
    func configCellReuestTrande(_ cell: RequestConnectionCell,_ dict: NSDictionary ,_ activityObj: ActivityObj)
    {
       
       if activityObj.sentRqs {
        
            cell.btnDecline.setTitle("CDD REQUESTING", for: .normal)
            cell.viewBGDecline.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_XAM)
            cell.lblRequest.text = "Request to"
            if let connectTo = dict.object(forKey: "connectFrom") as? NSDictionary
            {
                if let avatar = connectTo.object(forKey: "avatar") as? String
                {
                   // cell.imgCell.image = Common.convertBase64ToImage(avatar)
                     Common.loadAvatarFromServer(avatar, cell.imgCell)
                }
                else{
                    cell.imgCell.image = nil
                }
                let fname = connectTo.object(forKey: "fname") as? String ?? ""
                let lname = connectTo.object(forKey: "lname") as? String ?? ""
                cell.lblFullName.text = "\(fname) \(lname)"
                cell.lblUserName.text = "@\(connectTo.object(forKey: "username") as? String ?? "")"
                cell.tapViewConnect = { [] in
                    print(connectTo)
                    if let connectRp = connectTo.object(forKey: "connectRp") as? NSDictionary
                    {
                        print("connectRp --->",connectRp)
                        if let fileUrl = connectRp.object(forKey: "fileUrl") as? String {
                            let vc = SFSafariViewController.init(url: URL.init(string: "\(URL_AVARTA)/\(fileUrl)")!)
                            self.present(vc, animated: true) {
                                
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
                
                // ACCEPT CONNECT
                cell.tapAcceptConnect = { [] in
//                    if let _id = dict.object(forKey: "_id") as? String
//                    {
//                        self.readNotification(_id)
//                    }
                }
                cell.tapDelineConnect = { [] in
//                    if let _id = dict.object(forKey: "_id") as? String
//                    {
//                        self.readNotification(_id)
//                    }
//                     self.callAPIRemoveConnect(dict.object(forKey: "_id") as? String ?? "", "cancel")
                }
            }
        }
        else{
         cell.btnAccessConnect.setTitle("ACCEPT CDD REPORT EXCHANGE", for: .normal)
            if let _id = dict.object(forKey: "_id") as? String
            {
                if self.arrIDNotification.contains(_id)
                {
                    cell.viewNotification.isHidden = false
                }
                else{
                    cell.viewNotification.isHidden = true
                }
            }
            cell.btnDecline.setTitle("DECLINE CDD REPORT EXCHANGE", for: .normal)
            cell.lblRequest.text = "Request from"
            if let connectFrom = dict.object(forKey: "connectTo") as? NSDictionary
            {
                if let avatar = connectFrom.object(forKey: "avatar") as? String
                {
                   // cell.imgCell.image = Common.convertBase64ToImage(avatar)
                     Common.loadAvatarFromServer(avatar, cell.imgCell)
                }
                else{
                    cell.imgCell.image = nil
                }
                let fname = connectFrom.object(forKey: "fname") as? String ?? ""
                let lname = connectFrom.object(forKey: "lname") as? String ?? ""
                cell.lblFullName.text = "\(fname) \(lname)"
                cell.lblUserName.text = "@\(connectFrom.object(forKey: "username") as? String ?? "")"
                cell.tapViewConnect = { [] in
                    if let connectRp = connectFrom.object(forKey: "connectRp") as? NSDictionary
                    {
                        if let fileUrl = connectRp.object(forKey: "fileUrl") as? String {
                            let vc = SFSafariViewController.init(url: URL.init(string: "\(URL_AVARTA)/\(fileUrl)")!)
                            self.present(vc, animated: true) {
                                
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
            }
            cell.tapAcceptConnect = { [] in
                if let _id = dict.object(forKey: "_id") as? String
                {
                    self.readNotification(_id)
                }
                self.acceptCDDRequest(dict.object(forKey: "_id") as? String ?? "")
            }
            cell.tapDelineConnect = { [] in
                if let _id = dict.object(forKey: "_id") as? String
                {
                    self.readNotification(_id)
                }
                self.revokeCDDRequest(dict.object(forKey: "_id") as? String ?? "")
            }
        
        }
        
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
    
    func callAPIRemoveConnect(_ id: String, _ status: String)
    {
        
        ApiHelper.shared.acceptNewToAction(id, status) { success, errer in
            if success
            {
              self.callAPI()
            }
            else{
                if errer != nil {
                    APP_DELEGATE.showAlert(errer!.msg!)
                }
            }
        }
    }
    
    func callAPIAccept(_ id: String)
    {
        /*
        let param = ["cid":id]
        ApiHelper.shared.acceptConnection(param) { (success, error) in
            if success
            {
              self.callAPI()
            }
            else{
                if error != nil {
                    APP_DELEGATE.showAlert(error!.msg!)
                }
            }
        }*/
        ApiHelper.shared.acceptNewToAction(id, "accept") { success, errer in
            if success
            {
              self.callAPI()
            }
            else{
                if errer != nil {
                    APP_DELEGATE.showAlert(errer!.msg!)
                }
            }
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
           if self.arrIDNotification.count + numberConnection > 0
           {
               self.tabBarController?.tabBar.items![1].badgeValue = "\(self.arrIDNotification.count + numberConnection)"
           }
           else{
                self.tabBarController?.tabBar.items![1].badgeValue = nil
           }
           if !self.getValueActype(id).isEmpty {
               ApiHelper.shared.addReadNotification(id, self.getValueActype(id), self.getValueNotificationID(id)) { (success, error) in
                   
               }
           }
           
       }
       
       func getValueActype(_ id: String)-> String
       {
           for item in self.arrIDNotificationRequest
           {
               if  item.notifyId == id {
                   return item.actType
               }
           }
           return ""
       }
       
       func getValueNotificationID(_ id: String)-> String
       {
           for item in self.arrIDNotificationRequest
           {
               if  item.notifyId == id {
                   return item.id
               }
           }
           return ""
       }
}
