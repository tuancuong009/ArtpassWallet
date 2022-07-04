//
//  MyActivityVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 2/5/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit

class MyActivityVC: UIViewController {
    var arrNotifications = [NotificationObj]()
    @IBOutlet weak var subNotiActivity: UIViewX!
    @IBOutlet weak var lblNumberActivity: UILabel!
    @IBOutlet weak var subNotiArchived: UIViewX!
    @IBOutlet weak var lblNumberArchived: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.redirectActivity()
        APP_DELEGATE.actype = ""
        APP_DELEGATE.tracsationID = ""
        APP_DELEGATE.notificationID = ""
        self.callNotifications()
        super.viewWillAppear(animated)
    }
    
    func redirectActivity()
    {
        self.callNotificationsRedirect()
        
    }

    @IBAction func doActivity(_ sender: Any) {
        let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "MyActivityReportVC") as! MyActivityReportVC
        vc.arrNotifications = self.arrNotifications
        self.navigationController?.pushViewController(vc, animated: true)
      
    }
    @IBAction func doArchived(_ sender: Any) {
        self.subNotiArchived.isHidden = true
        self.unreadTabbar()
        let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "MyArchivedVC") as! MyArchivedVC
        vc.arrNotificationArchived = self.arrayArchivedNotification()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func arrayArchivedNotification()-> [NotificationObj]
    {
        var arrs = [NotificationObj]()
        for item in self.arrNotifications
        {
            if item.notifyCat == 2 && item.menuId == "F" {
                
            }
            else{
                if item.actType == "requested_cdd" || item.actType == "accepted_trade_connect"
                {
                }
                else{
                    arrs.append(item)
                }
            }
        }
        return arrs
    }
    func showHideActivity()
    {
        var numberActivity = 0
        var numberArchived = 0
        var numberRequest = 0
        var numberConnectiton = 0
        for item in self.arrNotifications
        {
            if item.actType == "pin_changing" || item.actType == "username_changing" || item.actType == "profile_pic_changing"{
                 
             }
              else if item.actType == "kyc_creating"{
               
                
            }
                
            else if item.actType == "apid_creating"{
                
            }
            else if item.notifyCat == 1 && item.menuId == "F"
            {
                numberRequest = numberRequest + 1
            }
            else if item.notifyCat == 1
            {
                numberActivity = numberActivity + 1
            }
            else if item.notifyCat == 2 && item.menuId == "F"
            {
                numberConnectiton = numberConnectiton + 1
            }
            else{
                numberArchived = numberArchived + 1
            }
        }
        if numberActivity == 0
        {
            self.subNotiActivity.isHidden = true
        }
        else{
            self.subNotiActivity.isHidden = false
            self.lblNumberActivity.text = "\(numberActivity)"
        }
        if numberArchived == 0
        {
            self.subNotiArchived.isHidden = true
        }
        else{
            self.subNotiArchived.isHidden = false
            self.lblNumberArchived.text = "\(numberArchived)"
        }
        if numberActivity + numberArchived > 0
        {
            self.tabBarController?.tabBar.items![2].badgeValue = "\(numberActivity + numberArchived)"
        }
        else{
             self.tabBarController?.tabBar.items![2].badgeValue = nil
        }
        
        if numberRequest + numberConnectiton > 0
        {
            self.tabBarController?.tabBar.items![1].badgeValue = "\(numberRequest + numberConnectiton)"
        }
        else{
             self.tabBarController?.tabBar.items![1].badgeValue = nil
        }
    }
    
    func unreadTabbar()
    {
        let arrs = self.arrayArchivedNotification()
        let numer = self.arrNotifications.count -  arrs.count
        if  numer > 0
        {
            self.tabBarController?.tabBar.items![2].badgeValue = "\(numer)"
        }
        else{
             self.tabBarController?.tabBar.items![2].badgeValue = nil
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

    @IBAction func doClickBuyer(_ sender: Any) {
        self.getUserInfo()
    }
    
    
}

extension MyActivityVC
{
    private func getUserInfo()
    {
        Common.showBusy()
        ApiHelper.shared.getUserInfo { (success,obj, error) in
            Common.hideBusy()
            if let profileObj = obj
            {
                APP_DELEGATE.profileObj = profileObj
                if profileObj.payment == nil {
                    APP_DELEGATE.showAlert("Please update your Buyer settings first to use 1-Click Compliance.")
                }
                else{
                    let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "ClickBuyerVC") as! ClickBuyerVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            else{
                APP_DELEGATE.showAlert("Please update your Buyer settings first to use 1-Click Compliance.")
            }
            
        }
    }
    
    private func callNotifications()
    {
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
        ApiHelper.shared.getNotifications { (success, arrs) in
            if let notifs = arrs
            {
                self.arrNotifications = notifs
                self.showHideActivity()
            }
            else{
                self.arrNotifications.removeAll()
                self.showHideActivity()
            }
        }
    }
    
    private func callNotificationsRedirect()
    {
       // Common.showBusy()
        
        ApiHelper.shared.getNotifications { (success, arrs) in
          //  Common.hideBusy()
            if let notifs = arrs
            {
                self.arrNotifications = notifs
                
            }
            else{
                self.arrNotifications.removeAll()
            }
            if APP_DELEGATE.isRedirectActivity {
                APP_DELEGATE.isRedirectActivity = false
                let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "MyActivityReportVC") as! MyActivityReportVC
                vc.arrNotifications = self.arrNotifications
                self.navigationController?.pushViewController(vc, animated: true)
               
            }
            else if APP_DELEGATE.isRedirectArchived {
                APP_DELEGATE.isRedirectArchived = false
                self.subNotiArchived.isHidden = true
                self.unreadTabbar()
                let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "MyArchivedVC") as! MyArchivedVC
                vc.arrNotificationArchived = self.arrayArchivedNotification()
                self.navigationController?.pushViewController(vc, animated: true)
            }
           
        }
    }
    
}
