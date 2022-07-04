//
//  BuyerActivityVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 6/10/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit
struct STATUS_BUYER_ACTIVE {
    static let declared_buyer = "declared:buyer"
    static let not_reply_yet = "not_reply_yet"
}
class BuyerActivityVC: UIViewController {

    @IBOutlet weak var tblActivity: UITableView!
    var dictItem: NSDictionary?
    var arrDatas = [ActivityObj]()
    var arrNotification = [NotificationObj]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateDatas()
        // Do any additional setup after loading the view.
    }
    

    func updateDatas()
    {
        if let dict = self.dictItem
        {
            if let buyers = dict.object(forKey: "buyers") as? [NSDictionary]
            {
                for buyer in buyers
                {
                    let obj = ActivityObj.init()
                    obj.dict = buyer
                    self.arrDatas.append(obj)
                }
                
            }
        }
        self.tblActivity.reloadData()
    }
    
    func checkExitNotification(_ username: String)-> NotificationObj?
    {
        print(self.arrNotification)
        for item in self.arrNotification
        {
            if let buyer = item.dict.object(forKey: "buyer") as? NSDictionary
            {
               
                if let usernameBuyer = buyer.object(forKey: "username") as? String
                {
                     print("usernameBuyer--->",usernameBuyer)
                     print("username--->",username)
                    if username == usernameBuyer {
                        return item
                    }
                }
            }
        }
        return nil
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
}


extension BuyerActivityVC: UITableViewDataSource, UITableViewDelegate
{
        func numberOfSections(in tableView: UITableView) -> Int {
           return 1
       }
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return self.arrDatas.count
       }
       
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           
           return 295
       }
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
            let cell = self.tblActivity.dequeueReusableCell(withIdentifier: "ActivityReportCell") as! ActivityReportCell
            self.configCellampAsAmp(cell, self.arrDatas[indexPath.row].dict, self.arrDatas[indexPath.row])
            cell.tapViewProfile = { [] in
                let dict = self.arrDatas[indexPath.row].dict
                if let status = dict.object(forKey: "status") as? String
                {
                    
                    if status == STATUS_BUYER_ACTIVE.not_reply_yet {
                    }
                    else if status == STATUS_BUYER_ACTIVE.declared_buyer {
                        if let username = dict.object(forKey: "username") as? String
                        {
                            let notificationObj = self.checkExitNotification(username)
                            if notificationObj != nil {
                                APP_DELEGATE.tracsationID = notificationObj!.notifyId
                                    APP_DELEGATE.actype = notificationObj!.actType
                                APP_DELEGATE.notificationID = notificationObj!.id
                            }
                        }
                        let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "ViewAmpReportVC") as! ViewAmpReportVC
                       vc.itemBuyer = self.arrDatas[indexPath.row].dict
                       vc.isAmpAsAmp = true
                        vc.transationID = self.dictItem!.object(forKey: "transacId") as? String ?? ""
                       self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else{
                        if let username = dict.object(forKey: "username") as? String
                        {
                            let notificationObj = self.checkExitNotification(username)
                            if notificationObj != nil {
                                APP_DELEGATE.tracsationID = notificationObj!.notifyId
                                    APP_DELEGATE.actype = notificationObj!.actType
                                APP_DELEGATE.notificationID = notificationObj!.id
                            }
                        }
                        let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "TransactionReportOverviewVC") as! TransactionReportOverviewVC
                        vc.dictItem = self.dictItem!
                        vc.dictBuyer = self.arrDatas[indexPath.row].dict
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
               
            }
            return cell
                
    }
    
    func configCellampAsAmp(_ cell: ActivityReportCell, _ buyer: NSDictionary, _ activityObj: ActivityObj)
    {
        cell.lblTransation.text = "Transaction as AMP"
        if let attachments = self.dictItem!.object(forKey: "attachments") as? NSDictionary
        {
            if let iPath = attachments.object(forKey: "iPath") as? String
            {
                cell.indicator.isHidden = false
                cell.indicator.startAnimating()
                let url = "\(URL_AVARTA)/\(iPath)"
                let replaceUrl  = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                cell.imgCell.sd_setImage(with: URL.init(string: replaceUrl ?? "")) { (image, error, type, url) in
                    cell.indicator.stopAnimating()
                    cell.indicator.isHidden = true
                }
            }
            else{
                cell.indicator.stopAnimating()
                cell.imgCell.image = nil
                cell.indicator.isHidden = true
            }
        }
        if let username = buyer.object(forKey: "username") as? String
        {
            cell.lblUsername.text = "With Buyer @\(username)"
            let notificationObj = self.checkExitNotification(username)
            if notificationObj == nil {
                cell.viewNotification.isHidden = true
            }
            else{
                cell.viewNotification.isHidden = false
            }
        }
        else{
            cell.viewNotification.isHidden = true
            cell.lblUsername.text = ""
        }
        if let company_info = buyer.object(forKey: "company") as? NSDictionary {
            cell.lblFullName.text = company_info.object(forKey: "name") as? String
        }
        else{
            let firstName = buyer.object(forKey: "fname") as? String ?? ""
            let lastName = buyer.object(forKey: "lname") as? String ?? ""
            cell.lblFullName.text = firstName + " " + lastName
        }
        
        cell.viewAction.isHidden = true
        if let status = buyer.object(forKey: "status") as? String
        {
            if status == STATUS_BUYER_ACTIVE.not_reply_yet {
                cell.lblPercent.text = "20%"
                cell.widthPercent.constant = (UIScreen.main.bounds.size.width - 80)/5
              
                cell.btnReview.setTitle("PENDING BUYER REPLY", for: .normal)
                cell.subBG.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_XAM)
            }
            else if status == STATUS_BUYER_ACTIVE.declared_buyer
            {
                cell.lblPercent.text = "40%"
                cell.widthPercent.constant = (UIScreen.main.bounds.size.width - 80)/5 * 2
              
                cell.btnReview.setTitle("VIEW BUYER REPORT", for: .normal)
                cell.subBG.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_TIM)
            }
            else{
                cell.lblPercent.text = "60%"
                cell.widthPercent.constant = (UIScreen.main.bounds.size.width - 80)/5 * 3
             
                cell.btnReview.setTitle("CREATE TRANSACTION REPORTS", for: .normal)
                cell.subBG.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_TIM)
            }
        }
       
    }
}
