//
//  MyAccountVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 2/5/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit
import SafariServices
class MyAccountVC: UIViewController {

    @IBOutlet weak var subNotification: UIViewX!
    @IBOutlet weak var SubNotificationProfile: UIViewX!
    @IBOutlet weak var lblNumberNotiProfile: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if UserDefaults.standard.bool(forKey: KEY_NOTIFICATION_SETTING) {
           if APP_DELEGATE.notificationChangeUserName != nil && APP_DELEGATE.notificationChangeProfilePic != nil{
              self.SubNotificationProfile.isHidden = false
                self.lblNumberNotiProfile.text = "2"
           }
           else{
                if APP_DELEGATE.notificationChangeUserName != nil {
                    self.SubNotificationProfile.isHidden = false
                    self.lblNumberNotiProfile.text = "1"
                }
                else if APP_DELEGATE.notificationChangeProfilePic != nil {
                    self.SubNotificationProfile.isHidden = false
                    self.lblNumberNotiProfile.text = "1"
                }
                else{
                    self.SubNotificationProfile.isHidden = true
                }
            
           }
           self.subNotification.isHidden = false
           
       }
       else{
            self.subNotification.isHidden = true
           if APP_DELEGATE.notificationChangeUserName != nil && APP_DELEGATE.notificationChangeProfilePic != nil{
              self.SubNotificationProfile.isHidden = false
                self.lblNumberNotiProfile.text = "2"
           }
           else{
                if APP_DELEGATE.notificationChangeUserName != nil {
                    self.SubNotificationProfile.isHidden = false
                    self.lblNumberNotiProfile.text = "1"
                }
                else if APP_DELEGATE.notificationChangeProfilePic != nil {
                    self.SubNotificationProfile.isHidden = false
                    self.lblNumberNotiProfile.text = "1"
                }
                else{
                    self.SubNotificationProfile.isHidden = true
                }
            
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
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func doTerm(_ sender: Any) {
        let vc = SFSafariViewController.init(url: URL.init(string: URL_TERMS)!)
        self.present(vc, animated: true) {
            
        }
    }
    @IBAction func doProfile(_ sender: Any) {
        let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "MyProfileVC") as! MyProfileVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func doSuport(_ sender: Any) {
        let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "SupportVC") as! SupportVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
