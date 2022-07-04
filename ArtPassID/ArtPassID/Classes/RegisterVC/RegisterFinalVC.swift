//
//  RegisterFinalVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 2/14/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit
import Alamofire
import SafariServices
import SwiftyJSON
class RegisterFinalVC: UIViewController {
    @IBOutlet weak var btnTick: UIButton!
    var isTick = false
    @IBOutlet weak var txfUserName: UITextField!
    @IBOutlet weak var txfNumber1: UITextField!
    @IBOutlet weak var txfNumber2: UITextField!
    @IBOutlet weak var txfNumber3: UITextField!
    @IBOutlet weak var txfNumber4: UITextField!
    @IBOutlet weak var txfNumber5: UITextField!
    @IBOutlet weak var txfNumber6: UITextField!
    var base64Face = ""
    var base64Avatar = ""
    @IBOutlet weak var imgAvatar: UIImageView!
    var imagePicker: UIImagePickerController!
    @IBOutlet weak var viewErrror: UIView!
    @IBOutlet weak var viewSuccess: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var lblUploadYourLogo: UILabel!
    @IBOutlet weak var btnEditAvatar: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        if APP_DELEGATE.acuantObj.faceImageUrl != nil {
//            self.downloadedFrom(urlStr: APP_DELEGATE.acuantObj.faceImageUrl!, username: APP_DELEGATE.acuantObj.username!, password: APP_DELEGATE.acuantObj.password!)
//        }
         self.indicator.startAnimating()
        if APP_DELEGATE.userObj.utype != UTYPE_USER.BUSINESS {
            self.lblUploadYourLogo.isHidden = true
        }
        else{
            self.lblUploadYourLogo.isHidden = false
             self.indicator.isHidden = true
            self.btnEditAvatar.setTitle("Upload Logo", for: .normal)
        }
        
        if let data = UserDefaults.standard.value(forKey: kImageFace) as? Data
       {
           self.indicator.isHidden = true
           
            if APP_DELEGATE.userObj.utype != UTYPE_USER.BUSINESS {
                DispatchQueue.main.async() { () -> Void in
                    self.imgAvatar.image = UIImage.init(data: data)
                    self.base64Face = "data:image/png;base64," + data.base64EncodedString()
                    self.base64Avatar = self.base64Face
                }
               
            }
            else{
                DispatchQueue.main.async() { () -> Void in
                   self.base64Face = "data:image/png;base64," + data.base64EncodedString()
               }
            }
       }
       else{
            if(APP_DELEGATE.acuantObj.faceImageUrl != nil){
            self.downloadedFromSaveImage(urlStr: APP_DELEGATE.acuantObj.faceImageUrl!, username: APP_DELEGATE.acuantObj.username!, password: APP_DELEGATE.acuantObj.password!, index: 0)
            }
       }
       
        if(APP_DELEGATE.acuantObj.frontImageUrl != nil){
            self.downloadedFromSaveImage(urlStr: APP_DELEGATE.acuantObj.frontImageUrl!, username: APP_DELEGATE.acuantObj.username!, password: APP_DELEGATE.acuantObj.password!, index: 1)
        }
        if(APP_DELEGATE.acuantObj.backImageUrl != nil){
            self.downloadedFromSaveImage(urlStr: APP_DELEGATE.acuantObj.backImageUrl!, username: APP_DELEGATE.acuantObj.username!, password: APP_DELEGATE.acuantObj.password!, index: 2)
        }
        if(APP_DELEGATE.acuantObj.signImageUrl != nil){
            self.downloadedFromSaveImage(urlStr: APP_DELEGATE.acuantObj.signImageUrl!, username: APP_DELEGATE.acuantObj.username!, password: APP_DELEGATE.acuantObj.password!, index: 3)
        }
        
        self.imgAvatar.layer.cornerRadius = self.imgAvatar.frame.size.width/2
        self.imgAvatar.layer.masksToBounds = true
        viewSuccess.isHidden = true
        viewErrror.isHidden = true
        print(self.paramListUbos())
    }
    
