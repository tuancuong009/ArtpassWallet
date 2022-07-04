//
//  NewTransaction2VC.swift
//  ArtPassID
//
//  Created by QTS Coder on 3/2/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit

class NewTransaction2VC: UIViewController {

    @IBOutlet weak var lblPlaceHolderDesc: UILabel!
    @IBOutlet weak var lblPlaceHolderMess: UILabel!
    @IBOutlet weak var tvDesc: UITextView!
    @IBOutlet weak var tvMess: UITextView!
    var username = ""
    var refenceNumber = ""
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

    @IBAction func doBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func doContinue(_ sender: Any) {
        if self.tvDesc.text!.trim().count == 0
        {
           APP_DELEGATE.showAlert(MSG_ERROR.ERROR_DESCRIPTION)
           return
        }
        if self.tvMess.text!.trim().count == 0
        {
           APP_DELEGATE.showAlert(MSG_ERROR.ERROR_MESSGAES)
           return
        }
       let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "NewTransaction3VC") as! NewTransaction3VC
       vc.username = self.username
       vc.refenceNumber = self.refenceNumber
        vc.message = self.tvMess.text!.trim()
        vc.desc =  self.tvDesc.text!.trim()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension NewTransaction2VC: UITextViewDelegate
{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        if textView == tvDesc {
            if updatedText.count > 0 {
                lblPlaceHolderDesc.isHidden = true
            }
            else{
                lblPlaceHolderDesc.isHidden = false
            }
        }
        else{
            if updatedText.count > 0 {
                lblPlaceHolderMess.isHidden = true
            }
            else{
                lblPlaceHolderMess.isHidden = false
            }
        }
        return true

    }
}
