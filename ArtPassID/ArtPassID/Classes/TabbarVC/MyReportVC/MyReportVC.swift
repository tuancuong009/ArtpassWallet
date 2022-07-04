//
//  MyReportVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 3/2/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit
import SafariServices
class MyReportVC: BaseVC {

    @IBOutlet weak var tblReport: UITableView!
    @IBOutlet weak var viewError: UIView!
    var notificationObj: NotificationObj?
    var arrNotifications = [NotificationObj]()
    override func viewDidLoad() {
        super.viewDidLoad()
         self.tblReport.isHidden = true
        self.viewError.isHidden = true
      
         self.updateBadgeNotificaitonReload()
        
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
}
extension MyReportVC: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblReport.dequeueReusableCell(withIdentifier: "MyReportCell") as! MyReportCell
        self.configCell(cell, indexPath)
        if notificationObj == nil {
            cell.subNotification.isHidden = true
        }
        else{
            if indexPath.row == 0 {
                if notificationObj!.actType == "kyc_creating" {
                    cell.subNotification.isHidden = false
                }
                else{
                    cell.subNotification.isHidden = true
                }
            }
            else if indexPath.row == 1 {
                if notificationObj!.actType == "apid_creating" {
                   cell.subNotification.isHidden = false
               }
               else{
                   cell.subNotification.isHidden = true
               }
            }
        }
        cell.tapViewReport = { [] in
            if indexPath.row == 0 {
//
//                if APP_DELEGATE.profileObj?.utype == UTYPE_USER.BUSINESS {
//                   if APP_DELEGATE.profileObj?.company_info == nil {
//                        self.callCddCreateReportBusiness()
//                   }
//                   else{
//                       let dictCmpany = APP_DELEGATE.profileObj?.company_info!
//                       if (dictCmpany!.object(forKey: "fileP") as? String) != nil
//                       {
//                           self.openFileCddBusiness()
//                       }
//                       else{
//                          self.callCddCreateReportBusiness()
//                       }
//                   }
//               }
//               else{
//                   if APP_DELEGATE.profileObj?.cdd == nil {
//                        self.callCddCreateReportPP()
//                   }
//                   else{
//                       let dictCmpany = APP_DELEGATE.profileObj?.cdd!
//                       if (dictCmpany!.object(forKey: "fileP") as? String) != nil
//                       {
//                           self.openFileCdd()
//                       }
//                       else{
//                           self.callCddCreateReportPP()
//                       }
//                   }
//               }
                if APP_DELEGATE.profileObj?.cdd == nil {
                    self.callCddCreateReportPP()
                }
                else{
                    let dictCmpany = APP_DELEGATE.profileObj?.cdd!
                    if (dictCmpany!.object(forKey: "fileP") as? String) != nil
                    {
                        self.openFileCdd()
                        
                    }
                    else{
                       self.callCddCreateReportPP()
                    }
                }
            }
            else{
                if APP_DELEGATE.profileObj?.connectRp != nil {
                    let connectRp = APP_DELEGATE.profileObj?.connectRp
                    if (connectRp!.object(forKey: "fileUrl") as? String) != nil
                    {
                          self.openViewConnectReport()
                    }
                    else{
                        self.callAPIConnectReport()
                    }
                }
                else{
                    self.callAPIConnectReport()
                }
//                var dictInfo: NSDictionary?
//                if APP_DELEGATE.profileObj?.utype == UTYPE_USER.BUSINESS {
//                   dictInfo = APP_DELEGATE.profileObj?.company_info
//                }
//                else{
//                   dictInfo = APP_DELEGATE.profileObj?.cdd
//               }
//               if dictInfo == nil {
//               }
//               else{
//                   if APP_DELEGATE.profileObj?.connectRp != nil {
//                       let connectRp = APP_DELEGATE.profileObj?.connectRp
//                       if (connectRp!.object(forKey: "fileUrl") as? String) != nil
//                       {
//                             self.openViewConnectReport()
//                       }
//                       else{
//                           self.callAPIConnectReport()
//                       }
//                   }
//                   else{
//                       let dictCmpany = dictInfo
//                       if (dictCmpany!.object(forKey: "fileP") as? String) != nil
//                       {
//                             self.callAPIConnectReport()
//                       }
//                       else{
//
//                       }
//                   }
//               }
            }
        }
        return cell
    }
    
    func configCell(_ cell: MyReportCell, _ indexPath: IndexPath)
    {
        if indexPath.row == 0 {
            cell.lblName.text = "MY CDD REPORT"
            cell.btnReview.setTitle("VIEW", for: .normal)
            cell.bgReview.backgroundColor =  Common.hexStringToUIColor(COLOR_REPORT.COLOR_TIM)
//            if APP_DELEGATE.profileObj?.utype == UTYPE_USER.BUSINESS {
//                if APP_DELEGATE.profileObj?.company_info == nil {
//                     cell.btnReview.setTitle("CREATE CDD REPORT", for: .normal)
//                     cell.bgReview.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_TIM)
//                }
//                else{
//                    let dictCmpany = APP_DELEGATE.profileObj?.company_info!
//                    if (dictCmpany!.object(forKey: "fileP") as? String) != nil
//                    {
//                         cell.btnReview.setTitle("VIEW", for: .normal)
//                          cell.bgReview.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_XANH)
//                    }
//                    else{
//                        cell.btnReview.setTitle("CREATE CDD REPORT", for: .normal)
//                        cell.bgReview.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_TIM)
//                    }
//                }
//            }
//            else{
//                if APP_DELEGATE.profileObj?.cdd == nil {
//                     cell.btnReview.setTitle("CREATE CDD REPORT", for: .normal)
//                     cell.bgReview.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_TIM)
//                }
//                else{
//                    let dictCmpany = APP_DELEGATE.profileObj?.cdd!
//                    if (dictCmpany!.object(forKey: "fileP") as? String) != nil
//                    {
//                         cell.btnReview.setTitle("VIEW", for: .normal)
//                          cell.bgReview.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_XANH)
//                    }
//                    else{
//                        cell.btnReview.setTitle("CREATE CDD REPORT", for: .normal)
//                        cell.bgReview.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_TIM)
//                    }
//                }
//            }
            if APP_DELEGATE.profileObj?.cdd == nil {
                 cell.btnReview.setTitle("CREATE CDD REPORT", for: .normal)
                 cell.bgReview.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_TIM)
            }
            else{
                let dictCmpany = APP_DELEGATE.profileObj?.cdd!
                if (dictCmpany!.object(forKey: "fileP") as? String) != nil
                {
                     cell.btnReview.setTitle("VIEW", for: .normal)
                      cell.bgReview.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_XANH)
                }
                else{
                    cell.btnReview.setTitle("CREATE CDD REPORT", for: .normal)
                    cell.bgReview.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_TIM)
                }
            }
        }
        else{
            cell.lblName.text = "MY ARTPASS ID"
            if APP_DELEGATE.profileObj?.connectRp != nil {
                let connectRp = APP_DELEGATE.profileObj?.connectRp
                if (connectRp!.object(forKey: "fileUrl") as? String) != nil
                {
                     cell.btnReview.setTitle("VIEW ARTPASS ID", for: .normal)
                      cell.bgReview.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_XANH)
                }
                else{
                    cell.btnReview.setTitle("CREATE YOUR REPORT", for: .normal)
                    cell.bgReview.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_TIM)
                }
            }
            else{
                cell.btnReview.setTitle("CREATE YOUR REPORT", for: .normal)
                cell.bgReview.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_TIM)
            }
