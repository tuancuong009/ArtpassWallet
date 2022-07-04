//
//  BusinessStep2VC.swift
//  ArtPassID
//
//  Created by QTS Coder on 3/20/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit

class BusinessStep2VC: UIViewController {

    @IBOutlet weak var lblBusinessName: UILabel!
    @IBOutlet weak var lblBusinessNumber: UILabel!
    @IBOutlet weak var lblAddressStreat: UILabel!
    @IBOutlet weak var lblZip: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    var dictCompany = NSDictionary.init()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
        // Do any additional setup after loading the view.
    }
    
    func updateUI()
    {
        APP_DELEGATE.userObj.company = self.dictCompany
       self.lblBusinessName.text = self.dictCompany.object(forKey: "name") as? String
       self.lblBusinessNumber.text = self.dictCompany.object(forKey: "company_number") as? String
       
       if let registered_address = self.dictCompany.object(forKey: "registered_address") as? NSDictionary
       {
           let city =  registered_address.object(forKey: "locality") as? String ?? ""
           let zipCode = registered_address.object(forKey: "postal_code") as? String ?? ""
           self.lblZip.text = zipCode + " " + city
           self.lblCountry.text = registered_address.object(forKey: "country") as? String
           self.lblAddressStreat.text = registered_address.object(forKey: "street_address") as? String
       }
        self.checkOfficeAndUbo()
    }
    
    func ownerUser()-> OfficeDirectorObj
    {
        let obj = OfficeDirectorObj.init(NSDictionary.init())
        let name = self.showValueByKey("Full Name")
        let arrName = name.components(separatedBy: " ")
        if arrName.count > 0 {
           obj.lastname = self.removeText(arrName.last!)
        }
        obj.firstname = self.removeText(name.replacingOccurrences(of: obj.lastname, with: ""))
        obj.birthdayCode = self.formatStringBirthday(self.getBirthdayAcuant())
        obj.birthday = self.formatStringBirthdayShow(self.getBirthdayAcuant())
        let coutryCode = self.showValueByKey("Issuing State Code")
        if coutryCode.count == 2
        {
            obj.country = "United States"
            obj.countryCode = "USA"
        }
        else{
            let countryName = self.showValueByKey("Issuing State Name")
            obj.country = countryName
            obj.countryCode = coutryCode
        }
        obj.isAPI = false
        obj.isScan = true
        return obj
    }
   
    func getBirthdayAcuant() -> String
    {
        if let arrs = APP_DELEGATE.acuantObj.data
        {
            for item in arrs {
                if item.contains("Birth Date") {
                    let arrFirstName = item.components(separatedBy: ":")
                    if arrFirstName.count  > 1 {
                        return arrFirstName[1]
                    }
                }
            }
        }
        return " "
    }
    func showValueByKey(_ key: String) -> String
    {
        if let arrs = APP_DELEGATE.acuantObj.data
        {
            for item in arrs {
                if item.contains(key) {
                    let arrFirstName = item.components(separatedBy: ":")
                    if arrFirstName.count  > 1 {
                        return arrFirstName[1]
                    }
                }
            }
        }
        return " "
    }
    
    func formatStringBirthday(_ date: String)-> String
    {
        if date.trim().count == 0 {
            return " "
        }
        let format = DateFormatter.init()
        format.dateFormat = "d MMM yyyy"
        if let dateFormat = format.date(from: date)
        {
            let format1 = DateFormatter.init()
            format1.dateFormat = "yyyy-MM-dd"
            return format1.string(from: dateFormat)
        }
        else
        {
            let format = DateFormatter.init()
            format.dateFormat = "MM-dd-yyyy"
            if let dateFormat = format.date(from: date)
            {
                let format1 = DateFormatter.init()
                format1.dateFormat = "yyyy-MM-dd"
                return format1.string(from: dateFormat)
            }
            return " "
        }
    }
    func formatStringBirthdayShow(_ date: String)-> String
    {
        if date.trim().count == 0 {
            return " "
        }
        let format = DateFormatter.init()
        format.dateFormat = "d MMM yyyy"
        if let dateFormat = format.date(from: date)
        {
            let format1 = DateFormatter.init()
            format1.dateFormat = "MMM, dd yyyy"
            return format1.string(from: dateFormat)
        }
        else
        {
            let format = DateFormatter.init()
            format.dateFormat = "MM-dd-yyyy"
            if let dateFormat = format.date(from: date)
            {
                let format1 = DateFormatter.init()
                format1.dateFormat = "MMM, dd yyyy"
                return format1.string(from: dateFormat)
            }
            return " "
        }
    }
    
    func checkOfficeAndUbo()
    {
        APP_DELEGATE.userObj.arrOffices.removeAll()
        APP_DELEGATE.userObj.arrUbos.removeAll()
        APP_DELEGATE.userObj.arrOffices.append(self.ownerUser())
        //APP_DELEGATE.userObj.arrUbos.append(self.ownerUser())
        /*let nameScan = self.showValueByKey("Full Name")
        if let company = dictCompany.object(forKey: "company") as? NSDictionary
        {
            if let officers = company.object(forKey: "officers") as? [NSDictionary]
            {
                for item in officers
                {
                    if let officer = item.object(forKey: "officer") as? NSDictionary
                    {
                        let name = officer.object(forKey: "name") as? String ?? ""
                        if nameScan.lowercased() != name.lowercased()
                        {
                            let obj = OfficeDirectorObj.init(officer)
                            obj.isAPI = true
                            APP_DELEGATE.userObj.arrOffices.append(obj)
                        }
                        else{
                            APP_DELEGATE.userObj.isDirector = true
                        }
                        
                    }
                }
            }
            
            if let ultimate_beneficial_owners = company.object(forKey: "ultimate_beneficial_owners") as? [NSDictionary]
            {
                for item in ultimate_beneficial_owners
                {
                    print("ITEM --->",item)
                    if let officer = item.object(forKey: "ultimate_beneficial_owner") as? NSDictionary
                    {
                        let name = officer.object(forKey: "name") as? String ?? ""
                        if nameScan.lowercased() != name.lowercased()
                        {
                             let obj = OfficeDirectorObj.init(officer)
                            obj.isAPI = true
                            APP_DELEGATE.userObj.arrUbos.append(obj)
                        }
                        
                    }
                }
            }
            
        }*/
        
    }
    
    func removeText(_ text: String)-> String
    {
        //Mr, Ms, Mrs
        var remove = text
        remove = remove.replacingOccurrences(of: "Mr", with: "")
        remove = remove.replacingOccurrences(of: "Ms", with: "")
        remove = remove.replacingOccurrences(of: "Mrs", with: "")
        return remove.trim()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func doReturn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func doConfirm(_ sender: Any) {
        let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "BusinessStep3VC") as! BusinessStep3VC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
