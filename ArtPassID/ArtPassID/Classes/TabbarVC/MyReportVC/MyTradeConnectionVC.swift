//
//  MyTradeConnectionVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 9/9/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit
import SafariServices
class MyTradeConnectionVC: UIViewController {
      var arrDatas = [MyTrandObj]()
    @IBOutlet weak var tblTrade: UITableView!
     var arrNotifications = [NotificationObj]()
     var indexP = 0
    var arrIDNotification = [String]()
    var arrIDNotificationRequest = [NotificationObj]()
    var numerRequest = 0
    var myArtPassVC: MyArtPassVC?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.saveNotification()
        self.callAPIGetConnection()
        self.updateNotification()
        
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func updateNotification()
    {
        if self.arrNotifications.count > 0 {
            let obj = self.arrNotifications[indexP]
            ApiHelper.shared.addReadNotification(obj.notifyId, obj.actType, obj.id) { (success, error) in
                if self.indexP == self.arrNotifications.count - 1
                {
                    self.indexP = 0
                    self.arrNotifications.removeAll()
                    self.arrIDNotificationRequest.removeAll()
                    self.arrIDNotification.removeAll()
                    self.tblTrade.reloadData()
                    if let vc = self.myArtPassVC{
                        vc.callNotifications()
                    }
                }
                else{
                    self.indexP = self.indexP + 1
                    self.updateNotification()
                }
            }
        }
        
    }
    
    func openSafari(_ url: String)
    {
        print("url---->",url)
        let vc = SFSafariViewController.init(url: URL.init(string: url)!)
        self.present(vc, animated: true) {
            
        }
    }
    @IBAction func doBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //API to get list of trade connections is: GET /api/user/tradeconnect
  
   
    func callAPIGetConnection()
    {
        ApiHelper.shared.getConnectionNews { success, connections, error in
            //Common.hideBusy()
            self.arrDatas.removeAll()
            if let connections = connections
            {
                for item in connections
                {
                    let obj = MyTrandObj.init()
                    obj.dict = item as! NSDictionary
                    var isCheck = false
                    if let connectFrom = obj.dict.object(forKey: "sender") as? NSDictionary
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
                    obj.isConnect = true
                    
                    //if  obj.dict.object(forKey: "exchangedCDD") == nil{
                        self.arrDatas.append(obj)
                    //}
                    
                }
            }
            self.tblTrade.reloadData()
           self.getListMyNetWork()
        }
        /*
        ApiHelper.shared.getListConnection("connected") { (success, connections, error) in
            self.arrDatas.removeAll()
            // print("connections--->",connections)
            print("connections--->",connections)
            if let connections = connections
            {
                for item in connections
                {
                    let obj = MyTrandObj.init()
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
                    obj.isConnect = true
                    
                    //if  obj.dict.object(forKey: "exchangedCDD") == nil{
                        self.arrDatas.append(obj)
                    //}
                    
                }
            }
            self.tblTrade.reloadData()
            self.callAPI()
        }
         */
    }
    
     func callAPI()
     {
         ApiHelper.shared.getListMyTrade() { (success, connections, error) in
           
            if let arrs = connections{
                for item in arrs{
                    let obj = MyTrandObj.init()
                    obj.dict = item
                    obj.isNetwork = false
                    self.arrDatas.append(obj)
                }
               
            }
             self.tblTrade.reloadData()
            self.getListMyNetWork()
         }
     }
    /*
     Applicant account:
     +32471101325
     PIN: 372020


     W҉a҉y҉n҉e҉, 4:50 PM
     AMP account:
     32 484775183      112358
     */
    func getListMyNetWork()
    {
        ApiHelper.shared.getListMyNetWork() { (success, connections, error) in
            //print("getListMyNetWork--->",connections)
           if let arrs = connections{
            print("getListMyNetWork--->",arrs)
            for item in arrs{
                let obj = MyTrandObj.init()
                obj.dict = item
                obj.isNetwork = true
                obj.is_applicant = item.object(forKey: "is_applicant") as? Bool ?? false
                self.arrDatas.append(obj)
            }
           }
            self.tblTrade.reloadData()
        }
    }
    
    func revokeTrandConn(_ id: String)
       {
        let param = ["cid":id]
        ApiHelper.shared.RevokeTrandConn(param) { (success, error) in
           if success
           {
               self.callAPIGetConnection()
           }
           else{
               if error != nil {
                   APP_DELEGATE.showAlert(error!.msg!)
               }
           }
       }
   }
    func getValueActype(_ id: String)-> String
    {
        for item in self.arrNotifications
        {
             let shared_cdd = item.actType
            if  item.notifyId == id && shared_cdd != "shared_cdd"{
                return item.actType
            }
        }
        return ""
    }
}

