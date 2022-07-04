//
//  NewTransaction3VC.swift
//  ArtPassID
//
//  Created by QTS Coder on 3/2/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit
import MobileCoreServices
import Photos
import AssetsLibrary
class NewTransaction3VC: UIViewController {
     var imagePicker: UIImagePickerController!
    @IBOutlet weak var imgPicture: UIImageView!
    var isUpload = false
    var username = ""
    var refenceNumber = ""
    var desc = ""
    var message = ""
    var fileUrl: URL?
    @IBOutlet weak var lblFIle: UILabel!
    var isFileDocument = false
    var imageDocument: UIImage?
    @IBOutlet weak var imgDocument: UIImageView!
    @IBOutlet weak var heightImgDocument: NSLayoutConstraint!
    @IBOutlet weak var lblOption: UILabel!
    @IBOutlet weak var viewOption: UIView!
    var isSellerAmpBuyer = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.heightImgDocument.constant = 0
        if self.isSellerAmpBuyer
        {
            self.lblOption.isHidden = true
            self.viewOption.isHidden = true
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func doTakeAPicture(_ sender: Any) {
        self.isUpload = false
        let documentPicker = UIDocumentMenuViewController(documentTypes: [(kUTTypeImage as String)], in: .import)
        documentPicker.addOption(withTitle: "From Library", image: #imageLiteral(resourceName: "library_image"), order: .first) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            imagePicker.mediaTypes = [kUTTypeImage as String]
            DispatchQueue.main.async {
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        documentPicker.addOption(withTitle: "Take a Picture", image: #imageLiteral(resourceName: "library_camera"), order: .first) {
            let videoPicker = UIImagePickerController()
            videoPicker.delegate = self
            videoPicker.sourceType = .camera
            videoPicker.mediaTypes = [kUTTypeImage as String]
            DispatchQueue.main.async {
                self.present(videoPicker, animated: true, completion: nil)
            }
        }
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    @IBAction func doUpload(_ sender: Any) {
        self.isUpload = true
        let documentPicker = UIDocumentMenuViewController(documentTypes: [(kUTTypePDF as String), (kUTTypeImage as String)], in: .import)
        documentPicker.addOption(withTitle: "From Library", image: #imageLiteral(resourceName: "library_image"), order: .first) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            imagePicker.mediaTypes = [kUTTypeImage as String]
            DispatchQueue.main.async {
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        documentPicker.addOption(withTitle: "Take a Picture", image: #imageLiteral(resourceName: "library_camera"), order: .first) {
            let videoPicker = UIImagePickerController()
            videoPicker.delegate = self
            videoPicker.sourceType = .camera
            videoPicker.mediaTypes = [kUTTypeImage as String]
            DispatchQueue.main.async {
                self.present(videoPicker, animated: true, completion: nil)
            }
        }
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        self.present(documentPicker, animated: true, completion: nil)
    }
    @IBAction func doCounnite(_ sender: Any) {
        if self.isSellerAmpBuyer {
         if self.imgPicture.image == nil
          {
              APP_DELEGATE.showAlert(MSG_ERROR.ERROR_PICTURE)
              return
          }
          APP_DELEGATE.createObj.picture = self.imgPicture.image!
          if self.isFileDocument {
              if self.fileUrl != nil
              {
                  APP_DELEGATE.createObj.iamgeDoc = nil
                  APP_DELEGATE.createObj.fileUrl = self.fileUrl
              }
          }
          else{
              if self.imgDocument.image != nil
              {
                  APP_DELEGATE.createObj.fileUrl = nil
                  APP_DELEGATE.createObj.iamgeDoc = self.imgDocument.image
                  //APP_DELEGATE.showAlert(MSG_ERROR.ERROR_DOCUMENT)
                  //return
              }
          }
            let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "ArtworkReportStep4VC") as! ArtworkReportStep4VC
            vc.isSellerAmpBuyer = self.isSellerAmpBuyer
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            if self.imgPicture.image == nil
            {
                APP_DELEGATE.showAlert(MSG_ERROR.ERROR_PICTURE)
                return
            }
            APP_DELEGATE.createObj.picture = self.imgPicture.image!
            if self.isFileDocument {
                if self.fileUrl != nil
                {
                    APP_DELEGATE.createObj.iamgeDoc = nil
                    APP_DELEGATE.createObj.fileUrl = self.fileUrl
                }
            }
            else{
                if self.imgDocument.image != nil
                {
                    APP_DELEGATE.createObj.fileUrl = nil
                    APP_DELEGATE.createObj.iamgeDoc = self.imgDocument.image
                    //APP_DELEGATE.showAlert(MSG_ERROR.ERROR_DOCUMENT)
                    //return
                }
            }
            
            let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "ArtworkReportStep4VC") as! ArtworkReportStep4VC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @objc func redirectHome()
    {
        APP_DELEGATE.isRedirectActivity = true
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func doBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func showCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
        
    }
}
extension NewTransaction3VC: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true) {
            
        }
    }
    
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)

        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            if !self.isUpload {
                 self.imgPicture.image = image
            }
            else{
                self.isFileDocument = false
                self.imgDocument.image = image
                self.heightImgDocument.constant = 80
                self.lblFIle.text = ""
            }
           
        }
    }
}
extension NewTransaction3VC: UIDocumentMenuDelegate, UIDocumentPickerDelegate {
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        self.present(documentPicker, animated: true, completion: nil)
    }
    //durationSeconds
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        if !self.isUpload {
            do {
                let jsonData = try Data(contentsOf: url, options: .mappedIfSafe)
                self.imgPicture.image = UIImage.init(data: jsonData)
            } catch {
                print(error)
            }
        }
        else{
            self.isFileDocument = true
            self.lblFIle.text = url.lastPathComponent
            self.fileUrl = url
            self.imgDocument.image = nil
            self.heightImgDocument.constant = 0
        }
        
    }
    
}
