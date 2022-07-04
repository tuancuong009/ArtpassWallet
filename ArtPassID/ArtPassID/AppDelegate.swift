//
//  AppDelegate.swift
//  ArtPassID
//
//  Created by QTS Coder on 4/19/19.
//  Copyright © 2019 QTS Coder. All rights reserved.
//

import UIKit
import SwiftyJSON
import IQKeyboardManagerSwift
import SwiftyStoreKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var orientationLock = UIInterfaceOrientationMask.portrait
    //var rootViewController: RootViewController?
    var acuantObj = AcuantObj.init()
    var userObj = UserObj.init()
    var profileObj: ProfileObj?
    var isRedirectActivity = false
    var isRedirectArchived = false
    var isRedoScan = false
    var isConnect = false
    var createObj = CreateObj.init()
    var inforUser: NSDictionary?
    var tracsationID = ""
    var actype = ""
    var notificationID = ""
    var myKYCVC: MyKYCVC?
    var notificationChangePin: NotificationObj?
    var notificationChangeUserName: NotificationObj?
    var notificationChangeProfilePic: NotificationObj?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
         IQKeyboardManager.shared.enable = true
       // self.initRoot()
        UserDefaults.standard.set(false, forKey: KEY_NOTIFICATION_SETTING)
        if (UserDefaults.standard.value(forKey: kToken) as? String) != nil {
            self.initHome()
       }
        else{
            print("SET ROOT VIEW CONTROLLER")
            self.initRoot()
        }
        return true
    }
    
   
//
    func stringArrayToData(stringArray: [String]) -> Data? {
      return try? JSONSerialization.data(withJSONObject: stringArray, options: [])
    }
    
    func dataToStringArray(data: Data) -> [String]? {
      return (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String]
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func showAlert(_ message: String)
    {
        let alert = UIAlertController.init(title: APP_NAME, message: message, preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "OK", style: .cancel) { (action) in
            
        }
        alert.addAction(ok)
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    func showAlertComeback(_ message: String, complete:@escaping (_ success: Bool) ->Void)
    {
        let alert = UIAlertController.init(title: APP_NAME, message: message, preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "OK", style: .cancel) { (action) in
            complete(true)
        }
        alert.addAction(ok)
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    func compleStorkit(){
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                       // UserDefaults.standard.set(true, forKey: KEY_INAPP_PRO)
                       // UserDefaults.standard.synchronize()
                    }
                    // Unlock content
                    
                case .failed, .purchasing, .deferred:
                    //UserDefaults.standard.set(false, forKey: KEY_INAPP_PRO)
                    //UserDefaults.standard.synchronize()
                    break // do nothing
                }
            }
        }
    }
    
    func veritfiedPurchase(){
        
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
            case .success(let receipt):
                let productId = INAPP_PURCHASE
                // Verify the purchase of a Subscription
                let purchaseResult = SwiftyStoreKit.verifySubscription(
                    ofType: .autoRenewable, // or .nonRenewing (see below)
                    productId: productId,
                    inReceipt: receipt)
                    
                switch purchaseResult {
                case .purchased(let expiryDate, let items):
                    print("\(productId) is valid until \(expiryDate)\n\(items)\n")
                    UserDefaults.standard.set(true, forKey: KEY_INAPP_PRO)
                    UserDefaults.standard.synchronize()
                case .expired(let expiryDate, let items):
                    print("\(productId) is expired since \(expiryDate)\n\(items)\n")
                    UserDefaults.standard.set(false, forKey: KEY_INAPP_PRO)
                     UserDefaults.standard.synchronize()
                case .notPurchased:
                    print("The user has never purchased \(productId)")
                    UserDefaults.standard.set(false, forKey: KEY_INAPP_PRO)
                    UserDefaults.standard.synchronize()
                }

            case .error(let error):
                print("Receipt verification failed: \(error)")
                UserDefaults.standard.set(false, forKey: KEY_INAPP_PRO)
                UserDefaults.standard.synchronize()
            }
        }
    }
}

extension AppDelegate
{
    func showAlertGlobally(_ alert: UIAlertController) {
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask
    {
        return self.orientationLock
    }
    
    struct AppUtility {
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.orientationLock = orientation
            }
        }
        
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
            self.lockOrientation(orientation)
            UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        }
    }
    func initHome()
    {
        let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "ConfirmAccountVC") as! ConfirmAccountVC
        let nav = UINavigationController.init(rootViewController: vc)
        nav.isNavigationBarHidden = true
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
    }
    
    
    func initRoot()
    {
        let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "IntroVC") as! IntroVC
        let nav = UINavigationController.init(rootViewController: vc)
        nav.isNavigationBarHidden = true
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
    }
    
    func initTabbar()
    {
        let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
        let nav = UINavigationController.init(rootViewController: vc)
        nav.isNavigationBarHidden = true
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
    }
}

