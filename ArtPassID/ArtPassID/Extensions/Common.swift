//
//  Common.swift
//  ArtPassID
//
//  Created by QTS Coder on 2/22/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit
import RappleProgressHUD
import SDWebImage
class Common {
    static func showBusy()
    {
        var attribute = RappleActivityIndicatorView.attribute(style: .apple, tintColor: .white, screenBG: .lightGray, progressBG: .black, progressBarBG: .orange, progreeBarFill: .red, thickness: 4)
        attribute[RappleIndicatorStyleKey] = RappleStyleCircle
        RappleActivityIndicatorView.startAnimatingWithLabel("", attributes: attribute)
        
    }
    
    static func hideBusy()
    {
        RappleActivityIndicatorView.stopAnimation()
    }
    
    static func hexStringToUIColor(_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    static func convertBase64ToImage(_ strBase64: String) -> UIImage?
    {
        var removeAvatar = strBase64.replacingOccurrences(of: "data:image/png;base64,", with: "")
       removeAvatar = removeAvatar.replacingOccurrences(of: "data:image/jpeg;base64,", with: "")
       if let  dataDecoded : Data = Data(base64Encoded: removeAvatar, options: .ignoreUnknownCharacters)
       {
           let decodedimage = UIImage(data: dataDecoded)
           return decodedimage
       }
       return nil
       
    }
    
    static func loadAvatarFromServer(_ avatar: String, _ imageView: UIImageView)
    {
    
        var url = URL_AVARTA + "/" + avatar
        url = url.replacingOccurrences(of: " ", with: "%20")
        //let escapedString = url.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
        print(url)
        imageView.contentMode = .scaleAspectFill
        imageView.sd_setImage(with: URL.init(string: url)) { (image, error, type, url) in
            print(error)
            print(image)
            if image == nil{
                imageView.image = nil
            }
       }
    }
    static func listAllIos3(_ countryCode: String) -> String
    {
        if let path = Bundle.main.path(forResource: "iso3", ofType: "json") {
            do {
                  let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                  let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                  if let jsonResult = jsonResult as? Dictionary<String, AnyObject> {
                       
                    if let ios3 = jsonResult[countryCode.uppercased()] as? String
                    {
                        print("ios3ULT --->", ios3)
                        return ios3
                    }
                  }
              } catch {
                   // handle error
              }
        }
        return countryCode
    }
    
    static func savetransacId(_ transacId: String)
    {
        var arrs = listTransacId()
        arrs.append(transacId)
        UserDefaults.standard.setValue(arrs, forKey: arrtransacId)
        UserDefaults.standard.synchronize()
    }
    
    static func checkExitTransacId(_ transacId: String)-> Bool
    {
        let arrs = listTransacId()
        if arrs.contains(transacId) {
            return true
        }
        return false
    }
    
    static func listTransacId()-> [String]
    {
        return UserDefaults.standard.value(forKey: arrtransacId) as? [String] ?? [String]()
    }
    
    static func allJurisdictions()-> [NSDictionary]
    {
        var arrs = [NSDictionary]()
        var dict = ["code":"ae_az",  "name": "Abu Dhabi (UAE)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_al",  "name": "Alabama (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_ak",  "name": "Alaska (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"al",  "name": "Albania"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_az",  "name": "Arizona (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_ar",  "name": "Arkansas (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"aw",  "name": "Aruba"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"au",  "name": "Australia"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"bs",  "name": "Bahamas"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"bh",  "name": "Bahrain"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"bd",  "name": "Bangladesh"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"bb",  "name": "Barbados"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"by",  "name": "Belarus"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"be",  "name": "Belgium"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"bz",  "name": "Belize"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"bm",  "name": "Bermuda"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"bo",  "name": "Bolivia"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"br",  "name": "Brazil"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"bg",  "name": "Bulgaria"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_ca",  "name": "California (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"kh",  "name": "Cambodia"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"ca",  "name": "Canada"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_co",  "name": "Colorado (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_ct",  "name": "Connecticut (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"hr",  "name": "Croatia"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"cw",  "name": "Curaçao"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"cy",  "name": "Cyprus"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_de",  "name": "Delaware (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"dk",  "name": "Denmark"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_dc",  "name": "District of Columbia (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"do",  "name": "Dominican Republic"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"ae_du",  "name": "Dubai (UAE)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"fi",  "name": "Finland"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_fl",  "name": "Florida (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"fr",  "name": "France"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"gf",  "name": "French Guiana"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_ga",  "name": "Georgia (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"de",  "name": "Germany"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"gi",  "name": "Gibraltar"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"gr",  "name": "Greece"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"gl",  "name": "Greenland"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"gp",  "name": "Guadeloupe"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"gg",  "name": "Guernsey"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_hi",  "name": "Hawaii (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"hk",  "name": "Hong Kong"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"is",  "name": "Iceland"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_id",  "name": "Idaho (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"in",  "name": "India"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_in",  "name": "Indiana (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_ia",  "name": "Iowa (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"ir",  "name": "Iran"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"ie",  "name": "Ireland"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"im",  "name": "Isle of Man"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"il",  "name": "Israel"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"jm",  "name": "Jamaica"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"jp",  "name": "Japan"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"je",  "name": "Jersey"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_ks",  "name": "Kansas (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_ky",  "name": "Kentucky (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"lv",  "name": "Latvia"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"li",  "name": "Liechtenstein"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_la",  "name": "Louisiana (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"lu",  "name": "Luxembourg"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_me",  "name": "Maine (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"my",  "name": "Malaysia"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"mt",  "name": "Malta"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"mq",  "name": "Martinique"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_md",  "name": "Maryland (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_ma",  "name": "Massachusetts (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"mu",  "name": "Mauritius"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"yt",  "name": "Mayotte"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"mx",  "name": "Mexico"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_mi",  "name": "Michigan (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_mn",  "name": "Minnesota (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_ms",  "name": "Mississippi (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_mo",  "name": "Missouri (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"md",  "name": "Moldova"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_mt",  "name": "Montana (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"me",  "name": "Montenegro"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"mm",  "name": "Myanmar"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_ne",  "name": "Nebraska (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"nl",  "name": "Netherlands"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_nv",  "name": "Nevada (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"ca_nb",  "name": "New Brunswick (Canada)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_nh",  "name": "New Hampshire (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_nj",  "name": "New Jersey (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_nm",  "name": "New Mexico (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_ny",  "name": "New York (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"nz",  "name": "New Zealand"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"ca_nl",  "name": "Newfoundland and Labrador (Ca..."]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_nc",  "name": "North Carolina (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_nd",  "name": "North Dakota (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"no",  "name": "Norway"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"ca_ns",  "name": "Nova Scotia (Canada)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_oh",  "name": "Ohio (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_ok",  "name": "Oklahoma (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_or",  "name": "Oregon (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"pk",  "name": "Pakistan"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"pa",  "name": "Panama"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_pa",  "name": "Pennsylvania (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"pl",  "name": "Poland"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"ca_pe",  "name": "Prince Edward Island (Canada)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"pr",  "name": "Puerto Rico"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"ca_qc",  "name": "Quebec (Canada)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_ri",  "name": "Rhode Island (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"ro",  "name": "Romania"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"rw",  "name": "Rwanda"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"re",  "name": "Réunion"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"bl",  "name": "Saint Barthélemy"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"mf",  "name": "Saint Martin (French part)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"pm",  "name": "Saint Pierre and Miquelon"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"sg",  "name": "Singapore"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"sk",  "name": "Slovakia"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"si",  "name": "Slovenia"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"za",  "name": "South Africa"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_sc",  "name": "South Carolina (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_sd",  "name": "South Dakota (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"es",  "name": "Spain"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"se",  "name": "Sweden"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"ch",  "name": "Switzerland"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"tj",  "name": "Tajikistan"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"tz",  "name": "Tanzania"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_tn",  "name": "Tennessee (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_tx",  "name": "Texas (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"th",  "name": "Thailand"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"to",  "name": "Tonga"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"tn",  "name": "Tunisia"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"ug",  "name": "Uganda"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"ua",  "name": "Ukraine"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"gb",  "name": "United Kingdom"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_ut",  "name": "Utah (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"vu",  "name": "Vanuatu"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_vt",  "name": "Vermont (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"vn",  "name": "Viet Nam"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_va",  "name": "Virginia (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_wa",  "name": "Washington (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_wv",  "name": "West Virginia (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_wi",  "name": "Wisconsin (US)"]
        arrs.append(dict as NSDictionary)
        dict = ["code":"us_wy",  "name": "Wyoming (US)"]
        arrs.append(dict as NSDictionary)
        return arrs
    }
}
extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
    var isValidURL: Bool {
              let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
              if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
                  // it is a link, if the match covers the whole string
                  return match.range.length == self.utf16.count
              } else {
                  return false
              }
          }
}

