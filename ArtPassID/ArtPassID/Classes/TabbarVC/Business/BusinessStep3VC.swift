//
//  BusinessStep3VC.swift
//  ArtPassID
//
//  Created by QTS Coder on 3/20/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit

class BusinessStep3VC: UIViewController {

    @IBOutlet weak var btnCheck1: UIButton!
    @IBOutlet weak var btnCheck2: UIButton!
    @IBOutlet weak var btnRatio: UIButton!
    var icTick1 = false
    var icTick2 = false
    var isRadio = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnCheck1.setImage(UIImage.init(named: "ic_check"), for: .normal)
        self.btnCheck2.setImage(UIImage.init(named: "ic_check"), for: .normal)
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
    @IBAction func doCheck1(_ sender: Any) {
        self.isRadio = false
        self.btnRatio.setImage(UIImage.init(named: "ic_radio"), for: .normal)
        if !icTick1 {
            self.icTick1 = true
            self.btnCheck1.setImage(UIImage.init(named: "ic_checked"), for: .normal)
        }
        else{
            self.icTick1 = false
            self.btnCheck1.setImage(UIImage.init(named: "ic_check"), for: .normal)
        }
        
    }
    
    @IBAction func doCheck2(_ sender: Any) {
       self.isRadio = false
       self.btnRatio.setImage(UIImage.init(named: "ic_radio"), for: .normal)
       if !icTick2 {
           self.icTick2 = true
           self.btnCheck2.setImage(UIImage.init(named: "ic_checked"), for: .normal)
       }
       else{
           self.icTick2 = false
           self.btnCheck2.setImage(UIImage.init(named: "ic_check"), for: .normal)
       }
    }
    @IBAction func doRadio(_ sender: Any) {
        if !self.isRadio
        {
            self.isRadio = true
            self.btnRatio.setImage(UIImage.init(named: "ic_radio_selected"), for: .normal)
        }
        else{
            self.isRadio = false
            self.btnRatio.setImage(UIImage.init(named: "ic_radio"), for: .normal)
        }
        
        self.icTick1 = false
        self.icTick2 = false
        self.btnCheck1.setImage(UIImage.init(named: "ic_check"), for: .normal)
        self.btnCheck2.setImage(UIImage.init(named: "ic_check"), for: .normal)
    }
    @IBAction func doCountine(_ sender: Any) {
        if isRadio {
            APP_DELEGATE.userObj.fOpts = icTick1
            APP_DELEGATE.userObj.sOpts = icTick2
            APP_DELEGATE.userObj.tOpts = isRadio
            
            let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "ActiveDirectorVC") as! ActiveDirectorVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            if self.icTick1 || self.icTick2 {
               
                let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "ActiveDirectorVC") as! ActiveDirectorVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