//            cell.lblName.text = "MY ARTPASS ID"
//            var dictInfo: NSDictionary?
//             if APP_DELEGATE.profileObj?.utype == UTYPE_USER.BUSINESS {
//                dictInfo = APP_DELEGATE.profileObj?.company_info
//             }
//             else{
//                dictInfo = APP_DELEGATE.profileObj?.cdd
//            }
//            if dictInfo == nil {
//                cell.btnReview.setTitle("PENDING AML UPDATE", for: .normal)
//                cell.bgReview.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_XAM)
//            }
//            else{
//                if APP_DELEGATE.profileObj?.connectRp != nil {
//                    let connectRp = APP_DELEGATE.profileObj?.connectRp
//                    if (connectRp!.object(forKey: "fileUrl") as? String) != nil
//                    {
//                         cell.btnReview.setTitle("VIEW ARTPASS ID", for: .normal)
//                          cell.bgReview.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_XANH)
//                    }
//                    else{
//                        cell.btnReview.setTitle("CREATE YOUR REPORT", for: .normal)
//                        cell.bgReview.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_TIM)
//                    }
//                }
//                else{
//                    let dictCmpany = dictInfo
//                    if (dictCmpany!.object(forKey: "fileP") as? String) != nil
//                    {
//                          cell.btnReview.setTitle("CREATE YOUR REPORT", for: .normal)
//                         cell.bgReview.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_TIM)
//                    }
//                    else{
//                        cell.btnReview.setTitle("PENDING AML UPDATE", for: .normal)
//                        cell.bgReview.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_XAM)
//                    }
//                }
//            }
        }
    }
    
    func callAPIConnectReport()
    {
        ApiHelper.shared.createConnectReport { (success, error) in
            if success
            {
              self.updateBadgeNotificaitonReload()
            }
            else{
                if error != nil {
                    APP_DELEGATE.showAlert(error!.msg!)
                }
            }
        }
    }
    
    func callCddCreateReportPP()
    {
        ApiHelper.shared.createCddReportPP { (success, error, statusCode) in
            if success
            {
              self.updateBadgeNotificaitonReload()
            }
            else{
                if statusCode == 500 {
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
        }
    }
    func updateBadgeNotificaitonReload()
    {
        self.arrNotifications.removeAll()
        ApiHelper.shared.getNotifications { (success, arrs) in
            if let notifs = arrs
            {
                 var numberKYCCreate = 0
                for item in notifs
                {
                    if item.actType == "pin_changing"{
                       UserDefaults.standard.set(true, forKey: KEY_NOTIFICATION_SETTING)
                        APP_DELEGATE.notificationChangePin = item
                   }
                    if item.actType == "username_changing"{
                         APP_DELEGATE.notificationChangeUserName = item
                    }
                    else{
                       APP_DELEGATE.notificationChangeUserName = nil
                    }
                    if item.actType == "profile_pic_changing"{
                         APP_DELEGATE.notificationChangeProfilePic = item
                    }
                    else{
                       APP_DELEGATE.notificationChangeProfilePic = nil
                    }
                    if item.actType == "kyc_creating"{
                        numberKYCCreate = numberKYCCreate + 1
                        self.arrNotifications.append(item)
                    }
                    else if item.actType == "apid_creating"{
                        numberKYCCreate = numberKYCCreate + 1
                        self.arrNotifications.append(item)
                    }
                   
                }
                
                if UserDefaults.standard.bool(forKey: KEY_NOTIFICATION_SETTING) {
                   
                    if APP_DELEGATE.notificationChangeUserName != nil && APP_DELEGATE.notificationChangeProfilePic != nil {
                        self.tabBarController?.tabBar.items![3].badgeValue = "3"
                    }
                    else{
                        if APP_DELEGATE.notificationChangeUserName != nil{
                            self.tabBarController?.tabBar.items![3].badgeValue = "2"
                        }
                        else  if APP_DELEGATE.notificationChangeProfilePic != nil{
                            self.tabBarController?.tabBar.items![3].badgeValue = "2"
                        }
                        else{
                            self.tabBarController?.tabBar.items![3].badgeValue = "1"
                        }
                    }
                    
                    
                }
                else{
                    if APP_DELEGATE.notificationChangeUserName != nil && APP_DELEGATE.notificationChangeProfilePic != nil {
                        self.tabBarController?.tabBar.items![3].badgeValue = "2"
                    }
                    else{
                        if APP_DELEGATE.notificationChangeUserName != nil{
                            self.tabBarController?.tabBar.items![3].badgeValue = "1"
                        }
                        else  if APP_DELEGATE.notificationChangeProfilePic != nil{
                            self.tabBarController?.tabBar.items![3].badgeValue = "1"
                        }
                        else{
                            self.tabBarController?.tabBar.items![3].badgeValue = nil
                        }
                    }
                }
                if numberKYCCreate > 0
                {
                    self.tabBarController?.tabBar.items![0].badgeValue = "\(numberKYCCreate)"
                    if let vc = APP_DELEGATE.myKYCVC{
                        vc.subNotification.isHidden = false
                    }
                }
                else{
                     self.tabBarController?.tabBar.items![0].badgeValue = nil
                    if let vc = APP_DELEGATE.myKYCVC{
                        vc.subNotification.isHidden = true
                    }
                }
            }
            else{
               self.tabBarController?.tabBar.items![2].badgeValue = nil
            }
            
           if self.arrNotifications.count > 0{
              self.notificationObj = self.arrNotifications[0]
              
          }
           else{
                self.notificationObj = nil
          }
          self.getUserInfo()
        }
    }
    func callCddCreateReportBusiness()
    {
        
        ApiHelper.shared.createCddReportBusiness { (success, error, statusCode) in
            if success
            {
              self.updateBadgeNotificaitonReload()
            }
            else{
                if statusCode == 500 {
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
        }
    }
    
    @objc func hideError()
    {
        self.tabBarController?.tabBar.isHidden = false
         self.viewError.isHidden = true
    }
    func openViewConnectReport()
    {
        let url = "\(URL_AVARTA)/connectreport/\(APP_DELEGATE.profileObj!._id)"
        print(url)
        let vc = SFSafariViewController.init(url: URL.init(string: url)!)
        self.present(vc, animated: true) {
            
        }
    }
 
    func openFileCdd()
    {
        let dictCmpany = APP_DELEGATE.profileObj?.cdd!
        if (dictCmpany!.object(forKey: "fileP") as? String) != nil
        {
             let url = "\(URL_AVARTA)/\(dictCmpany!.object(forKey: "fileP") as! String)"
            print(url)
            let vc = SFSafariViewController.init(url: URL.init(string: url)!)
            self.present(vc, animated: true) {
    
            }
        }
//        let url = "\(URL_AVARTA)/cddreport/\(APP_DELEGATE.profileObj!._id)"
//        print(url)
//        let vc = SFSafariViewController.init(url: URL.init(string: url)!)
//        self.present(vc, animated: true) {
//
//        }
    }
    
    func openFileCddBusiness()
    {
        let url = "\(URL_AVARTA)/profilereport/\(APP_DELEGATE.profileObj!._id)"
        print(url)
        let vc = SFSafariViewController.init(url: URL.init(string: url)!)
        self.present(vc, animated: true) {
            
        }
    }
}

extension MyReportVC
{
    private func getUserInfo()
    {
       
        ApiHelper.shared.getUserInfo { (success,obj, error) in
            if let profileObj = obj
            {
                self.tblReport.isHidden = false
                APP_DELEGATE.profileObj = profileObj
                self.tblReport.reloadData()
            }
        }
        
        
    }
}
