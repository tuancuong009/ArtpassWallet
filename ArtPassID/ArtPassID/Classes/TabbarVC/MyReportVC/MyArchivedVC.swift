//
//  MyArchivedVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 3/3/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit
import SafariServices
class MyArchivedVC: UIViewController {
     var arrDatas = [ActivityObj]()
    var arrNotificationArchived = [NotificationObj]()
    @IBOutlet weak var tblActivity: UITableView!
    var indexP = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.callAPI()
        if self.arrNotificationArchived.count > 0 {
            self.updateNotification()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           Common.hideBusy()
    }
    
    func updateNotification()
    {
        let obj = self.arrNotificationArchived[indexP]
        ApiHelper.shared.addReadNotification(obj.notifyId, obj.actType, obj.id) { (success, error) in
            if self.indexP == self.arrNotificationArchived.count - 1
            {
                self.indexP = 0
            }
            else{
                self.indexP = self.indexP + 1
                self.updateNotification()
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
    func openSafari(_ url: String)
    {
        print("URL --->","\(URL_AVARTA)/\(url)")
       let vc = SFSafariViewController.init(url: URL.init(string: "\(URL_AVARTA)/\(url)")!)
       self.present(vc, animated: true) {
           
       }
    }
    @IBAction func doBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MyArchivedVC: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrDatas.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let activityObj = self.arrDatas[indexPath.row]
        if activityObj.typeActivity == TAG_ARRAY.ampAsAmp {
            return 282
        }
        return 210
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let activityObj = self.arrDatas[indexPath.row]
        if activityObj.typeActivity == TAG_ARRAY.ampAsAmp {
            let cell = self.tblActivity.dequeueReusableCell(withIdentifier: "ArchivedAmpCell") as! ArchivedAmpCell
            self.configCellAmpasAmp(cell, activityObj.dict, activityObj)
            cell.tapReportBuyer = { [] in
                guard let transacId = activityObj.dict.value(forKey: "transacId") as? String else {return}
                let url = "\(URL_TRANSACTION_BUYERANDSELLER_REPORT)\(transacId)/buyer"
                print("URL --->",url)
               let vc = SFSafariViewController.init(url: URL.init(string: url)!)
               self.present(vc, animated: true) {
                   
               }
//                if let buyers = activityObj.dict.object(forKey: "buyers") as? [NSDictionary]
//                {
//                    let buyer = buyers[0]
//                    if let file = buyer.object(forKey: "reportFile") as? String {
//                        print("reportFile buyers --->",file)
//                        self.openSafari(file)
//                    }
//                }
            }
            cell.tapReportSeller = { [] in
                guard let transacId = activityObj.dict.value(forKey: "transacId") as? String else {return}
                 let url = "\(URL_TRANSACTION_BUYERANDSELLER_REPORT)\(transacId)/seller"
                 print("URL --->",url)
                let vc = SFSafariViewController.init(url: URL.init(string: url)!)
                self.present(vc, animated: true) {
                    
                }
//                if let seller = activityObj.dict.object(forKey: "seller") as? NSDictionary
//                {
//
//                    if let file = seller.object(forKey: "reportFile") as? String {
//                         print("reportFile seller --->",file)
//                        self.openSafari(file)
//                    }
//                }
            }
            return cell
        }
        else{
            let cell = self.tblActivity.dequeueReusableCell(withIdentifier: "ActivityReportCell") as! ActivityReportCell
            let activityObj = self.arrDatas[indexPath.row]
            if activityObj.typeActivity == TAG_ARRAY.ampAsBuyer || activityObj.typeActivity == TAG_ARRAY.ampAsSeller {
                self.configCellAmpBuyerAndSeller(cell, activityObj.dict, activityObj)
                cell.tapViewProfile = { [] in
                    if let buyerId = activityObj.dict.object(forKey: "ampuser") as? NSDictionary
                    
                    {
                       let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "MyProfileArchivedVC") as! MyProfileArchivedVC
                       vc.userBuyer =  buyerId.object(forKey: "username") as? String ?? ""
                       vc.dictItem = activityObj.dict
                        if activityObj.typeActivity == TAG_ARRAY.ampAsBuyer {
                            vc.isAmpAsBuyer = true
                        }
                        else{
                            vc.isAmpBuyerAndSeller = true
                        }
                        
                        vc.typeActivity = activityObj.typeActivity
                       self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                return cell
            }
            else{
                self.configCell(cell, activityObj.dict, activityObj)
                cell.tapViewProfile = { [] in
                    if activityObj.typeActivity == TAG_ARRAY.transacAsSeller
                    {
                        if let buyerId = activityObj.dict.object(forKey: "buyer") as? NSDictionary
                        
                        {
                           let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "MyProfileArchivedVC") as! MyProfileArchivedVC
                           vc.userBuyer =  buyerId.object(forKey: "username") as? String ?? ""
                           vc.dictItem = activityObj.dict
                            vc.isSent = true
                           self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                    else{
                        if let buyerId = activityObj.dict.object(forKey: "seller") as? NSDictionary
                        {
                           let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "MyProfileArchivedVC") as! MyProfileArchivedVC
                           vc.userBuyer = buyerId.object(forKey: "username") as? String ?? ""
                           vc.dictItem = activityObj.dict
                            vc.isSent = false
                           self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
                return cell
            }
        }
        
    }
    
    func configCell(_ cell: ActivityReportCell, _ dict: NSDictionary, _ activityObj: ActivityObj)
    {
        if let attachments = dict.object(forKey: "attachments") as? NSDictionary
       {
           if let iPath = attachments.object(forKey: "iPath") as? String
           {
               let url = "\(URL_AVARTA)/\(iPath)"
               let replaceUrl  = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
               cell.imgCell.sd_setImage(with: URL.init(string: replaceUrl ?? "")) { (image, error, type, url) in
                   
               }
           }
           else{
               cell.imgCell.image = nil
           }
       }
        if activityObj.typeActivity == TAG_ARRAY.transacAsSeller {
            cell.lblTransation.text = "Transaction as seller"
            if let buyer = dict.object(forKey: "buyer") as? NSDictionary
            {
                
                print("buyer--->")
                if let username = buyer.object(forKey: "username") as? String
                {
                    cell.lblUsername.text = "With buyer @\(username)"
                }
                else{
                    cell.lblUsername.text = "#"
                }
                if let company_info = buyer.object(forKey: "company") as? NSDictionary {
                    cell.lblFullName.text = company_info.object(forKey: "name") as? String
                }
                else{
                    let firstName = buyer.object(forKey: "fname") as? String ?? ""
                    let lastName = buyer.object(forKey: "lname") as? String ?? ""
                    cell.lblFullName.text = firstName + " " + lastName
                }
                
            }
        }
        else{
            cell.lblTransation.text = "Transaction as buyer"
            if let seller = dict.object(forKey: "seller") as? NSDictionary
            {
                
                if let username = seller.object(forKey: "username") as? String
                {
                    cell.lblUsername.text = "With seller @\(username)"
                }
                else{
                    cell.lblUsername.text = "#"
                }
                if let company_info = seller.object(forKey: "company") as? NSDictionary {
                   cell.lblFullName.text = company_info.object(forKey: "name") as? String
                }
                else{
                    let firstName = seller.object(forKey: "fname") as? String ?? ""
                    let lastName = seller.object(forKey: "lname") as? String ?? ""
                    cell.lblFullName.text = firstName + " " + lastName
                }
                
            }
        }
      
        cell.btnReview.setTitle("VIEW TRANSACTION REPORT", for: .normal)
        cell.subBG.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_XANH)
    }
    
    func configCellAmpBuyerAndSeller(_ cell: ActivityReportCell, _ dict: NSDictionary, _ activityObj: ActivityObj)
       {
        
           if let attachments = dict.object(forKey: "attachments") as? NSDictionary
          {
              if let iPath = attachments.object(forKey: "iPath") as? String
              {
                  let url = "\(URL_AVARTA)/\(iPath)"
                  let replaceUrl  = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                  cell.imgCell.sd_setImage(with: URL.init(string: replaceUrl ?? "")) { (image, error, type, url) in
                      
                  }
              }
              else{
                  cell.imgCell.image = nil
              }
          }
           if let buyer = dict.object(forKey: "ampuser") as? NSDictionary
           {
               
               print("buyer--->")
               if let username = buyer.object(forKey: "username") as? String
               {
                
                    if activityObj.typeActivity == TAG_ARRAY.ampAsBuyer {
                         cell.lblTransation.text = "Transaction as buyer"
                        cell.lblUsername.text = "With AMP @\(username)"
                       
                   }
                   else{
                         cell.lblTransation.text = "Transaction as seller"
                        cell.lblUsername.text = "With AMP @\(username)"
                   }
               }
               else{
                   cell.lblUsername.text = "#"
               }
               if let company_info = buyer.object(forKey: "company") as? NSDictionary {
                   cell.lblFullName.text = company_info.object(forKey: "name") as? String
               }
               else{
                   let firstName = buyer.object(forKey: "fname") as? String ?? ""
                   let lastName = buyer.object(forKey: "lname") as? String ?? ""
                   cell.lblFullName.text = firstName + " " + lastName
               }
               
           }
           if activityObj.typeActivity == TAG_ARRAY.ampAsBuyer {
                cell.btnReview.setTitle("BUYER TRANSACTION REPORT", for: .normal)
           }
           else if activityObj.typeActivity == TAG_ARRAY.ampAsSeller {
                cell.btnReview.setTitle("SELLER TRANSACTION REPORT", for: .normal)
            }
           
           cell.subBG.backgroundColor = Common.hexStringToUIColor(COLOR_REPORT.COLOR_XANH)
       }
    
    func configCellAmpasAmp(_ cell: ArchivedAmpCell, _ dict: NSDictionary, _ activityObj: ActivityObj)
    {
        if let attachments = dict.object(forKey: "attachments") as? NSDictionary
       {
           if let iPath = attachments.object(forKey: "iPath") as? String
           {
               let url = "\(URL_AVARTA)/\(iPath)"
               let replaceUrl  = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
               cell.imgCell.sd_setImage(with: URL.init(string: replaceUrl ?? "")) { (image, error, type, url) in
                   
               }
           }
           else{
               cell.imgCell.image = nil
           }
       }
        if let buyers = dict.object(forKey: "buyers") as? [NSDictionary]
        {
            let buyer = buyers[0]
            if let username = buyer.object(forKey: "username") as? String
            {
             
                 cell.lblBuyerUserName.text = "With buyer @\(username)"
            }
            else{
                cell.lblBuyerUserName.text = "#"
            }
            if let company_info = buyer.object(forKey: "company") as? NSDictionary {
                cell.lblBuyerName.text = company_info.object(forKey: "name") as? String
            }
            else{
                let firstName = buyer.object(forKey: "fname") as? String ?? ""
                let lastName = buyer.object(forKey: "lname") as? String ?? ""
                cell.lblBuyerName.text = firstName + " " + lastName
            }
            
        }
        
        if let seller = dict.object(forKey: "seller") as? NSDictionary
        {
            
            if let username = seller.object(forKey: "username") as? String
            {
             
                 cell.lblSellerUserName.text = "With seller @\(username)"
            }
            else{
                cell.lblSellerUserName.text = "#"
            }
            if let company_info = seller.object(forKey: "company") as? NSDictionary {
                cell.lblSellerName.text = company_info.object(forKey: "name") as? String
            }
            else{
                let firstName = seller.object(forKey: "fname") as? String ?? ""
                let lastName = seller.object(forKey: "lname") as? String ?? ""
                cell.lblSellerName.text = firstName + " " + lastName
            }
            
        }
    }
    
}
extension MyArchivedVC
{
    func sorterForFileIDASC(this:ActivityObj, that:ActivityObj) -> Bool {
      let thisDict = this.dict
      let thatDis = that.dict
      let updatedTimeThis = thisDict.object(forKey: "createdTime") as? Double ?? 0.0
      let updatedTimeThat = thatDis.object(forKey: "createdTime") as? Double ?? 0.0
      return updatedTimeThis > updatedTimeThat
    }
    
    private func callAPI()
    {
         ApiHelper.shared.getArchived { (success, recs, sents, ampAsAmpUser, ampAsBuyer, ampAsSeller, error) in
           self.arrDatas.removeAll()
           if let arrRecs = recs
           {
               for item in arrRecs
               {
                   let obj = ActivityObj.init()
                   obj.dict = item as! NSDictionary
                    obj.typeActivity = TAG_ARRAY.transacAsBuyer
                   self.arrDatas.append(obj)
               }
           }
           if let arrSents = sents
           {
               for item in arrSents
               {
                  let obj = ActivityObj.init()
                   obj.dict = item as! NSDictionary
                   obj.typeActivity = TAG_ARRAY.transacAsSeller
                   self.arrDatas.append(obj)
               }
           }
            
            if let arrs = ampAsAmpUser
            {
                for item in arrs
                {
                   let obj = ActivityObj.init()
                    obj.dict = item as! NSDictionary
                    obj.typeActivity = TAG_ARRAY.ampAsAmp
                    self.arrDatas.append(obj)
                }
            }
            if let arrs = ampAsBuyer
            {
                for item in arrs
                {
                   let obj = ActivityObj.init()
                    obj.dict = item as! NSDictionary
                    obj.typeActivity = TAG_ARRAY.ampAsBuyer
                    self.arrDatas.append(obj)
                }
            }
            if let arrs = ampAsSeller
            {
                for item in arrs
                {
                   let obj = ActivityObj.init()
                    obj.dict = item as! NSDictionary
                    obj.typeActivity = TAG_ARRAY.ampAsSeller
                    self.arrDatas.append(obj)
                }
            }
           self.arrDatas = self.arrDatas.sorted(by: self.sorterForFileIDASC(this:that:))
           self.tblActivity.reloadData()
       }
   }
}
