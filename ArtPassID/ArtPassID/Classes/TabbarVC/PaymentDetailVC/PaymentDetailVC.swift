//
//  PaymentDetailVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 5/14/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit
import Alamofire
class PaymentDetailVC: UIViewController {

    @IBOutlet weak var btnCheck1: UIButton!
    @IBOutlet weak var btnCheck2: UIButton!
    @IBOutlet weak var btnCheck3: UIButton!
    @IBOutlet weak var txfSignature: UITextField!
    var icTick1 = false
    var icTick2 = false
    var icTick3 = false
    @IBOutlet weak var lblNoteOption: UILabel!
    var username = ""
    var dictItem = NSDictionary.init()
    @IBOutlet weak var lblNoteCheck1: UILabel!
    @IBOutlet weak var lblNoteCheck2: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblTitleNavi: UILabel!
    @IBOutlet weak var lblTitleNote: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var viewSuccess: UIView!
    @IBOutlet weak var lblNoteUser: UILabel!
    var isAmpAsBuyer = false
    var isAmpAsSeller = false
   var isMoreSetting = false
    @IBOutlet weak var subProvenance: UIView!
    @IBOutlet weak var heightSubProvenance: NSLayoutConstraint!
    @IBOutlet weak var tvProvenance: UITextView!
    @IBOutlet weak var lblPlaceHolder: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnCheck1.setImage(UIImage.init(named: "ic_check"), for: .normal)
        self.btnCheck2.setImage(UIImage.init(named: "ic_check"), for: .normal)
        self.btnCheck3.setImage(UIImage.init(named: "ic_check"), for: .normal)
        self.viewSuccess.isHidden = true
        self.lblNoteCheck1.text = "I will purchase as the principal buyer of the artwork and pay with my own funds."
        if isMoreSetting {
            self.lblTitleNavi.text = "1-CLICK COMPLIANCE"
            self.lblDesc.text = "The information contained herein does not constitute in any way a binding sales or purchase agreement or any other sales or purchase obligation whatsoever. Your information will remain available to the AMP (Art Market Participant), prior to the sales transaction, after which it may becomes part of the compliant Transaction Report in the event of a successful sale. This information will be removed from our servers in the event that the transaction is not completed."
            
            self.lblTitleNote.text = "I DECLARE THAT IN THE EVENT OF A PURCHASE:"
           
            self.lblNoteCheck2.text = "I will have the authority to purchase the work"
            self.lblNoteOption.text = "I will purchase the work as the only Ultimate Beneficial Owner (UBO) "
            self.btnNext.setTitle("SET DEFAULT PURCHASE DETAILS", for: .normal)
            self.subProvenance.isHidden = true
            self.heightSubProvenance.constant = 0
        }
        else{
            if self.isAmpAsSeller {
                self.lblTitleNavi.text = "CONFIRM SELLER DETAILS"
                self.lblTitleNote.text = "I DECLARE THAT:"
                self.lblNoteCheck1.text = "I am purchasing as the principal owner of the artwork and will pay with my own funds"
                self.lblNoteCheck2.text = "I have the authority to sell the work"
                self.lblNoteOption.text = "I sell this work as the only Ultimate Beneficial Owner (UBO)"
                self.btnNext.setTitle("CONFIRM", for: .normal)
                 self.lblNoteUser.text = "\(username) HAS RECEIVED"
            }
            else{
                self.subProvenance.isHidden = true
                self.heightSubProvenance.constant = 0
                if let profileObj = APP_DELEGATE.profileObj {
                    if let company_info = profileObj.company_info
                    {
                        if let name = company_info.object(forKey: "name") as? String
                        {
                            self.lblNoteCheck1.text = "\(name) will purchase as the principal buyer of the artwork and pay with my own funds."
                            self.lblNoteOption.text = "\(name) will purchase the work as the only Ultimate Beneficial Owner (UBO)"
                        }
                    }
                    else{
                        self.lblNoteCheck1.text = "I am purchasing as the principal owner of the artwork and will pay with my own funds"
                        self.lblNoteOption.text = "I will purchase the work as the only Ultimate Beneficial Owner (UBO)"
                    }
                }
                else{
                    self.lblNoteCheck1.text = "I am purchasing as the principal owner of the artwork and will pay with my own funds"
                    self.lblNoteOption.text = "I will purchase the work as the only Ultimate Beneficial Owner (UBO)"
                }
            }
            
            if self.isAmpAsBuyer || self.isAmpAsSeller {
                self.lblDesc.text = "This buyer report is compiled by artpass ID to comply with AMLD5 regulated purchases of works of art. The information contained herein does not constitute in any way a binding sales or purchase agreement or any other sales or purchase obligation whatsoever. Your information will remain available to the AMP (Art Market Participant), prior to the sales transaction, after which it may becomes part of the compliant Transaction Report in the event of a successful sale. This information will be removed from our servers in the event that the transaction is not completed."
            }
        }
        