    func parawmCmpany()-> [String: Any]
    {
        var paramCompany = [String: Any]()
       paramCompany["name"] = APP_DELEGATE.userObj.company.object(forKey: "name") as? String ?? ""
       paramCompany["number"] = APP_DELEGATE.userObj.company.object(forKey: "company_number") as? String ?? ""
       paramCompany["jurisdiction_code"] = APP_DELEGATE.userObj.company.object(forKey: "jurisdiction_code") as? String ?? ""
        paramCompany["current_status"] = APP_DELEGATE.userObj.company.object(forKey: "current_status") as? String ?? ""
                   paramCompany["company_type"] = APP_DELEGATE.userObj.company.object(forKey: "company_type") as? String ?? ""
                   paramCompany["incorporation_date"] = APP_DELEGATE.userObj.company.object(forKey: "incorporation_date") as? String ?? ""
       if let registered_address = APP_DELEGATE.userObj.company.object(forKey: "registered_address") as? NSDictionary
       {
               paramCompany["street_addr"] = registered_address.object(forKey: "street_address") as? String
               paramCompany["country"] = registered_address.object(forKey: "country") as? String
       }
       if APP_DELEGATE.userObj.tOpts {
           paramCompany["roles"] = ["tOpts"]
       }
       else{
           if APP_DELEGATE.userObj.fOpts && APP_DELEGATE.userObj.sOpts
           {
               paramCompany["roles"] = ["fOpts", "sOpts"]
           }
           else{
               if APP_DELEGATE.userObj.fOpts
               {
                   paramCompany["roles"] = ["fOpts"]
               }
               else{
                   paramCompany["roles"] = ["sOpts"]
               }
           }
       }
        paramCompany["listOffs"] = JSON.init(self.paramListOffs()).arrayValue
        paramCompany["listUBOs"] = JSON.init(self.paramListUbos()).arrayValue
        return paramCompany
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func doTick(_ sender: Any) {
      isTick = !isTick
      if isTick {
          btnTick.setImage(UIImage.init(named: "ic_checked"), for: .normal)
      }
      else{
          btnTick.setImage(UIImage.init(named: "ic_check"), for: .normal)
      }
   }
    @IBAction func doCreate(_ sender: Any) {
        if self.txfUserName.text!.trim().isEmpty {
            APP_DELEGATE.showAlert(MSG_ERROR.ERROR_USERNAME)
            return
        }
        if self.txfNumber1.text!.isEmpty || self.txfNumber2.text!.isEmpty || self.txfNumber3.text!.isEmpty || self.txfNumber4.text!.isEmpty || self.txfNumber5.text!.isEmpty || self.txfNumber6.text!.isEmpty{
            APP_DELEGATE.showAlert(MSG_ERROR.ERROR_PASSWORD)
            return
        }
        if APP_DELEGATE.userObj.utype == UTYPE_USER.BUSINESS {
            if self.imgAvatar.image == nil {
                APP_DELEGATE.showAlert(MSG_ERROR.ERROR_LOGO)
                return
            }
        }
        
        if !self.isTick {
            APP_DELEGATE.showAlert(MSG_ERROR.ERROR_CHECK_LOGIN)
            return
        }
        
        self.view.endEditing(true)
        ApiHelper.shared.checkUser(param: ["username":txfUserName.text!.trim()]) { (success, error) in
            if let mess = error
            {
                if mess == "true" {
                    Common.showBusy()
                    ApiHelper.shared.registerUser(self.paramWS()) { (success, error) in
                        Common.hideBusy()
                        if success
                        {
                            let phoneRe = APP_DELEGATE.userObj.phoneNumber
//                           let first  = String(phoneRe.prefix(1))
//                           if first == "0" {
//                               phoneRe = phoneRe.substring(from: 1)
//                           }
                             let param = ["phoneNum": phoneRe, "pincode": self.joinPassword(), "phoneCode": APP_DELEGATE.userObj.phoneCode.replacingOccurrences(of: "+", with: "")]
                            ApiHelper.shared.loginUser(param) { (success, error) in
                                Common.hideBusy()
                                if success
                                {
                                    self.viewSuccess.isHidden = false
                                    self.perform(#selector(self.redirectTabbar), with: nil, afterDelay: TIME_OUT)
                                }
                                else{
                                    if error != nil {
                                        APP_DELEGATE.showAlert(error!.msg!)
                                    }
                                }
                            }
                        }
                        else{
                            Common.hideBusy()
                            if error != nil {
                                APP_DELEGATE.showAlert(error!.msg!)
                            }
                        }
                    }
                }
                else{
                    self.viewErrror.isHidden = false
                    // APP_DELEGATE.showAlert(mess)
                }
            }
        }
        
        
    }
    
    @objc func redirectTabbar()
    {
       let item = NSKeyedArchiver.archivedData(withRootObject: APP_DELEGATE.acuantObj)
       UserDefaults.standard.set(item, forKey: KACUANT)
       self.view.endEditing(true)
       let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
       self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func doChangeAvatar(_ sender: Any) {
        self.showPhotoAndLibrary()
    }
    
    func showCamera()
       {
           if UIImagePickerController.isSourceTypeAvailable(.camera) {
               imagePicker =  UIImagePickerController()
               imagePicker.delegate = self
               imagePicker.sourceType = .camera
               imagePicker.allowsEditing = true
               present(imagePicker, animated: true, completion: nil)
           }
           
       }
       
       func showLibrary()
       {
           if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
               imagePicker =  UIImagePickerController()
               imagePicker.delegate = self
               imagePicker.sourceType = .photoLibrary
               imagePicker.allowsEditing = true
               present(imagePicker, animated: true, completion: nil)
           }
       }
       
       func showPhotoAndLibrary()
       {
           let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
           let camera = UIAlertAction.init(title: "Take a photo", style: .default) { (action) in
               self.showCamera()
           }
           alert.addAction(camera)
           
           let library = UIAlertAction.init(title: "Choose from library", style: .default) { (action) in
               self.showLibrary()
           }
           alert.addAction(library)
           
           let cancel = UIAlertAction.init(title: "Cancel", style: .cancel) { (action) in
               
           }
           alert.addAction(cancel)
           self.present(alert, animated: true) {
               
           }
       }
    @IBAction func doReturnError(_ sender: Any) {
        self.viewErrror.isHidden = true
    }
    @IBAction func doTerm(_ sender: Any) {
        let vc = SFSafariViewController.init(url: URL.init(string: URL_TERMS)!)
        self.present(vc, animated: true) {
            
        }
    }
}
extension RegisterFinalVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true) {
            
        }
    }
    
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)

        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {
            self.lblUploadYourLogo.isHidden = true
            self.imgAvatar.image = image
            let data = image.jpegData(compressionQuality: 0.8)
            self.base64Avatar = "data:image/png;base64," + data!.base64EncodedString()
            
            if self.base64Face.isEmpty {
                self.base64Face = self.base64Avatar
            }
        }
    }
}

