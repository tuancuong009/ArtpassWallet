//
//  IntroVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 11/28/19.
//  Copyright © 2019 QTS Coder. All rights reserved.
//

import UIKit
import SafariServices
class IntroVC: UIViewController {

    @IBOutlet weak var cltIntro: UICollectionView!
    @IBOutlet weak var pageContrl: UIPageControl!
    @IBOutlet weak var btnNext: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        cltIntro.register(UINib.init(nibName: "IntroCollect", bundle: nil), forCellWithReuseIdentifier: "IntroCollect")
        cltIntro.register(UINib.init(nibName: "IntroCollectFirst", bundle: nil), forCellWithReuseIdentifier: "IntroCollectFirst")
        self.pageContrl.numberOfPages = 5
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
    @IBAction func doWallet(_ sender: Any) {
    }
    @IBAction func doArtPlus(_ sender: Any) {
    }
    
    @IBAction func doNext(_ sender: Any) {
        // let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterStep1VC") as! RegisterStep1VC
       // self.navigationController?.pushViewController(vc, animated: true)
//        if UserDefaults.standard.bool(forKey: KEY_INAPP_PRO) {
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterStep1VC") as! RegisterStep1VC
//            self.navigationController?.pushViewController(vc, animated: true)
//         }
//        else{
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PayWithApplePayVC") as! PayWithApplePayVC
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//
        //guard let url = URL(string: URL_OPEN_REGISTER) else { return }
        //UIApplication.shared.open(url)
        let vc = SFSafariViewController.init(url: URL.init(string: URL_OPEN_REGISTER)!)
        self.present(vc, animated: true) {
            
        }
    }
    @IBAction func doJoineId(_ sender: Any) {
        let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "ScanConnectVC") as! ScanConnectVC
        vc.isJoideID = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
} 

extension IntroVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        if indexPath.row == 0 {
            let collect = self.cltIntro.dequeueReusableCell(withReuseIdentifier: "IntroCollectFirst", for: indexPath) as! IntroCollectFirst
            collect.configLabel()
            return collect
        }
        
        else{
            let collect = self.cltIntro.dequeueReusableCell(withReuseIdentifier: "IntroCollect", for: indexPath) as! IntroCollect
            if indexPath.row == 1 {
                collect.lbltitle.text = "Smart Solution"
                collect.lblDesc.text = "There is no need for physical passports and utility bills to be taken to places or emailed."
                collect.lblR.isHidden = true
                collect.imgCell.image = UIImage.init(named: "slide3")
            }
            else if indexPath.row == 2 {
                collect.lbltitle.text = "Fast Onboarding"
                collect.lblDesc.text = "In only takes a few minutes to get your artpass ID."
                collect.lblR.isHidden = true
                collect.imgCell.image = UIImage.init(named: "slide1")
            }
            else if indexPath.row == 3 {
                collect.lbltitle.text = "Secure Sharing"
                collect.lblDesc.text = "artpass ID members can instantly connect with each other and securely share their CDD Report with 1-Click."
                collect.lblR.isHidden = true
                collect.imgCell.image = UIImage.init(named: "slide2")
            } 
            else{
                collect.lbltitle.text = "Transaction Report"
                collect.lblDesc.text = "Creating AML compliant Transaction Reports in one private and secure place."
                collect.lblR.isHidden = true
                collect.imgCell.image = UIImage.init(named: "slide4")
            }
            
            collect.configLabel()
            return collect
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        print(collectionView.frame.size.width, collectionView.frame.size.height)
        return CGSize(width: UIScreen.main.bounds.size.width, height:collectionView.frame.size.height)
        
    }
}

extension IntroVC: UIScrollViewDelegate
{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        let currentPage = Int(ceil(x/w))
        pageContrl.currentPage = currentPage
        
    }
}

