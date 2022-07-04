//
//  ArtworkReportStep5VC.swift
//  ArtPassID
//
//  Created by QTS Coder on 5/11/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit

class ArtworkReportStep5VC: UIViewController {

    @IBOutlet weak var btnCheck1: UIButton!
    @IBOutlet weak var btnCheck2: UIButton!
    @IBOutlet weak var btnCheck3: UIButton!
    @IBOutlet weak var txfSignature: UITextField!
    var icTick1 = false
    var icTick2 = false
    var icTick3 = false
    @IBOutlet weak var lblBuyerUsername: UILabel!
    @IBOutlet weak var lblRef: UILabel!
    @IBOutlet weak var viewSuccess: UIView!
    @IBOutlet weak var lblUserNameNote: UILabel!
    @IBOutlet weak var lblCheckNote3: UILabel!
    
    @IBOutlet weak var tvProvenance: UITextView!
    @IBOutlet weak var lblPlaceHolder: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnCheck1.setImage(UIImage.init(named: "ic_check"), for: .normal)
        self.btnCheck2.setImage(UIImage.init(named: "ic_check"), for: .normal)
        self.btnCheck3.setImage(UIImage.init(named: "ic_check"), for: .normal)
        
        self.lblUserNameNote.text = "\(APP_DELEGATE.createObj.username) HAS RECEIVED"
        self.lblBuyerUsername.text = APP_DELEGATE.createObj.username
        self.lblRef.text = APP_DELEGATE.createObj.refNumber
        self.viewSuccess.isHidden = true
       
        // Do any additional setup after loading the view.
    }
    //I hereby declare that there are no third parties security interests over the artwork 
    @IBAction func doBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
    @IBAction func doStart(_ sender: Any) {
        if !icTick1 || !icTick2 || !icTick3{
            APP_DELEGATE.showAlert("Please confirm to continue")
            return
        }
        if self.txfSignature.text!.trim().isEmpty {
            APP_DELEGATE.showAlert("Signature is required")
            return
        }
        let sinature = self.txfSignature.text!.trim()
        if !sinature.contains("/s/") {
            APP_DELEGATE.showAlert("Invalid signature please try again")
            return
        }
        if !self.checkValidateSignature() {
            APP_DELEGATE.showAlert("Invalid signature please try again")
            return
        }
        if self.tvProvenance.text!.trim().isEmpty {
            APP_DELEGATE.showAlert("Provenance is required")
            return
        }
        self.view.endEditing(true)
        self.callAPI()
    }
    //trong thuộc tính kycAmlInfo có doc_fname và doc_lname
    func checkValidateSignature()-> Bool
    {
       // var doc_fname = ""
        var doc_lname = ""
        if let profileObj = APP_DELEGATE.profileObj {
            if let amlReport = profileObj.amlReport{
                if let appData = amlReport.object(forKey: "appData") as? NSDictionary{
                    if let info = appData.object(forKey: "info") as? NSDictionary{
                       // doc_fname = info.object(forKey: "firstName") as? String ?? ""
                        doc_lname = info.object(forKey: "lastName") as? String ?? ""
                    }
                  
                }
            }
        }
        
        var arrSignatire = doc_lname.trim().components(separatedBy: " ")
        arrSignatire.append(doc_lname.trim().lowercased())
        arrSignatire.append(doc_lname.trim().replacingOccurrences(of: " ", with: ""))
        var sinature = self.txfSignature.text!.trim().lowercased()
        sinature = sinature.replacingOccurrences(of: " ", with: "")
        sinature = sinature.replacingOccurrences(of: "/s/", with: "")
        print("sinature-->",sinature)
        for item in arrSignatire {
            if item.lowercased() == sinature.lowercased() {
                  return true
            }
        }
       return false
    }
    //HAVEMAN
    func removeSpace(_ value: String)-> String
    {
       var text = value
       text = text.replacingOccurrences(of: " ", with: "")
       return text
    }
    
    func callAPI()
    {
        var arrRoles = [String]()
        if self.icTick1 {
            arrRoles.append("fOpts")
        }
        if self.icTick2 {
            arrRoles.append("sOpts")
        }
        if self.icTick3 {
            arrRoles.append("tOpts")
        }
        let stringRoles = arrRoles.joined(separator: ",")
        let param = ["unamebuyer": APP_DELEGATE.createObj.username.lowercased(), "refnum": APP_DELEGATE.createObj.refNumber, "desc": APP_DELEGATE.createObj.desc , "artistName": APP_DELEGATE.createObj.artistName ,"workTitle": APP_DELEGATE.createObj.titleWork,"mediumWork": APP_DELEGATE.createObj.medium,"materials": APP_DELEGATE.createObj.materials,"createdWork": APP_DELEGATE.createObj.dateCreate,"edition": APP_DELEGATE.createObj.editorNumber,"watermark": APP_DELEGATE.createObj.signature,"esign": self.txfSignature.text!.trim(), "roles": stringRoles, "duration": APP_DELEGATE.createObj.dimesion, "provenanceWork": self.tvProvenance.text!] as [String : Any]
        print("PARAM -->",param)
        Common.showBusy()
        if APP_DELEGATE.createObj.fileUrl != nil
        {
            ApiHelper.shared.uploadFile(_param: param, APP_DELEGATE.createObj.picture, APP_DELEGATE.createObj.fileUrl) { (success, error) in
                Common.hideBusy()
                if success!
                {
                    self.viewSuccess.isHidden = false
                    self.tabBarController?.tabBar.isHidden = true
                    //self.navigationController?.popToRootViewController(animated: true)
                    self.perform(#selector(self.redirectHome), with: nil, afterDelay: TIME_OUT)
                }
                else{
                    if error != nil {
                        APP_DELEGATE.showAlert(error!.msg!)
                    }
                }
            }
        }
        else{
            ApiHelper.shared.uploadImageFile(_param: param, APP_DELEGATE.createObj.picture, APP_DELEGATE.createObj.iamgeDoc) { (success, error) in
                 Common.hideBusy()
                if success!
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
           APP_DELEGATE.isRedirectActivity = true
           self.tabBarController?.tabBar.isHidden = false
           self.navigationController?.popToRootViewController(animated: true)
       }
}
extension ArtworkReportStep5VC: UITextViewDelegate
{
    func textViewDidChange(_ textView: UITextView) {
        if self.tvProvenance.text!.isEmpty {
            self.lblPlaceHolder.isHidden = false
        }
        else{
            self.lblPlaceHolder.isHidden = true
        }
    }
}