extension RegisterFinalVC
{
    //765380215
    func paramWS()-> [String:Any]
    {
        let phoneRe = APP_DELEGATE.userObj.phoneNumber
//        let first  = String(phoneRe.prefix(1))
//        if first == "0" {
//            phoneRe = phoneRe.substring(from: 1)
//        }0765380215
        var param = [String: Any]()
        param["email"] = APP_DELEGATE.userObj.email
        param["pincode"] = self.joinPassword()
        param["password"] = self.joinPassword()
        param["phone"] = phoneRe
        param["phoneCode"] = APP_DELEGATE.userObj.phoneCode.replacingOccurrences(of: "+", with: "")
        param["verify_time_phone"] =  Int(Date().timeIntervalSince1970)
        param["username"] =  txfUserName.text!.trim().lowercased()
        param["street_name"] =  APP_DELEGATE.userObj.street_address
        param["street_number"] = " "
        param["country_name"] = APP_DELEGATE.userObj.country
        param["country_code"] = Common.listAllIos3(APP_DELEGATE.userObj.countryCode)
        param["zipcode"] =  APP_DELEGATE.userObj.zipcode
        param["city"] =  APP_DELEGATE.userObj.city
        param["userState"] =  APP_DELEGATE.userObj.state
        param["utype"] =  APP_DELEGATE.userObj.utype
        param["onlineProfile"] = " "
        param["doc_img"] = self.base64Face
        param["avatar"] = self.base64Avatar
        param["doc_name"] = self.showValueByKey("Full Name").replacingOccurrences(of: "\'", with: "")
        param["doc_given_name"] = self.showValueByKey("Given Name").replacingOccurrences(of: "\'", with: "")
        param["doc_surname"] = self.showValueByKey("Surname").replacingOccurrences(of: "\'", with: "")
        param["doc_addr"] = self.showValueByKeyAddress().replacingOccurrences(of: "\'", with: "")
        param["doc_state_code"] = self.showValueByKey("Issuing State Code").replacingOccurrences(of: "\'", with: "")
        param["birth_date"] = self.formatStringBirthday(self.showValueByKey("Birth Date")).replacingOccurrences(of: "\'", with: "")
        param["doc_state_name"] = self.showValueByKey("Issuing State Name").replacingOccurrences(of: "\'", with: "")
        param["doc_number"] = self.showValueByKey("Document Number").replacingOccurrences(of: "\'", with: "")
        param["doc_sex"] = self.showValueByKey("Sex")
        param["doc_auth"] = self.showValueByKey("Authentication Result").replacingOccurrences(of: "\'", with: "")
        param["fname"] = APP_DELEGATE.userObj.fname
        param["lname"] = APP_DELEGATE.userObj.lname
        if APP_DELEGATE.userObj.utype == UTYPE_USER.BUSINESS {
           var paramCompany = [String: Any]()
            paramCompany["name"] = APP_DELEGATE.userObj.company.object(forKey: "name") as? String ?? ""
            paramCompany["number"] = APP_DELEGATE.userObj.company.object(forKey: "company_number") as? String ?? ""
            paramCompany["jurisdiction_code"] = APP_DELEGATE.userObj.company.object(forKey: "jurisdiction_code") as? String ?? ""
            paramCompany["current_status"] = APP_DELEGATE.userObj.company.object(forKey: "current_status") as? String ?? ""
            paramCompany["company_type"] = APP_DELEGATE.userObj.company.object(forKey: "company_type") as? String ?? ""
            paramCompany["incorporation_date"] = APP_DELEGATE.userObj.company.object(forKey: "incorporation_date") as? String ?? ""
            if let registered_address = APP_DELEGATE.userObj.company.object(forKey: "registered_address") as? NSDictionary
            {
                    paramCompany["street_addr"] = registered_address.object(forKey: "street_address") as? String
                    paramCompany["country"] = registered_address.object(forKey: "country") as? String
            }
            var arrRoles = [String]()
            if APP_DELEGATE.userObj.fOpts {
                arrRoles.append("fOpts")
            }
            if APP_DELEGATE.userObj.sOpts {
                arrRoles.append("sOpts")
            }
            if APP_DELEGATE.userObj.tOpts {
                arrRoles.append("tOpts")
            }
            paramCompany["roles"] = arrRoles
            paramCompany["listOffs"] = self.paramListOffs()
            if APP_DELEGATE.userObj.arrUbos.count == 0 {
                paramCompany["listUBOs"] = []
            }
            else{
                paramCompany["listUBOs"] = self.paramListUbos()
            }
            paramCompany["isDirector"] = "true"
            paramCompany["esign"] = APP_DELEGATE.userObj.signature
            param["company_info"] = paramCompany
            //param["isDirector"] = APP_DELEGATE.userObj.isDirector
        }
         
        return param
    }
    
