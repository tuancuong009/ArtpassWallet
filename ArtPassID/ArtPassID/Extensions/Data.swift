//
//  Data.swift
//  ArtPassID
//
//  Created by QTS Coder on 2/21/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit

class UserObj
{
    var email = ""
    var phoneCode = ""
    var phoneNumber = ""
    var veritificatonCode = ""
    var street_address = ""
    var city = ""
    var zipcode = ""
    var state = ""
    var country = ""
    var countryCode = ""
    var username = ""
    var phoneAPI = ""
    var password = ""
    var fname = ""
    var lname = ""
    var utype = ""
   
    var company = NSDictionary.init()
    var fOpts = false
    var sOpts = false
    var tOpts = false
    var arrOffices = [OfficeDirectorObj]()
    var arrUbos = [OfficeDirectorObj]()
    var isDirector = false
//    var fopts = false
//    var sopts = false
//    var topts = false
    var signature = ""
}

class ProfileObj {
    var _id = ""
    var email = ""
    var fname = ""
    var lname = ""
    var location = NSDictionary.init()
    var phone = ""
    var phoneCode = ""
    var userState = ""
    var username = ""
    var avatar = ""
    var is_sharing_ccd = false
     var pinCode = ""
    var createdAt = 0.0
    var kycAmlInfo = NSDictionary()
    var amlReport: NSDictionary?
    var profileReport: NSDictionary?
    var company_info: NSDictionary?
    var company: NSDictionary?
    var connectRp: NSDictionary?
    var utype = ""
    var cdd: NSDictionary?
    var payment: NSDictionary?
    var dict: NSDictionary?
    init(_ dict: NSDictionary) {
        self._id = dict["_id"] as? String ?? ""
        self.email = dict["email"] as? String ?? ""
        self.fname = dict["fname"] as? String ?? ""
        self.lname = dict["lname"] as? String ?? ""
        self.phone = dict["phone"] as? String ?? ""
        self.userState = dict["userState"] as? String ?? ""
        self.username = dict["username"] as? String ?? ""
        self.phoneCode = dict["phoneCode"] as? String ?? ""
        self.avatar = dict["avatar"] as? String ?? ""
        self.createdAt = dict["createdAt"] as? Double ?? 0.0
        self.location = dict["location"] as? NSDictionary ?? NSDictionary.init()
        self.kycAmlInfo = dict["kycAmlInfo"] as? NSDictionary ?? NSDictionary.init()
        self.cdd = dict["cdd"] as? NSDictionary ?? NSDictionary.init()
        self.amlReport = dict["amlReport"] as? NSDictionary
        self.profileReport = dict["profileReport"] as? NSDictionary
        self.company = dict["company"] as? NSDictionary
        self.company_info = dict["company_info"] as? NSDictionary
         self.connectRp = dict["connectRp"] as? NSDictionary
        self.utype = dict["utype"] as? String ?? ""
        self.payment = dict["payments"] as? NSDictionary
        self.pinCode = dict["pinCode"] as? String ?? ""
        self.dict = dict
        if let oneclick = dict.object(forKey: "is_sharing_cdd") as? String
        {
            self.is_sharing_ccd = oneclick == "1" ? true : false
        }
        else{
            self.is_sharing_ccd = dict.object(forKey: "is_sharing_cdd") as? Bool ?? false
        }
        
    }
}

class ActivityObj {
    var dict = NSDictionary.init()
    var dictAmpAsBuyer = NSDictionary.init()
    var typeActivity = ""
    var sentRqs = false
}


class OfficeDirectorObj {
    var firstname = ""
    var lastname = ""
    var birthday = ""
    var birthdayCode = ""
    var country = ""
    var countryCode = ""
    var address = ""
    var current_status = ""
    var end_date = ""
    var id: Int = 0
    var inactive = false
    var nationality = ""
    var occupation = ""
    var opencorporates_url = ""
    var position = ""
    var start_date = ""
    var uid = ""
    var isAPI = true
    var isUBO = false
    var isCallIPA = false
    var isScan = false
    init (_ dict: NSDictionary)
    {
        
        self.address = dict.object(forKey: "address") as? String ?? ""
        self.current_status = dict.object(forKey: "current_status") as? String ?? ""
        self.end_date = dict.object(forKey: "end_date") as? String ?? ""
        self.id = dict.object(forKey: "id") as? Int ?? 0
        self.inactive = dict.object(forKey: "inactive") as? Bool ?? false
        self.nationality = dict.object(forKey: "nationality") as? String ?? ""
        self.occupation = dict.object(forKey: "occupation") as? String ?? ""
        self.opencorporates_url = dict.object(forKey: "opencorporates_url") as? String ?? ""
        self.position = dict.object(forKey: "position") as? String ?? ""
        self.start_date = dict.object(forKey: "start_date") as? String ?? ""
        self.uid = dict.object(forKey: "uid") as? String ?? ""
        let name = dict.object(forKey: "name") as? String ?? ""
        let arrName = name.components(separatedBy: " ")
        if arrName.count > 0 {
            self.lastname = self.removeText(arrName.last!)
        }
        self.firstname = self.removeText(name.replacingOccurrences(of: self.lastname, with: ""))
        self.isAPI = true
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
}


class CreateObj {
    var username = ""
    var refNumber = ""
    var artistName = ""
    var titleWork = ""
    var medium = ""
    var materials = ""
    var dateCreate = ""
    var editorNumber = ""
    var dimesion = ""
    var signature = ""
    var desc = ""
    var picture = UIImage.init()
    var fileUrl: URL?
    var iamgeDoc: UIImage?
    var fOpts = false
    var sOpts = false
    var tOpts = false
    var singatureUser = ""

}


class NotificationObj
{
    var id = ""
    var dict = NSDictionary.init()
    var notifyId = ""
    var notifyCat = 0
    var actType = ""
    var menuId = ""
    init(_ dict: NSDictionary) {
        self.dict = dict
        self.id =  dict.object(forKey: "_id") as? String ?? ""
        self.notifyId =  dict.object(forKey: "notifyId") as? String ?? ""
        if let type = dict.object(forKey: "notifyCat") as? String
        {
            print("type--->", type)
            self.notifyCat =  Int(type)!
        }
        else
        {
            self.notifyCat =  dict.object(forKey: "notifyCat") as? Int ?? 0
        }
         self.actType =  dict.object(forKey: "actType") as? String ?? ""
        self.menuId =  dict.object(forKey: "menuId") as? String ?? ""
    }
}
