//
//  ArtworkReportStep3VC.swift
//  ArtPassID
//
//  Created by QTS Coder on 5/11/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit

class ArtworkReportStep3VC: UIViewController {

    @IBOutlet weak var txfSignature: UITextField!
    @IBOutlet weak var tvMessage: UITextView!
    @IBOutlet weak var lblPlaaceHolder: UILabel!
    var isSellerAmpBuyer = false
    override func viewDidLoad() {
        super.viewDidLoad()

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
    @IBAction func doContinue(_ sender: Any) {
        if self.isSellerAmpBuyer {
//            if self.txfSignature.text!.trim().isEmpty {
//               APP_DELEGATE.showAlert("Signature is required")
//               return
//            }
            APP_DELEGATE.createObj.signature = self.txfSignature.text!.trim()
            APP_DELEGATE.createObj.desc = self.tvMessage.text!.trim()
            let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "NewTransaction3VC") as! NewTransaction3VC
            vc.isSellerAmpBuyer = self.isSellerAmpBuyer
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
//            if self.txfSignature.text!.trim().isEmpty {
//                APP_DELEGATE.showAlert("Signature is required")
//                return
//            }
    //        if self.tvMessage.text!.trim().isEmpty {
    //            APP_DELEGATE.showAlert("Description is required")
    //            return
    //        }
            APP_DELEGATE.createObj.signature = self.txfSignature.text!.trim()
            APP_DELEGATE.createObj.desc = self.tvMessage.text!.trim()
            let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "NewTransaction3VC") as! NewTransaction3VC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}

extension ArtworkReportStep3VC: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.tvMessage.becomeFirstResponder()
        return true
    }
}
extension ArtworkReportStep3VC: UITextViewDelegate
{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        if textView == tvMessage {
            if updatedText.count > 0 {
                lblPlaaceHolder.isHidden = true
            }
            else{
                lblPlaaceHolder.isHidden = false
            }
        }
        
        return true

    }
}
