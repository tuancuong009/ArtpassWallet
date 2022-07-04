//
//  BaseVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 9/14/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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
    func updateBadgeNotificaiton()
    {
        
        ApiHelper.shared.getNotifications { (success, arrs) in
            if let notifs = arrs
            {
                var numberRequest = 0
                var numberActivity = 0
                var numberArchived = 0
                var numberConnectiton = 0
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
                    
                     if item.actType == "pin_changing" || item.actType == "username_changing" || item.actType == "profile_pic_changing"{
                         
                     }
                      else if item.actType == "kyc_creating"{
                        numberKYCCreate = numberKYCCreate + 1
                        
                    }
                        
                    else if item.actType == "apid_creating"{
                        numberKYCCreate = numberKYCCreate + 1
                        
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
            else{
               self.tabBarController?.tabBar.items![2].badgeValue = nil
            }
        }
    }
}
