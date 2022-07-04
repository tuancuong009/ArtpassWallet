//
//  CompleteSignUpVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 5/13/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit

class CompleteSignUpVC: UIViewController {

    @IBOutlet weak var btnCheck1: UIButton!
    @IBOutlet weak var btnCheck2: UIButton!
    @IBOutlet weak var btnCheck3: UIButton!
    @IBOutlet weak var txfSignUp: UITextField!
    var icTick1 = false
    var icTick2 = false
    var icTick3 = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnCheck1.setImage(UIImage.init(named: "ic_check"), for: .normal)
        self.btnCheck2.setImage(UIImage.init(named: "ic_check"), for: .normal)
        self.btnCheck3.setImage(UIImage.init(named: "ic_check"), for: .normal)
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

    @IBAction func doCheck1(_ sender: Any) {
        if !icTick1 {
            self.icTick1 = true
            self.btnCheck1.setImage(UIImage.init(named: "ic_checked"), for: .normal)
        }
        else{
            self.icTick1 = false
            self.btnCheck1.setImage(UIImage.init(named: "ic_check"), for: .normal)
        }
    }
    @IBAction func doCheck2(_ sender: Any) {
        if !icTick2 {
           self.icTick2 = true
           self.btnCheck2.setImage(UIImage.init(named: "ic_checked"), for: .normal)
       }
       else{
           self.icTick2 = false
           self.btnCheck2.setImage(UIImage.init(named: "ic_check"), for: .normal)
       }
    }
    @IBAction func doCheck3(_ sender: Any) {
        if !icTick3 {
            self.icTick3 = true
            self.btnCheck3.setImage(UIImage.init(named: "ic_checked"), for: .normal)
        }
        else{
            self.icTick3 = false
            self.btnCheck3.setImage(UIImage.init(named: "ic_check"), for: .normal)
        }
    }
    @IBAction func doCountine(_ sender: Any) {
        if !icTick1 && !icTick2 && !icTick3{
            APP_DELEGATE.showAlert("Please select an option to continue")
            return
        }
        if self.txfSignUp.text!.trim().isEmpty {
            APP_DELEGATE.showAlert("Signature is required")
            return
        }
        let sinature = self.txfSignUp.text!.trim()
        if !sinature.contains("/s/") {
            APP_DELEGATE.showAlert("Invalid signature please try again")
            return
        }
        if !self.checkValidateSignature() {
            APP_DELEGATE.showAlert("Invalid signature please try again")
            return
        }
        
        APP_DELEGATE.userObj.fOpts = icTick1
        APP_DELEGATE.userObj.sOpts = icTick2
        APP_DELEGATE.userObj.tOpts = icTick3
        APP_DELEGATE.userObj.signature = sinature
        let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "RegisterFinalVC") as! RegisterFinalVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func showValueByKey(_ key: String) -> String
    {
       if let arrs = APP_DELEGATE.acuantObj.data
       {
           for item in arrs {
               if item.contains(key) {
                   let arrFirstName = item.components(separatedBy: ":")
                   if arrFirstName.count  > 1 {
                       return arrFirstName[1]
                   }
               }
           }
       }
       return " "
    }
    func checkValidateSignature()-> Bool
    {
        ///s/davidmargueritefdehaeck
        let arrSignatire = "\(self.removeSpace(self.showValueByKey("Surname").replacingOccurrences(of: "\'", with: "")))".lowercased()
        
        var sinature = self.txfSignUp.text!.trim()
        sinature = sinature.replacingOccurrences(of: " ", with: "")
        sinature = sinature.replacingOccurrences(of: "/s/", with: "")
         print("sinature--->",sinature)
        if arrSignatire.contains(sinature.lowercased()) {
            return true
        }
        return false
    }
    
    func removeSpace(_ value: String)-> String
    {
        var text = value
        text = text.replacingOccurrences(of: " ", with: "")
        return text
    }
}
