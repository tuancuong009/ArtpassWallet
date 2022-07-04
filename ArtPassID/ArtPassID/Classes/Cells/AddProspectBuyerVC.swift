//
//  AddProspectBuyerVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 6/9/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit
import Alamofire
import SafariServices
class AddProspectBuyerVC: UIViewController {
    var tapNotifications: (() ->())?
    @IBOutlet weak var lblUsernmae: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblArtiName: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMedium: UILabel!
    @IBOutlet weak var lblDimen: UILabel!
    @IBOutlet weak var txfBuyer: UITextField!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var lblBuyerUsername: UILabel!
    @IBOutlet weak var lblBuyerName: UILabel!
    @IBOutlet weak var lblBuyerCompany: UILabel!
    @IBOutlet weak var btnViewConnect: UIButton!
    @IBOutlet weak var imgCell: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var dictItem = NSDictionary.init()
    var dictResult: NSDictionary?
    var arrBuyers = [NSMutableDictionary]()
    var oneClickF = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSearch.isHidden = true
        self.updateUI()
        self.lblBuyerName.text = ""
        self.lblBuyerUsername.text =  ""
        self.lblBuyerCompany.text = ""
        oneClickF = self.dictItem.object(forKey: "oneClickAndWorkF") as? String ?? ""
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
    @IBAction func clickQrCode(_ sender: Any) {
        if !oneClickF.isEmpty {
            let vc = SFSafariViewController.init(url: URL.init(string: "\(URL_AVARTA)/\(oneClickF)")!)
            self.present(vc, animated: true) {
                
            }
        }
    }
    @IBAction func doback(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doViewConnect(_ sender: Any) {
        if self.dictResult != nil {
            ApiHelper.shared.updatetransactionAmpAsBuyer(self.paramCallAPI()) { (success, error) in
                if success
                {
                    self.tapNotifications?()
                    self.navigationController?.popViewController(animated: true)
                }
                else{
                    if error != nil {
                        APP_DELEGATE.showAlert(error!.msg!)
                    }
                }
            }
        }
        else{
            if self.txfBuyer.text!.trim().isEmpty {
                return
            }
            self.view.endEditing(true)
            let param = ["username":self.txfBuyer.text!.trim()]
            ApiHelper.shared.checkUserNameBuyer(param: param) { (success, val, message) in
                if success
                {
                    if let result = val
                    {
                        print("result--->",result)
                        self.dictResult = result.object(forKey: "user") as? NSDictionary
                        self.viewSearch.isHidden = false
                        self.configSearchUser()
                    }
                }
                else{
                    if let mess = message {
                        APP_DELEGATE.showAlert(mess)
                    }
                }
            }
        }
        
    }
    //status = "reviewing_seller:amper:60";
    func configSearchUser()
    {
        self.btnViewConnect.setTitle("REQUEST BUYER REPORT", for: .normal)
        if let dict = self.dictResult
        {
            if let company_info = dict.object(forKey: "company") as? NSDictionary {
               self.lblBuyerCompany.text = company_info.object(forKey: "name") as? String
           }
            let firstName = dict.object(forKey: "fname") as? String ?? ""
            let lastName = dict.object(forKey: "lname") as? String ?? ""
            self.lblBuyerName.text = firstName + " " + lastName
            self.lblBuyerUsername.text =  dict.object(forKey: "username") as? String ?? ""
            self.txfBuyer.isEnabled = false
        }
    }
    
    func paramCallAPI()-> Parameters
    {
        //not_reply_yet
        var param:Parameters = [:]
        param["transacId"] = self.dictItem.object(forKey: "transacId") as? String ?? ""
        let muDict = NSMutableDictionary.init(dictionary: self.dictResult!)
        muDict.setValue("not_reply_yet", forKey: "status")
         muDict.setValue("\(Date().timeIntervalSince1970)", forKey: "addedTime")
        self.arrBuyers.append(muDict)
        param["buyers"] = self.arrBuyers
        param["ampuser"] = self.dictItem.object(forKey: "ampuser") as? NSDictionary ??  NSDictionary.init()
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

        return param
    }
}

extension AddProspectBuyerVC
{
    func updateUI()
    {
        if let attachments = self.dictItem.object(forKey: "attachments") as? NSDictionary
        {
            if let iPath = attachments.object(forKey: "iPath") as? String
            {
                self.indicator.isHidden = false
                self.indicator.startAnimating()
                let url = "\(URL_AVARTA)/\(iPath)"
                let replaceUrl  = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                self.imgCell.sd_setImage(with: URL.init(string: replaceUrl ?? "")) { (image, error, type, url) in
                    self.indicator.stopAnimating()
                    self.indicator.isHidden = true
                }
            }
            else{
                self.indicator.stopAnimating()
                self.imgCell.image = nil
                self.indicator.isHidden = true
            }
        }
        if let buyer = self.dictItem.object(forKey: "ampuser") as? NSDictionary
        {
            
           
            if let username = buyer.object(forKey: "username") as? String
            {
                self.lblUsernmae.text = "With seller @\(username)"
            }
            else{
                self.lblUsernmae.text = ""
            }
            if let company_info = buyer.object(forKey: "company") as? NSDictionary {
                self.lblName.text = company_info.object(forKey: "name") as? String
            }
            else{
                let firstName = buyer.object(forKey: "fname") as? String ?? ""
                let lastName = buyer.object(forKey: "lname") as? String ?? ""
                self.lblName.text = firstName + " " + lastName
            }
            
        }
        self.lblArtiName.text = self.dictItem.object(forKey: "artist") as? String
        self.lblTitle.text = self.dictItem.object(forKey: "title") as? String
        self.lblMedium.text = self.dictItem.object(forKey: "medium") as? String
        self.lblDimen.text = self.dictItem.object(forKey: "duration") as? String
        if let buyers = self.dictItem.object(forKey: "buyers") as? [NSDictionary]
        {
           for buyer in buyers
           {
                self.arrBuyers.append(NSMutableDictionary.init(dictionary: buyer))
           }
        }
    }
}
