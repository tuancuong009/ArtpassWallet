//
//  ActiveDirectorVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 5/4/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit

class ActiveDirectorVC: UIViewController {
    var isUbo = false
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var viewBGConfirm: UIViewX!
    @IBOutlet weak var spaceBottomTbl: NSLayoutConstraint!
    @IBOutlet weak var tblOffice: UITableView!
    var arrDatas = [OfficeDirectorObj]()
    @IBOutlet weak var lblNote: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var viewBGAdd: UIViewX!
    @IBOutlet weak var btnBack: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
        self.showUIConfirm(true)
        self.showUIAdd(true)
    }
    func updateUI()
    {
        if self.isUbo {
            self.btnBack.isHidden = false
            self.lblNote.text = "ACTIVE ULTIMATE BENEFICIAL OWNERS (UBO)"
            self.btnAdd.setTitle("ADD AN ACTIVE UBO", for: .normal)
            self.arrDatas = APP_DELEGATE.userObj.arrUbos
        }
        else{
            self.btnBack.isHidden = true
            self.arrDatas = APP_DELEGATE.userObj.arrOffices
        }
    }


    func showUIConfirm(_ isValid: Bool)
    {
        if !isValid {
            self.btnConfirm.isEnabled = false
            self.viewBGConfirm.backgroundColor = UIColor.lightGray
        }
        else{
            self.btnConfirm.isEnabled = true
            self.viewBGConfirm.backgroundColor = Common.hexStringToUIColor("8B1A4B")
        }
    }
    
    func showUIAdd(_ isValid: Bool)
    {
        if !isValid {
            self.btnAdd.isEnabled = false
            self.viewBGAdd.backgroundColor = UIColor.lightGray
        }
        else{
            self.btnAdd.isEnabled = true
            self.viewBGAdd.backgroundColor = Common.hexStringToUIColor("82BD82")
        }
    }
    
    func showValidForm()
    {
        var isValid = true
        for item in arrDatas
        {
            if item.birthday.isEmpty || item.country.isEmpty {
                isValid = false
                break
            }
        }
        self.showUIConfirm(isValid)
        self.showUIAdd(isValid)
    }
    
    
    @IBAction func doConfirm(_ sender: Any) {
        if !isUbo {
            APP_DELEGATE.userObj.arrOffices = self.arrDatas
            self.getDataUBO()
            let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "ActiveDirectorVC") as! ActiveDirectorVC
            vc.isUbo = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            if self.arrDatas.count == 0{
                APP_DELEGATE.showAlert("Please enter at least 1 profile")
                return
            }
            APP_DELEGATE.userObj.arrUbos = self.arrDatas
            
           let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "CompleteSignUpVC") as! CompleteSignUpVC
           self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func doAddDirectorOffice(_ sender: Any) {
        if !isUbo {
            APP_DELEGATE.userObj.arrOffices = self.arrDatas
        }
        else{
            APP_DELEGATE.userObj.arrUbos = self.arrDatas
        }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddOfficeDirectorVC") as! AddOfficeDirectorVC
        vc.isUBO = self.isUbo
        vc.tapConfirm = { [] in
            vc.officeDirectorObj.isAPI = false
            self.arrDatas.append(vc.officeDirectorObj)
            self.tblOffice.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func getDataUBO()
    {
        APP_DELEGATE.userObj.arrUbos.removeAll()
        for item in self.arrDatas
        {
            if item.isUBO {
                item.isCallIPA = true
                APP_DELEGATE.userObj.arrUbos.append(item)
            }
            
        }
    }
    @IBAction func doback(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ActiveDirectorVC: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDatas.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblOffice.dequeueReusableCell(withIdentifier: "ActiveDirectorCell") as! ActiveDirectorCell
        let item = self.arrDatas[indexPath.row]
        cell.tapUBO = { [] in
            item.isUBO = !item.isUBO
            if item.isUBO {
                cell.imgTick.image = UIImage.init(named: "ic_tick1")
            }
            else{
                cell.imgTick.image = UIImage.init(named: "ic_tick")
            }
        }
        self.configCell(cell, item)
        return cell
    }
    
    func configCell(_ cell: ActiveDirectorCell, _ data: OfficeDirectorObj)
    {
        cell.lblName.text = data.firstname.uppercased() + " " + data.lastname.uppercased()
        
        cell.lblNational.text = data.country
        if data.birthday.isEmpty
        {
            cell.lblBirthday.text = "ADD DAY/MONTH/YEAR SELECTOR"
        }
        else{
            cell.lblBirthday.text = "Date of birth:" + " " + data.birthday
        }
        if data.countryCode.isEmpty
        {
            cell.lblNational.text = "ADD COUNTRY SELECTOR"
        }
        else{
            cell.lblNational.text = "Nationality:" + " " + data.countryCode
        }
        if data.isUBO {
            cell.imgTick.image = UIImage.init(named: "ic_tick1")
        }
        else{
            cell.imgTick.image = UIImage.init(named: "ic_tick")
        }
        cell.lblIamUbo.text = "\(data.firstname.uppercased()) is also an UBO"
        if self.isUbo {
            cell.subUBO.isHidden = true
            cell.heightUBO.constant = 0
            cell.spaceTopUBO.constant = 0
        }
    }
}
