//
//  MyPassIDVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 2/7/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit

class MyPassIDVC: UIViewController {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var imgQrCode: UIImageView!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var lblConnectID: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        imgAvatar.layer.cornerRadius = imgAvatar.frame.size.width/2
        imgAvatar.layer.masksToBounds = true
        self.getUserInfo()
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

    @IBAction func doBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension MyPassIDVC
{
    private func getUserInfo()
    {
        self.lblConnectID.text = ""
        viewContent.isHidden = true
        ApiHelper.shared.getUserInfo { (success,obj, error) in
            self.viewContent.isHidden = false
            if let profileObj = obj
            {
                APP_DELEGATE.profileObj = profileObj
                if profileObj.avatar.count > 0
                {
                   //self.imgAvatar.image = Common.convertBase64ToImage(profileObj.avatar)
                    Common.loadAvatarFromServer(profileObj.avatar, self.imgAvatar)
                }
                let url = "\(URL_AVARTA)/connectreport/\(profileObj._id)"
                self.imgQrCode.image = self.createQRFromString(url, size: CGSize(width: self.imgQrCode.frame.size.width * 2, height: self.imgQrCode.frame.size.height * 2))
                if let connectRp = profileObj.connectRp
                {
                    if let code = connectRp.object(forKey: "code") as? String
                    {
                        self.lblConnectID.text = "MY ARTPASS ID #\(code)"
                    }
                }
            }
        }
    }
    func createQRFromString(_ str: String, size: CGSize) -> UIImage {
        let stringData = str.data(using: .utf8)

      let qrFilter = CIFilter(name: "CIQRCodeGenerator")!
      qrFilter.setValue(stringData, forKey: "inputMessage")
      qrFilter.setValue("H", forKey: "inputCorrectionLevel")

      let minimalQRimage = qrFilter.outputImage!
      // NOTE that a QR code is always square, so minimalQRimage..width === .height
      let minimalSideLength = minimalQRimage.extent.width

      let smallestOutputExtent = (size.width < size.height) ? size.width : size.height
      let scaleFactor = smallestOutputExtent / minimalSideLength
      let scaledImage = minimalQRimage.transformed(
        by: CGAffineTransform(scaleX: scaleFactor, y: scaleFactor))

      return UIImage(ciImage: scaledImage,
                     scale: UIScreen.main.scale,
                     orientation: .up)
    }
    
}
