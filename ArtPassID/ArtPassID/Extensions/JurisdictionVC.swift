//
//  JurisdictionVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 3/30/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit

class JurisdictionVC: UIViewController {
    var tapSelect: (() ->())?
    @IBOutlet weak var tblData: UITableView!
    @IBOutlet weak var txfSearch: UITextField!
    var arrDatas = [NSDictionary]()
    var arrSearchs = [NSDictionary]()
    var dictSelect = NSDictionary.init()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.arrDatas = Common.allJurisdictions()
        self.arrSearchs = self.arrDatas
        tblData.register(UINib.init(nibName: "JurisdictionCell", bundle: nil), forCellReuseIdentifier: "JurisdictionCell")
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
    @IBAction func doCancel(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
    
}
extension JurisdictionVC: UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
           let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            self.arrDatas.removeAll()
            if updatedText.isEmpty {
                self.arrDatas = self.arrSearchs
            }
            else{
                for item in self.arrSearchs
               {
                   let valName = item.object(forKey: "name") as? String ?? ""
                   if valName.lowercased().contains(updatedText.lowercased()) {
                       self.arrDatas.append(item)
                   }
               }
            }
           
            self.tblData.reloadData()
        }
        return true
    }
}
extension JurisdictionVC: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrDatas.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblData.dequeueReusableCell(withIdentifier: "JurisdictionCell") as! JurisdictionCell
        let dict = self.arrDatas[indexPath.row]
        cell.lblName.text = dict.object(forKey: "name") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tblData.deselectRow(at: indexPath, animated: true)
        self.dictSelect = self.arrDatas[indexPath.row]
        self.tapSelect?()
        self.dismiss(animated: true) {
            
        }
    }
}
