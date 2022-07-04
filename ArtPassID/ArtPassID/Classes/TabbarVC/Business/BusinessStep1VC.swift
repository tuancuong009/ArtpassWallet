//
//  BusinessStep1VC.swift
//  ArtPassID
//
//  Created by QTS Coder on 3/20/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit
import SKCountryPicker
class BusinessStep1VC: UIViewController {

    @IBOutlet weak var txfBusinessName: UITextField!
    @IBOutlet weak var txfCodeNumber: UITextField!
    @IBOutlet weak var txfCountry: UITextField!
    var countryCode = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.txfBusinessName.text = "art"
        //self.txfCodeNumber.text = "12402898"
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
    @IBAction func doBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doCountry(_ sender: Any) {
       let vc = JurisdictionVC()
        vc.tapSelect = { [] in
            let dict = vc.dictSelect
            self.txfCountry.text = dict.object(forKey: "name") as? String
            self.countryCode = dict.object(forKey: "code") as? String ?? ""
        }
        self.present(vc, animated: true) {
            
        }
    }
    @IBAction func doSearch(_ sender: Any) {
        if self.msgError().isEmpty {
            self.callWS()
          
        }
        else{
            APP_DELEGATE.showAlert(self.msgError())
        }
        
    }
    
    func msgError()-> String
    {
        var msg = ""
        if self.txfBusinessName.text!.trim().isEmpty {
            msg = MSG_ERROR.ERROR_BUSINESS_NAME
        }
        else if self.txfCodeNumber.text!.trim().isEmpty {
            msg = MSG_ERROR.ERROR_BUSINESS_NUMBER
        }
        else if self.txfCountry.text!.trim().isEmpty {
            msg = MSG_ERROR.ERROR_COUNTRY
        }
        return msg
    }
    
    func callWS()
    {
        let param = ["company_name":self.txfBusinessName.text!.trim(), "company_number": self.txfCodeNumber.text!.trim(), "jurisdiction_code": self.countryCode.lowercased()]
        ApiHelper.shared.getInforCompany(param: param) { (success, val, error) in
            if success
            {
                if let result = val
                {
                    let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "BusinessStep2VC") as! BusinessStep2VC
                    vc.dictCompany = result
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            else{
                if error != nil {
                    APP_DELEGATE.showAlert(error!)
                }
            }
        }
    }
}

extension BusinessStep1VC: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txfBusinessName
        {
            txfCodeNumber.becomeFirstResponder()
        }
        else{
            txfCodeNumber.resignFirstResponder()
        }
        return true
    }
    
    
}
