//
//  ArtworkReportStep4VC.swift
//  ArtPassID
//
//  Created by QTS Coder on 5/11/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit

class ArtworkReportStep4VC: UIViewController {

    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblNote: UILabel!
    @IBOutlet weak var lblFile: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var viewSuccess: UIView!
    var isSellerAmpBuyer = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
         self.viewSuccess.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func doBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateUI()
    {
        if self.isSellerAmpBuyer {
            self.btnContinue.setTitle("REQUEST SELLER REPORT", for: .normal)
        }
        self.imgPicture.image = APP_DELEGATE.createObj.picture
        self.lblName.text = APP_DELEGATE.createObj.artistName
        self.lblTitle.text = APP_DELEGATE.createObj.titleWork
        self.lblNote.text = "\(APP_DELEGATE.createObj.signature)\n\(APP_DELEGATE.createObj.medium)\n\(APP_DELEGATE.createObj.dimesion)\n\(APP_DELEGATE.createObj.dateCreate)\n"
        if APP_DELEGATE.createObj.fileUrl != nil {
            self.lblFile.text = APP_DELEGATE.createObj.fileUrl!.lastPathComponent
        }
        else{
            self.lblFile.text = ""
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func doEdit(_ sender: Any) {
        let viewControllers = self.navigationController!.viewControllers as [UIViewController]
        for aViewController:UIViewController in viewControllers {
            if aViewController.isKind(of: ArtworkReportVC.self) {
                _ = self.navigationController?.popToViewController(aViewController, animated: true)
            }
        }
    }
    
    @IBAction func doContinue(_ sender: Any) {
        if self.isSellerAmpBuyer {
            self.callAPI()
            /*self.viewSuccess.isHidden = false
            self.tabBarController?.tabBar.isHidden = true
            self.perform(#selector(self.redirectHome), with: nil, afterDelay: TIME_OUT)*/
        }
        else{
            let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "ArtworkReportStep5VC") as! ArtworkReportStep5VC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func redirectHome()
    {
        APP_DELEGATE.isRedirectActivity = true
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func callAPI()
    {
        
        let param = ["unamebuyer": APP_DELEGATE.createObj.username.lowercased(),"refnum": APP_DELEGATE.createObj.refNumber, "desc": APP_DELEGATE.createObj.desc , "artistName": APP_DELEGATE.createObj.artistName ,"workTitle": APP_DELEGATE.createObj.titleWork,"mediumWork": APP_DELEGATE.createObj.medium,"materials": APP_DELEGATE.createObj.materials,"createdWork": APP_DELEGATE.createObj.dateCreate,"edition": APP_DELEGATE.createObj.editorNumber,"watermark": APP_DELEGATE.createObj.signature, "duration": APP_DELEGATE.createObj.dimesion] as [String : Any]
        print("PARAM -->",param)
        Common.showBusy()
        ApiHelper.shared.uploadImageFileBuyerAmpAndSeller(_param: param, APP_DELEGATE.createObj.picture) { (success, error) in
             Common.hideBusy()
            if success!
            {
                 self.viewSuccess.isHidden = false
                self.tabBarController?.tabBar.isHidden = true
                 self.perform(#selector(self.redirectHome), with: nil, afterDelay: TIME_OUT)
                
            }
            else{
                if error != nil {
                    APP_DELEGATE.showAlert(error!.msg!)
                }
            }
        }
        
    }
}
