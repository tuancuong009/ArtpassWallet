//
//  MoreSettingVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 6/29/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit
import LocalAuthentication
enum BiometricType {
    case none
    case touch
    case face
}
class MoreSettingVC: UIViewController {

    @IBOutlet weak var lblSignInFaceOrTouch: UILabel!
    @IBOutlet weak var subNotification: UIViewX!
    @IBOutlet weak var btnTouch: UISwitch!
    @IBOutlet weak var viewTouch: UIViewX!
    @IBOutlet weak var heightTouch: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.bool(forKey: KEY_NOTIFICATION_SETTING) {
            self.subNotification.isHidden = false
        }
        else{
            self.subNotification.isHidden = true
        }
        self.btnTouch.isOn = UserDefaults.standard.bool(forKey: kFaceIdOrTouchId)
    }
    func biometricType() -> BiometricType {
        let authContext = LAContext()
        if #available(iOS 11, *) {
            let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
            switch(authContext.biometryType) {
            case .none:
                return .none
            case .touchID:
                return .touch
            case .faceID:
                return .face
            }
        } else {
            return authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touch : .none
        }
    }
    
    
    func updateUI(){
        let typeAuth = self.biometricType()
        if typeAuth == .none {
            self.viewTouch.isHidden = true
            self.heightTouch.constant = 0
        }
        else if typeAuth == .touch {
            self.viewTouch.isHidden = false
            self.heightTouch.constant = 60
            self.lblSignInFaceOrTouch.text = "Sign in with Touch ID"
        }
        else{
            self.viewTouch.isHidden = false
            self.heightTouch.constant = 60
            self.lblSignInFaceOrTouch.text = "Sign in with Face ID"
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
    @IBAction func changeTouch(_ sender: Any) {
        UserDefaults.standard.set(btnTouch.isOn, forKey: kFaceIdOrTouchId)
    }
    
    @IBAction func doBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
   
    @IBAction func doClickBuyer(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentDetailVC") as! PaymentDetailVC
        vc.isMoreSetting = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func doClickCDDSharing(_ sender: Any) {
    }
}
