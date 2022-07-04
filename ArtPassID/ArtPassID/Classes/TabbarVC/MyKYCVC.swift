//
//  MyKYCVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 2/5/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit

class MyKYCVC: BaseVC {
    
    @IBOutlet weak var subNotification: UIViewX!
    var arrNotifications = [NotificationObj]()
    override func viewDidLoad() {
        super.viewDidLoad()
        APP_DELEGATE.myKYCVC = self
        self.getUserInfo()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         updateBadgeNotificaiton()
    }
    private func getUserInfo()
    {
        ApiHelper.shared.getUserInfo { (success,obj, error) in
            if let profileObj = obj
            {
                APP_DELEGATE.profileObj = profileObj
            }
            
        }
    }

   
    @IBAction func doKYC(_ sender: Any) {
      //  let storyBoard = STORYBOARD_MainSDK
       // let resultViewController = storyBoard.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
       // self.navigationController?.pushViewController(resultViewController, animated: true)
    }
    
}