    func paramListOffs() -> [NSDictionary]
    {
        var jsonDataObject = [NSDictionary]()
        for item in APP_DELEGATE.userObj.arrOffices
        {
             let param1 = NSMutableDictionary.init()
             if item.isAPI {
                let name = item.firstname + " " + item.lastname
                param1["name"] = name.trim()
                param1["date_of_birth"] = item.birthdayCode
                param1["country"] = ["name": item.country, "iso2code": item.countryCode]
                
                param1["address"] =  item.address
                param1["current_status"] =  item.current_status
                param1["end_date"] =  item.end_date
                param1["id"] =  item.id
                param1["inactive"] =  item.inactive
                param1["nationality"] =  item.nationality
                param1["occupation"] =  item.occupation
                param1["opencorporates_url"] =  item.opencorporates_url
                param1["start_date"] =  item.start_date
                param1["occupation"] =  item.occupation
                param1["uid"] =  item.uid
                param1["isAlsoUBO"] = item.isUBO
                if item.isScan {
                    param1["inactive"] = true
                }
                else{
                    param1["inactive"] = false
                }
            }
            else{
                let name = item.firstname + " " + item.lastname
                param1["name"] = name.trim()
                param1["date_of_birth"] = item.birthdayCode
                param1["country"] = ["name": item.country, "iso2code": item.countryCode]
                param1["inactive"] = true
                param1["position"] = "director"
                param1["isAlsoUBO"] = item.isUBO
                if item.isScan {
                    param1["inactive"] = true
                }
                else{
                    param1["inactive"] = false
                }
            }
           let dictParam = ["officer": param1]
//            do {
//                let jsonData = try JSONSerialization.data(withJSONObject: dictParam)
//                if let json = String(data: jsonData, encoding: .utf8) {
//                    print(json)
//
//                }
//            } catch {
//                print("something went wrong with parsing json")
//            }
            jsonDataObject.append(dictParam as NSDictionary)
        }
        
        return jsonDataObject
    }
    func paramListUbos() -> [NSDictionary]
    {
        var jsonDataObject = [NSDictionary]()
        for item in APP_DELEGATE.userObj.arrUbos
        {
            if !item.isCallIPA {
                let param1 = NSMutableDictionary.init()
                if item.isAPI {
                    let name = item.firstname + " " + item.lastname
                    param1["name"] = name.trim()
                    param1["date_of_birth"] = item.birthdayCode
                    param1["country"] = ["name": item.country, "iso2code": item.countryCode]
                    param1["opencorporates_url"] =  item.opencorporates_url
                }
                else{
                   let name = item.firstname + " " + item.lastname
                   param1["name"] = name.trim()
                   param1["date_of_birth"] = item.birthdayCode
                   param1["country"] = ["name": item.country, "iso2code": item.countryCode]
                }
                let dictParam = ["ultimate_beneficial_owner": param1]
//               do {
//                   let jsonData = try JSONSerialization.data(withJSONObject: dictParam)
//                   if let json = String(data: jsonData, encoding: .utf8) {
//                       print(json)
//                       jsonDataObject.append(json)
//                   }
//               } catch {
//                   print("something went wrong with parsing json")
//               }
                jsonDataObject.append(dictParam as NSDictionary)
            }
            
        }
        
        return jsonDataObject
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
    func showValueByKeyAddress() -> String
    {
        let isCheck = false
        if let arrs = APP_DELEGATE.acuantObj.data
        {
            for item in arrs {
                if item.contains("Birth Place") {
                    let arrFirstName = item.components(separatedBy: ":")
                    if arrFirstName.count  > 1 {
                        return arrFirstName[1]
                    }
                }
            }
        }
        if !isCheck {
            if let arrs = APP_DELEGATE.acuantObj.data
            {
                for item in arrs {
                    if item.contains("Address") {
                        let arrFirstName = item.components(separatedBy: ":")
                        if arrFirstName.count  > 1 {
                            return arrFirstName[1]
                        }
                    }
                }
            }
        }
        return " "
    }
    func joinPassword()-> String
    {
        return "\(txfNumber1.text!.trim())" + "\(txfNumber2.text!.trim())" + "\(txfNumber3.text!.trim())" + "\(txfNumber4.text!.trim())" + "\(txfNumber5.text!.trim())" + "\(txfNumber6.text!.trim())"
    }
    
//    func downloadedFrom(urlStr:String,username:String,password:String) {
//        let loginData = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
//        let base64LoginData = loginData.base64EncodedString()
//        print(loginData)
//        // create the request
//        let url = URL(string: urlStr)!
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.setValue("Basic \(base64LoginData)", forHTTPHeaderField: "Authorization")
//
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//            print(error)
//            print(response)
//            let httpURLResponse = response as? HTTPURLResponse
//            if(httpURLResponse?.statusCode == 200){
//                UserDefaults.standard.setValue(data!, forKey: kImageFace)
//                UserDefaults.standard.synchronize()
//                DispatchQueue.main.async() { () -> Void in
//                    self.base64Face = "data:image/png;base64," + data!.base64EncodedString()
//                    self.base64Avatar = self.base64Face
//                    self.imgAvatar.image = UIImage.init(data: data!)
//                }
//            }else {
//                return
//            }
//            }.resume()
//    }
    
    func downloadedFromSaveImage(urlStr:String,username:String,password:String, index: Int) {
           let loginData = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
           let base64LoginData = loginData.base64EncodedString()
           print(loginData)
           // create the request
           let url = URL(string: urlStr)!
           var request = URLRequest(url: url)
           request.httpMethod = "GET"
           request.setValue("Basic \(base64LoginData)", forHTTPHeaderField: "Authorization")
           
           URLSession.shared.dataTask(with: request) { (data, response, error) in
               let httpURLResponse = response as? HTTPURLResponse
               if(httpURLResponse?.statusCode == 200){
                    
                   if index == 0
                   {
                        DispatchQueue.main.async() { () -> Void in
                            self.indicator.isHidden = true
                            if APP_DELEGATE.userObj.utype != UTYPE_USER.BUSINESS {
                                self.base64Face = "data:image/png;base64," + data!.base64EncodedString()
                                self.base64Avatar = self.base64Face
                                self.imgAvatar.image = UIImage.init(data: data!)
                            }
                            else{
                                self.base64Face = "data:image/png;base64," + data!.base64EncodedString()
                            }
                            UserDefaults.standard.setValue(data!, forKey: kImageFace)
                        }
                        
                   }
                   else if index == 1
                   {
                       UserDefaults.standard.setValue(data!, forKey: kImageFront)
                   }
                   else if index == 2
                   {
                       UserDefaults.standard.setValue(data!, forKey: kImageBack)
                   }
                   else{
                       UserDefaults.standard.setValue(data!, forKey: kImageSign)
                   }
                   UserDefaults.standard.synchronize()
                   
               }else {
                    DispatchQueue.main.async() { () -> Void in
                        self.indicator.isHidden = true
                    }
                    
                   return
               }
               }.resume()
       }
    
}
extension RegisterFinalVC: UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                           replacementString string: String) -> Bool
    {
        if textField == txfUserName {
            return true
        }
        else{
            
            if textField.text!.count < 1  && string.count > 0{
                textField.text = string
                if textField == txfNumber1
                {
                    txfNumber2.becomeFirstResponder()
                }
                else if textField == txfNumber2
                {
                   txfNumber3.becomeFirstResponder()
                }else if textField == txfNumber3
                {
                   txfNumber4.becomeFirstResponder()
                }else if textField == txfNumber4
                {
                   txfNumber5.becomeFirstResponder()
                }else if textField == txfNumber5
                {
                   txfNumber6.becomeFirstResponder()
                }
                else{
                   // self.view.endEditing(true)
                }
                return false
            }
            else if textField.text!.count >= 1  && string.count == 0{
                textField.text = ""
                if textField == txfNumber6
                {
                    txfNumber5.becomeFirstResponder()
                }
                else if textField == txfNumber5
                {
                   txfNumber4.becomeFirstResponder()
                }else if textField == txfNumber4
                {
                   txfNumber3.becomeFirstResponder()
                }else if textField == txfNumber3
                {
                   txfNumber2.becomeFirstResponder()
                }else if textField == txfNumber2
                {
                   txfNumber1.becomeFirstResponder()
                }
                return false
            }
            return true
        }
       
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txfUserName {
        }
        else{
          textField.text = ""
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txfUserName {
            txfNumber1.becomeFirstResponder()
        }
        return true
    }
}
