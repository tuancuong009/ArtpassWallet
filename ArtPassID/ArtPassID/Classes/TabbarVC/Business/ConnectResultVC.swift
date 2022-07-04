//
//  ConnectResultVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 3/27/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit
import SafariServices

class ConnectResultVC: UIViewController {

    var qrDataCodeString: String?
    @IBOutlet weak var viewSuccess: UIView!
    
    static func controller() -> ConnectResultVC {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConnectResultVC") as! ConnectResultVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSuccess.isHidden = true
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func viewConnectReportAction(_ sender: Any) {
        if let codeString = qrDataCodeString, let url = URL.init(string: codeString) {
            let vc = SFSafariViewController.init(url: url)
            DispatchQueue.main.async {
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func connectAction(_ sender: Any) {
        if let qrcode = self.qrDataCodeString
        {
            print("qrcode--->",qrcode)
            let arrs = qrcode.components(separatedBy: "/")
            let param = ["connect_to": arrs.last!]
            ApiHelper.shared.commectUser(param) { (success, error) in
                if success
                {
                    self.viewSuccess.isHidden = false
                    self.tabBarController?.tabBar.isHidden = true
                     self.perform(#selector(self.redirectHome), with: nil, afterDelay: TIME_OUT)
                }
                else{
                    if error != nil {
                        APP_DELEGATE.showAlert(error!.msg!)
                    }
                }
            }
        }
        
    }
    
    @objc func redirectHome()
    {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popToRootViewController(animated: true)
    }
}
