//
//  TradeCell.swift
//  ArtPassID
//
//  Created by QTS Coder on 9/9/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit

class TradeCell: UITableViewCell {
    var tapViewID: (() ->())?
    var tapViewCDDReport: (() ->())?
    var tapViewRemove: (() ->())?
    var tapIndus: (() ->())?
    @IBOutlet weak var imgAvatar: UIImageViewX!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var bgView: UIViewX!
    @IBOutlet weak var btnView: UIButton!
    @IBOutlet weak var lblConnect: UILabel!
    @IBOutlet weak var subNotification: UIViewX!
    @IBOutlet weak var viewInspection: UIView!
    @IBOutlet weak var viewCddReport: UIView!
    @IBOutlet weak var viewRemove: UIView!
    @IBOutlet weak var btnViewCdd: UIButton!
    @IBOutlet weak var btnViewInsu: UIButton!
    @IBOutlet weak var btnRemove: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func doView(_ sender: Any) {
        self.tapViewID?()
    }
    @IBAction func doViewCDD(_ sender: Any) {
        self.tapViewCDDReport?()
    }
    @IBAction func doRemove(_ sender: Any) {
        self.tapViewRemove?()
    }
    @IBAction func doInsu(_ sender: Any) {
        self.tapIndus?()
    }
    
