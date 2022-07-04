//
//  ResultViewController.swift
//  SampleApp
//
//  Created by Tapas Behera on 7/12/18.
//  Copyright © 2018 com.acuant. All rights reserved.
//

import UIKit
import AcuantImagePreparation

class ResultViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var frontImage: UIImageView!
    @IBOutlet var backImage: UIImageView!
    @IBOutlet var faceImage: UIImageView!
    @IBOutlet var signImage: UIImageView!
    @IBOutlet weak var spaceTblData: NSLayoutConstraint!
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         if let savedItem = UserDefaults.standard.object(forKey: KACUANT) as? Data
         {
                if let acuantObj = NSKeyedUnarchiver.unarchiveObject(with: savedItem) as? AcuantObj
                {
                    APP_DELEGATE.acuantObj = acuantObj
                     if(APP_DELEGATE.acuantObj.frontImageUrl != nil){
                        if let image = UserDefaults.standard.value(forKey: kImageFront) as? Data
                        {
                            frontImage.image = UIImage.init(data: image)
                        }
                        else{
                            frontImage.downloadedFrom(urlStr: APP_DELEGATE.acuantObj.frontImageUrl!, username: APP_DELEGATE.acuantObj.username!, password: APP_DELEGATE.acuantObj.password!, index: 1)
                        }
                        
                    }
                    if(APP_DELEGATE.acuantObj.backImageUrl != nil){
                        if let image = UserDefaults.standard.value(forKey: kImageBack) as? Data
                        {
                            backImage.image = UIImage.init(data: image)
                        }
                        else{
                              backImage.downloadedFrom(urlStr: APP_DELEGATE.acuantObj.backImageUrl!, username: APP_DELEGATE.acuantObj.username!, password: APP_DELEGATE.acuantObj.password!, index: 2)
                        }
                      
                    }
                    
                    if(APP_DELEGATE.acuantObj.faceImageUrl != nil){
                        if let image = UserDefaults.standard.value(forKey: kImageFace) as? Data
                        {
                            faceImage.image = UIImage.init(data: image)
                        }
                        else{
                            faceImage.downloadedFrom(urlStr: APP_DELEGATE.acuantObj.faceImageUrl!, username: APP_DELEGATE.acuantObj.username!, password: APP_DELEGATE.acuantObj.password!, index: 3)
                        }
                        
                    }
                    
                    if(APP_DELEGATE.acuantObj.signImageUrl != nil){
                        if let image = UserDefaults.standard.value(forKey: kImageSign) as? Data
                        {
                            signImage.image = UIImage.init(data: image)
                            self.spaceTblData.constant = 84
                        }
                        else{
                             signImage.downloadedFrom(urlStr: APP_DELEGATE.acuantObj.signImageUrl!, username: APP_DELEGATE.acuantObj.username!, password: APP_DELEGATE.acuantObj.password!, index: 4)
                        }
                       
                    }
                    else{
                        self.spaceTblData.constant = 20
                    }
                    
//                    if(APP_DELEGATE.acuantObj.front != nil){
//                        frontImage.image = APP_DELEGATE.acuantObj.front
//                    }
//
//                    if(APP_DELEGATE.acuantObj.back != nil){
//                        backImage.image = APP_DELEGATE.acuantObj.back
//                    }
                }
        }
         
       
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(APP_DELEGATE.acuantObj.data == nil){
            return 0
        }
        return APP_DELEGATE.acuantObj.data!.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.text = APP_DELEGATE.acuantObj.data?[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont.init(name: "Roboto-Regular", size: 17.0)
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension UIImageView {
    func downloadedFrom(urlStr:String,username:String,password:String, index: Int) {
        let loginData = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
        let base64LoginData = loginData.base64EncodedString()
        print(loginData)
        // create the request
        let url = URL(string: urlStr)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Basic \(base64LoginData)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            print(error)
            print(response)
            let httpURLResponse = response as? HTTPURLResponse
            if(httpURLResponse?.statusCode == 200){
                let downloadedImage = UIImage(data: data!)
                if index == 1
                {
                    UserDefaults.standard.setValue(data!, forKey: kImageFront)
                }
                else if index == 2
                {
                    UserDefaults.standard.setValue(data!, forKey: kImageBack)
                }
                else if index == 3
                {
                    UserDefaults.standard.setValue(data!, forKey: kImageFace)
                }
                else{
                    UserDefaults.standard.setValue(data!, forKey: kImageSign)
                    
                }
                UserDefaults.standard.synchronize()
                DispatchQueue.main.async() { () -> Void in
                    self.image = downloadedImage
                    self.isHidden=false;
                }
            }else {
                return
            }
            }.resume()
    }
    
}
