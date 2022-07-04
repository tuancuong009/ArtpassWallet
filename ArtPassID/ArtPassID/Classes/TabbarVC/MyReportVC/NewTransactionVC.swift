//
//  NewTransactionVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 3/2/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit

class NewTransactionVC: UIViewController {

    @IBOutlet weak var txfUserName: UITextField!
    @IBOutlet weak var txfreferenceNumber: UITextField!
    var isSellerAmpBuyer = false
    @IBOutlet weak var lblNavi: UILabel!
    @IBOutlet weak var lblBuyerUser: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.isSellerAmpBuyer {
            self.lblNavi.text = "ARTWORK REPORT"
            self.lblBuyerUser.text = "SELLER'S USER NAME"
            self.txfUserName.placeholder = "Enter the user name of the seller here"
        }
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
    @IBAction func doback(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doCountine(_ sender: Any) {
        if self.isSellerAmpBuyer {
            if self.txfUserName.text!.trim().count == 0
            {
                APP_DELEGATE.showAlert(MSG_ERROR.ERROR_BUYER_USERNAME)
                return
            }
            if self.txfreferenceNumber.text!.trim().count == 0
            {
                APP_DELEGATE.showAlert(MSG_ERROR.ERROR_REFERENCE)
                return
            }
            APP_DELEGATE.createObj = CreateObj.init()
            APP_DELEGATE.createObj.username = self.txfUserName.text!.trim()
            APP_DELEGATE.createObj.refNumber = self.txfreferenceNumber.text!.trim()
            ApiHelper.shared.checkUser(param: ["username": self.txfUserName.text!.trim().lowercased()]) { (success, message) in
              if let mess = message
              {
                  if mess == "true" {
                      APP_DELEGATE.showAlert("The username does not exist")
                  }
                  else{
                      APP_DELEGATE.createObj = CreateObj.init()
                      APP_DELEGATE.createObj.username = self.txfUserName.text!.trim()
                      APP_DELEGATE.createObj.refNumber = self.txfreferenceNumber.text!.trim()
                        let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "ArtworkReportVC") as! ArtworkReportVC
                     vc.isSellerAmpBuyer = self.isSellerAmpBuyer
                     self.navigationController?.pushViewController(vc, animated: true)
                  }
              }
            }
        }
        else{
            if self.txfUserName.text!.trim().count == 0
            {
                APP_DELEGATE.showAlert(MSG_ERROR.ERROR_BUYER_USERNAME)
                return
            }
            if self.txfreferenceNumber.text!.trim().count == 0
            {
                APP_DELEGATE.showAlert(MSG_ERROR.ERROR_REFERENCE)
                return
            }
            ApiHelper.shared.checkUser(param: ["username": self.txfUserName.text!.trim().lowercased()]) { (success, message) in
                if let mess = message
                {
                    if mess == "true" {
                        APP_DELEGATE.showAlert("The username does not exist")
                    }
                    else{
                        APP_DELEGATE.createObj = CreateObj.init()
                        APP_DELEGATE.createObj.username = self.txfUserName.text!.trim()
                        APP_DELEGATE.createObj.refNumber = self.txfreferenceNumber.text!.trim()
                      let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "ArtworkReportVC") as! ArtworkReportVC
                       //vc.username = self.txfUserName.text!.trim()
                       //vc.refenceNumber = self.txfreferenceNumber.text!.trim()
                       self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
    }
    
}

extension NewTransactionVC: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txfUserName
        {
            txfreferenceNumber.becomeFirstResponder()
        }
        else{
            txfreferenceNumber.resignFirstResponder()
        }
        return true
    }
}
