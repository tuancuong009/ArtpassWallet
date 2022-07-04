//
//  ConfirmAccountVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 2/25/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit
import SDWebImage
import LocalAuthentication
class ConfirmAccountVC: UIViewController {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    var context = LAContext()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isHidden = true
        self.getUserInfo()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imgAvatar.layer.cornerRadius = self.imgAvatar.frame.size.width/2
        self.imgAvatar.layer.masksToBounds = true
    }

    func checkLoginAuth(){
        context = LAContext()

        context.localizedCancelTitle = "Cancel"

        // First check if we have the needed hardware support.
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {

            let reason = "Log in to your account"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason ) { success, error in

                if success {

                    // Move to the main thread because a state update triggers UI changes.
                    DispatchQueue.main.async { [] in
                        self.loginUser()
                    }

                } else {
                    if let err = error as? LAError{
                        if err.code == LAError.userCancel{
                            
                        }
                        else{
                            DispatchQueue.main.async { [] in
                                self.showAlert(self.displayErrorMessage(error: err))
                            }
                        }
                        
                    }
                    print(error?.localizedDescription ?? "Failed to authenticate")
                   
                    
                    // Fall back to a asking for username and password.
                    // ...
                }
            }
        } else {
            //self.showAlert("Can't evaluate policy")
            //print(error?.localizedDescription ?? "Can't evaluate policy")

            // Fall back to a asking for username and password.
            // ...
        }
    }
    func displayErrorMessage(error:LAError) -> String {
            var message = ""
            switch error.code {
            case LAError.authenticationFailed:
                message = "Authentication Failed."
                break
            case LAError.userCancel:
                message = "User Cancelled."
                break
            case LAError.userFallback:
                message = "Fallback authentication mechanism selected."
                break
            case LAError.touchIDNotEnrolled:
                message = "Touch ID is not enrolled."

            case LAError.passcodeNotSet:
                message = "Passcode is not set on the device."
                break
            case LAError.systemCancel:
                message = "System Cancelled."
                break
            default:
                message = error.localizedDescription
            }
            return message
    }
    func loginUser(){
        let phoneRe = UserDefaults.standard.value(forKey: kPhoneLogin) as? String ?? ""
        let pincode = UserDefaults.standard.value(forKey: kPasswordLogin) as? String ?? ""
        let phoneCode = UserDefaults.standard.value(forKey: kPhoneCode) as? String ?? ""
        let param = ["phoneNum": phoneRe, "pincode": pincode, "phoneCode": phoneCode]
        self.view.isUserInteractionEnabled = false
        ApiHelper.shared.loginUser(param) { (success, error) in
           // Common.hideBusy()
            self.view.isUserInteractionEnabled = true
            if success
            {
                self.perform(#selector(self.redirectTabbar), with: nil, afterDelay:0)
            }
            else{
                let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "ConfirmPasswordVC") as! ConfirmPasswordVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    @objc func redirectTabbar()
    {
        
        let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    func showAlert(_ message: String){
        let alert = UIAlertController.init(title: "Authentication Failed", message: message, preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "Try again", style: .default) { (action) in
            self.checkLoginAuth()
        }
        alert.addAction(ok)
        
        let enterpasscode = UIAlertAction.init(title: "Enter PIN code", style: .default) { (action) in
            let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "ConfirmPasswordVC") as! ConfirmPasswordVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        alert.addAction(enterpasscode)
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func doNotMe(_ sender: Any) {
        let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func doContinue(_ sender: Any) {
        let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "ConfirmPasswordVC") as! ConfirmPasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension ConfirmAccountVC
{
    
    private func getUserInfo()
    {
        ApiHelper.shared.getUserInfoConfirmAccount { (success,obj, error) in
            
            if let profileObj = obj
            {
                self.view.isHidden = false
                APP_DELEGATE.profileObj = profileObj
                self.lblMessage.text = "HEY \(profileObj.fname), IS THAT YOU?"
                self.btnContinue.setTitle("CONTINUE AS \(profileObj.fname)", for: .normal)
                if profileObj.avatar.count > 0
                {
                    Common.loadAvatarFromServer(profileObj.avatar, self.imgAvatar)
                }
                if UserDefaults.standard.bool(forKey: kFaceIdOrTouchId) {
                    self.checkLoginAuth()
                }
                
            }
            else{
                UserDefaults.standard.removeObject(forKey: kToken)
                UserDefaults.standard.removeObject(forKey: kPhoneCode)
                UserDefaults.standard.removeObject(forKey: kPasswordLogin)
                UserDefaults.standard.removeObject(forKey: kPhoneLogin)
                UserDefaults.standard.synchronize()
                APP_DELEGATE.showAlertComeback("Token expried, Please login again") { success in
                    let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "IntroVC") as! IntroVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
               
            }
            
        }
    }
}
