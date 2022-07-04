//
//  CreateNewTransationVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 5/7/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit

class CreateNewTransationVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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
    @IBAction func doCreateSellerAMPBuyer(_ sender: Any) {
        let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "NewTransactionVC") as! NewTransactionVC
        vc.isSellerAmpBuyer = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func doBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