extension MyTradeConnectionVC: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrDatas.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mytraidObj = self.arrDatas[indexPath.row]
        if mytraidObj.isConnect {
            if mytraidObj.isPending {
                if !mytraidObj.sentRqs {
                    return 460
                }
                return 390
            }
            var heightCell = 673 - 325
            if mytraidObj.sentRqs{
                var isShareSender = false
                if let sender = mytraidObj.dict.object(forKey: "sender") as? NSDictionary
                {
                    if let oneclick = sender.object(forKey: "is_sharing_cdd") as? String
                    {
                        isShareSender = oneclick == "1" ? true : false
                    }
                    else{
                        isShareSender = sender.object(forKey: "is_sharing_cdd") as? Bool ?? false
                    }
                }
                
               
                if let sender_req_cdd = mytraidObj.dict.object(forKey: "sender_req_cdd") as? NSDictionary {
                    let status = sender_req_cdd.object(forKey: "status") as? String ?? ""
                    if status == "pending"{
                        heightCell = heightCell + 65
                    }
                    
                    
                    if status == "accepted"{
                        heightCell = heightCell + 65
                        heightCell = heightCell + 65
                    }
                    else{
                        if isShareSender {
                            heightCell = heightCell + 65
                            heightCell = heightCell + 65
                        }
                        
                    }
                }
                else{
                    heightCell = heightCell + 65
                }
                if let receiver_req_cdd = mytraidObj.dict.object(forKey: "receiver_req_cdd") as? NSDictionary{
                    let statusReceiver = receiver_req_cdd.object(forKey: "status") as? String ?? ""
                    if statusReceiver == "pending" {
                        heightCell = heightCell + 65
                        heightCell = heightCell + 65
                    }
                    
                    if statusReceiver == "accepted" {
                        heightCell = heightCell + 65
                    }
                }
                else{
                    if isShareSender {
                        heightCell = heightCell + 65
                    }
                }
                return CGFloat(heightCell)
            }
            else{
                var isShareCDD = false
                if let connectTo = mytraidObj.dict.object(forKey: "sender") as? NSDictionary
                {
                    if let oneclick = connectTo.object(forKey: "is_sharing_cdd") as? String
                    {
                        isShareCDD = oneclick == "1" ? true : false
                    }
                    else{
                        isShareCDD = connectTo.object(forKey: "is_sharing_cdd") as? Bool ?? false
                    }
                }
                var isShareReceiver = false
                if let receiver = mytraidObj.dict.object(forKey: "receiver") as? NSDictionary
                {
                    if let oneclick = receiver.object(forKey: "is_sharing_cdd") as? String
                    {
                        isShareReceiver = oneclick == "1" ? true : false
                    }
                    else{
                        isShareReceiver = receiver.object(forKey: "is_sharing_cdd") as? Bool ?? false
                    }
                }
                if let sender_req_cdd = mytraidObj.dict.object(forKey: "receiver_req_cdd") as? NSDictionary {
                    let status = sender_req_cdd.object(forKey: "status") as? String ?? ""
                    if status == "pending"{
                        heightCell = heightCell +  65
                    }else{
                    }
                    
                    if status == "accepted" || isShareCDD{
                        heightCell = heightCell +  65
                        heightCell = heightCell +  65
                    }
                    else{
                    }
                }
                else{
                    if !isShareCDD {
                        heightCell = heightCell +  65
                    }
                    else{
                        heightCell = heightCell +  65
                        heightCell = heightCell +  65
                    }
                }
                if let receiver_req_cdd = mytraidObj.dict.object(forKey: "sender_req_cdd") as? NSDictionary{
                    let statusReceiver = receiver_req_cdd.object(forKey: "status") as? String ?? ""
                    if statusReceiver == "pending" {
                        heightCell = heightCell +  65
                        heightCell = heightCell +  65
                    }
                    else{
                    }
                    
                    if statusReceiver == "accepted" {
                        heightCell = heightCell +  65
                    }
                    else{
                    }
                }
                else{
                    if isShareReceiver {
                        heightCell = heightCell +  65
                    }
                }
                return CGFloat(heightCell)
            }
        }
        else{
            if !mytraidObj.isNetwork {
                if let userInfo = mytraidObj.dict.object(forKey: "userInfo") as? NSDictionary{
                    if let isAMP = userInfo.object(forKey: "isAMP") as? Bool
                    {
                        if isAMP {
                            return 350
                        }
                    }
                }
                return 413
            }
            if !mytraidObj.is_applicant {
                let app_request_cdd = mytraidObj.dict.object(forKey: "app_request_cdd") as? NSDictionary
                let amp_request_cdd = mytraidObj.dict.object(forKey: "amp_request_cdd") as? NSDictionary
                if app_request_cdd == nil {
                    return 413
                }
                else{
                    if let app_request = app_request_cdd, let status = app_request.object(forKey: "status") as? String, status == "pending"{
                        return 413
                    }
                    else if let amp_request = amp_request_cdd, let status = amp_request.object(forKey: "status") as? String, status == "pending"{
                        return 413
                    }
                    else{
                        return 478
                    }
                }
            }else{
                let app_request_cdd = mytraidObj.dict.object(forKey: "app_request_cdd") as? NSDictionary
                let amp_request_cdd = mytraidObj.dict.object(forKey: "amp_request_cdd") as? NSDictionary
                if amp_request_cdd == nil {
                    return 413
                }
                else{
                    if let app_request = app_request_cdd, let status = app_request.object(forKey: "status") as? String, status == "pending"{
                        return 413
                    }
                    else if let amp_request = amp_request_cdd, let status = amp_request.object(forKey: "status") as? String, status == "pending"{
                        return 413
                    }
                    else{
                        return 478
                    }
                }
            }
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mytraidObj = self.arrDatas[indexPath.row]
        if mytraidObj.isConnect {
            
            let cell = self.tblTrade.dequeueReusableCell(withIdentifier: "ConnectionCell") as! ConnectionCell
            let obj = self.arrDatas[indexPath.row]
            self.configCell(cell, obj.dict, obj)
            
            return cell
        }
        else{
            if !mytraidObj.isNetwork {
                let cell = self.tblTrade.dequeueReusableCell(withIdentifier: "TradeCell") as! TradeCell
                cell.configCell(mytraidObj.dict)
                let dict = mytraidObj.dict
                cell.tapViewCDDReport = { [] in
                    if let userInfo = dict.object(forKey: "userInfo") as? NSDictionary{
                        if let isAMP = userInfo.object(forKey: "isAMP") as? Bool
                        {
                            if isAMP {
                                if let _id = dict.object(forKey: "_id") as? String
                                {
                                    let actType = self.getValueActype(_id)
                                    if self.arrIDNotification.contains(_id) && !actType.isEmpty
                                    {
                                        self.readNotification(_id)
                                    }
                                   
                                }
                                self.requestCDDReport(dict.object(forKey: "_id") as? String ?? "", "")
                            }
                            else{
                                if let access = dict.object(forKey: "accessToken") as? String
                                {
                                     self.openSafari("\(URL_SERVER)sharedcdd/\(access)?access_token=\(UserDefaults.standard.value(forKey: kToken) as? String ?? "")")
                                }
                            }
                        }
                       
                    }
                    
                   
                }
                cell.tapViewID = { [] in
                    if let userInfo = dict.object(forKey: "userInfo") as? NSDictionary{
                        if let id = userInfo.object(forKey: "_id") as? String{
                            self.openSafari("\(URL_AVARTA)/connectreport/\(id)")
                        }
                    }
                }
                cell.tapViewRemove = { [] in
                    self.revokeTrandConn(dict.object(forKey: "_id") as? String ?? "")
                }
                
                if let tradeType = dict.object(forKey: "tradeType") as? NSDictionary
                {
                
                    if let _id =  tradeType.object(forKey: "id") as? String{
                        let actType = self.getValueActype(_id)
                        print("actType 2--->",actType)
                        if self.arrIDNotification.contains(_id) && !actType.isEmpty
                        {
                            cell.subNotification.isHidden = false
                        }
                        else{
                            cell.subNotification.isHidden = true
                        }
                    }
                    else{
                        cell.subNotification.isHidden = true
                    }
                }
                else{
                    cell.subNotification.isHidden = true
                }
                return cell
            }
            else{
                let cell = self.tblTrade.dequeueReusableCell(withIdentifier: "TradeCell2") as! TradeCell
                let dict = mytraidObj.dict
                if !mytraidObj.is_applicant {
                    cell.configCellAppliant(dict)
                    cell.tapViewID = { [] in
                        let user_id = dict.object(forKey: "user_id") as? NSDictionary ?? NSDictionary.init()
                        if let access = user_id.object(forKey: "_id") as? String
                        {
                             self.openSafari("\(URL_AVARTA)/connectreport/\(access)")
                        }
                    }
                    cell.tapViewCDDReport = { [] in
                        let app_request_cdd = mytraidObj.dict.object(forKey: "app_request_cdd") as? NSDictionary
                        let amp_request_cdd = mytraidObj.dict.object(forKey: "amp_request_cdd") as? NSDictionary
                        if app_request_cdd == nil {
                            if let access = dict.object(forKey: "secret_token") as? String
                            {
                                ApiHelper.shared.RequestCDDAccessApplicantNetwork(access) { (success, error) in
                                    if success
                                    {
                                        self.callAPIGetConnection()
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
                            if let app_request = app_request_cdd, let status = app_request.object(forKey: "status") as? String, status == "pending"{
                                
                            }
                            else if let amp_request = amp_request_cdd, let status = amp_request.object(forKey: "status") as? String, status == "pending"{
                                if let access = dict.object(forKey: "secret_token") as? String
                                {
                                    ApiHelper.shared.ApplicantAcceptRequestNetwork(access) { (success, error) in
                                        if success
                                        {
                                            self.callAPIGetConnection()
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
                                let user_id = dict.object(forKey: "user_id") as? NSDictionary ?? NSDictionary.init()
                                let cdd = user_id.object(forKey: "cdd") as? NSDictionary ?? NSDictionary.init()
                                if let fileUrl = cdd.object(forKey: "fileP") as? String
                                {
                                     self.openSafari("\(URL_AVARTA)/\(fileUrl)")
                                }
                            }
                        }
                        
                    }
                    cell.tapIndus = { [] in
                        let user_id = dict.object(forKey: "user_id") as? NSDictionary ?? NSDictionary.init()
                        let InspectRp = user_id.object(forKey: "InspectRp") as? NSDictionary ?? NSDictionary.init()
                        if let fileUrl = InspectRp.object(forKey: "fileUrl") as? String
                        {
                             self.openSafari("\(URL_AVARTA)/\(fileUrl)")
                        }
                    }
                    cell.tapViewRemove = { [] in
                        let amp_request_cdd = dict.object(forKey: "amp_request_cdd") as? NSDictionary
                        if let amp_request = amp_request_cdd, let status = amp_request.object(forKey: "status") as? String, status == "accepted"{
                            if let access = dict.object(forKey: "secret_token") as? String
                            {
                                ApiHelper.shared.ApplicantRevokeAcceptCDDNetwork(access) { (success, error) in
                                    if success
                                    {
                                        self.callAPIGetConnection()
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
                            ApiHelper.shared.deleteCDDNetwork(mytraidObj.dict) { (success, error) in
//                                if success
//                                {
//                                    self.callAPIGetConnection()
//                                }
//                                else{
//                                    if error != nil {
//                                        APP_DELEGATE.showAlert(error!.msg!)
//                                    }
//                                }
                                self.callAPIGetConnection()
                            }
                            
                        }
                        
                    }
                }
                else{
                 // iS AMP
                    cell.configCellAMP(dict)
                    cell.tapViewID = { [] in
                        let user_id = dict.object(forKey: "user_id") as? NSDictionary ?? NSDictionary.init()
                        if let access = user_id.object(forKey: "_id") as? String
                        {
                             self.openSafari("\(URL_AVARTA)/connectreport/\(access)")
                        }
                    }
                    cell.tapViewCDDReport = { [] in
                        let app_request_cdd = mytraidObj.dict.object(forKey: "app_request_cdd") as? NSDictionary
                        let amp_request_cdd = mytraidObj.dict.object(forKey: "amp_request_cdd") as? NSDictionary
                        if amp_request_cdd == nil {
                            if let access = dict.object(forKey: "secret_token") as? String
                            {
                                ApiHelper.shared.AMPRequestCDDNetwork(access) { (success, error) in
                                    if success
                                    {
                                        self.callAPIGetConnection()
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
                            if let app_request = app_request_cdd, let status = app_request.object(forKey: "status") as? String, status == "pending"{
                                if let access = dict.object(forKey: "secret_token") as? String
                                {
                                    ApiHelper.shared.AMPAcceptRequestNetwork(access) { (success, error) in
                                        if success
                                        {
                                            self.callAPIGetConnection()
                                        }
                                        else{
                                            if error != nil {
                                                APP_DELEGATE.showAlert(error!.msg!)
                                            }
                                        }
                                    }
                                }
                            }
                            else if let amp_request = amp_request_cdd, let status = amp_request.object(forKey: "status") as? String, status == "pending"{
                               
                            }
                            else{
                                let user_id = dict.object(forKey: "user_id") as? NSDictionary ?? NSDictionary.init()
                                let cdd = user_id.object(forKey: "cdd") as? NSDictionary ?? NSDictionary.init()
                                if let fileUrl = cdd.object(forKey: "fileP") as? String
                                {
                                     self.openSafari("\(URL_AVARTA)/\(fileUrl)")
                                }
                            }
                        }
                        
                    }
                    cell.tapIndus = { [] in
                        let user_id = dict.object(forKey: "user_id") as? NSDictionary ?? NSDictionary.init()
                        let InspectRp = user_id.object(forKey: "InspectRp") as? NSDictionary ?? NSDictionary.init()
                        if let fileUrl = InspectRp.object(forKey: "fileUrl") as? String
                        {
                             self.openSafari("\(URL_AVARTA)/\(fileUrl)")
                        }
                    }
                    cell.tapViewRemove = { [] in
                        let app_request_cdd = dict.object(forKey: "app_request_cdd") as? NSDictionary
                        if let app_request_cdd = app_request_cdd, let status = app_request_cdd.object(forKey: "status") as? String, status == "accepted"{
                            if let access = dict.object(forKey: "secret_token") as? String
                            {
                                ApiHelper.shared.AMPRemoveCDDNetwork(access) { (success, error) in
                                    if success
                                    {
                                        self.callAPIGetConnection()
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
                            ApiHelper.shared.deleteCDDNetwork(mytraidObj.dict) { (success, error) in
                                self.callAPIGetConnection()
                            }
                        }
                        
                    }
                }
                return cell
            }
        }
        
    }
}
/*
 Here is applicant account:
 Phone: +84 916663949
 Pincode: 653045

 here is amp account:
 Phone: +32 484775183
 Pincode: 112358
 if amp_request_cdd object is empty => show REQUEST CDD button

 if amp_request_cdd.status = 'pending' => show PENDING CDD REQUEST

 if amp_request_cdd.status = 'accepted' => show VIEW CDD REPORT and VIEW INSPECTION REPORT and REVOKE CDD ACCESS.
 */

extension MyTradeConnectionVC{
   
    
    func configCell(_ cell: ConnectionCell,_ dict: NSDictionary ,_ activityObj: MyTrandObj)
    {
       if activityObj.sentRqs {
            if let connectTo = dict.object(forKey: "receiver") as? NSDictionary
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
            if let connectFrom = dict.object(forKey: "sender") as? NSDictionary
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
        if let requestedTime = activityObj.dict.object(forKey: "req_time") as? Double
        {
            let format = DateFormatter.init()
            format.dateFormat = "MM/dd/yyyy"
            let date = format.string(from: Date.init(milliseconds: Int64(requestedTime)))
            cell.lblTime.text = "Connected on \(date)"
        }
        
        if let status = activityObj.dict.object(forKey: "status") as? String{
            if status == "accepted" {
                cell.viewRevoke.isHidden = false
            }
            else{
                cell.viewRevoke.isHidden = true
            }
        }
        else{
            cell.viewRevoke.isHidden = true
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
        print("activityObj.sentRqs--->",activityObj.sentRqs)
        cell.viewCCDReport.isHidden = true
        cell.viewAccept.isHidden = true
        cell.viewDieclineReport.isHidden = true
        cell.viewRevoke.isHidden = true
        cell.viewCDDReport.isHidden = true
        cell.viewInspection.isHidden = true
        
        cell.spaceViewCDD.isHidden = true
        cell.spaceAcept.isHidden = true
        cell.spaceDeline.isHidden = true
        cell.spaceRemove.isHidden = true
        cell.spaceRequestCDD.isHidden = true
        cell.spaceInpec.isHidden = true
        cell.viewArt.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_XANH)
        cell.viewInspection.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_XANH)
        if activityObj.sentRqs{
            var isShareSender = false
            if let sender = dict.object(forKey: "sender") as? NSDictionary
            {
                if let oneclick = sender.object(forKey: "is_sharing_cdd") as? String
                {
                    isShareSender = oneclick == "1" ? true : false
                }
                else{
                    isShareSender = sender.object(forKey: "is_sharing_cdd") as? Bool ?? false
                }
            }
            
           
            if let sender_req_cdd = activityObj.dict.object(forKey: "sender_req_cdd") as? NSDictionary {
                let status = sender_req_cdd.object(forKey: "status") as? String ?? ""
                if status == "pending"{
                    cell.viewCCDReport.isHidden = false
                    cell.spaceRequestCDD.isHidden = false
                    cell.btnCDD.setTitle("CDD REQUEST PENDING", for: .normal)
                    cell.bgCDD.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_XAM)
                }else{
                    cell.viewCCDReport.isHidden = true
                    cell.spaceRequestCDD.isHidden = true
                }
                
                
                if status == "accepted"{
                    cell.spaceViewCDD.isHidden = false
                    cell.viewCDDReport.isHidden = false
                    
                    cell.spaceInpec.isHidden = false
                    cell.viewInspection.isHidden = false
                }
                else{
                    if isShareSender {
                        cell.spaceViewCDD.isHidden = false
                        cell.viewCDDReport.isHidden = false
                        
                        cell.spaceInpec.isHidden = false
                        cell.viewInspection.isHidden = false
                    }
                    else{
                        cell.spaceViewCDD.isHidden = true
                        cell.viewCDDReport.isHidden = true
                        
                        cell.spaceInpec.isHidden = true
                        cell.viewInspection.isHidden = true
                    }
                    
                }
            }
            else{
                cell.spaceInpec.isHidden = true
                cell.viewInspection.isHidden = true
                cell.spaceRequestCDD.isHidden = false
                cell.spaceViewCDD.isHidden = true
                cell.viewCDDReport.isHidden = true
                cell.viewCCDReport.isHidden = false
                cell.btnCDD.setTitle("REQUEST CDD REPORT", for: .normal)
                cell.bgCDD.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_XANH)
            }
            if let receiver_req_cdd = activityObj.dict.object(forKey: "receiver_req_cdd") as? NSDictionary{
                let statusReceiver = receiver_req_cdd.object(forKey: "status") as? String ?? ""
                if statusReceiver == "pending" {
                    cell.viewAccept.isHidden = false
                    cell.viewDieclineReport.isHidden = false
                    cell.spaceAcept.isHidden = false
                    cell.spaceDeline.isHidden = false
                }
                else{
                    cell.viewAccept.isHidden = true
                    cell.viewDieclineReport.isHidden = true
                    cell.spaceAcept.isHidden = true
                    cell.spaceDeline.isHidden = true
                }
                
                if statusReceiver == "accepted" {
                    cell.spaceRemove.isHidden = false
                    cell.viewRevoke.isHidden = false
                }
                else{
                    cell.spaceRemove.isHidden = true
                    cell.viewRevoke.isHidden = true
                }
            }
            else{
                if isShareSender {
                    cell.spaceRemove.isHidden = false
                    cell.viewRevoke.isHidden = false
                }
            }
            
        }
        else{
            var isShareCDD = false
            
            if let connectTo = dict.object(forKey: "sender") as? NSDictionary
            {
                if let oneclick = connectTo.object(forKey: "is_sharing_cdd") as? String
                {
                    isShareCDD = oneclick == "1" ? true : false
                }
                else{
                    isShareCDD = connectTo.object(forKey: "is_sharing_cdd") as? Bool ?? false
                }
            }
            var isShareReceiver = false
            if let receiver = dict.object(forKey: "receiver") as? NSDictionary
            {
                if let oneclick = receiver.object(forKey: "is_sharing_cdd") as? String
                {
                    isShareReceiver = oneclick == "1" ? true : false
                }
                else{
                    isShareReceiver = receiver.object(forKey: "is_sharing_cdd") as? Bool ?? false
                }
            }
            
            if let sender_req_cdd = activityObj.dict.object(forKey: "receiver_req_cdd") as? NSDictionary {
                let status = sender_req_cdd.object(forKey: "status") as? String ?? ""
                if status == "pending"{
                    cell.viewCCDReport.isHidden = false
                    cell.spaceRequestCDD.isHidden = false
                    cell.btnCDD.setTitle("CDD REQUEST PENDING", for: .normal)
                    cell.bgCDD.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_XAM)
                }else{
                    cell.viewCCDReport.isHidden = true
                    cell.spaceRequestCDD.isHidden = true
                }
                
                if status == "accepted" || isShareCDD {
                    cell.spaceViewCDD.isHidden = false
                    cell.viewCDDReport.isHidden = false
                    cell.spaceInpec.isHidden = false
                    cell.viewInspection.isHidden = false
                }
                else{
                    cell.spaceViewCDD.isHidden = true
                    cell.viewCDDReport.isHidden = true
                    cell.spaceInpec.isHidden = true
                    cell.viewInspection.isHidden = true
                }
            }
            else{
                if !isShareCDD {
                    cell.spaceInpec.isHidden = true
                    cell.viewInspection.isHidden = true
                    cell.spaceRequestCDD.isHidden = false
                    cell.spaceViewCDD.isHidden = true
                    cell.viewCDDReport.isHidden = true
                    cell.viewCCDReport.isHidden = false
                    cell.btnCDD.setTitle("REQUEST CDD REPORT", for: .normal)
                    cell.bgCDD.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_XANH)
                }
                else{
                   
                    cell.spaceRequestCDD.isHidden = true
                    cell.spaceViewCDD.isHidden = true
                    cell.spaceViewCDD.isHidden = false
                    cell.viewCDDReport.isHidden = false
                    cell.spaceInpec.isHidden = false
                    cell.viewInspection.isHidden = false
                }
            }
            if let receiver_req_cdd = activityObj.dict.object(forKey: "sender_req_cdd") as? NSDictionary{
                let statusReceiver = receiver_req_cdd.object(forKey: "status") as? String ?? ""
                if statusReceiver == "pending" {
                    cell.viewAccept.isHidden = false
                    cell.viewDieclineReport.isHidden = false
                    cell.spaceAcept.isHidden = false
                    cell.spaceDeline.isHidden = false
                }
                else{
                    cell.viewAccept.isHidden = true
                    cell.viewDieclineReport.isHidden = true
                    cell.spaceAcept.isHidden = true
                    cell.spaceDeline.isHidden = true
                }
                
                if statusReceiver == "accepted" {
                    
                    cell.spaceRemove.isHidden = false
                    cell.viewRevoke.isHidden = false
                }
                else{
                    cell.spaceRemove.isHidden = true
                    cell.viewRevoke.isHidden = true
                }
            }
            else{
                if isShareReceiver {
                    cell.spaceRemove.isHidden = false
                    cell.viewRevoke.isHidden = false
                }
            }
        }
        
        cell.tapViewConnect = { [] in
            if let _id = activityObj.dict.object(forKey: "_id") as? String
            {
                let actType = self.getValueActype(_id)
                if self.arrIDNotification.contains(_id) && !actType.isEmpty
                {
                    self.readNotification(_id)
                }
               
            }
            var dictInfo: NSDictionary?
            if activityObj.sentRqs {
                if let connectTo = activityObj.dict.object(forKey: "receiver") as? NSDictionary
                {
                    dictInfo = connectTo
                }
            }
            else{
                if let connectTo = activityObj.dict.object(forKey: "sender") as? NSDictionary
                {
                    dictInfo = connectTo
                }
            }
            if let dict = dictInfo {
                if let _id = dict.object(forKey: "_id") as? String
                {
                    self.openSafari("\(URL_AVARTA)/connectreport/\(_id)")
                }

            }
            else{
                APP_DELEGATE.showAlert("No connect report")
            }
        }
        cell.tapRemoveConnect = { [] in
                 
                if let _id = activityObj.dict.object(forKey: "_id") as? String
                {
                    let actType = self.getValueActype(_id)
                    if self.arrIDNotification.contains(_id) && !actType.isEmpty
                    {
                        self.readNotification(_id)
                    }
                   
                }
            
             self.deleteConnect(activityObj.dict.object(forKey: "req_id") as? String ?? "")
        }
        
        
        cell.tapCCDReport = { [] in
            if activityObj.sentRqs{
                if let sender_req_cdd = activityObj.dict.object(forKey: "sender_req_cdd") as? NSDictionary {
                    let status = sender_req_cdd.object(forKey: "status") as? String ?? ""
                    if status == "pending"{
                    }else{
                    }
                }
                else{
                    if let _id = activityObj.dict.object(forKey: "_id") as? String
                    {
                        let actType = self.getValueActype(_id)
                        if self.arrIDNotification.contains(_id) && !actType.isEmpty
                        {
                            self.readNotification(_id)
                        }
                       
                    }
                    self.requestCDDReport(activityObj.dict.object(forKey: "req_id") as? String ?? "", "request-access-cdd")
                }
            }
            else{
                if let receiver_req_cdd = activityObj.dict.object(forKey: "receiver_req_cdd") as? NSDictionary {
                    let status = receiver_req_cdd.object(forKey: "status") as? String ?? ""
                    if status == "pending"{
                       
                    }else{
                       
                    }
                }
                else{
                    if let _id = activityObj.dict.object(forKey: "_id") as? String
                    {
                        let actType = self.getValueActype(_id)
                        if self.arrIDNotification.contains(_id) && !actType.isEmpty
                        {
                            self.readNotification(_id)
                        }
                       
                    }
                    self.requestCDDReport(activityObj.dict.object(forKey: "req_id") as? String ?? "", "request-access-cdd")
                }
            }
        }
        cell.tapViewCDDReport = { [] in
            if let _id = activityObj.dict.object(forKey: "_id") as? String
            {
                let actType = self.getValueActype(_id)
                if self.arrIDNotification.contains(_id) && !actType.isEmpty
                {
                    self.readNotification(_id)
                }
               
            }
            if activityObj.sentRqs {
                if let receiver_req_cdd = activityObj.dict.object(forKey: "sender_req_cdd") as? NSDictionary {
                    if  let access = receiver_req_cdd.object(forKey: "access_token") as? String
                    {
                        self.openSafari("\(URL_SERVER)connect/\(activityObj.dict.object(forKey: "_id") as? String ?? "")/view/\(access)?access_token=\(UserDefaults.standard.value(forKey: kToken) as? String ?? "")")
                    }
                }
                
                
            }
            else{
                if let sender_req_cdd = activityObj.dict.object(forKey: "receiver_req_cdd") as? NSDictionary {
                    if  let access = sender_req_cdd.object(forKey: "access_token") as? String
                    {
                        self.openSafari("\(URL_SERVER)connect/\(activityObj.dict.object(forKey: "req_id") as? String ?? "")/view/\(access)?access_token=\(UserDefaults.standard.value(forKey: kToken) as? String ?? "")")
                    }
                }else{
                    var dictInfo: NSDictionary?
                    if activityObj.sentRqs {
                        if let connectTo = activityObj.dict.object(forKey: "receiver") as? NSDictionary
                        {
                            dictInfo = connectTo
                        }
                    }
                    else{
                        if let connectTo = activityObj.dict.object(forKey: "sender") as? NSDictionary
                        {
                            dictInfo = connectTo
                        }
                    }
                    if let dict = dictInfo{
                        if let InspectRp = dict.object(forKey: "cdd") as? NSDictionary, let fileUrl = InspectRp.object(forKey: "fileP") as? String {
                            self.openSafari("\(URL_AVARTA)/\(fileUrl)")
                        }
                    }
                }
            }
            
        }
        cell.tapAccept = { [] in
            if let _id = activityObj.dict.object(forKey: "_id") as? String
            {
                let actType = self.getValueActype(_id)
                if self.arrIDNotification.contains(_id) && !actType.isEmpty
                {
                    self.readNotification(_id)
                }
               
            }
            self.requestCDDReport(activityObj.dict.object(forKey: "req_id") as? String ?? "", "accept-access-cdd")
        }
        cell.tapDeclineCDDReport = { [] in
            if let _id = activityObj.dict.object(forKey: "_id") as? String
            {
                let actType = self.getValueActype(_id)
                if self.arrIDNotification.contains(_id) && !actType.isEmpty
                {
                    self.readNotification(_id)
                }
               
            }
            self.requestCDDReport(activityObj.dict.object(forKey: "req_id") as? String ?? "", "decline-access-cdd")
            //self.requestCDDReport(obj.dict.object(forKey: "_id") as? String ?? "")
        }
        
        cell.tapRevoke = { [] in
            
            if let _id = activityObj.dict.object(forKey: "_id") as? String
            {
                let actType = self.getValueActype(_id)
                if self.arrIDNotification.contains(_id) && !actType.isEmpty
                {
                    self.readNotification(_id)
                }
               
            }
            if activityObj.sentRqs {
                var isShareSender = false
                if let sender = dict.object(forKey: "sender") as? NSDictionary
                {
                    if let oneclick = sender.object(forKey: "is_sharing_cdd") as? String
                    {
                        isShareSender = oneclick == "1" ? true : false
                    }
                    else{
                        isShareSender = sender.object(forKey: "is_sharing_cdd") as? Bool ?? false
                    }
                }
                if let receiver_req_cdd = activityObj.dict.object(forKey: "receiver_req_cdd") as? NSDictionary {
                    let status = receiver_req_cdd.object(forKey: "status") as? String ?? ""
                   
                    if status == "accepted"{
                        self.callAPIRemoveConnect(activityObj.dict.object(forKey: "req_id") as? String ?? "", "")
                    }
                }
                else{
                    if isShareSender {
                        self.turnOffShare(activityObj.dict.object(forKey: "req_id") as? String ?? "")
                    }
                }
            }
            else{
                var isShareRe = false
                if let receiver = activityObj.dict.object(forKey: "receiver") as? NSDictionary
                {
                    if let oneclick = receiver.object(forKey: "is_sharing_cdd") as? String
                    {
                        isShareRe = oneclick == "1" ? true : false
                    }
                    else{
                        isShareRe = receiver.object(forKey: "is_sharing_cdd") as? Bool ?? false
                    }
                }
                if let sender_req_cdd = activityObj.dict.object(forKey: "sender_req_cdd") as? NSDictionary {
                    let status = sender_req_cdd.object(forKey: "status") as? String ?? ""
                   
                    if status == "accepted"{
                        self.callAPIRemoveConnect(activityObj.dict.object(forKey: "req_id") as? String ?? "", "")
                    }
                }
                else{
                    if isShareRe {
                        self.turnOffShare(activityObj.dict.object(forKey: "req_id") as? String ?? "")
                    }
                }
                
               // self.callAPIRemoveConnect(activityObj.dict.object(forKey: "req_id") as? String ?? "", "")
            }
            
        
         
        }
        
        cell.tapInspection = { [] in
            var dictInfo: NSDictionary?
            if activityObj.sentRqs {
                if let connectTo = activityObj.dict.object(forKey: "receiver") as? NSDictionary
                {
                    dictInfo = connectTo
                }
            }
            else{
                if let connectTo = activityObj.dict.object(forKey: "sender") as? NSDictionary
                {
                    dictInfo = connectTo
                }
            }
            if let dict = dictInfo{
                if let InspectRp = dict.object(forKey: "InspectRp") as? NSDictionary, let fileUrl = InspectRp.object(forKey: "fileUrl") as? String {
                    self.openSafari("\(URL_AVARTA)/\(fileUrl)")
                }
            }
        }
//        if let exchangedCDD = activityObj.dict.object(forKey: "exchangedCDD") as? NSDictionary{
//            if activityObj.dict.object(forKey: "accessToken") == nil{
//                let requestedId = exchangedCDD.object(forKey: "requestedId") as? String ?? ""
//                if requestedId == APP_DELEGATE.profileObj?._id {
//                    cell.viewDieclineReport.isHidden = true
//                    cell.btnCDD.setTitle("CDD REQUEST PENDING", for: .normal)
//                    cell.bgCDD.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_XAM)
//                }
//                else{
//                    cell.viewDieclineReport.isHidden = false
//                    cell.btnCDD.setTitle("ACCEPT TO SHARE CDD REPORT", for: .normal)
//                    cell.bgCDD.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_TIM)
//                }
//            }
//            else{
//                cell.viewDieclineReport.isHidden = true
//                cell.btnCDD.setTitle("VIEW CDD REPORT", for: .normal)
//                cell.bgCDD.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_XANH)
//            }
//        }
//        else{
//            cell.viewDieclineReport.isHidden = true
//            cell.btnCDD.setTitle("REQUEST CDD REPORT", for: .normal)
//            cell.bgCDD.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_XANH)
//
//        }
    }
    func callAPIAccept(_ id: String)
    {
        
        let param = ["cid":id]
        ApiHelper.shared.acceptConnection(param) { (success, error) in
            if success
            {
              self.callAPIGetConnection()
            }
            else{
                if error != nil {
                    APP_DELEGATE.showAlert(error!.msg!)
                }
            }
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
                   if indexP <= self.arrIDNotificationRequest.count {
                       self.arrIDNotificationRequest.remove(at: indexP)
                   }
                   self.arrIDNotification.remove(at: indexP)
                   
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
    
   
    func callAPIRemoveConnect(_ id: String, _ status: String)
    {
        
        ApiHelper.shared.removeConnectNew(id) { success, errer in
            if success
            {
                self.callAPIGetConnection()
            }
            else{
                if errer != nil {
                    APP_DELEGATE.showAlert(errer!.msg!)
                }
            }
        }
    }
    
    func turnOffShare(_ id: String)
    {
        
        ApiHelper.shared.turnOnOffsharing(id) { success, errer in
            if success
            {
                self.callAPIGetConnection()
            }
            else{
                if errer != nil {
                    APP_DELEGATE.showAlert(errer!.msg!)
                }
            }
        }
    }
    func deleteConnect(_ id: String)
    {
        
        ApiHelper.shared.deleteConnectNew(id) { success, errer in
            if success
            {
                self.callAPIGetConnection()
            }
            else{
                if errer != nil {
                    APP_DELEGATE.showAlert(errer!.msg!)
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
                self.callAPIGetConnection()
            }
            else{
                if error != nil {
                    APP_DELEGATE.showAlert(error!.msg!)
                }
            }
        }
    }
    
    func requestCDDReport(_ id: String, _ action: String)
    {
        ApiHelper.shared.APINewConnection(id, action) { success, errer, erroCode in
            if success
            {
                self.callAPIGetConnection()
            }
            else{
                if errer != nil {
                   APP_DELEGATE.showAlert(errer!.msg!)
               }
            }
        }
       
    }
    
    func acceptCDDRequest(_ id: String)
    {
         let param = ["cid":id]
        ApiHelper.shared.AcceptCDDRequest(param) { (success, error) in
            if success
            {
                self.callAPIGetConnection()
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
                self.callAPIGetConnection()
            }
            else{
                if error != nil {
                    APP_DELEGATE.showAlert(error!.msg!)
                }
            }
        }
    }
}