        // Do any additional setup after loading the view.
    }
   
    
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
        print("self.checkValidateSignature()----->",self.checkValidateSignature())
        if !self.checkValidateSignature() {
            APP_DELEGATE.showAlert("Invalid signature please try again")
            return
        }
        if self.isAmpAsSeller {
            if self.tvProvenance.text!.trim().isEmpty {
                APP_DELEGATE.showAlert("Provenance is required")
                return
            }
        }
        self.view.endEditing(true)
        if self.isMoreSetting
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
            let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "FromPaymentDetailVC") as! FromPaymentDetailVC
            vc.arrRoles = arrRoles
            vc.isMoreSetting = true
            vc.signature = self.txfSignature.text!.trim()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            if self.isAmpAsSeller {
               ApiHelper.shared.updatetransactionAmpAsBuyer(self.paramCallAPI()) { (success, error) in
                   if success
                   {
                       ApiHelper.shared.addReadNotification(APP_DELEGATE.tracsationID, APP_DELEGATE.actype, APP_DELEGATE.notificationID) { (success, error) in
                            self.viewSuccess.isHidden = false
                            self.tabBarController?.tabBar.isHidden = true
                            self.perform(#selector(self.redirectHome), with: nil, afterDelay: TIME_OUT)
                        }

                   }
                   else{
                       if error != nil {
                           APP_DELEGATE.showAlert(error!.msg!)
                       }
                   }
               }
           }
           else{
                self.callAPI()
           }
        }
       
       
    }
    
    @objc func redirectHome()
    {
        APP_DELEGATE.isRedirectActivity = true
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func checkValidateSignature()-> Bool
    {
        //var doc_fname = ""
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
        let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "FromPaymentDetailVC") as! FromPaymentDetailVC
        vc.username = self.username
        vc.dictItem = self.dictItem
        vc.arrRoles = arrRoles
        vc.isAmpAsBuyer = self.isAmpAsBuyer
        vc.signature = self.txfSignature.text!.trim()
        vc.provenanceWork = self.tvProvenance.text!.trim()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func paramCallAPI()-> Parameters
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
        var param:Parameters = [:]
        param["transacId"] = self.dictItem.object(forKey: "transacId") as? String ?? ""
        param["sellerEsign"] = self.txfSignature.text!.trim()
        param["seller"] = self.dictItem.object(forKey: "seller") as? NSDictionary ??  NSDictionary.init()
        param["ampuser"] = self.dictItem.object(forKey: "ampuser") as? NSDictionary ??  NSDictionary.init()
        param["roles"] = arrRoles
        param["attachments"] = self.dictItem.object(forKey: "attachments") as? NSDictionary ??  NSDictionary.init()
        param["refnum"] = self.dictItem.object(forKey: "refnum") as? String ?? ""
        param["desc"] = self.dictItem.object(forKey: "desc") as? String ?? ""
        param["artist"] = self.dictItem.object(forKey: "artist") as? String ?? ""
        param["title"] = self.dictItem.object(forKey: "title") as? String ?? ""
        param["medium"] = self.dictItem.object(forKey: "medium") as? String ?? ""
        param["materials"] = self.dictItem.object(forKey: "materials") as? String ?? ""
        param["workCreatedTime"] = self.dictItem.object(forKey: "workCreatedTime") as? String ?? ""
        param["edition"] = self.dictItem.object(forKey: "edition") as? String ?? ""
        param["duration"] = self.dictItem.object(forKey: "duration") as? String ?? ""
        param["watermark"] = self.dictItem.object(forKey: "watermark") as? String ?? ""
        param["status"] = self.dictItem.object(forKey: "status") as? String ?? ""
        param["provenanceWork"] = self.tvProvenance.text!.trim()
        return param
    }
}

extension PaymentDetailVC: UITextViewDelegate
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
