//
//  MyProfileVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 2/24/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit

class MyProfileVC: UIViewController {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
     var imagePicker: UIImagePickerController!
    var isChangeAvatar = false
    @IBOutlet weak var subNotification: UIViewX!
    @IBOutlet weak var subNotificationPic: UIViewX!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isChangeAvatar
        {
            self.getUserInfo()
        }
        else{
            self.isChangeAvatar = false
        }
         if APP_DELEGATE.notificationChangeUserName != nil {
            self.subNotification.isHidden = false
       }
       else{
            self.subNotification.isHidden = true
       }
        if APP_DELEGATE.notificationChangeProfilePic != nil {
            self.subNotificationPic.isHidden = false
       }
       else{
            self.subNotificationPic.isHidden = true
       }
        if UserDefaults.standard.bool(forKey: KEY_NOTIFICATION_SETTING) {
                          
           if APP_DELEGATE.notificationChangeUserName != nil && APP_DELEGATE.notificationChangeProfilePic != nil {
               self.tabBarController?.tabBar.items![3].badgeValue = "3"
           }
           else{
               if APP_DELEGATE.notificationChangeUserName != nil{
                   self.tabBarController?.tabBar.items![3].badgeValue = "2"
               }
               else  if APP_DELEGATE.notificationChangeProfilePic != nil{
                   self.tabBarController?.tabBar.items![3].badgeValue = "2"
               }
               else{
                   self.tabBarController?.tabBar.items![3].badgeValue = "1"
               }
           }
           
           
       }
       else{
           if APP_DELEGATE.notificationChangeUserName != nil && APP_DELEGATE.notificationChangeProfilePic != nil {
               self.tabBarController?.tabBar.items![3].badgeValue = "2"
           }
           else{
               if APP_DELEGATE.notificationChangeUserName != nil{
                   self.tabBarController?.tabBar.items![3].badgeValue = "1"
               }
               else  if APP_DELEGATE.notificationChangeProfilePic != nil{
                   self.tabBarController?.tabBar.items![3].badgeValue = "1"
               }
               else{
                   self.tabBarController?.tabBar.items![3].badgeValue = nil
               }
           }
       }
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Common.hideBusy()
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
    @IBAction func doEditAvatar(_ sender: Any) {
        self.isChangeAvatar = true
        if let btn = sender as? UIButton{
            self.showPhotoAndLibrary(btn)
        }
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imgAvatar.layer.cornerRadius = self.imgAvatar.frame.size.width/2
        self.imgAvatar.layer.masksToBounds = true
    }
}
extension MyProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true) {
            
        }
    }
    
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)

        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {
            self.imgAvatar.image = image
            //ApiHelper.shared.updateAvatar(self.imgAvatar.image) { (success, error) in
                
            //}
            let data = image.jpegData(compressionQuality: 0.8)
            
            ApiHelper.shared.updateAvatar(UIImage.init(data: data!) ?? image) { (success, error) in
                self.subNotificationPic.isHidden = true
                  self.readNotification()
                  if UserDefaults.standard.bool(forKey: KEY_NOTIFICATION_SETTING) {
                                           
                    if APP_DELEGATE.notificationChangeUserName != nil && APP_DELEGATE.notificationChangeProfilePic != nil {
                        self.tabBarController?.tabBar.items![3].badgeValue = "3"
                    }
                    else{
                        if APP_DELEGATE.notificationChangeUserName != nil{
                            self.tabBarController?.tabBar.items![3].badgeValue = "2"
                        }
                        else  if APP_DELEGATE.notificationChangeProfilePic != nil{
                            self.tabBarController?.tabBar.items![3].badgeValue = "2"
                        }
                        else{
                            self.tabBarController?.tabBar.items![3].badgeValue = "1"
                        }
                    }
                    
                    
                }
                else{
                    if APP_DELEGATE.notificationChangeUserName != nil && APP_DELEGATE.notificationChangeProfilePic != nil {
                        self.tabBarController?.tabBar.items![3].badgeValue = "2"
                    }
                    else{
                        if APP_DELEGATE.notificationChangeUserName != nil{
                            self.tabBarController?.tabBar.items![3].badgeValue = "1"
                        }
                        else  if APP_DELEGATE.notificationChangeProfilePic != nil{
                            self.tabBarController?.tabBar.items![3].badgeValue = "1"
                        }
                        else{
                            self.tabBarController?.tabBar.items![3].badgeValue = nil
                        }
                    }
                }
            }
            
            
//            let base64Face = "data:image/png;base64," + data!.base64EncodedString()
//            ApiHelper.shared.updateProfile(["avatar": base64Face]) { (success, error) in
//
//            }
        }
    }
    func readNotification(){
        if let notiObj = APP_DELEGATE.notificationChangeProfilePic{
            ApiHelper.shared.addReadNotification(notiObj.notifyId, "profile_pic_changing", notiObj.id) { (success, error) in
                                  
            }
            APP_DELEGATE.notificationChangeProfilePic = nil
        }
       
    }
}

extension MyProfileVC
{
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
    
    func showPhotoAndLibrary(_ sender: UIButton)
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
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = sender
            //popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        }
        self.present(alert, animated: true) {
            
        }
    }
  
    private func getUserInfo()
    {
        ApiHelper.shared.getUserInfo { (success,obj, error) in
            if let profileObj = obj
            {
                APP_DELEGATE.profileObj = profileObj
                self.lblName.text =  profileObj.fname + " " + profileObj.lname
                self.lblEmail.text = profileObj.email
                self.lblPhone.text = profileObj.phone
                self.lblUserName.text  = "@"

                if let location = profileObj.location.object(forKey: "street") as? NSDictionary{
                    let streetName = location.object(forKey: "name") as? String
                    let country = (profileObj.location.object(forKey: "country") as? NSDictionary)?.object(forKey: "name") as? String
                    let city = profileObj.location.object(forKey: "city") as? String
                    let zipcode = profileObj.location.object(forKey: "zipcode") as? String
                    self.lblAddress.text =  "\(streetName ?? "")\n\(zipcode ?? "") \(city ?? "")\n\(country ?? "")"
                }
                else{
                    let streetName = profileObj.location.object(forKey: "street") as? String
                    let country = profileObj.location.object(forKey: "country") as? String
                    let city = profileObj.location.object(forKey: "town") as? String
                    let zipcode = profileObj.location.object(forKey: "postCode") as? String
                    self.lblAddress.text =  "\(streetName ?? "")\n\(zipcode ?? "") \(city ?? "")\n\(country ?? "")"
                }
                
                self.lblUserName.text = "@" + profileObj.username
                if profileObj.avatar.count > 0
                {
                   // self.imgAvatar.image = Common.convertBase64ToImage(profileObj.avatar)
                    Common.loadAvatarFromServer(profileObj.avatar, self.imgAvatar)
                }
            }
        }
    }
}
