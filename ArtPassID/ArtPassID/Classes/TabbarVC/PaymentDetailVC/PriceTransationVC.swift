//
//  PriceTransationVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 5/15/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class PriceTransationVC: UIViewController {

    @IBOutlet weak var imgCell: UIImageView!
    @IBOutlet weak var lblBuyerUsername: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblRef: UILabel!
    @IBOutlet weak var txfPrice: UITextField!
    var dictItem = NSDictionary.init()
    @IBOutlet weak var txfCurrecy: UITextField!
    @IBOutlet weak var viewSuccess: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
        self.viewSuccess.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    func updateUI()
    {
        if let attachments = self.dictItem.object(forKey: "attachments") as? NSDictionary
        {
              if let iPath = attachments.object(forKey: "iPath") as? String
              {
                let url = "\(URL_AVARTA)/\(iPath)"
                let replaceUrl  = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                  self.imgCell.sd_setImage(with: URL.init(string: replaceUrl ?? "")) { (image, error, type, url) in
                      
                  }
              }
              else{
                  self.imgCell.image = nil
              }
        }
        self.lblName.text = self.dictItem.object(forKey: "artist") as? String
        self.lblTitle.text = self.dictItem.object(forKey: "title") as? String
        self.lblBuyerUsername.text = ""
        self.lblRef.text = dictItem.object(forKey: "refnum") as? String
        if let buyer = dictItem.object(forKey: "buyer") as? NSDictionary
       {
           if let username = buyer.object(forKey: "username") as? String
           {
            self.lblBuyerUsername.text = "@\(username)"
           }
           else{
               self.lblBuyerUsername.text = ""
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
    @IBAction func doCurrent(_ sender: Any) {
        DPPickerManager.shared.showPicker(title: "CURRTENCY", selected: self.txfCurrecy.text!, strings: ["EURO", "USD", "GBP", "CHF"]) { (val, index, success) in
            if !success
            {
                self.txfCurrecy.text = val
            }
        }
    }
    @IBAction func doContinue(_ sender: Any) {
        if self.txfPrice.text!.trim().isEmpty {
            APP_DELEGATE.showAlert("Sales price is required")
            return
        }
        if self.txfCurrecy.text!.trim().isEmpty {
            APP_DELEGATE.showAlert("Currency price is required")
            return
        }
        self.view.endEditing(true)
        self.completeTransaction(self.dictItem)
    }
    func paramListOffs(_ arrDict: [NSDictionary]) -> [String]
       {
           var jsonDataObject = [String]()
           for officer in arrDict
           {
                 let item = officer.object(forKey: "officer") as! NSDictionary
                let country = item.object(forKey: "country") as? NSDictionary ?? NSDictionary()
                let param1 = NSMutableDictionary.init()
                param1["name"] = item.object(forKey: "name") as? String ?? ""
                param1["date_of_birth"] = item.object(forKey: "date_of_birth") as? String ?? ""
                param1["country"] = ["name": country.object(forKey: "name") as? String ?? "", "iso2code": country.object(forKey: "iso2code") as? String ?? ""]
               
                param1["position"] = "director"
                param1["isAlsoUBO"] = item.object(forKey: "isAlsoUBO") as? Bool ?? false
                param1["inactive"] = item.object(forKey: "inactive") as? Bool ?? false
                let dictParam = ["officer": param1]
               do {
                   let jsonData = try JSONSerialization.data(withJSONObject: dictParam)
                   if let json = String(data: jsonData, encoding: .utf8) {
                       print(json)
                       jsonDataObject.append(json)
                   }
               } catch {
                   print("something went wrong with parsing json")
               }
           }
           
           return jsonDataObject
       }
    
       func paramListUbos(_ arrDict: [NSDictionary]) -> [String]
       {
           var jsonDataObject = [String]()
           for ultimate_beneficial_owner in arrDict
           {
                let item = ultimate_beneficial_owner.object(forKey: "officer") as! NSDictionary
                let country = item.object(forKey: "country") as? NSDictionary ?? NSDictionary()
                let param1 = NSMutableDictionary.init()
                param1["name"] = item.object(forKey: "name") as? String ?? ""
                param1["date_of_birth"] = item.object(forKey: "date_of_birth") as? String ?? ""
                param1["country"] = ["name": country.object(forKey: "name") as? String ?? "", "iso2code": country.object(forKey: "iso2code") as? String ?? ""]
            
               let dictParam = ["ultimate_beneficial_owner": param1]
                  do {
                      let jsonData = try JSONSerialization.data(withJSONObject: dictParam)
                      if let json = String(data: jsonData, encoding: .utf8) {
                          print(json)
                          jsonDataObject.append(json)
                      }
                  } catch {
                      print("something went wrong with parsing json")
                  }
               
           }
           
           return jsonDataObject
    }
    func completeTransaction(_ dict: NSDictionary)
    {
        
        let param = NSMutableDictionary.init(dictionary: dictItem)
        let seller = dict.object(forKey: "seller") as? NSDictionary ??  NSDictionary.init()
        let buyer = dict.object(forKey: "buyer") as? NSDictionary ??  NSDictionary.init()
//        let paramSeller = NSMutableDictionary.init(dictionary: seller)
//        let paramBuyer = NSMutableDictionary.init(dictionary: buyer)
//        paramSeller.setValue(self.paramListOffs(seller.object(forKey: "listOffs") as? [NSDictionary] ?? [NSDictionary]()), forKey: "listOffs")
//         paramSeller.setValue(self.paramListOffs(seller.object(forKey: "listUBOs") as? [NSDictionary] ?? [NSDictionary]()), forKey: "listUBOs")
//
//        paramBuyer.setValue(self.paramListOffs(buyer.object(forKey: "listOffs") as? [NSDictionary] ?? [NSDictionary]()), forKey: "listOffs")
//        paramBuyer.setValue(self.paramListOffs(buyer.object(forKey: "listUBOs") as? [NSDictionary] ?? [NSDictionary]()), forKey: "listUBOs")
        
        param["seller"] =  seller
        param["buyer"] = buyer
        param["price"] = self.txfPrice.text!.trim()
        param["currency"] = self.txfCurrecy.text!.trim()
        param["step"] = "complete"
        print("param--->",param)
        ApiHelper.shared.sellerProcess(param as! Parameters) { (success, error) in
            if success
            {
                if !APP_DELEGATE.actype.isEmpty {
                     ApiHelper.shared.addReadNotification(APP_DELEGATE.tracsationID, APP_DELEGATE.actype, APP_DELEGATE.notificationID) { (success, error) in
                        self.viewSuccess.isHidden = false
                      self.tabBarController?.tabBar.isHidden = true
                      self.perform(#selector(self.redirectHome), with: nil, afterDelay: TIME_OUT)
                     }
                }
                else{
                    self.viewSuccess.isHidden = false
                      self.tabBarController?.tabBar.isHidden = true
                      self.perform(#selector(self.redirectHome), with: nil, afterDelay: TIME_OUT)
                }
               
            }
            else{
                if error != nil {
                    APP_DELEGATE.showAlert(error!.msg!)
                }
            }
        }
       
//        let url = URL(string: "https://artpass.id/api/data/fromios")
//        var request = URLRequest(url: url!)
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpMethod = "POST"
//        request.httpBody = try! JSONSerialization.data(withJSONObject: param, options: [])
//
//        Alamofire.request(request).responseJSON { (response) in
//            switch response.result {
//            case .success:
//                print(response.result.value)
//                break
//            case .failure:
//                print(response.error)
//                break
//            }
//        }
    }
    
    @objc func redirectHome()
    {
        APP_DELEGATE.isRedirectArchived = true
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popToRootViewController(animated: true)
    }
}
