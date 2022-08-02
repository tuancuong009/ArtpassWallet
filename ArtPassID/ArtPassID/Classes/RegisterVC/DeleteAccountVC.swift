//
//  DeleteAccountVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 02/08/2022.
//  Copyright © 2022 QTS Coder. All rights reserved.
//

import UIKit
import SafariServices
import MessageUI
class DeleteAccountVC: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var lblMessage: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        var arrTribute = NSMutableAttributedString.init()
        arrTribute = arrTribute.normalColor("For AML Compliance you can only request to delete your account by email at ", .white)
        arrTribute = arrTribute.normalColor("accounts@artpass.id", Common.hexStringToUIColor("367AF6"))
        arrTribute = arrTribute.normalColor(". The Art Market Participants you transacted with in the past will not be able to delete your information. Part of their AML compliance obligations is to securely store the KYC information from their customers for 5 or 10 years, depending on the region. ", .white)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3

        // *** Apply attribute to string ***
        arrTribute.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, arrTribute.length))
        self.lblMessage.attributedText = arrTribute
        
        self.lblMessage.isUserInteractionEnabled = true
        self.lblMessage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnLabel(_:))))
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    @objc func handleTapOnLabel(_ gesture: UITapGestureRecognizer) {
        let text = "accounts@artpass.id."
       
        let privacyRange = (text as NSString).range(of: "accounts@artpass.id.")

        if gesture.didTapAttributedTextInLabel(label: lblMessage, inRange: privacyRange) {
            let recipientEmail = "accounts@artpass.id"
            let subject = ""
            let body = ""

            // Show default mail composer
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients([recipientEmail])
                mail.setSubject(subject)
                mail.setMessageBody(body, isHTML: false)

                self.present(mail, animated: true)

                // Show third party email composer if default Mail app is not present
            }
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

    @IBAction func doBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func doWeb(_ sender: Any) {
        self.openWebView()
    }
    @IBAction func doEmail(_ sender: Any) {
        let recipientEmail = "accounts@artpass.id"
        let subject = ""
        let body = ""

        // Show default mail composer
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([recipientEmail])
            mail.setSubject(subject)
            mail.setMessageBody(body, isHTML: false)

            self.present(mail, animated: true)

            // Show third party email composer if default Mail app is not present
        }
    }
    private func openWebView(){
        if let url = URL.init(string: "https://artpass.id/account_termination.pdf"){
            let vc = SFSafariViewController.init(url: url)
            self.present(vc, animated: true) {
                
            }
        }
    }
}
