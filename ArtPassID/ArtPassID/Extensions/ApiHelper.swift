//
//  ApiHelper.swift
//  WOC
//
//  Created by QTS Coder on 12/23/19.
//  Copyright © 2019 QTS Coder. All rights reserved.
//

import UIKit
import Alamofire
class ApiHelper {
    static let shared = ApiHelper()
    private let headerNoAuth: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded"]
    private var manager: Alamofire.SessionManager
    private init() {
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            URL_AVARTA: .disableEvaluation
        ]
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        
        manager = Alamofire.SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
    }
    
    func registerUser(_ para: Parameters, complete:@escaping (_ success: Bool, _ errer: ErrorModel?) ->Void)
    {
            print("PARAM -->",para)
            print("URL -->",URL_REGISTER)
        
        
          let url = URL(string: URL_REGISTER)
           var request = URLRequest(url: url!)
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           request.httpMethod = "POST"
           request.httpBody = try! JSONSerialization.data(withJSONObject: para, options: [])

             Alamofire.request(request).responseJSON { (response) in
              print(response)
                  Common.hideBusy()
                 switch response.result {
                 case .success:
                    if let val = response.value as? NSDictionary
                    {
                        print(val)
                       if let error_text = val.object(forKey: "error") as? NSDictionary {
                         complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""))
                        }
                        else{
                            complete(true ,nil)
                        }
                    }
                     break
                 case .failure(let error):
                     Common.hideBusy()
                     print(response)
                     complete(false, ErrorManager.processError(error: error))
                     break
                 }
             }
    }
    
    func phoneCheck(_ para: Parameters, complete:@escaping (_ success: Bool, _ request_id: String?, _ errer: ErrorModel?) ->Void)
    {
           print(para)
            print("PARAM -->",para)
            print("URL -->",URL_PHONE_CHECK)
           Common.showBusy()
           manager.request(URL.init(string: URL_PHONE_CHECK)!, method: .post, parameters: para,  encoding: URLEncoding.default, headers: headerNoAuth)
               .responseJSON { response in
                   Common.hideBusy()
                   print(response)
                   switch(response.result) {
                   case .success(_):
                       if let val = response.value as? NSDictionary
                       {
                           print(val)
                            if let error_text = val.object(forKey: "error_text") as? String {
                                 complete(false, nil, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text))
                            }
                            else{
                                if let request_id = val.object(forKey: "request_id") as? String
                                {
                                      complete(true, request_id ,nil)
                                }
                                else{
                                     complete(false, nil, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "error_text") as? String))
                                 }
                            }
                           
                       }
                       break
                   case .failure(let error):
                       Common.hideBusy()
                       complete(false, nil, ErrorManager.processError(error: error))
                   }
           }
    }
    
    func phoneVerify(_ para: Parameters, complete:@escaping (_ success: Bool, _ errer: ErrorModel?) ->Void)
    {
           print(para)
           Common.showBusy()
           manager.request(URL.init(string: URL_PHONE_VERIFY)!, method: .post, parameters: para,  encoding: URLEncoding.default, headers: headerNoAuth)
               .responseJSON { response in
                   Common.hideBusy()
                   print(response)
                   switch(response.result) {
                   case .success(_):
                       
                       if let val = response.value as? NSDictionary
                       {
                           print(val)
                           if let val = response.value as? NSDictionary
                           {
                               print(val)
                                if let error_text = val.object(forKey: "error_text") as? String {
                                     complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text))
                                }
                                else{
                                    complete(true ,nil)
                                }
                               
                           }
                           break
                       }
                       break
                   case .failure(let error):
                       Common.hideBusy()
                       complete(false, ErrorManager.processError(error: error))
                   }
           }
    }
    
    func loginUser(_ para: Parameters, complete:@escaping (_ success: Bool, _ errer: ErrorModel?) ->Void)
    {
            print("PARAM -->",para)
            print("URL -->",URL_LOGIN)
           manager.request(URL.init(string: URL_LOGIN)!, method: .post, parameters: para,  encoding: URLEncoding.default, headers: headerNoAuth)
               .responseJSON { response in
                   print(response)
                   switch(response.result) {
                   case .success(_):
                       
                       if let val = response.value as? NSDictionary
                       {
                           print(val)
                          if let error_text = val.object(forKey: "error") as? NSDictionary {
                            complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""))
                           }
                           else{
                                if let status = val.object(forKey: "statusCode") as? Int
                                {
                                    if  status == 200 {
                                        if let token = val.object(forKey: "token") as? String
                                        {
                                            UserDefaults.standard.setValue(token, forKey: kToken)
                                            UserDefaults.standard.synchronize()
                                            complete(true, nil)
                                        }
                                        else{
                                            complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                        }
                                    }
                                    else{
                                        complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                    }
                                }
                                else{
                                    complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                }
                           }
                       }
                       break
                   case .failure(let error):
                       Common.hideBusy()
                       complete(false, ErrorManager.processError(error: error))
                   }
           }
    }
    
    func getUserInfo(complete:@escaping (_ success: Bool, _ obj: ProfileObj?,_ errer: ErrorModel?) ->Void)
    {
           Common.showBusy()
            let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
        print("Header --->", header)
           manager.request(URL.init(string: URL_GETINFORUSER)!, method: .get, parameters: nil,  encoding: URLEncoding.default, headers: header)
               .responseJSON { response in
                   Common.hideBusy()
                   print(response)
                   switch(response.result) {
                   case .success(_):
                       
                    if let val = response.value as? NSDictionary
                     {
                        if (val.object(forKey: "error") as? String) != nil
                        {
                            complete(true ,nil, nil)
                        }
                        else{
                            APP_DELEGATE.inforUser = val
                            complete(true ,ProfileObj.init(val), nil)
                        }
                        
                         
                     }
                    break
                   case .failure(let error):
                       Common.hideBusy()
                       complete(false, nil, ErrorManager.processError(error: error))
                   }
           }
    }
    func getUserInfoConfirmAccount(complete:@escaping (_ success: Bool, _ obj: ProfileObj?,_ errer: ErrorModel?) ->Void)
    {
            let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
        print("Header --->", header)
           manager.request(URL.init(string: URL_GETINFORUSER)!, method: .get, parameters: nil,  encoding: URLEncoding.default, headers: header)
               .responseJSON { response in
                   print(response)
                   switch(response.result) {
                   case .success(_):
                       
                    if let val = response.value as? NSDictionary
                     {
                        if (val.object(forKey: "error") as? String) != nil
                        {
                            complete(true ,nil, nil)
                        }
                        else{
                            APP_DELEGATE.inforUser = val
                            complete(true ,ProfileObj.init(val), nil)
                        }
                        
                         
                     }
                    break
                   case .failure(let error):
                       Common.hideBusy()
                       complete(false, nil, ErrorManager.processError(error: error))
                   }
           }
    }
    func updateProfile(_ para: Parameters, complete:@escaping (_ success: Bool, _ errer: ErrorModel?) ->Void)
    {
            print("PARAM -->",para)
            print("URL -->",URL_UPDATE_PROFILE)
        let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
           manager.request(URL.init(string: URL_UPDATE_PROFILE)!, method: .post, parameters: para,  encoding: URLEncoding.default, headers: header)
               .responseJSON { response in
                   print(response)
                   switch(response.result) {
                   case .success(_):
                       
                       if let val = response.value as? NSDictionary
                       {
                           print(val)
                          if let error_text = val.object(forKey: "error") as? NSDictionary {
                            complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""))
                           }
                           else{
                                if let status = val.object(forKey: "status") as? Int
                                {
                                    if  status == 200 {
                                       complete(true, nil)
                                    }
                                    else{
                                        complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                    }
                                }
                                else{
                                    complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                }
                           }
                       }
                       break
                   case .failure(let error):
                       Common.hideBusy()
                       complete(false, ErrorManager.processError(error: error))
                   }
           }
    }
    
    func updateProfileSettingCryCurreny(_ para: Parameters, complete:@escaping (_ success: Bool, _ errer: ErrorModel?) ->Void)
    {
            print("PARAM -->",para)
            print("URL -->",URL_UPDATE_PROFILE)
        let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
           manager.request(URL.init(string: URL_UPDATE_PROFILE)!, method: .post, parameters: para,  encoding: URLEncoding.default, headers: header)
               .responseJSON { response in
                   print(response)
                   switch(response.result) {
                   case .success(_):
                       
                       if let val = response.value as? NSDictionary
                       {
                           print(val)
                          if let error_text = val.object(forKey: "error") as? NSDictionary {
                            complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""))
                           }
                           else{
                                if let status = val.object(forKey: "status") as? Int
                                {
                                    if  status == 200 {
                                       complete(true, nil)
                                    }
                                    else{
                                        complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                    }
                                }
                                else{
                                    complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                }
                           }
                       }
                       break
                   case .failure(let error):
                       Common.hideBusy()
                       complete(false, ErrorManager.processError(error: error))
                   }
           }
    }
    
    func updateProfileCryCurrency(_ para: Parameters, complete:@escaping (_ success: Bool, _ errer: ErrorModel?) ->Void)
    {
            print("PARAM -->",para)
            print("URL -->",URL_UPDATE_CURRENTCY)
        let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
           manager.request(URL.init(string: URL_UPDATE_CURRENTCY)!, method: .post, parameters: para,  encoding: URLEncoding.default, headers: header)
               .responseJSON { response in
                   print(response)
                   switch(response.result) {
                   case .success(_):
                       
                       if let val = response.value as? NSDictionary
                       {
                           print(val)
                          if let error_text = val.object(forKey: "error") as? NSDictionary {
                            complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""))
                           }
                           else{
                                if let status = val.object(forKey: "statusCode") as? Int
                                {
                                    if  status == 200 {
                                       complete(true, nil)
                                    }
                                    else{
                                        complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                    }
                                }
                                else{
                                    complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                }
                           }
                       }
                       break
                   case .failure(let error):
                       Common.hideBusy()
                       complete(false, ErrorManager.processError(error: error))
                   }
           }
    }
    func updateAvatar(_ profileImage: UIImage?, complete:@escaping (_ success: Bool?,_ errer: ErrorModel?) ->Void)
    {
        Common.showBusy()
        let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
        
        manager.upload(multipartFormData: { (multipartFormData) in
            
            if profileImage != nil
            {
                multipartFormData.append(profileImage!.jpegData(compressionQuality: 0.5)!, withName: "avtFile", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            }
        }, usingThreshold: UInt64.init(), to: URL_UPLOAD_AVATAR, method: .post, headers: header) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print(response)
                    if let val = response.value as? NSDictionary
                    {
                        print(val)
                    }
                    Common.hideBusy()
                }
            case .failure(let error):
                print(error)
                complete(false , ErrorManager.processError(error: error))
                Common.hideBusy()
            }
        }
    }
    
    func uploadFile(_param: Parameters, _ image: UIImage, _ filePDF: URL?, complete:@escaping (_ success: Bool?,_ errer: ErrorModel?) ->Void)
    {
        let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
       print(header)
        print(_param)
        //print(URL_UPLOAD_FILE)
        if filePDF != nil {
            do {
                let jsonData = try Data(contentsOf: filePDF!, options: .mappedIfSafe)
                       let URL2 = try! URLRequest(url: URL_UPLOAD_TRANSTION , method: .post, headers: header)
                           
                           Alamofire.upload(multipartFormData: { (multipartFormData) in
                               multipartFormData.append(image.jpegData(compressionQuality: 0.5)!, withName: "imgFile", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
                               multipartFormData.append(jsonData,  withName: "docFile", fileName: filePDF!.lastPathComponent , mimeType: "application/pdf")
                               for (key, value) in _param {
                                   multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
                               }
                               
                           }, with: URL2, encodingCompletion: { (result) in
                               
                               switch result {
                               case .success(let upload, _, _):
                                   
                                   upload.responseJSON{
                                       response in
                                       print("response-->",response)
                                       if let data = response.result.value{
                                           DispatchQueue.main.async {
                                               if(response.response?.statusCode == 200){
                                                  // callback(true, JSON(data), JSON((response.response?.statusCode)!))
                                                   complete(true, nil)
                                               } else{
                                                   //callback(false, JSON(data), JSON((response.response?.statusCode)!))
                                                   complete(false, ErrorManager.processError(error: response.error))
                                               }
                                           }
                                       }
                                       else{
                                         complete(false, ErrorManager.processError(error: response.error))
                                      }
                                   }
                                   
                               case .failure(let encodingError):
                                   print(encodingError)
                                   DispatchQueue.main.async {
                                       complete(false, ErrorManager.processError(error: encodingError))
                                      // callback(false,JSON(self.getStatusCodeString(408)),JSON(408))
                                   }
                                   
                               }
                               
                           })
            } catch {
                 complete(false , ErrorManager.processError(error: error))
                print(error)
            }
        }
        else{
                   let URL2 = try! URLRequest(url: URL_UPLOAD_TRANSTION , method: .post, headers: header)
                       
                       Alamofire.upload(multipartFormData: { (multipartFormData) in
                           multipartFormData.append(image.jpegData(compressionQuality: 0.5)!, withName: "imgFile", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
                          
                           for (key, value) in _param {
                               multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
                           }
                           
                       }, with: URL2, encodingCompletion: { (result) in
                           
                           switch result {
                           case .success(let upload, _, _):
                               
                               upload.responseJSON{
                                   response in
                                   print("response-->",response)
                                   if let data = response.result.value{
                                       DispatchQueue.main.async {
                                           if(response.response?.statusCode == 200){
                                              // callback(true, JSON(data), JSON((response.response?.statusCode)!))
                                               complete(true, nil)
                                           } else{
                                               //callback(false, JSON(data), JSON((response.response?.statusCode)!))
                                               complete(false, ErrorManager.processError(error: response.error))
                                           }
                                       }
                                   }
                                   else{
                                     complete(false, ErrorManager.processError(error: response.error))
                                  }
                               }
                               
                           case .failure(let encodingError):
                               print(encodingError)
                               DispatchQueue.main.async {
                                   complete(false, ErrorManager.processError(error: encodingError))
                                  // callback(false,JSON(self.getStatusCodeString(408)),JSON(408))
                               }
                               
                           }
                           
                       })
        }
    }
    
    func uploadImageFile(_param: Parameters, _ image: UIImage, _ imageDocument: UIImage?, complete:@escaping (_ success: Bool?,_ errer: ErrorModel?) ->Void)
    {
      
        let header: HTTPHeaders    = ["Content-Type": "multipart/form-data", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
        let URL2 = try! URLRequest(url: URL_UPLOAD_TRANSTION , method: .post, headers: header)
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(image.jpegData(compressionQuality: 0.5)!, withName: "imgFile", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
               //  multipartFormData.append(imageDocument!.jpegData(compressionQuality: 0.5)!, withName: "docFile", fileName: "\(Date().timeIntervalSince1970)_2.jpeg", mimeType: "image/jpeg")

                for (key, value) in _param {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
                }
                
            }, with: URL2, encodingCompletion: { (result) in
                
                switch result {
                case .success(let upload, _, _):
                    
                    upload.responseJSON{
                        response in
                        //Common.hideBusy()
                        print("response-->",response)
                        if let data = response.result.value{
                            DispatchQueue.main.async {
                                if(response.response?.statusCode == 200){
                                   // callback(true, JSON(data), JSON((response.response?.statusCode)!))
                                    complete(true, nil)
                                } else{
                                    //callback(false, JSON(data), JSON((response.response?.statusCode)!))
                                    complete(false, ErrorManager.processError(error: response.error))
                                }
                            }
                        }
                        else{
                           complete(false, ErrorManager.processError(error: response.error))
                        }
                    }
                    
                case .failure(let encodingError):
                    print(encodingError)
                    DispatchQueue.main.async {
                        complete(false, ErrorManager.processError(error: encodingError))
                       // callback(false,JSON(self.getStatusCodeString(408)),JSON(408))
                    }
                    
                }
                
            })
        
    }
    
    func stringArrayToData(stringArray: [String]) -> Data? {
        return try? JSONSerialization.data(withJSONObject: stringArray, options: [.fragmentsAllowed])
    }
    
    func dataToStringArray(data: Data) -> [String]? {
      return (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String]
    }
    
    func createAMlReport(complete:@escaping (_ success: Bool, _ errer: ErrorModel?) ->Void)
    {
        Common.showBusy()
         let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
         print(header)
        print(URL_CREATE_ALM_REPORT)
           manager.request(URL.init(string: URL_CREATE_ALM_REPORT)!, method: .post, parameters:nil,  encoding: URLEncoding.default, headers: header)
               .responseJSON { response in
                   print(response)
                  Common.hideBusy()
                   switch(response.result) {
                   case .success(_):
                       
                       if let val = response.value as? NSDictionary
                       {
                           print(val)
                          if let error_text = val.object(forKey: "error") as? NSDictionary {
                            complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""))
                           }
                           else{
                                if let status = val.object(forKey: "status") as? Int
                                {
                                    if  status == 200 {
                                        complete(true, nil)
                                    }
                                    else{
                                        complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                    }
                                }
                                else{
                                    complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                }
                           }
                       }
                       break
                   case .failure(let error):
                       Common.hideBusy()
                       complete(false, ErrorManager.processError(error: error))
                   }
           }
    }
    
    func createProfileReport(complete:@escaping (_ success: Bool, _ errer: ErrorModel?) ->Void)
    {
        Common.showBusy()
        let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
        print(header)
        print(URL_CREATE_PROFILE_REPORT)
        manager.request(URL.init(string: URL_CREATE_PROFILE_REPORT)!, method: .post, parameters:nil,  encoding: URLEncoding.default, headers: header)
               .responseJSON { response in
                   print(response)
                  Common.hideBusy()
                   switch(response.result) {
                   case .success(_):
                       
                       if let val = response.value as? NSDictionary
                       {
                           print(val)
                          if let error_text = val.object(forKey: "error") as? NSDictionary {
                            complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""))
                           }
                           else{
                                if let status = val.object(forKey: "status") as? Int
                                {
                                    if  status == 200 {
                                        complete(true, nil)
                                    }
                                    else{
                                        complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                    }
                                }
                                else{
                                    complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                }
                           }
                       }
                       break
                   case .failure(let error):
                       Common.hideBusy()
                       complete(false, ErrorManager.processError(error: error))
                   }
           }
    }
    func createConnectReport(complete:@escaping (_ success: Bool, _ errer: ErrorModel?) ->Void)
    {
        Common.showBusy()
        let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
        print(header)
        print(URL_CONNECT_REPORT)
        manager.request(URL.init(string: URL_CONNECT_REPORT)!, method: .post, parameters:nil,  encoding: URLEncoding.default, headers: header)
               .responseJSON { response in
                   print(response)
                  Common.hideBusy()
                   switch(response.result) {
                   case .success(_):
                       
                       if let val = response.value as? NSDictionary
                       {
                           print(val)
                          if let error_text = val.object(forKey: "error") as? NSDictionary {
                            complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""))
                           }
                           else{
                                if let status = val.object(forKey: "status") as? Int
                                {
                                    if  status == 200 {
                                        complete(true, nil)
                                    }
                                    else{
                                        complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                    }
                                }
                                else{
                                    complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                }
                           }
                       }
                       break
                   case .failure(let error):
                       Common.hideBusy()
                       complete(false, ErrorManager.processError(error: error))
                   }
           }
    }
    func getActivity(complete:@escaping (_ success: Bool,_ arrRecRqs: NSArray?, _ arrSentRqs: NSArray?, _ ampAsAmp: NSArray?, _ ampAsBuyer: NSArray?, _ ampAsSeller: NSArray?, _ errer: ErrorModel?) ->Void)
    {
        Common.showBusy()
        let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
        print(header)
        print(URL_GET_ACTIVITY)
        manager.request(URL.init(string: URL_GET_ACTIVITY)!, method: .get, parameters:nil,  encoding: URLEncoding.default, headers: header)
               .responseJSON { response in
                  Common.hideBusy()
                 print(response)
                   switch(response.result) {
                   case .success(_):
                       
                       if let val = response.value as? NSDictionary
                       {
                           
                          if let error_text = val.object(forKey: "error") as? NSDictionary {
                            complete(false, nil, nil, nil, nil, nil, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""))
                           }
                           else{
                           // print(val)
                                if let status = val.object(forKey: "statusCode") as? Int
                                {
                                    if  status == 200 {
                                        var recRqs = NSArray.init()
                                        var sentRqs = NSArray.init()
                                        var arrampAsAmp = NSArray.init()
                                        var arrampAsBuyer = NSArray.init()
                                        var arrampAsSeller = NSArray.init()
                                        if let arrs = val.object(forKey: "transacAsBuyer") as? NSArray
                                        {
                                            recRqs = arrs
                                        }
                                        if let arr1s = val.object(forKey: "transacAsSeller") as? NSArray
                                        {
                                            sentRqs = arr1s
                                        }
                                        if let arr2s = val.object(forKey: "ampAsAmp") as? NSArray
                                        {
                                            arrampAsAmp = arr2s
                                        }
                                        if let arr3s = val.object(forKey: "ampAsBuyer") as? NSArray
                                        {
                                            arrampAsBuyer = arr3s
                                        }
                                        if let arr4s = val.object(forKey: "ampAsSeller") as? NSArray
                                        {
                                            arrampAsSeller = arr4s
                                        }
                                        //print(recRqs)
                                        //print(sentRqs)
                                        complete(true, recRqs,sentRqs,arrampAsAmp,arrampAsBuyer,arrampAsSeller, nil)
                                    }
                                    else{
                                        complete(false, nil, nil, nil, nil, nil, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                    }
                                }
                                else{
                                    complete(false, nil, nil, nil, nil, nil, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                }
                           }
                       }
                       break
                   case .failure(let error):
                       Common.hideBusy()
                       complete(false, nil, nil, nil, nil, nil, ErrorManager.processError(error: error))
                   }
           }
    }
    
    func getDetailAcitivity(_ userName: String, complete:@escaping (_ success: Bool, _ obj: ProfileObj?, _ val: NSDictionary?, _ errer: ErrorModel?) ->Void)
    {
        Common.showBusy()
        let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
        let param = ["username": userName]
        print(URL_DETAIL_ACTIVITY)
        manager.request(URL.init(string: URL_DETAIL_ACTIVITY)!, method: .post , parameters:param,  encoding: URLEncoding.default, headers: header)
               .responseJSON { response in
                   print(response)
                  Common.hideBusy()
                   switch(response.result) {
                   case .success(_):
                       
                       if let val = response.value as? NSDictionary
                       {
                           print(val)
                          if let error_text = val.object(forKey: "error") as? NSDictionary {
                            complete(false, nil, nil, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""))
                           }
                           else{
                                if let status = val.object(forKey: "status") as? Int
                                {
                                    if  status == 200 {
                                        if let _u = val.object(forKey: "_u") as? NSDictionary
                                        {
                                            complete(true, ProfileObj.init(_u), _u, nil)
                                        }
                                        else{
                                            complete(true, nil, nil, nil)
                                        }
                                    }
                                    else{
                                        complete(false, nil, nil, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                    }
                                }
                                else{
                                    complete(false, nil, nil, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                }
                           }
                       }
                       break
                   case .failure(let error):
                       Common.hideBusy()
                       complete(false, nil, nil, ErrorManager.processError(error: error))
                   }
           }
    }



    func acceptActivity(_ param: NSMutableDictionary, complete:@escaping (_ success: Bool, _ errer: ErrorModel?) ->Void)
    {
        Common.showBusy()
        let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
        print(header)
        print("PARAM --->",param)
        manager.request(URL.init(string: "\(URL_SERVER)kycaml/acceptRq")!, method: .post, parameters:param as! Parameters,  encoding: URLEncoding.default, headers: header)
               .responseJSON { response in
                   print(response)
                  Common.hideBusy()
                   switch(response.result) {
                   case .success(_):
                       
                       if let val = response.value as? NSDictionary
                       {
                           print(val)
                          if let error_text = val.object(forKey: "error") as? NSDictionary {
                            complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""))
                           }
                           else{
                                if let status = val.object(forKey: "status") as? Int
                                {
                                    if  status == 200 {
                                        complete(true, nil)
                                    }
                                    else{
                                        complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                    }
                                }
                                else{
                                    complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                }
                           }
                       }
                       break
                   case .failure(let error):
                       Common.hideBusy()
                       complete(false, ErrorManager.processError(error: error))
                   }
           }
    }
    


    func decineActivity(_ transacId: String, complete:@escaping (_ success: Bool, _ errer: ErrorModel?) ->Void)
      {
          Common.showBusy()
          let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
          print(header)
          print(URL_CREATE_PROFILE_REPORT)
          manager.request(URL.init(string: "\(URL_SERVER)kycaml/rejectRq/\(transacId)")!, method: .delete, parameters:nil,  encoding: URLEncoding.default, headers: header)
                 .responseJSON { response in
                     print(response)
                    Common.hideBusy()
                     switch(response.result) {
                     case .success(_):
                         
                         if let val = response.value as? NSDictionary
                         {
                             print(val)
                            if let error_text = val.object(forKey: "error") as? NSDictionary {
                              complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""))
                             }
                             else{
                                  if let status = val.object(forKey: "status") as? Int
                                  {
                                      if  status == 200 {
                                          complete(true, nil)
                                      }
                                      else{
                                          complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                      }
                                  }
                                  else{
                                      complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                  }
                             }
                         }
                         break
                     case .failure(let error):
                         Common.hideBusy()
                         complete(false, ErrorManager.processError(error: error))
                     }
             }
      }
    
    func getArchived(complete:@escaping (_ success: Bool,_ arrRecRqs: NSArray?, _ arrSentRqs: NSArray?, _ ampAsAmpUser: NSArray?, _ ampAsBuyer: NSArray?, _ ampAsSeller: NSArray?, _ errer: ErrorModel?) ->Void)
    {
        Common.showBusy()
        let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
        print(header)
        print(URL_GET_ARCHIVED)
        manager.request(URL.init(string: URL_GET_ARCHIVED)!, method: .get, parameters:nil,  encoding: URLEncoding.default, headers: header)
               .responseJSON { response in
                  Common.hideBusy()
                   switch(response.result) {
                   case .success(_):
                       
                       if let val = response.value as? NSDictionary
                       {
                           
                          if let error_text = val.object(forKey: "error") as? NSDictionary {
                            complete(false, nil, nil, nil, nil, nil, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""))
                           }
                           else{
                            print(val)
                                if let status = val.object(forKey: "status") as? Int
                                {
                                    if  status == 200 {
                                        var recRqs = NSArray.init()
                                        var sentRqs = NSArray.init()
                                        var arrrampAsAmpUser = NSArray.init()
                                        var arrrampAsBuyer = NSArray.init()
                                        var arrrampAsSeller = NSArray.init()
                                        if let arrs = val.object(forKey: "recRqs") as? NSArray
                                        {
                                            recRqs = arrs
                                        }
                                        if let arr1s = val.object(forKey: "sentRqs") as? NSArray
                                        {
                                            sentRqs = arr1s
                                        }
                                        if let arrs = val.object(forKey: "ampAsAmpUser") as? NSArray
                                        {
                                            arrrampAsAmpUser = arrs
                                        }
                                        if let arrs = val.object(forKey: "ampAsBuyer") as? NSArray
                                        {
                                            arrrampAsBuyer = arrs
                                        }
                                        if let arrs = val.object(forKey: "ampAsSeller") as? NSArray
                                        {
                                            arrrampAsSeller = arrs
                                        }
                                        print(recRqs)
                                        print(sentRqs)
                                        complete(true, recRqs,sentRqs, arrrampAsAmpUser, arrrampAsBuyer, arrrampAsSeller , nil)
                                    }
                                    else{
                                        complete(false, nil, nil,  nil, nil, nil, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                    }
                                }
                                else{
                                    complete(false, nil, nil,  nil, nil, nil, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                }
                           }
                       }
                       break
                   case .failure(let error):
                       Common.hideBusy()
                       complete(false, nil, nil,  nil, nil, nil, ErrorManager.processError(error: error))
                   }
           }
    }
    
    func checkUser( param: Parameters, _ complete:@escaping (_ success: Bool, _ message: String?) ->Void)
       {
           Common.showBusy()
            let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
            print(header)
           print(URL_CHECK_USER)
              manager.request(URL.init(string: URL_CHECK_USER)!, method: .post, parameters:param,  encoding: URLEncoding.default, headers: header)
                  .responseJSON { response in
                      print(response)
                     Common.hideBusy()
                      switch(response.result) {
                      case .success(_):
                          
                          if let val = response.value as? NSDictionary
                          {
                              if let message = val.object(forKey: "message") as? String
                              {
                                   complete(true, message)
                              }
                          }
                          break
                      case .failure(let error):
                          Common.hideBusy()
                          complete(false, error.localizedDescription)
                      }
              }
       }
    
    func getInforCompany( param: Parameters, _ complete:@escaping (_ success: Bool,_ value: NSDictionary?, _ message: String?) ->Void)
    {
        Common.showBusy()
         let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
         print(param)
        print(URL_SEARCH_INFOR_COMPANY)
        
           manager.request(URL.init(string: URL_SEARCH_INFOR_COMPANY)!, method: .post, parameters:param,  encoding: URLEncoding.default, headers: header)
               .responseJSON { response in
                   print(response)
                  Common.hideBusy()
                   switch(response.result) {
                   case .success(_):
                       
                       if let val = response.value as? NSDictionary
                       {
                            if let error_text = val.object(forKey: "error") as? NSDictionary {
                             complete(false, nil , error_text.object(forKey: "message") as? String ?? "")
                            }
                            else{
                                if let ocData = val.object(forKey: "data") as? NSDictionary
                                {
                                    complete(true, ocData, nil)
                                }
                            }
                           
                       }
                       break
                   case .failure(let error):
                       Common.hideBusy()
                       complete(false, nil , error.localizedDescription)
                   }
           }
    }
    /*
     ACCOUNTS

     Nathalie
     +32 471101325
     123456


     artplusdemo
     +32484775184
     112358


     */
    func commectUser(_ param: Parameters, complete:@escaping (_ success: Bool, _ errer: ErrorModel?) ->Void)
    {
        Common.showBusy()
        let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
        print(header)
        print("PARAM --->",param)
         print("URL_CONNECT_USER --->",URL_CONNECT_USER + "/request")
        manager.request(URL.init(string: URL_CONNECT_USER + "/request")!, method: .post, parameters:param,  encoding: URLEncoding.default, headers: header)
               .responseJSON { response in
                   print(response)
                  Common.hideBusy()
                   switch(response.result) {
                   case .success(_):
                       
                       if let val = response.value as? NSDictionary
                       {
                           print(val)
                          if let error_text = val.object(forKey: "error") as? NSDictionary {
                            complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""))
                           }
                           else{
                                if let status = val.object(forKey: "statusCode") as? Int
                                {
                                    if  status == 200 {
                                        complete(true, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                    }
                                    else{
                                        complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                    }
                                }
                                else{
                                    complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                }
                           }
                       }
                       break
                   case .failure(let error):
                       Common.hideBusy()
                       complete(false, ErrorManager.processError(error: error))
                   }
           }
    }
    
    func getListRequest(complete:@escaping (_ success: Bool,_ Arrconnections: NSArray?, _ errer: ErrorModel?) ->Void)
       {
           Common.showBusy()
           let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
           print(header)
        print("response --->",URL_CONNECT_USER + "/requests")
           manager.request(URL.init(string: URL_CONNECT_USER + "/requests")!, method: .get, parameters:nil,  encoding: URLEncoding.default, headers: header)
                  .responseJSON { response in
                     //Common.hideBusy()
                    print("response --->",response)
                      switch(response.result) {
                      case .success(_):
                          
                          if let val = response.value as? NSDictionary
                          {
                              
                             if let error_text = val.object(forKey: "error") as? NSDictionary {
                               complete(false, nil, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""))
                              }
                              else{
                               
                                   if let status = val.object(forKey: "code") as? Int
                                   {
                                       print("status----->",status)
                                       if  status == 200 {
                                           var connections = NSArray.init()
                                           if let arrs = val.object(forKey: "data") as? NSArray
                                           {
                                               connections = arrs
                                           }
                                          
                                           complete(true,connections , nil)
                                       }
                                       else{
                                           complete(false, nil, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                       }
                                   }
                                   else{
                                       complete(false, nil, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                   }
                              }
                          }
                          break
                      case .failure(let error):
                          Common.hideBusy()
                          complete(false, nil, ErrorManager.processError(error: error))
                      }
              }
       }
    
    func getListConnection(_ status: String, complete:@escaping (_ success: Bool,_ Arrconnections: NSArray?, _ errer: ErrorModel?) ->Void)
       {
           Common.showBusy()
           let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
           print(header)
        print("response --->","\(URL_SERVER)user/connect?status=\(status)")
           manager.request(URL.init(string: "\(URL_SERVER)user/connect?status=\(status)")!, method: .get, parameters:nil,  encoding: URLEncoding.default, headers: header)
                  .responseJSON { response in
                     //Common.hideBusy()
                    print("response --->",response)
                      switch(response.result) {
                      case .success(_):
                          
                          if let val = response.value as? NSDictionary
                          {
                              
                             if let error_text = val.object(forKey: "error") as? NSDictionary {
                               complete(false, nil, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""))
                              }
                              else{
                               
                                   if let status = val.object(forKey: "status") as? Int
                                   {
                                       print("status----->",status)
                                       if  status == 200 {
                                           var connections = NSArray.init()
                                           if let arrs = val.object(forKey: "connections") as? NSArray
                                           {
                                               connections = arrs
                                           }
                                          
                                           complete(true,connections , nil)
                                       }
                                       else{
                                           complete(false, nil, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                       }
                                   }
                                   else{
                                       complete(false, nil, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                   }
                              }
                          }
                          break
                      case .failure(let error):
                          Common.hideBusy()
                          complete(false, nil, ErrorManager.processError(error: error))
                      }
              }
       }
    
    func getConnectionNews(complete:@escaping (_ success: Bool,_ Arrconnections: NSArray?, _ errer: ErrorModel?) ->Void)
       {
           Common.showBusy()
           let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
           print(header)
        print("response --->","\(URL_SERVER)connections")
           manager.request(URL.init(string: "\(URL_SERVER)connections")!, method: .get, parameters:nil,  encoding: URLEncoding.default, headers: header)
                  .responseJSON { response in
                     //Common.hideBusy()
                    print("response --->",response)
                      switch(response.result) {
                      case .success(_):
                          
                          if let val = response.value as? NSDictionary
                          {
                              
                             if let error_text = val.object(forKey: "error") as? NSDictionary {
                               complete(false, nil, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""))
                              }
                              else{
                               
                                   if let status = val.object(forKey: "code") as? Int
                                   {
                                       print("status----->",status)
                                       if  status == 200 {
                                           var connections = NSArray.init()
                                           if let arrs = val.object(forKey: "data") as? NSArray
                                           {
                                               connections = arrs
                                           }
                                          
                                           complete(true,connections , nil)
                                       }
                                       else{
                                           complete(false, nil, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                       }
                                   }
                                   else{
                                       complete(false, nil, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                   }
                              }
                          }
                          break
                      case .failure(let error):
                          Common.hideBusy()
                          complete(false, nil, ErrorManager.processError(error: error))
                      }
              }
       }
    func getListMyTrade( complete:@escaping (_ success: Bool,_ Arrconnections: [NSDictionary]?, _ errer: ErrorModel?) ->Void)
    {
        //Common.showBusy()
        let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
        print("url--->","\(URL_SERVER)user/tradeconnect")
        manager.request(URL.init(string: "\(URL_SERVER)user/tradeconnect")!, method: .get, parameters:nil,  encoding: URLEncoding.default, headers: header)
               .responseJSON { response in
                  //Common.hideBusy()
                 print("response --->",response)
                   switch(response.result) {
                   case .success(_):
                       
                       if let val = response.value as? NSDictionary
                       {
                           
                          if let error_text = val.object(forKey: "error") as? NSDictionary {
                            complete(false, nil, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""))
                           }
                           else{
                            
                                if let status = val.object(forKey: "status") as? Int
                                {
                                    if  status == 200 {
                                        var connections = [NSDictionary]()
                                        if let arrs = val.object(forKey: "data") as? [NSDictionary]
                                        {
                                            connections = arrs
                                        }
                                       
                                        complete(true,connections , nil)
                                    }
                                    else{
                                        complete(false, nil, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                    }
                                }
                                else{
                                    complete(false, nil, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                }
                           }
                       }
                       break
                   case .failure(let error):
                       Common.hideBusy()
                       complete(false, nil, ErrorManager.processError(error: error))
                   }
           }
    }
    
    func getListMyNetWork( complete:@escaping (_ success: Bool,_ Arrconnections: [NSDictionary]?, _ errer: ErrorModel?) ->Void)
    {
        //Common.showBusy()
        let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
        print("url--->","\(URL_SERVER)user/networks")
        manager.request(URL.init(string: "\(URL_SERVER)user/networks")!, method: .get, parameters:nil,  encoding: URLEncoding.default, headers: header)
               .responseJSON { response in
                  Common.hideBusy()
                 print("getListMyNetWork --->",response)
                   switch(response.result) {
                   case .success(_):
                       
                       if let val = response.value as? NSDictionary
                       {
                           
                          if let error_text = val.object(forKey: "error") as? NSDictionary {
                            complete(false, nil, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""))
                           }
                           else{
                                var connections = [NSDictionary]()
                                if let arrs = val.object(forKey: "data") as? [NSDictionary]
                                {
                                    connections = arrs
                                }
                           
                                complete(true,connections , nil)
                           }
                       }
                       break
                   case .failure(let error):
                       Common.hideBusy()
                       complete(false, nil, ErrorManager.processError(error: error))
                   }
           }
    }
    
    func removeConnect(_ param: Parameters, complete:@escaping (_ success: Bool, _ errer: ErrorModel?) ->Void)
    {
        Common.showBusy()
        let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
        print("\(URL_SERVER)user/remove-connect")
        print("PARAM --->",param)
        manager.request(URL.init(string: "\(URL_SERVER)user/remove-connect")!, method: .post, parameters:param,  encoding: URLEncoding.default, headers: header)
               .responseJSON { response in
                  Common.hideBusy()
                   switch(response.result) {
                   case .success(_):
                       
                       if let val = response.value as? NSDictionary
                       {
                           print(val)
                          if let error_text = val.object(forKey: "error") as? NSDictionary {
                            complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""))
                           }
                           else{
                                if let status = val.object(forKey: "status") as? Int
                                {
                                    if  status == 200 {
                                        complete(true, nil)
                                    }
                                    else{
                                        complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                    }
                                }
                                else{
                                    complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                }
                           }
                       }
                       break
                   case .failure(let error):
                       Common.hideBusy()
                       complete(false, ErrorManager.processError(error: error))
                   }
           }
    }
    
    func removeConnectNew(_ req_id: String, complete:@escaping (_ success: Bool, _ errer: ErrorModel?) ->Void)
    {
        Common.showBusy()
        let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
    
        manager.request(URL.init(string: "\(URL_SERVER)connect/\(req_id)/revoke-access-cdd")!, method: .post, parameters:nil,  encoding: URLEncoding.default, headers: header)
               .responseJSON { response in
                  Common.hideBusy()
                   switch(response.result) {
                   case .success(_):
                       
                       if let val = response.value as? NSDictionary
                       {
                           print(val)
                          if let error_text = val.object(forKey: "error") as? NSDictionary {
                            complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""))
                           }
                           else{
                               complete(true, nil)
                           }
                       }
                       break
                   case .failure(let error):
                       Common.hideBusy()
                       complete(false, ErrorManager.processError(error: error))
                   }
           }
    }
    
    func deleteConnectNew(_ req_id: String, complete:@escaping (_ success: Bool, _ errer: ErrorModel?) ->Void)
    {
        Common.showBusy()
        let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
        print("url--->","\(URL_SERVER)connect/\(req_id)")
        manager.request(URL.init(string: "\(URL_SERVER)connect/\(req_id)")!, method: .delete, parameters:nil,  encoding: URLEncoding.default, headers: header)
               .responseJSON { response in
                  Common.hideBusy()
                   switch(response.result) {
                   case .success(_):
                       
                       if let val = response.value as? NSDictionary
                       {
                           print(val)
                          if let error_text = val.object(forKey: "error") as? NSDictionary {
                            complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""))
                           }
                           else{
                               complete(true, nil)
                           }
                       }
                       break
                   case .failure(let error):
                       Common.hideBusy()
                       complete(false, ErrorManager.processError(error: error))
                   }
           }
    }
    
    func acceptNewToAction(_ rep_id: String, _ action: String, complete:@escaping (_ success: Bool, _ errer: ErrorModel?) ->Void)
       {
           Common.showBusy()
           let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
           print("API --->",URL_SERVER + "connect/request/\(rep_id)/\(action)")
           manager.request(URL.init(string: URL_SERVER + "connect/request/\(rep_id)/\(action)")!, method: .post, parameters:nil,  encoding: URLEncoding.default, headers: header)
                  .responseJSON { response in
                     Common.hideBusy()
                      switch(response.result) {
                      case .success(_):
                          
                          if let val = response.value as? NSDictionary
                          {
                              print(val)
                             if let error_text = val.object(forKey: "error") as? NSDictionary {
                               complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""))
                              }
                              else{
                                  complete(true, nil)
                              }
                          }
                          break
                      case .failure(let error):
                          Common.hideBusy()
                          complete(false, ErrorManager.processError(error: error))
                      }
              }
       }
    
    func acceptConnection(_ param: Parameters, complete:@escaping (_ success: Bool, _ errer: ErrorModel?) ->Void)
       {
           Common.showBusy()
           let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
           print(header)
           print("PARAM --->",param)
           manager.request(URL.init(string: "\(URL_SERVER)user/accept-connect")!, method: .post, parameters:param,  encoding: URLEncoding.default, headers: header)
                  .responseJSON { response in
                     Common.hideBusy()
                      switch(response.result) {
                      case .success(_):
                          
                          if let val = response.value as? NSDictionary
                          {
                              print(val)
                             if let error_text = val.object(forKey: "error") as? NSDictionary {
                               complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""))
                              }
                              else{
                                   if let status = val.object(forKey: "status") as? Int
                                   {
                                       if  status == 200 {
                                           complete(true, nil)
                                       }
                                       else{
                                           complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                       }
                                   }
                                   else{
                                       complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                   }
                              }
                          }
                          break
                      case .failure(let error):
                          Common.hideBusy()
                          complete(false, ErrorManager.processError(error: error))
                      }
              }
       }
    
    func updatetransaction(_ param: Parameters, complete:@escaping (_ success: Bool, _ errer: ErrorModel?) ->Void)
    {
        Common.showBusy()
        let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
        print(header)
        print("PARAM --->",param)
        manager.request(URL.init(string: "\(URL_SERVER)kycaml/updatetransaction")!, method: .post, parameters:param,  encoding: URLEncoding.default, headers: header)
               .responseJSON { response in
                  Common.hideBusy()
                   switch(response.result) {
                   case .success(_):
                       
                       if let val = response.value as? NSDictionary
                       {
                           print(val)
                          if let error_text = val.object(forKey: "error") as? NSDictionary {
                            complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""))
                           }
                           else{
                                if let status = val.object(forKey: "statusCode") as? Int
                                {
                                    if  status == 200 {
                                        complete(true, nil)
                                    }
                                    else{
                                        complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                    }
                                }
                                else{
                                    complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                }
                           }
                       }
                       break
                   case .failure(let error):
                       Common.hideBusy()
                       complete(false, ErrorManager.processError(error: error))
                   }
           }
    }
    func updatetransactionAmpAsBuyer(_ param: Parameters, complete:@escaping (_ success: Bool, _ errer: ErrorModel?) ->Void)
   {
      print("param------------->",param)
        Common.showBusy()
        let url = URL(string: "\(URL_SERVER)kycaml/updateamptransaction")
        var request = URLRequest(url: url!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.httpBody = try! JSONSerialization.data(withJSONObject: param, options: [])

          Alamofire.request(request).responseJSON { (response) in
           print(response)
               Common.hideBusy()
              switch response.result {
              case .success:
                    if let val = response.value as? NSDictionary
                   {
                       
                      if let error_text = val.object(forKey: "error") as? NSDictionary {
                        complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""))
                       }
                       else{
                            if let status = val.object(forKey: "statusCode") as? Int
                            {
                                if  status == 200 {
                                    complete(true, nil)
                                }
                                else{
                                    complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                }
                            }
                            else{
                                complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                            }
                       }
                   }
                  break
              case .failure(let error):
                  Common.hideBusy()
                  print(response)
                  complete(false, ErrorManager.processError(error: error))
                  break
              }
          }
   }
    
    
    func sellerProcess(_ param: Parameters, complete:@escaping (_ success: Bool, _ errer: ErrorModel?) ->Void)
    {
        Common.showBusy()
       
        let url = URL(string: "\(URL_SERVER)kycaml/updatetransaction")
       var request = URLRequest(url: url!)
       request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")", forHTTPHeaderField: "Authorization")
       request.httpMethod = "POST"
       request.httpBody = try! JSONSerialization.data(withJSONObject: param, options: [])

       Alamofire.request(request).responseJSON { (response) in
        print(response)
            Common.hideBusy()
           switch response.result {
           case .success:
                 if let val = response.value as? NSDictionary
                {
                    
                   if let error_text = val.object(forKey: "error") as? NSDictionary {
                     complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""))
                    }
                    else{
                         if let status = val.object(forKey: "statusCode") as? Int
                         {
                             if  status == 200 {
                                 complete(true, nil)
                             }
                             else{
                                 complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                             }
                         }
                         else{
                             complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                         }
                    }
                }
               break
           case .failure(let error):
               Common.hideBusy()
               print(response)
               complete(false, ErrorManager.processError(error: error))
               break
           }
       }
    }
    
    //updatetransaction
    func fromios(_ param: [String: Any], complete:@escaping (_ success: Bool, _ errer: ErrorModel?) ->Void)
    {
        Common.showBusy()
        let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
        print(header)
        //print("PARAM --->",param)
        manager.request(URL.init(string: "https://artpass.id/api/data/fromios")!, method: .post, parameters:param,  encoding: URLEncoding.default, headers: header)
               .responseJSON { response in
                print(response)
                  Common.hideBusy()
                   switch(response.result) {
                   case .success(_):
                       
                       if let val = response.value as? NSDictionary
                       {
                         // print("VAL --->",val)
                       }
                       break
                   case .failure(let error):
                       Common.hideBusy()
                       complete(false, ErrorManager.processError(error: error))
                   }
           }
    }
    
    func fromios1(_ param: NSDictionary, complete:@escaping (_ success: Bool, _ errer: ErrorModel?) ->Void)
    {
        Common.showBusy()
        let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
        print(header)
        //print("PARAM --->",param)
        manager.request(URL.init(string: "https://artpass.id/api/data/fromios")!, method: .post, parameters:param as! Parameters,  encoding: URLEncoding.default, headers: header)
               .responseJSON { response in
                print(response)
                  Common.hideBusy()
                   switch(response.result) {
                   case .success(_):
                       
                       if let val = response.value as? NSDictionary
                       {
                         // print("VAL --->",val)
                       }
                       break
                   case .failure(let error):
                       Common.hideBusy()
                       complete(false, ErrorManager.processError(error: error))
                   }
           }
    }
    
    func uploadImageFileBuyerAmpAndSeller(_param: Parameters, _ image: UIImage, complete:@escaping (_ success: Bool?,_ errer: ErrorModel?) ->Void)
    {
    
        let header: HTTPHeaders    = ["Content-Type": "multipart/form-data", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
        let URL2 = try! URLRequest(url: URL.init(string: "\(URL_SERVER)kycaml/amptransaction")! , method: .post, headers: header)
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(image.jpegData(compressionQuality: 0.5)!, withName: "imgFile", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")

                for (key, value) in _param {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
                }
                
            }, with: URL2, encodingCompletion: { (result) in
                
                switch result {
                case .success(let upload, _, _):
                    
                    upload.responseJSON{
                        response in
                        //Common.hideBusy()
                        print("response-->",response)
                        if let data = response.result.value{
                            print("Data",data)
                            DispatchQueue.main.async {
                                if(response.response?.statusCode == 200){
                                   // callback(true, JSON(data), JSON((response.response?.statusCode)!))
                                    complete(true, nil)
                                } else{
                                    //callback(false, JSON(data), JSON((response.response?.statusCode)!))
                                    complete(false, ErrorManager.processError(error: response.error))
                                }
                            }
                        }
                        else{
                           complete(false, ErrorManager.processError(error: response.error))
                        }
                    }
                    
                case .failure(let encodingError):
                    print(encodingError)
                    DispatchQueue.main.async {
                        complete(false, ErrorManager.processError(error: encodingError))
                       // callback(false,JSON(self.getStatusCodeString(408)),JSON(408))
                    }
                    
                }
                
            })
        
    }
    func checkUserNameBuyer( param: Parameters, _ complete:@escaping (_ success: Bool, _ val: NSDictionary?, _ message: String?) ->Void)
    {
          Common.showBusy()
           let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
           print(header)
             manager.request(URL.init(string: "\(URL_SERVER)kycaml/checkusername")!, method: .post, parameters:param,  encoding: URLEncoding.default, headers: header)
                 .responseJSON { response in
                     print(response)
                    Common.hideBusy()
                     switch(response.result) {
                     case .success(_):
                         
                         if let val = response.value as? NSDictionary
                         {
                            if let status = val.object(forKey: "statusCode") as? Int
                            {
                                if  status == 200 {
                                    complete(true, val, nil)
                                }
                                else{
                                    if let error = val.object(forKey: "error") as? NSDictionary
                                    {
                                        complete(false, nil, error.object(forKey: "message") as? String)
                                    }
                                    else{
                                        complete(false, nil, MSG_ERROR.ERROR_SERVER)
                                    }
                                }
                            }
                            else{
                                if let error = val.object(forKey: "error") as? NSDictionary
                                {
                                    complete(false, nil, error.object(forKey: "message") as? String)
                                }
                                else{
                                    complete(false, nil, MSG_ERROR.ERROR_SERVER)
                                }
                            }
                         }
                         break
                     case .failure(let error):
                         Common.hideBusy()
                         complete(false, nil, error.localizedDescription)
                     }
             }
      }
    func rejectTransaction(_ transacId: String, complete:@escaping (_ success: Bool, _ errer: ErrorModel?) ->Void)
    {
        Common.showBusy()
        let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
        print(header)
        manager.request(URL.init(string: "\(URL_SERVER)kycaml/rejectRq/\(transacId)")!, method: .post, parameters:nil,  encoding: URLEncoding.default, headers: header)
               .responseJSON { response in
                  Common.hideBusy()
                   switch(response.result) {
                   case .success(_):
                       
                       if let val = response.value as? NSDictionary
                       {
                           print(val)
                          if let error_text = val.object(forKey: "error") as? NSDictionary {
                            complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""))
                           }
                           else{
                                if let status = val.object(forKey: "statusCode") as? Int
                                {
                                    if  status == 200 {
                                        complete(true, nil)
                                    }
                                    else{
                                        complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                    }
                                }
                                else{
                                    complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                }
                           }
                       }
                       break
                   case .failure(let error):
                       Common.hideBusy()
                       complete(false, ErrorManager.processError(error: error))
                   }
           }
    }
  
    func rejectProfile(_ transacId: String, _ transactType: String, complete:@escaping (_ success: Bool, _ errer: ErrorModel?) ->Void)
    {
        Common.showBusy()
        let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
       
        let param = ["transactType": transactType]
         print("param --->",param)
          print("URL --->","\(URL_SERVER)kycaml/rejectRq/\(transacId)")
        manager.request(URL.init(string: "\(URL_SERVER)kycaml/rejectRq/\(transacId)")!, method: .post, parameters:param,  encoding: URLEncoding.default, headers: header)
               .responseJSON { response in
                   print(response)
                  Common.hideBusy()
                   switch(response.result) {
                   case .success(_):
                       
                       if let val = response.value as? NSDictionary
                       {
                           print(val)
                          if let error_text = val.object(forKey: "error") as? NSDictionary {
                            complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""))
                           }
                           else{
                                if let status = val.object(forKey: "status") as? Int
                                {
                                    if  status == 200 {
                                        complete(true, nil)
                                    }
                                    else{
                                        complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                    }
                                }
                                else{
                                    complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                }
                           }
                       }
                       break
                   case .failure(let error):
                       Common.hideBusy()
                       complete(false, ErrorManager.processError(error: error))
                   }
           }
    }
    
    func getTransactionAmp(_ url: String, complete:@escaping (_ success: Bool, _ obj: NSDictionary?,_ errer: ErrorModel?) ->Void)
      {
             Common.showBusy()
              let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
          print("Header --->", header)
             manager.request(URL.init(string: url)!, method: .get, parameters: nil,  encoding: URLEncoding.default, headers: header)
                 .responseJSON { response in
                     Common.hideBusy()
                     print(response)
                     switch(response.result) {
                     case .success(_):
                         
                      if let val = response.value as? NSDictionary
                       {
                          if (val.object(forKey: "error") as? String) != nil
                          {
                              complete(true ,nil, nil)
                          }
                          else{
                              complete(true ,val, nil)
                          }
                          
                           
                       }
                      break
                     case .failure(let error):
                         Common.hideBusy()
                         complete(false, nil, ErrorManager.processError(error: error))
                     }
             }
      }
    
    func adduser(_ param: Parameters, complete:@escaping (_ success: Bool, _ errer: ErrorModel?) ->Void)
    {
        print("param--->",param)
        Common.showBusy()
       
        let url = URL(string: "\(URL_SERVER)transaction-amp/adduser")
       var request = URLRequest(url: url!)
       request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")", forHTTPHeaderField: "Authorization")
       request.httpMethod = "POST"
       request.httpBody = try! JSONSerialization.data(withJSONObject: param, options: [])

       Alamofire.request(request).responseJSON { (response) in
        print(response)
            Common.hideBusy()
           switch response.result {
           case .success:
                 if let val = response.value as? NSDictionary
                {
                    
                   if let error_text = val.object(forKey: "error") as? NSDictionary {
                     complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""))
                    }
                    else{
                         if let status = val.object(forKey: "statusCode") as? Int
                         {
                             if  status == 200 {
                                 complete(true, nil)
                             }
                             else{
                                 complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                             }
                         }
                         else{
                             complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                         }
                    }
                }
               break
           case .failure(let error):
               Common.hideBusy()
               print(response)
               complete(false, ErrorManager.processError(error: error))
               break
           }
       }
    }
    func getNotifications(complete:@escaping (_ success: Bool, _ arrs: [NotificationObj]?) ->Void)
    {
        let url = "\(URL_SERVER)notifies"
        print("URL-->",url)
        let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
        print("Header --->", header)
        manager.request(URL.init(string: url)!, method: .get, parameters: nil,  encoding: URLEncoding.default, headers: header)
               .responseJSON { response in
                   print(response)
                    var arrNotifications = [NotificationObj]()
                   switch(response.result) {
                   case .success(_):
                       
                    if let val = response.value as? NSDictionary
                     {
                        if let data = val.object(forKey: "data") as? [NSDictionary] {
                            for item in data
                            {
                                arrNotifications.append(NotificationObj.init(item))
                            }
                            complete(true,arrNotifications)
                        }
                        else{
                            complete(true,arrNotifications)
                        }
                     }
                    else{
                        complete(true,arrNotifications)
                    }
                    break
                   case .failure( _):
                       complete(true, nil)
                   }
           }
    }
    
    func addReadNotification(_ notifyId: String, _ actType: String,_ id: String , complete:@escaping (_ success: Bool, _ errer: ErrorModel?) ->Void)
    {
        let param = ["isRead": true, "actType": actType, "_id": id] as [String : Any]
        print("param--->",param)
        let url = URL(string: "\(URL_SERVER)notifies/\(notifyId)")
        print("url--->",url)
       var request = URLRequest(url: url!)
       request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")", forHTTPHeaderField: "Authorization")
       request.httpMethod = "POST"
       request.httpBody = try! JSONSerialization.data(withJSONObject: param, options: [])

       Alamofire.request(request).responseJSON { (response) in
        print(response)
           switch response.result {
           case .success:
                 if let val = response.value as? NSDictionary
                {
                    
                   if let error_text = val.object(forKey: "error") as? NSDictionary {
                     complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""))
                    }
                    else{
                         if let status = val.object(forKey: "statusCode") as? Int
                         {
                             if  status == 200 {
                                 complete(true, nil)
                             }
                             else{
                                 complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                             }
                         }
                         else{
                             complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                         }
                    }
                }
               break
           case .failure(let error):
               print(response)
               complete(false, ErrorManager.processError(error: error))
               break
           }
       }
    }
    
    func createCddReportPP(complete:@escaping (_ success: Bool, _ errer: ErrorModel?, _ statusCode: Int) ->Void)
    {
        Common.showBusy()
        let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
        print(header)
        print(URL_CONNECT_REPORT)
        manager.request(URL.init(string: "\(URL_AVARTA)/cddreport/create")!, method: .post, parameters:nil,  encoding: URLEncoding.default, headers: header)
               .responseJSON { response in
                   print(response)
                  Common.hideBusy()
                   switch(response.result) {
                   case .success(_):
                       
                       if let val = response.value as? NSDictionary
                       {
                           print(val)
                          if let error_text = val.object(forKey: "error") as? NSDictionary {
                            complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""), response.response?.statusCode ?? 200)
                           }
                           else{
                                if let status = val.object(forKey: "status") as? Int
                                {
                                    if  status == 200 {
                                        complete(true, nil, response.response?.statusCode ?? 200)
                                    }
                                    else{
                                       if let error = val.object(forKey: "error") as? String{
                                             complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error), 500)
                                        }
                                        else{
                                             complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""), response.response?.statusCode ?? 200)
                                        }
                                    }
                                }
                                else{
                                   if let error = val.object(forKey: "error") as? String{
                                         complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error), 500)
                                    }
                                    else{
                                         complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""), response.response?.statusCode ?? 200)
                                    }
                                }
                           }
                       }
                       break
                   case .failure(let error):
                       Common.hideBusy()
                       complete(false, ErrorManager.processError(error: error), 500)
                   }
           }
    }
    
    func createCddReportBusiness(complete:@escaping (_ success: Bool, _ errer: ErrorModel?, _ statusCode: Int) ->Void)
    {
        Common.showBusy()
        let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
        print(header)
        print("\(URL_AVARTA)/profilereport/create")
        manager.request(URL.init(string: "\(URL_AVARTA)/profilereport/create")!, method: .post, parameters:nil,  encoding: URLEncoding.default, headers: header)
               .responseJSON { response in
                   print(response)
                  Common.hideBusy()
                   switch(response.result) {
                   case .success(_):
                       
                       if let val = response.value as? NSDictionary
                       {
                           print(val)
                          if let error_text = val.object(forKey: "error") as? NSDictionary {
                            complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""), response.response?.statusCode ?? 200)
                           }
                           else{
                                if let status = val.object(forKey: "status") as? Int
                                {
                                    if  status == 200 {
                                        complete(true, nil, response.response?.statusCode ?? 200)
                                    }
                                    else{
                                        if let error = val.object(forKey: "error") as? String{
                                             complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error), 500)
                                        }
                                        else{
                                             complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""), response.response?.statusCode ?? 200)
                                        }
                                    }
                                }
                                else{
                                   if let error = val.object(forKey: "error") as? String{
                                         complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error), 500)
                                    }
                                    else{
                                         complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""), response.response?.statusCode ?? 200)
                                    }
                                }
                           }
                       }
                       break
                   case .failure(let error):
                       Common.hideBusy()
                       complete(false, ErrorManager.processError(error: error), 500)
                   }
           }
    }
    
    
    func usersharecdd(_ param: Parameters, complete:@escaping (_ success: Bool, _ errer: ErrorModel?) ->Void)
    {
        Common.showBusy()
        let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
        print(header)
        print("PARAM --->",param)
        manager.request(URL.init(string: "\(URL_SERVER)user/sharecdd")!, method: .post, parameters:param,  encoding: URLEncoding.default, headers: header)
               .responseJSON { response in
                  Common.hideBusy()
                   switch(response.result) {
                   case .success(_):
                       
                       if let val = response.value as? NSDictionary
                       {
                           print(val)
                          if let error_text = val.object(forKey: "error") as? NSDictionary {
                            complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""))
                           }
                           else{
                                if let status = val.object(forKey: "status") as? Int
                                {
                                    if  status == 200 {
                                        complete(true, nil)
                                    }
                                    else{
                                        complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                    }
                                }
                                else{
                                    complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                }
                           }
                       }
                       break
                   case .failure(let error):
                       Common.hideBusy()
                       complete(false, ErrorManager.processError(error: error))
                   }
           }
    }
    
    func revokeAccess(_ param: Parameters, complete:@escaping (_ success: Bool, _ errer: ErrorModel?) ->Void)
    {
        Common.showBusy()
        let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
        print(header)
        print("PARAM --->",param)
        manager.request(URL.init(string: "\(URL_SERVER)user/revokecdd")!, method: .post, parameters:param,  encoding: URLEncoding.default, headers: header)
               .responseJSON { response in
                  Common.hideBusy()
                   switch(response.result) {
                   case .success(_):
                       
                       if let val = response.value as? NSDictionary
                       {
                           print(val)
                          if let error_text = val.object(forKey: "error") as? NSDictionary {
                            complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""))
                           }
                           else{
                                if let status = val.object(forKey: "status") as? Int
                                {
                                    if  status == 200 {
                                        complete(true, nil)
                                    }
                                    else{
                                        complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                    }
                                }
                                else{
                                    complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                }
                           }
                       }
                       break
                   case .failure(let error):
                       Common.hideBusy()
                       complete(false, ErrorManager.processError(error: error))
                   }
           }
    }
    
    func APINewConnection(_ id: String,_ action: String, complete:@escaping (_ success: Bool, _ errer: ErrorModel?, _ erroCode: Int?) ->Void)
    {
        Common.showBusy()
        let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
        print("URL--->","\(URL_SERVER)connect/\(id)/\(action)")
        manager.request(URL.init(string: "\(URL_SERVER)connect/\(id)/\(action)")!, method: .post, parameters:nil,  encoding: URLEncoding.default, headers: header)
               .responseJSON { response in
                  Common.hideBusy()
                   switch(response.result) {
                   case .success(_):
                       
                       if let val = response.value as? NSDictionary
                       {
                           print(val)
                          if let error_text = val.object(forKey: "error") as? NSDictionary {
                            complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""), error_text.object(forKey: "code") as? Int)
                           }
                           else{
                                if let status = val.object(forKey: "code") as? Int
                                {
                                    if  status == 200 {
                                        complete(true, nil, nil)
                                    }
                                    else{
                                        complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""), nil)
                                    }
                                }
                                else{
                                    complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""), nil)
                                }
                           }
                       }
                       break
                   case .failure(let error):
                       Common.hideBusy()
                       complete(false, ErrorManager.processError(error: error),nil)
                   }
           }
    }
    
    func requestCDDReport(_ param: Parameters, complete:@escaping (_ success: Bool, _ errer: ErrorModel?, _ erroCode: Int?) ->Void)
    {
        Common.showBusy()
        let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
        print("URL--->","\(URL_SERVER)user/requestCdd")
        print("PARAM --->",param)
        manager.request(URL.init(string: "\(URL_SERVER)user/requestCdd")!, method: .post, parameters:param,  encoding: URLEncoding.default, headers: header)
               .responseJSON { response in
                  Common.hideBusy()
                   switch(response.result) {
                   case .success(_):
                       
                       if let val = response.value as? NSDictionary
                       {
                           print(val)
                          if let error_text = val.object(forKey: "error") as? NSDictionary {
                            complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""), error_text.object(forKey: "code") as? Int)
                           }
                           else{
                                if let status = val.object(forKey: "status") as? Int
                                {
                                    if  status == 200 {
                                        complete(true, nil, nil)
                                    }
                                    else{
                                        complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""), nil)
                                    }
                                }
                                else{
                                    complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""), nil)
                                }
                           }
                       }
                       break
                   case .failure(let error):
                       Common.hideBusy()
                       complete(false, ErrorManager.processError(error: error),nil)
                   }
           }
    }
    
    
    func AcceptCDDRequest(_ param: Parameters, complete:@escaping (_ success: Bool, _ errer: ErrorModel?) ->Void)
    {
        Common.showBusy()
        let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
        print(header)
        print("PARAM --->",param)
        manager.request(URL.init(string: "\(URL_SERVER)user/acceptCdd")!, method: .post, parameters:param,  encoding: URLEncoding.default, headers: header)
               .responseJSON { response in
                  Common.hideBusy()
                   switch(response.result) {
                   case .success(_):
                       
                       if let val = response.value as? NSDictionary
                       {
                           print(val)
                          if let error_text = val.object(forKey: "error") as? NSDictionary {
                            complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""))
                           }
                           else{
                                if let status = val.object(forKey: "status") as? Int
                                {
                                    if  status == 200 {
                                        complete(true, nil)
                                    }
                                    else{
                                        complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                    }
                                }
                                else{
                                    complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                }
                           }
                       }
                       break
                   case .failure(let error):
                       Common.hideBusy()
                       complete(false, ErrorManager.processError(error: error))
                   }
           }
    }
    
    func RevokeCDDRequest(_ param: Parameters, complete:@escaping (_ success: Bool, _ errer: ErrorModel?) ->Void)
    {
        Common.showBusy()
        let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
        print(header)
        print("PARAM --->",param)
        manager.request(URL.init(string: "\(URL_SERVER)user/revokecdd")!, method: .post, parameters:param,  encoding: URLEncoding.default, headers: header)
               .responseJSON { response in
                  Common.hideBusy()
                   switch(response.result) {
                   case .success(_):
                       
                       if let val = response.value as? NSDictionary
                       {
                           print(val)
                          if let error_text = val.object(forKey: "error") as? NSDictionary {
                            complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""))
                           }
                           else{
                                if let status = val.object(forKey: "status") as? Int
                                {
                                    if  status == 200 {
                                        complete(true, nil)
                                    }
                                    else{
                                        complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                    }
                                }
                                else{
                                    complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                }
                           }
                       }
                       break
                   case .failure(let error):
                       Common.hideBusy()
                       complete(false, ErrorManager.processError(error: error))
                   }
           }
    }
    func RevokeTrandConn(_ param: Parameters, complete:@escaping (_ success: Bool, _ errer: ErrorModel?) ->Void)
    {
        Common.showBusy()
        let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
        print(header)
        print("PARAM --->",param)
        manager.request(URL.init(string: "\(URL_SERVER)user/remove-trade-conn")!, method: .post, parameters:param,  encoding: URLEncoding.default, headers: header)
               .responseJSON { response in
                  Common.hideBusy()
                   switch(response.result) {
                   case .success(_):
                       
                       if let val = response.value as? NSDictionary
                       {
                           print(val)
                          if let error_text = val.object(forKey: "error") as? NSDictionary {
                            complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""))
                           }
                           else{
                                if let status = val.object(forKey: "status") as? Int
                                {
                                    if  status == 200 {
                                        complete(true, nil)
                                    }
                                    else{
                                        complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                    }
                                }
                                else{
                                    complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                }
                           }
                       }
                       break
                   case .failure(let error):
                       Common.hideBusy()
                       complete(false, ErrorManager.processError(error: error))
                   }
           }
    }
    
    func changePin(_ para: Parameters, complete:@escaping (_ success: Bool, _ errer: ErrorModel?) ->Void)
    {
            print("PARAM -->",para)
            print("URL -->",URL_UPDATE_PROFILE)
        let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
           manager.request(URL.init(string: URL_CHANGEPASSWORD)!, method: .post, parameters: para,  encoding: URLEncoding.default, headers: header)
               .responseJSON { response in
                   print(response)
                   switch(response.result) {
                   case .success(_):
                       
                       if let val = response.value as? NSDictionary
                       {
                           print(val)
                          if let error_text = val.object(forKey: "error") as? NSDictionary {
                            complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""))
                           }
                           else{
                                if let status = val.object(forKey: "status") as? Int
                                {
                                    if  status == 200 {
                                       complete(true, nil)
                                    }
                                    else{
                                        complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                    }
                                }
                                else{
                                    complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                }
                           }
                       }
                       break
                   case .failure(let error):
                       Common.hideBusy()
                       complete(false, ErrorManager.processError(error: error))
                   }
           }
    }
    
    // NEW UI
    func RequestCDDAccessApplicantNetwork(_ secret_token: String, complete:@escaping (_ success: Bool, _ errer: ErrorModel?) ->Void)
    {
        Common.showBusy()
        let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
        print(header)
        let param = ["secret_token": secret_token]
        manager.request(URL.init(string: "\(URL_SERVER)user/revoke-amp-access")!, method: .post, parameters:param,  encoding: URLEncoding.default, headers: header)
               .responseJSON { response in
                  Common.hideBusy()
                   switch(response.result) {
                   case .success(_):
                       
                       if let val = response.value as? NSDictionary
                       {
                           print(val)
                          if let error_text = val.object(forKey: "error") as? NSDictionary {
                            complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""))
                           }
                           else{
                            if let status = val.object(forKey: "message") as? String
                            {
                                if  status == "ok" {
                                        complete(true, nil)
                                    }
                                    else{
                                        complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                    }
                                }
                                else{
                                    complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                }
                           }
                       }
                       break
                   case .failure(let error):
                       Common.hideBusy()
                       complete(false, ErrorManager.processError(error: error))
                   }
           }
    }
    
    func ApplicantAcceptRequestNetwork(_ secret_token: String, complete:@escaping (_ success: Bool, _ errer: ErrorModel?) ->Void)
    {
        Common.showBusy()
        let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
        print(header)
        let param = ["secret_token": secret_token]
        manager.request(URL.init(string: "\(URL_SERVER)user/app-accept-share-cdd")!, method: .post, parameters:param,  encoding: URLEncoding.default, headers: header)
               .responseJSON { response in
                  Common.hideBusy()
                   switch(response.result) {
                   case .success(_):
                       
                       if let val = response.value as? NSDictionary
                       {
                           print(val)
                          if let error_text = val.object(forKey: "error") as? NSDictionary {
                            complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""))
                           }
                           else{
                            if let status = val.object(forKey: "message") as? String
                            {
                                if  status == "ok" {
                                        complete(true, nil)
                                    }
                                    else{
                                        complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                    }
                                }
                                else{
                                    complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                }
                           }
                       }
                       break
                   case .failure(let error):
                       Common.hideBusy()
                       complete(false, ErrorManager.processError(error: error))
                   }
           }
    }
    
    func ApplicantRevokeAcceptCDDNetwork(_ secret_token: String, complete:@escaping (_ success: Bool, _ errer: ErrorModel?) ->Void)
    {
        Common.showBusy()
        let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
        print(header)
        let param = ["secret_token": secret_token]
        manager.request(URL.init(string: "\(URL_SERVER)user/remove-cdd-network")!, method: .post, parameters:param,  encoding: URLEncoding.default, headers: header)
               .responseJSON { response in
                  Common.hideBusy()
                   switch(response.result) {
                   case .success(_):
                       
                       if let val = response.value as? NSDictionary
                       {
                           print(val)
                          if let error_text = val.object(forKey: "error") as? NSDictionary {
                            complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""))
                           }
                           else{
                            if let status = val.object(forKey: "message") as? String
                            {
                                if  status == "ok" {
                                        complete(true, nil)
                                    }
                                    else{
                                        complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                    }
                                }
                                else{
                                    complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                }
                           }
                       }
                       break
                   case .failure(let error):
                       Common.hideBusy()
                       complete(false, ErrorManager.processError(error: error))
                   }
           }
    }
    
    
    func AMPRequestCDDNetwork(_ secret_token: String, complete:@escaping (_ success: Bool, _ errer: ErrorModel?) ->Void)
    {
        Common.showBusy()
        let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
        print(header)
        let param = ["secret_token": secret_token]
        manager.request(URL.init(string: "\(URL_SERVER)user/amp-rq-access-cdd")!, method: .post, parameters:param,  encoding: URLEncoding.default, headers: header)
               .responseJSON { response in
                  Common.hideBusy()
                   switch(response.result) {
                   case .success(_):
                       
                       if let val = response.value as? NSDictionary
                       {
                           print(val)
                          if let error_text = val.object(forKey: "error") as? NSDictionary {
                            complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""))
                           }
                           else{
                            if let status = val.object(forKey: "message") as? String
                            {
                                if  status == "ok" {
                                        complete(true, nil)
                                    }
                                    else{
                                        complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                    }
                                }
                                else{
                                    complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                }
                           }
                       }
                       break
                   case .failure(let error):
                       Common.hideBusy()
                       complete(false, ErrorManager.processError(error: error))
                   }
           }
    }
    
    
    func AMPAcceptRequestNetwork(_ secret_token: String, complete:@escaping (_ success: Bool, _ errer: ErrorModel?) ->Void)
    {
        Common.showBusy()
        let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
        print(header)
        let param = ["secret_token": secret_token]
        manager.request(URL.init(string: "\(URL_SERVER)user/accept-cdd-network")!, method: .post, parameters:param,  encoding: URLEncoding.default, headers: header)
               .responseJSON { response in
                  Common.hideBusy()
                   switch(response.result) {
                   case .success(_):
                       
                       if let val = response.value as? NSDictionary
                       {
                           print(val)
                          if let error_text = val.object(forKey: "error") as? NSDictionary {
                            complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""))
                           }
                           else{
                            if let status = val.object(forKey: "message") as? String
                            {
                                if  status == "ok" {
                                        complete(true, nil)
                                    }
                                    else{
                                        complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                    }
                                }
                                else{
                                    complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                }
                           }
                       }
                       break
                   case .failure(let error):
                       Common.hideBusy()
                       complete(false, ErrorManager.processError(error: error))
                   }
           }
    }
    
    func AMPRemoveCDDNetwork(_ secret_token: String, complete:@escaping (_ success: Bool, _ errer: ErrorModel?) ->Void)
    {
        Common.showBusy()
        let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
        print("\(URL_SERVER)user/remove-cdd-network")
        let param = ["secret_token": secret_token]
        manager.request(URL.init(string: "\(URL_SERVER)user/remove-cdd-network")!, method: .post, parameters:param,  encoding: URLEncoding.default, headers: header)
               .responseJSON { response in
                  Common.hideBusy()
                   switch(response.result) {
                   case .success(_):
                       
                       if let val = response.value as? NSDictionary
                       {
                           print(val)
                          if let error_text = val.object(forKey: "error") as? NSDictionary {
                            complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""))
                           }
                           else{
                                if let status = val.object(forKey: "message") as? String
                                {
                                    if  status == "ok" {
                                        complete(true, nil)
                                    }
                                    else{
                                        complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                    }
                                }
                                else{
                                    complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                }
                           }
                       }
                       break
                   case .failure(let error):
                       Common.hideBusy()
                       complete(false, ErrorManager.processError(error: error))
                   }
           }
    }
    
    
    func deleteCDDNetwork(_ dict: NSDictionary, complete:@escaping (_ success: Bool, _ errer: ErrorModel?) ->Void)
    {
        Common.showBusy()
        let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
        print("\(URL_SERVER)user/delete-cdd-network")
        manager.request(URL.init(string: "\(URL_SERVER)user/delete-cdd-network")!, method: .post, parameters:dict as! Parameters,  encoding: URLEncoding.default, headers: header)
               .responseJSON { response in
                  Common.hideBusy()
                   switch(response.result) {
                   case .success(_):
                       
                       if let val = response.value as? NSDictionary
                       {
                           print(val)
                          if let error_text = val.object(forKey: "error") as? NSDictionary {
                            complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""))
                           }
                           else{
                                if let status = val.object(forKey: "message") as? String
                                {
                                    if  status == "ok" {
                                        complete(true, nil)
                                    }
                                    else{
                                        complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                    }
                                }
                                else{
                                    complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                }
                           }
                       }
                       break
                   case .failure(let error):
                       Common.hideBusy()
                       complete(false, ErrorManager.processError(error: error))
                   }
           }
    }
    
    func updateShareCDDReport(_ para: Parameters, complete:@escaping (_ success: Bool, _ errer: ErrorModel?) ->Void)
    {
        let url = URL(string: URL_UPDATE_PROFILE)
        var request = URLRequest(url: url!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.httpBody = try! JSONSerialization.data(withJSONObject: para, options: [])

           Alamofire.request(request).responseJSON { (response) in
            print(response)
                Common.hideBusy()
               switch response.result {
               case .success:
                   if let val = response.value as? NSDictionary
                   {
                       print(val)
                      if let error_text = val.object(forKey: "error") as? NSDictionary {
                        complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""))
                       }
                       else{
                            if let status = val.object(forKey: "status") as? Int
                            {
                                if  status == 200 {
                                   complete(true, nil)
                                }
                                else{
                                    complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                }
                            }
                            else{
                                complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                            }
                       }
                   }
                   break
               case .failure(let error):
                   Common.hideBusy()
                   print(response)
                   complete(false, ErrorManager.processError(error: error))
                   break
               }
           }
        /*
            print("PARAM -->",para)
            print("URL -->",URL_UPDATE_PROFILE)
        let header: HTTPHeaders    = [ "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
           manager.request(URL.init(string: URL_UPDATE_PROFILE)!, method: .post, parameters: para,  encoding: URLEncoding.default, headers: header)
               .responseJSON { response in
                   print(response)
                   switch(response.result) {
                   case .success(_):
                       
                       if let val = response.value as? NSDictionary
                       {
                           print(val)
                          if let error_text = val.object(forKey: "error") as? NSDictionary {
                            complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""))
                           }
                           else{
                                if let status = val.object(forKey: "status") as? Int
                                {
                                    if  status == 200 {
                                       complete(true, nil)
                                    }
                                    else{
                                        complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                    }
                                }
                                else{
                                    complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                }
                           }
                       }
                       break
                   case .failure(let error):
                       Common.hideBusy()
                       complete(false, ErrorManager.processError(error: error))
                   }
           }*/
    }
    
    
    func turnOnOffsharing(_ req_id: String, complete:@escaping (_ success: Bool, _ errer: ErrorModel?) ->Void)
    {
        Common.showBusy()
        let header: HTTPHeaders    = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as? String ?? "")"]
        print(header)
        manager.request(URL.init(string: "\(URL_SERVER)connect/turn-on-off-sharing/\(req_id)")!, method: .post, parameters:nil,  encoding: URLEncoding.default, headers: header)
               .responseJSON { response in
                  Common.hideBusy()
                   switch(response.result) {
                   case .success(_):
                       
                       if let val = response.value as? NSDictionary
                       {
                           print(val)
                          if let error_text = val.object(forKey: "error") as? NSDictionary {
                            complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: error_text.object(forKey: "message") as? String ?? ""))
                           }
                           else{
                            if let status = val.object(forKey: "message") as? String
                            {
                                if  status == "ok" {
                                        complete(true, nil)
                                    }
                                    else{
                                        complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                    }
                                }
                                else{
                                    complete(false, ErrorManager.processError(error: nil, errorCode: nil, errorMsg: val.object(forKey: "message") as? String ?? ""))
                                }
                           }
                       }
                       break
                   case .failure(let error):
                       Common.hideBusy()
                       complete(false, ErrorManager.processError(error: error))
                   }
           }
    }
}


