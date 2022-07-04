//
//  RegisterStep3VC.swift
//  ArtPassID
//
//  Created by QTS Coder on 4/19/19.
//  Copyright © 2019 QTS Coder. All rights reserved.
//

import UIKit

class RegisterStep3VC: UIViewController {
    var imagePickerController: UIImagePickerController!
    @IBOutlet weak var btnAvatar: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func doBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func doAvatar(_ sender: Any) {
        let alertController = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraOk = UIAlertAction.init(title: "Take a photo", style: .default) { (action) in
            self.openCamera()
        }
        alertController.addAction(cameraOk)
        
        let library = UIAlertAction.init(title: "Choose from library", style: .default) { (action) in
            self.openLibray()
        }
        alertController.addAction(library)
        
        let cancel = UIAlertAction.init(title: "Cancel", style: .cancel) { (action) in
            
        }
        alertController.addAction(cancel)
        if let presenter = alertController.popoverPresentationController {
            presenter.sourceView = btnAvatar
            presenter.sourceRect = btnAvatar.bounds
        }
        self.present(alertController, animated: true) {
            
        }
    }
    
    func openLibray()
    {
        imagePickerController = UIImagePickerController.init()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController = UIImagePickerController.init()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .camera
            imagePickerController.allowsEditing = true
            
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    @IBAction func doContinue(_ sender: Any) {
        //let vc = STORYBOARD_MainSDK.instantiateViewController(withIdentifier: "RootViewController") as! RootViewController
        //self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension RegisterStep3VC: UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.btnAvatar.setBackgroundImage(image, for: .normal)
        }
        picker.dismiss(animated: true) {
            
        }
    }
}
