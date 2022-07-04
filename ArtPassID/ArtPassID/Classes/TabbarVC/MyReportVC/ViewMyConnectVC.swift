//
//  ViewMyConnectVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 3/31/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit
import SafariServices
class ViewMyConnectVC: UIViewController {
     var tapSuccess: (() ->())?
    @IBOutlet weak var imgAvatar: UIImageViewX!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblTimeConnetc: UILabel!
    var activityObj: ActivityObj?
    var imageAvatar = UIImage.init()
    var fullname = ""
    var username = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
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

    func updateUI()
    {
        self.imgAvatar.image = imageAvatar
        self.lblFullName.text = fullname
        self.lblUsername.text = username
        if let obj = activityObj
        {
            if let requestedTime = obj.dict.object(forKey: "requestedTime") as? Double
            {
                let format = DateFormatter.init()
                format.dateFormat = "MM/dd/yyyy"
                let date = format.string(from: Date.init(milliseconds: Int64(requestedTime)))
                self.lblTimeConnetc.text = "Connected on \(date)"
            }
        }
    }
    
    func openSafari(_ url: String)
    {
        let vc = SFSafariViewController.init(url: URL.init(string: url)!)
        self.present(vc, animated: true) {
            
        }
    }
    
    @IBAction func doBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func doViewConnectReport(_ sender: Any) {
        var dictInfo: NSDictionary?
        if let obj = activityObj
        {
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
    @IBAction func doViewKYCReport(_ sender: Any) {
        var dictInfo: NSDictionary?
        if let obj = activityObj
        {
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
        }
        if let dict = dictInfo {
            if let kycAmlInfo = dict.object(forKey: "kycAmlInfo") as? NSDictionary
            {
                if let fileUrl = kycAmlInfo.object(forKey: "reportUrl") as? String {
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
    @IBAction func doViewAmlReport(_ sender: Any) {
        var dictInfo: NSDictionary?
        if let obj = activityObj
        {
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
        }
        if let dict = dictInfo {
            if let connectRp = dict.object(forKey: "amlReport") as? NSDictionary
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
    @IBAction func doViewBusinissAmlReport(_ sender: Any) {
        var dictInfo: NSDictionary?
        if let obj = activityObj
        {
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
        }
        if let dict = dictInfo {
            if let connectRp = dict.object(forKey: "company") as? NSDictionary
            {
                if let fileUrl = connectRp.object(forKey: "fileP") as? String {
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
    @IBAction func doArchived(_ sender: Any) {
    }
    @IBAction func doRemoveConnection(_ sender: Any) {
        if let obj = activityObj
        {
            self.callAPIRemoveConnect(obj.dict.object(forKey: "_id") as? String ?? "", "remove")
        }
    }
    
    func callAPIRemoveConnect(_ id: String, _ status: String)
       {
           let param = ["cid":id, "action": status]
           ApiHelper.shared.removeConnect(param) { (success, error) in
               if success
               {
                 self.tapSuccess?()
                self.navigationController?.popViewController(animated: true)
               }
               else{
                   if error != nil {
                       APP_DELEGATE.showAlert(error!.msg!)
                   }
               }
           }
       }
}
