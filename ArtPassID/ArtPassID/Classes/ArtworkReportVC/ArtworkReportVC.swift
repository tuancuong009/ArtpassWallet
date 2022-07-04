//
//  ArtworkReportVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 5/11/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit

class ArtworkReportVC: UIViewController {

    @IBOutlet weak var txfName: UITextField!
    @IBOutlet weak var txfTitle: UITextField!
    @IBOutlet weak var txfMedium: UITextField!
    @IBOutlet weak var txfMatrial: UITextField!
    var arrMedium = ["Painting",
    "Drawing",
    "Mixed media",
    "Original sculpture or statuary",
    "Limited edition engraving",
    "Limited edition lithograph",
    "Limited edition print",
    "Limited edition sculpture cast",
    "Limited edition tapestry",
    "Limited edition ceramic",
    "Limited edition photograph",
    "Limited edition new media art"]
    var isSellerAmpBuyer = false
    override func viewDidLoad() {
        super.viewDidLoad()

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
    @IBAction func doMedium(_ sender: Any) {
        DPPickerManager.shared.showPicker(title: "Mediun", selected: self.txfMedium.text!, strings: arrMedium) { (val, index, success) in
            if !success
            {
                self.txfMedium.text = val
            }
        }
    }
    
    @IBAction func doBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doContinue(_ sender: Any) {
        if self.isSellerAmpBuyer {
            if txfName.text!.trim().isEmpty {
                APP_DELEGATE.showAlert("Artist name, date of birth and nationality is required")
                return
            }
            if txfTitle.text!.trim().isEmpty {
                APP_DELEGATE.showAlert("Title of the artwork is required")
                return
            }
            if txfMedium.text!.trim().isEmpty {
                APP_DELEGATE.showAlert("Medium is required")
                return
            }
            if txfMatrial.text!.trim().isEmpty {
                APP_DELEGATE.showAlert("Materials is required")
                return
            }
            APP_DELEGATE.createObj.artistName = self.txfName.text!.trim()
            APP_DELEGATE.createObj.titleWork = self.txfTitle.text!.trim()
            APP_DELEGATE.createObj.medium = self.txfMedium.text!.trim()
            APP_DELEGATE.createObj.materials = self.txfMatrial.text!.trim()
            let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "ArtworkReportStep2VC") as! ArtworkReportStep2VC
            vc.isSellerAmpBuyer = self.isSellerAmpBuyer
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            if txfName.text!.trim().isEmpty {
                APP_DELEGATE.showAlert("Artist name, date of birth and nationality is required")
                return
            }
            if txfTitle.text!.trim().isEmpty {
                APP_DELEGATE.showAlert("Title of the artwork is required")
                return
            }
            if txfMedium.text!.trim().isEmpty {
                APP_DELEGATE.showAlert("Medium is required")
                return
            }
            if txfMatrial.text!.trim().isEmpty {
                APP_DELEGATE.showAlert("Materials is required")
                return
            }
            APP_DELEGATE.createObj.artistName = self.txfName.text!.trim()
            APP_DELEGATE.createObj.titleWork = self.txfTitle.text!.trim()
            APP_DELEGATE.createObj.medium = self.txfMedium.text!.trim()
            APP_DELEGATE.createObj.materials = self.txfMatrial.text!.trim()
            let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "ArtworkReportStep2VC") as! ArtworkReportStep2VC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ArtworkReportVC: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txfName
        {
            txfTitle.becomeFirstResponder()
        }
        else if textField == txfTitle
        {
            txfMatrial.becomeFirstResponder()
        }
        else{
            txfMatrial.resignFirstResponder()
        }
        return true
    }
}
