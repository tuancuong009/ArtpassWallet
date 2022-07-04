//
//  MyArtPassVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 2/5/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit

class MyArtPassVC: UIViewController {

   // @IBOutlet weak var subNotificationRequest: UIViewX!
    //@IBOutlet weak var lblNumberRequest: UILabel!
    @IBOutlet weak var subNotificationConnection: UIViewX!
    @IBOutlet weak var lblNumberConnection: UILabel!
    var arrIDNotificationTrades = [NotificationObj]()
     var arrIDNotificationConnection = [NotificationObj]()
    var arrIDNotificationRequest = [NotificationObj]()
    @IBOutlet weak var subNotificationTrade: UIViewX!
    @IBOutlet weak var lblNumberTradeNotifi: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.callNotifications()
        if APP_DELEGATE.isConnect
        {
            APP_DELEGATE.isConnect = false
            let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "RequestReceiverVC") as! RequestReceiverVC
            self.navigationController?.pushViewController(vc, animated: true)
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

    @IBAction func doConnect(_ sender: Any) {
        let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "MyPassIDVC") as! MyPassIDVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func doConnection(_ sender: Any) {
//        let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "NewMyConnectionVC") as! NewMyConnectionVC
//        vc.arrIDNotificationRequest = self.arrIDNotificationConnection
//        vc.numerRequest = self.arrIDNotificationConnection.count
//        self.navigationController?.pushViewController(vc, animated: true)
        let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "MyTradeConnectionVC") as! MyTradeConnectionVC
        vc.arrNotifications = self.arrIDNotificationTrades
        vc.myArtPassVC = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func doCreateEvent(_ sender: Any) {
        let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "ScanConnectVC") as! ScanConnectVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func doRequest(_ sender: Any) {
       // let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "RequestReceiverVC") as! RequestReceiverVC
        //vc.arrIDNotificationRequest = self.arrIDNotificationRequest
        //vc.numberConnection = self.arrIDNotificationConnection.count
        //self.navigationController?.pushViewController(vc, animated: true)
//        let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "NewMyTradeVC") as! NewMyTradeVC
//        vc.arrIDNotificationRequest = self.arrIDNotificationTrades
//        vc.numerRequest = self.arrIDNotificationTrades.count
//        self.navigationController?.pushViewController(vc, animated: true)
        let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "RequestReceiverVC") as! RequestReceiverVC
         vc.arrIDNotificationRequest = self.arrIDNotificationRequest
         vc.numberConnection = self.arrIDNotificationRequest.count
         self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func callNotifications()
   {
        
        self.arrIDNotificationRequest.removeAll()
        self.arrIDNotificationConnection.removeAll()
        ApiHelper.shared.getNotifications { (success, arrs) in
            self.arrIDNotificationRequest.removeAll()
            self.arrIDNotificationConnection.removeAll()
          if let notifs = arrs
          {
              
              var numberRequest = 0
              var numberActivity = 0
              var numberArchived = 0
              var numberConnectiton = 0
              var numberTrade = 0
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
                  }else if item.actType == "apid_creating"{
                      numberKYCCreate = numberKYCCreate + 1
                      
                  }
                  else if item.notifyCat == 1 && item.menuId == "F"
                  {
                     self.arrIDNotificationRequest.append(item)
                      numberRequest = numberRequest + 1
                  }
                  else if item.notifyCat == 1
                  {
                      numberActivity = numberActivity + 1
                  }
                  else if item.notifyCat == 2 && item.menuId == "F"
                  {
                    if item.actType == "requested_cdd" || item.actType == "accepted_trade_connect" || item.actType == "accepted_request"
                    {
                        self.arrIDNotificationTrades.append(item)
                        numberTrade = numberTrade + 1
                    }
                    else if item.actType == "sent_request"{
                        self.arrIDNotificationConnection.append(item)
                        numberConnectiton = numberConnectiton + 1
                    }
                        
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
            }
            else{
                 self.tabBarController?.tabBar.items![0].badgeValue = nil
            }
                if numberActivity + numberArchived > 0
                {
                    self.tabBarController?.tabBar.items![2].badgeValue = "\(numberActivity + numberArchived)"
                }
                else{
                    self.tabBarController?.tabBar.items![2].badgeValue = nil
                }
                if numberRequest +  numberConnectiton + numberTrade > 0
                {
                    self.tabBarController?.tabBar.items![1].badgeValue = "\(numberRequest + numberConnectiton + numberTrade)"
                }
                else{
                     //self.subNotificationRequest.isHidden = true
                     self.tabBarController?.tabBar.items![1].badgeValue = nil
                }
               if numberTrade > 0
               {
                    self.subNotificationTrade.isHidden = false
                    self.lblNumberTradeNotifi.text = "\(numberTrade)"
               }
               else{
                    self.subNotificationTrade.isHidden = true
               }
                if numberRequest +  numberConnectiton > 0
              {
                   self.subNotificationConnection.isHidden = false
                   self.lblNumberConnection.text = "\(numberRequest +  numberConnectiton)"
              }
              else{
                   self.subNotificationConnection.isHidden = true
              }
          }
          else{
             self.tabBarController?.tabBar.items![2].badgeValue = nil
            self.tabBarController?.tabBar.items![1].badgeValue = nil
          }
      }
  }
}
