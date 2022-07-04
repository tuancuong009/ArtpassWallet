//
//  AmpAsBuyerVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 6/2/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit
import SafariServices
class AmpAsBuyerVC: UIViewController {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    var itemBuyer = NSDictionary.init()
    var isAmpAsSeller = false
    @IBOutlet weak var lblNavi: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblNoteFile: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
        // Do any additional setup after loading the view.
    }
    
//VIEW CONNECT ID
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
    @IBAction func doViewFile(_ sender: Any) {
        //seller_sale_rpFile
        if self.isAmpAsSeller {
            if let ampuser = itemBuyer.object(forKey: "ampuser") as? NSDictionary
            {
                if let reportFile = ampuser.object(forKey: "seller_sale_rpFile") as? String
                {
                    let url = "\(URL_AVARTA)/\(reportFile)"
                     print("URL --->",url)
                    let vc = SFSafariViewController.init(url: URL.init(string: url)!)
                    self.present(vc, animated: true) {
                        
                    }
                }
            }
        }
        else{
            /*
            if let ampuser = itemBuyer.object(forKey: "ampuser") as? NSDictionary
           {
               if let amlReport = ampuser.object(forKey: "connectRp") as? NSDictionary
               {
                   if let reportFile = amlReport.object(forKey: "fileUrl") as? String
                   {
                       let url = "\(URL_AVARTA)/\(reportFile)"
                        print("URL --->",url)
                       let vc = SFSafariViewController.init(url: URL.init(string: url)!)
                       self.present(vc, animated: true) {
                           
                       }
                   }
               }
               
           }*/
            if let ampuser = itemBuyer.object(forKey: "ampuser") as? NSDictionary
            {
                if let reportFile = ampuser.object(forKey: "buyer_purchase_rpFile") as? String
                {
                    let url = "\(URL_AVARTA)/\(reportFile)"
                     print("URL --->",url)
                    let vc = SFSafariViewController.init(url: URL.init(string: url)!)
                    self.present(vc, animated: true) {
                        
                    }
                }
            }
        }
       
    }
    @IBAction func doProceess(_ sender: Any) {
        let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "PaymentDetailVC") as! PaymentDetailVC
        vc.username = self.lblUserName.text!.replacingOccurrences(of: "@", with: "")
        vc.dictItem = self.itemBuyer
        vc.isAmpAsSeller = self.isAmpAsSeller
        vc.isAmpAsBuyer = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func updateUI()
    {
         self.lblNoteFile.text = "VIEW AMP REPORT"
        if self.isAmpAsSeller {
            self.lblNavi.text = "COMPLETE SELLER REPORT"
           
        }
        imgAvatar.layer.cornerRadius = imgAvatar.frame.size.width/2
        imgAvatar.layer.masksToBounds = true
        if let buyer = self.itemBuyer.object(forKey: "ampuser") as? NSDictionary
        {
            
            if let username = buyer.object(forKey: "username") as? String
            {
                self.lblUserName.text = "@\(username)"
            }
            else{
                self.lblUserName.text = ""
            }
            if let company_info = buyer.object(forKey: "company") as? NSDictionary {
                self.lblName.text = company_info.object(forKey: "name") as? String
            }
            else{
                let firstName = buyer.object(forKey: "fname") as? String ?? ""
                let lastName = buyer.object(forKey: "lname") as? String ?? ""
                self.lblName.text = firstName + " " + lastName
            }
            if let avatar = buyer.object(forKey: "avatar") as? String {
                Common.loadAvatarFromServer(avatar, self.imgAvatar)
                //self.imgAvatar.image = Common.convertBase64ToImage(avatar)
            }
        }
    }
}
