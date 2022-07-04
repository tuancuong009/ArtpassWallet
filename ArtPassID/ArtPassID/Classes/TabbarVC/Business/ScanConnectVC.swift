//
//  ScanConnectVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 3/27/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//
import UIKit
import SafariServices
class ScanConnectVC: UIViewController {
    var isJoideID = false
    @IBOutlet weak var lblNavi: UILabel!
    @IBOutlet weak var scannerView: QRScannerView!{
        didSet {
            scannerView.delegate = self
        }
    }
    var qrData: QRData? = nil {
        didSet {
            if qrData != nil {
                if qrData!.codeString!.isValidURL {
                    if self.isJoideID {
                        var qrocde = qrData!.codeString!
                        if !qrocde.contains("http"){
                            qrocde = "http://" + qrocde
                        }
                        if let url = URL.init(string: qrocde), self.verifyUrl(urlString: qrocde){
                            
                            let vc = SFSafariViewController.init(url: url)
                            self.present(vc, animated: true)
                            self.navigationController?.popViewController(animated: true)
                        }
                        else{
                            let alert = UIAlertController.init(title: APP_NAME, message: "Please point to the QR-code from the seller to start your eID KYC onboarding.", preferredStyle: .alert)
                            let ok = UIAlertAction.init(title: "OK", style: .cancel) { (action) in
                                if !self.scannerView.isRunning {
                                    self.scannerView.startScanning()
                                }
                            }
                            alert.addAction(ok)
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                    else{
                        let controller = ConnectResultVC.controller()
                        controller.qrDataCodeString = qrData?.codeString
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                   
                }
                else{
                    if self.isJoideID {
                        let alert = UIAlertController.init(title: APP_NAME, message: "Please point to the QR-code from the seller to start your eID KYC onboarding.", preferredStyle: .alert)
                        let ok = UIAlertAction.init(title: "OK", style: .cancel) { (action) in
                            if !self.scannerView.isRunning {
                                self.scannerView.startScanning()
                            }
                        }
                        alert.addAction(ok)
                        self.present(alert, animated: true, completion: nil)
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
                }
                //self.performSegue(withIdentifier: "detailSeuge", sender: self)
            }
        }
    }
    
    func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.isJoideID {
            self.lblNavi.text = "SCAN QR TO START"
        }
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
        //if !scannerView.isRunning {
            scannerView.stopScanning()
        //}
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
extension ScanConnectVC: QRScannerViewDelegate {
    func qrScanningDidStop() {
    }
    
    func qrScanningDidFail() {
        APP_DELEGATE.showAlert("Scanning Failed. Please try again")
    }
    
    func qrScanningSucceededWithCode(_ str: String?) {
        self.qrData = QRData(codeString: str)
    }
    
    
    
}
