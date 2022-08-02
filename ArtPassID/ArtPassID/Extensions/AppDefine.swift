//
//  AppDefine.swift
//  ArtPassID
//
//  Created by QTS Coder on 4/19/19.
//  Copyright © 2019 QTS Coder. All rights reserved.
//

import UIKit
import SwiftyStoreKit
let APP_NAME = "artpass PRO"
let APP_DELEGATE = UIApplication.shared.delegate as! AppDelegate
let KACUANT = "kacuant"
let kImageFront = "kImageFront"
let kImageBack = "kImageBack"
let kImageFace = "kImageFace"
let kImageSign = "kImageSign"
let kPhoneLogin = "kPhoneLogin"
let kPasswordLogin = "kPasswordLogin"
let kPhoneCode = "kPhoneCode"
let kToken = "kToken"
let TIME_OUT = 5.0
let URL_TERMS = "https://artpass.id/terms/"
let URL_OPEN_REGISTER = "https://onboarding.artpass.id/"
let arrtransacId  = "transacId"
//let INAPP_PURCHASE = "com.artpassid.annual"
let INAPP_PURCHASE = "com.artpassid.annual.address"

let KEY_INAPP_PRO = "key_pro"
let SHARED_SCRETKEY = "98c5f840ac22417dbc59156668028f16"
let KEY_NOTIFICATION_SETTING = "KEY_NOTIFICATION_SETTING"
let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: SHARED_SCRETKEY)

class DeviceType {
    static func getStoryboard() -> UIStoryboard
    {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return UIStoryboard.init(name: "Main", bundle: nil)
        }
        else{
             return UIStoryboard.init(name: "Main", bundle: nil)
        }
    }
}


struct MSG_ERROR {
    static let ERROR_EMAIL = "Email is required"
    static let ERROR_EMAIL_INVALID = "Email invalid"
    static let ERROR_PHONE = "Phone Number is required"
    static let ERROR_CODE = "Verification code is required"
    static let ERROR_STREET_ADDRESS = "Street address is required"
    static let ERROR_CITY = "City is required"
    static let ERROR_ZIPCODE = "Zipcode is required"
    static let ERROR_STATE = "State/Province/Region is required"
    static let ERROR_COUNTRY = "Country is required"
    static let ERROR_USERNAME = "Username is required"
    static let ERROR_CHECK_LOGIN = "You must agree to our Terms of Service and Privacy Policy"
    static let ERROR_PASSWORD = "Pincode is required"
    static let ERROR_FNAME = "Legal first name is required"
    static let ERROR_LNAME =  "Legal last name is required"
    static let ERROR_BUYER_USERNAME = "Buyer's user name is required"
    static let ERROR_REFERENCE = "Reference number is required"
    static let ERROR_DESCRIPTION = "Description is required"
    static let ERROR_MESSGAES = "Message to the buyer is required"
    static let ERROR_PICTURE  = "Please select a picture of the object"
    static let ERROR_DOCUMENT  = "Please upload document file"
    static let ERROR_LOGIN_CODE  = "Login code is required"
    static let ERROR_BUSINESS_NAME = "Business name is required"
    static let ERROR_BUSINESS_NUMBER = "Business registration number is required"
    static let ERROR_BIRTHDAY = "Date of birtday is required"
    static let ERROR_NATIONALITY = "Nationality is required"
    static let ERROR_SERVER = "Server error"
    static let ERROR_LOGO = "Please upload your logo"
}


struct COLOR_REPORT {
    static let COLOR_XANH = "34cd8d"
    static let COLOR_TIM = "b00058"
    static let COLOR_XAM = "404040"
}

struct STATUS_ACTIVITY {
    static let PENDING = "pending:seller"
    static let ACCEPT_BUYER = "accepted:buyer"
    static let ACCEPT_SELLER = "accepted:seller"
    static let PEDDING = "pending:seller"
    static let ARCHIVED = "archived:seller"
}


struct UTYPE_USER {
    static let ARTIST = "ARTIST"
    static let PATRON = "PATRON"
    static let BUSINESS = "BUSINESS"
    static let NONPROFIT = "NONPROFIT"
}

struct TAG_ARRAY
{
    static let ampAsBuyer = "ampAsBuyer"
    static let ampAsAmp = "ampAsAmp"
    static let ampAsSeller = "ampAsSeller"
    static let transacAsBuyer = "transacAsBuyer"
    static let transacAsSeller = "transacAsSeller"
}


struct STATUS_AMPASBUYER {
    static let AMPASBUYER_20 = "not_reply_yet"
    static let AMPASBUYER_40 = "declared:buyer"
    static let AMPASBUYER_60 = "approved:ampuser"
}

struct STATUS_AMPASSELLER {
    static let AMPASSELLER_20 = "init:amper:20"
    static let AMPASSELLER_40 = "declaring:seller:40"
    static let AMPASSELLER_60 = "reviewing_seller:amper:60"
    static let AMPASSELLER_BUYER_20 = "adding_buyer:amper:20"
}
struct STATUS_AMPASAMP {
    static let AMPASAMP_20 = "init:amper:20"
    static let AMPASAMP_40 = "declaring:seller:40"
    static let AMPASAMP_60 = "reviewing_seller:amper:60"
    static let AMPASAMP_BUYER_20 = "adding_buyer:amper:20"
    static let AMPASAMP_DECLARING_BUYER_40 = "declaring:buyer:40"
    static let AMPASAMP_BUYER_60 = "reviewing_buyer:amper:60"
}


