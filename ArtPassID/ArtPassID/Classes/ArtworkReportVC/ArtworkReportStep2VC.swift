//
//  ArtworkReportStep2VC.swift
//  ArtPassID
//
//  Created by QTS Coder on 5/11/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit

class ArtworkReportStep2VC: UIViewController {

    @IBOutlet weak var txfDate: UITextField!
    @IBOutlet weak var txfNumber: UITextField!
    @IBOutlet weak var txfDurian: UITextField!
    var isSellerAmpBuyer = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func doCreate(_ sender: Any) {
        DPPickerManager.shared.showPicker(title: "Date of creation/period", selected: Date()) { (date, success) in
            if !success
            {
                let format = DateFormatter.init()
                format.dateFormat = "yyyy-MM-dd"
                self.txfDate.text = format.string(from: date!)
            }
        }
    }
    @IBAction func doBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
  

    @IBAction func doContinue(_ sender: Any) {
        if self.isSellerAmpBuyer {
            if self.txfDate.text!.trim().isEmpty {
                APP_DELEGATE.showAlert("Date of creation/period is required")
                return
            }
            if self.txfDurian.text!.trim().isEmpty {
                APP_DELEGATE.showAlert("Dimensions or duration is required")
                return
            }
            APP_DELEGATE.createObj.dateCreate = self.txfDate.text!.trim()
            APP_DELEGATE.createObj.editorNumber = self.txfNumber.text!.trim()
            APP_DELEGATE.createObj.dimesion = self.txfDurian.text!.trim()
            let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "ArtworkReportStep3VC") as! ArtworkReportStep3VC
            vc.isSellerAmpBuyer = self.isSellerAmpBuyer
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            if self.txfDate.text!.trim().isEmpty {
               APP_DELEGATE.showAlert("Date of creation/period is required")
               return
           }
           if self.txfDurian.text!.trim().isEmpty {
               APP_DELEGATE.showAlert("Dimensions or duration is required")
               return
           }
           APP_DELEGATE.createObj.dateCreate = self.txfDate.text!.trim()
            APP_DELEGATE.createObj.editorNumber = self.txfNumber.text!.trim()
            APP_DELEGATE.createObj.dimesion = self.txfDurian.text!.trim()
           let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "ArtworkReportStep3VC") as! ArtworkReportStep3VC
           self.navigationController?.pushViewController(vc, animated: true)
        }
       
    }
}

extension ArtworkReportStep2VC: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txfDate {
            txfNumber.becomeFirstResponder()
        }
        else if textField == txfNumber
        {
            self.txfDurian.becomeFirstResponder()
        }
        else{
            self.txfDurian.resignFirstResponder()
        }
        return true
    }
}