    func configCell(_ result: NSDictionary)
    {
        self.lblFullName.numberOfLines = 1
        self.lblUserName.numberOfLines = 1
        if let userInfo = result.object(forKey: "userInfo") as? NSDictionary{
            self.lblFullName.text = (userInfo.object(forKey: "fname") as? String ?? "") + " " + (userInfo.object(forKey: "lname") as? String ?? "")
             self.lblUserName.text = "@\(userInfo.object(forKey: "username") as? String ?? "")"
             if let avatar = userInfo.object(forKey: "avatar") as? String
            {
                //self.imgAvatar.image = Common.convertBase64ToImage(avatar)
                 Common.loadAvatarFromServer(avatar, self.imgAvatar)
            }
            else{
                self.imgAvatar.image = nil
            }
            if let requestedTime = result.object(forKey: "createdTime") as? Double
            {
                let format = DateFormatter.init()
                format.dateFormat = "MM/dd/yyyy"
                let date = format.string(from: Date.init(milliseconds: Int64(requestedTime)))
                self.lblConnect.text = "Connected on \(date)"
            }
            if let isAMP = userInfo.object(forKey: "isAMP") as? Bool
            {
                print("isAMP---->",isAMP)
                if isAMP {
                   // self.btnViewCdd.setTitle("REQUEST CDD REPORT", for: .normal)
                    //self.viewCddReport.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_TIM)
                    self.viewCddReport.isHidden = true
                }
                else{
                    self.viewCddReport.isHidden = false
                    self.btnViewCdd.setTitle("VIEW CDD REPORT", for: .normal)
                    self.viewCddReport.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_XANH)
                }
            }
        }
    }
    
    func configCellAppliant(_ result: NSDictionary)
    {
        self.lblFullName.numberOfLines = 1
        self.lblUserName.numberOfLines = 1
        if let userInfo = result.object(forKey: "user_id") as? NSDictionary{
            self.lblFullName.text = (userInfo.object(forKey: "fname") as? String ?? "") + " " + (userInfo.object(forKey: "lname") as? String ?? "")
             self.lblUserName.text = "@\(userInfo.object(forKey: "username") as? String ?? "")"
             if let avatar = userInfo.object(forKey: "avatar") as? String
            {
                //self.imgAvatar.image = Common.convertBase64ToImage(avatar)
                 Common.loadAvatarFromServer(avatar, self.imgAvatar)
            }
            else{
                self.imgAvatar.image = nil
            }
            if let requestedTime = result.object(forKey: "created_time") as? Double
            {
                let format = DateFormatter.init()
                format.dateFormat = "MM/dd/yyyy"
                let date = format.string(from: Date.init(milliseconds: Int64(requestedTime)))
                self.lblConnect.text = "Connected on \(date)"
            }
        }
        else{
            self.lblFullName.text = " "
            self.lblUserName.text = " "
            self.lblConnect.text = "Connected on"
        }
        /*
         With applicant:
         Show REQUEST CDD REPORT: is_amp is true  and app_request_cdd is empty
         Show  PENDING CDD REPORT: is _amp is true and app_request_cdd.status is 'pending'
         */
        //if amp_request_cdd.status = 'accepted' => show VIEW CDD REPORT and VIEW INSPECTION REPORT and REVOKE CDD ACCESS.
        let app_request_cdd = result.object(forKey: "app_request_cdd") as? NSDictionary
        let amp_request_cdd = result.object(forKey: "amp_request_cdd") as? NSDictionary
        if app_request_cdd == nil {
            self.btnViewCdd.setTitle("REQUEST CDD REPORT", for: .normal)
            self.viewInspection.isHidden = true
            self.viewCddReport.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_XANH)
        }
        else{
            if let app_request_cdd = app_request_cdd, let status = app_request_cdd.object(forKey: "status") as? String, status == "pending"{
                self.btnViewCdd.setTitle("PENDING CDD REQUEST", for: .normal)
                self.viewInspection.isHidden = true
                self.viewCddReport.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_XAM)
            }
            else if let amp_request_cdd = amp_request_cdd, let status = amp_request_cdd.object(forKey: "status") as? String, status == "pending"{
                self.btnViewCdd.setTitle("ACCEPT CDD REQUEST", for: .normal)
                self.viewInspection.isHidden = true
                self.viewCddReport.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_TIM)
            }
            else{
                self.btnViewCdd.setTitle("VIEW CDD REPORT", for: .normal)
                self.viewInspection.isHidden = false
                self.viewCddReport.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_XANH)
            }
        }
        
        if let amp_request_cdd = amp_request_cdd, let status = amp_request_cdd.object(forKey: "status") as? String, status == "accepted"{
            self.btnRemove.setTitle("REVOKE CDD ACCESS", for: .normal)
        }
        else{
            self.btnRemove.setTitle("REMOVE CONNECTION", for: .normal)
        }
    }
    
    
    func configCellAMP(_ result: NSDictionary)
    {
        self.lblFullName.numberOfLines = 1
        self.lblUserName.numberOfLines = 1
        if let userInfo = result.object(forKey: "user_id") as? NSDictionary{
            self.lblFullName.text = (userInfo.object(forKey: "fname") as? String ?? "") + " " + (userInfo.object(forKey: "lname") as? String ?? "")
             self.lblUserName.text = "@\(userInfo.object(forKey: "username") as? String ?? "")"
             if let avatar = userInfo.object(forKey: "avatar") as? String
            {
                //self.imgAvatar.image = Common.convertBase64ToImage(avatar)
                 Common.loadAvatarFromServer(avatar, self.imgAvatar)
            }
            else{
                self.imgAvatar.image = nil
            }
            if let requestedTime = result.object(forKey: "created_time") as? Double
            {
                let format = DateFormatter.init()
                format.dateFormat = "MM/dd/yyyy"
                let date = format.string(from: Date.init(milliseconds: Int64(requestedTime)))
                self.lblConnect.text = "Connected on \(date)"
            }
        }
        else{
            self.lblFullName.text = " "
            self.lblUserName.text = " "
            self.lblConnect.text = "Connected on "
        }
      /*
         amp_request_cdd
         W҉a҉y҉n҉e҉, 10:24 AM
         for AMP:
         Show REQUEST CDD REPORT: is_applicant is true and amp_request_cdd is empty
         Show CDD REQUEST PENDING: is_applicant is true and amp_request_cdd.status is 'pending
         */
        let app_request_cdd = result.object(forKey: "app_request_cdd") as? NSDictionary
        let amp_request_cdd = result.object(forKey: "amp_request_cdd") as? NSDictionary
        if amp_request_cdd == nil {
            self.btnViewCdd.setTitle("REQUEST CDD REPORT", for: .normal)
            self.viewInspection.isHidden = true
            self.viewCddReport.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_XANH)
        }
        else{
            if let app_request = app_request_cdd, let status = app_request.object(forKey: "status") as? String, status == "pending"{
                self.btnViewCdd.setTitle("ACCEPT CDD REQUEST", for: .normal)
                self.viewInspection.isHidden = true
                self.viewCddReport.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_TIM)
            }
            else if let amp_request = amp_request_cdd, let status = amp_request.object(forKey: "status") as? String, status == "pending"{
                self.btnViewCdd.setTitle("PENDING CDD REQUEST", for: .normal)
                self.viewInspection.isHidden = true
                self.viewCddReport.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_XAM)
            }
            else{
                self.btnViewCdd.setTitle("VIEW CDD REPORT", for: .normal)
                self.viewInspection.isHidden = false
                self.viewCddReport.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_XANH)
            }
        }
        if let app_request_cdd = app_request_cdd, let status = app_request_cdd.object(forKey: "status") as? String, status == "accepted"{
            self.btnRemove.setTitle("REVOKE CDD ACCESS", for: .normal)
        }
        else{
            self.btnRemove.setTitle("REMOVE CONNECTION", for: .normal)
        }
    }
}
