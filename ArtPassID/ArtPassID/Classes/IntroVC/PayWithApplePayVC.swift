//
//  PayWithApplePayVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 10/6/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit
import SwiftyStoreKit
import SafariServices
class PayWithApplePayVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
//        SwiftyStoreKit.retrieveProductsInfo([INAPP_PURCHASE]) { result in
//            if let product = result.retrievedProducts.first {
//                let priceString = product.localizedPrice!
//                print("Product: \(product.localizedDescription), price: \(priceString)")
//            }
//            else if let invalidProductId = result.invalidProductIDs.first {
//                print("Invalid product identifier: \(invalidProductId)")
//            }
//            else {
//                print("Error: \(result.error)")
//            }
//        }
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
    
    func openSafari(_ url: String){
        let vc = SFSafariViewController.init(url: URL.init(string: url)!)
        self.present(vc, animated: true) {
            
        }
    }
    func getInfoInApp(){
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            
            if case .success(let receipt) = result {
                let purchaseResult = SwiftyStoreKit.verifySubscription(
                    ofType: .autoRenewable,
                    productId: INAPP_PURCHASE,
                    inReceipt: receipt)
                
                switch purchaseResult {
                case .purchased(let expiryDate, let items):
                    Common.hideBusy()
                    if items.count > 0{
                        if let item0 = items.first{
                            UserDefaults.standard.setValue(self.formatDate(item0.purchaseDate), forKey: dateStartInApp)
                            UserDefaults.standard.setValue(self.formatDate(item0.subscriptionExpirationDate ?? expiryDate), forKey: dateEndInApp)
                            UserDefaults.standard.synchronize()
                        }
                    }
                    UserDefaults.standard.set(true, forKey: KEY_INAPP_PRO)
                   UserDefaults.standard.synchronize()
                   let alert = UIAlertController.init(title: APP_NAME, message: "Purchase successfully!", preferredStyle: .alert)
                   let cancel = UIAlertAction.init(title: "OK", style: .cancel) { (action) in
                       let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterStep1VC") as! RegisterStep1VC
                       self.navigationController?.pushViewController(vc, animated: true)
                   }
                   alert.addAction(cancel)
                   self.present(alert, animated: true) {
                       
                   }
                    print("Product is valid until \(expiryDate)")
                    
                case .expired(let expiryDate, _):
                    print("Product is expired since \(expiryDate)")
                case .notPurchased:
                    print("This product has never been purchased")
                    Common.hideBusy()
                }

            } else {
                Common.hideBusy()
                // receipt verification error
            }
        }
    }
    func formatDate(_ dateStr: Date)-> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatterGet.string(from: dateStr)
    }
    
    @IBAction func doPay(_ sender: Any) {
        Common.showBusy()
        SwiftyStoreKit.purchaseProduct(INAPP_PURCHASE, quantity: 1, atomically: true) { result in
            switch result {
            case .success(let purchase):
                print("Purchase Success: \(purchase.productId)")
                self.getInfoInApp()
                //self.showAlert("Purchase successfully!")
            case .error(let error):
                Common.hideBusy()
                APP_DELEGATE.showAlert((error as NSError).localizedDescription)
            }
        }
    }
    
    @IBAction func doTerm(_ sender: Any) {
        self.openSafari("https://artpass.id/terms/")
    }
    @IBAction func doPrivacy(_ sender: Any) {
         self.openSafari("https://artpass.id/privacy")
    }
    
}
