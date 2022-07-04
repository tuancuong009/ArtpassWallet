//
//  ClickBuyerVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 6/29/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit
import SafariServices
class ClickBuyerVC: UIViewController {

    @IBOutlet weak var scannerView: QRScannerView!{
        didSet {
            scannerView.delegate = self
        }
    }
    var qrData: QRData? = nil {
        didSet {
            if qrData != nil {
                if qrData!.codeString!.isValidURL {
                    if !qrData!.codeString!.contains("artpass.id/transaction-amp/") {
                        let alert = UIAlertController.init(title: APP_NAME, message: "QR-Code is invalid", preferredStyle: .alert)
                        let ok = UIAlertAction.init(title: "OK", style: .cancel) { (action) in
                            if !self.scannerView.isRunning {
                                self.scannerView.startScanning()
                            }
                        }
                        alert.addAction(ok)
                        self.present(alert, animated: true, completion: nil)
                    }
                    else{
                        self.callAPII(qrData!.codeString!)
                    }
                    
                }
                else{
                    let alert = UIAlertController.init(title: APP_NAME, message: "Can not open \(qrData!.codeString!)", preferredStyle: .alert)
                    let ok = UIAlertAction.init(title: "OK", style: .cancel) { (action) in
                        if !self.scannerView.isRunning {
                            self.scannerView.startScanning()
                        }
                    }
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                }
                //self.performSegue(withIdentifier: "detailSeuge", sender: self)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if !scannerView.isRunning {
            scannerView.startScanning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //if !scannerView.isRunning {
            scannerView.stopScanning()
        //}
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
       // if !scannerView.isRunning {
            scannerView.stopScanning()
        //}
    }
    
    func callAPII(_ linkQrcode: String)
    {
        ApiHelper.shared.getTransactionAmp(linkQrcode) { (success, val, error) in
            if let result = val
            {
                if let transaction = result.object(forKey: "transaction") as? NSDictionary {
                    let transacId = transaction.object(forKey: "transacId") as? String ?? ""
                    if Common.checkExitTransacId(transacId)
                    {
                        let alert = UIAlertController.init(title: APP_NAME, message: "You already requested 1-Click Compliance for this artwork.", preferredStyle: .alert)
                        let ok = UIAlertAction.init(title: "OK", style: .cancel) { (action) in
                            if !self.scannerView.isRunning {
                                self.scannerView.startScanning()
                            }
                        }
                        alert.addAction(ok)
                        self.present(alert, animated: true, completion: nil)
                    }
                    else{
                        let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "ConfirmClickBuyerVC") as! ConfirmClickBuyerVC
                        vc.linkQrcode = linkQrcode
                        vc.dictAMP = transaction
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                }
            }
            else{
                APP_DELEGATE.showAlert(MSG_ERROR.ERROR_SERVER)
            }
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

    @IBAction func doBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
extension ClickBuyerVC: QRScannerViewDelegate {
    func qrScanningDidStop() {
    }
    
    func qrScanningDidFail() {
        APP_DELEGATE.showAlert("Scanning Failed. Please try again")
    }
    
    func qrScanningSucceededWithCode(_ str: String?) {
        self.qrData = QRData(codeString: str)
    }
    
    
    
}
