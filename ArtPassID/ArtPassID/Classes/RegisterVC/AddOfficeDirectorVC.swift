//
//  AddOfficeDirectorVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 5/4/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit
import SKCountryPicker
class AddOfficeDirectorVC: UIViewController {

    @IBOutlet weak var txfFirstName: UITextField!
    @IBOutlet weak var txfLastName: UITextField!
    @IBOutlet weak var txfBirthday: UITextField!
    @IBOutlet weak var txfCountry: UITextField!
    var officeDirectorObj = OfficeDirectorObj.init(NSDictionary.init())
    var tapConfirm: (() ->())?
    @IBOutlet weak var imgTick: UIImageView!
    @IBOutlet weak var viewTick: UIView!
    var isUBO = false
    @IBOutlet weak var lblTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("isUBO--->",isUBO)
        if !self.isUBO {
            self.lblTitle.text = "ACTIVE DIRECTORS/OFFICERS"
        }
        txfFirstName.text = officeDirectorObj.firstname
        txfLastName.text = officeDirectorObj.lastname
        txfBirthday.text = officeDirectorObj.birthday
        txfCountry.text = officeDirectorObj.country
        if officeDirectorObj.isUBO {
            self.imgTick.image = UIImage.init(named: "ic_tick1")
        }
        else{
            self.imgTick.image = UIImage.init(named: "ic_tick")
        }
        //if isUBO {
            viewTick.isHidden = true
        //}
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
    @IBAction func doConfirm(_ sender: Any) {
        if txfFirstName.text!.trim().isEmpty {
            APP_DELEGATE.showAlert(MSG_ERROR.ERROR_FNAME)
            return
        }
        if txfLastName.text!.trim().isEmpty {
            APP_DELEGATE.showAlert(MSG_ERROR.ERROR_LNAME)
            return
        }
        if txfBirthday.text!.trim().isEmpty {
            APP_DELEGATE.showAlert(MSG_ERROR.ERROR_BIRTHDAY)
            return
        }
        if txfCountry.text!.trim().isEmpty {
            APP_DELEGATE.showAlert(MSG_ERROR.ERROR_COUNTRY)
            return
        }
        let name = txfFirstName.text!.trim() + " " + txfLastName.text!.trim()
        if !self.checkValidateName(name) {
            APP_DELEGATE.showAlert("The person is already added, please try again.")
            return
        }
        officeDirectorObj.firstname = txfFirstName.text!.trim()
        officeDirectorObj.lastname = txfLastName.text!.trim()
        officeDirectorObj.birthday = txfBirthday.text!.trim()
        officeDirectorObj.country = txfCountry.text!.trim()
        
        self.tapConfirm?()
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func doBirthday(_ sender: Any) {
        DPPickerManager.shared.showPicker(title: "DATE OF BIRTH", selected: Date()) { (date, success) in
            if let datePicker = date
            {
                let format = DateFormatter.init()
                format.dateFormat = "MMM, dd yyyy"
                self.txfBirthday.text = format.string(from: datePicker)
                self.birthdayCode(datePicker)
            }
        }
        
    }
    
    func birthdayCode(_ date: Date)
    {
        let format = DateFormatter.init()
        format.dateFormat = "yyyy-MM-dd"
        officeDirectorObj.birthdayCode = format.string(from: date)
    }
    @IBAction func doCountry(_ sender: Any) {
        CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in

          guard let self = self else { return }

            self.txfCountry.text = country.countryName
            self.officeDirectorObj.countryCode = Common.listAllIos3(country.countryCode)
        }
    }
    @IBAction func doUBO(_ sender: Any) {
        officeDirectorObj.isUBO = !officeDirectorObj.isUBO
        if officeDirectorObj.isUBO {
            self.imgTick.image = UIImage.init(named: "ic_tick1")
        }
        else{
            self.imgTick.image = UIImage.init(named: "ic_tick")
        }
    }
    
    func checkValidateName(_ name: String)-> Bool
    {
        var isValid = true
        
        for item in APP_DELEGATE.userObj.arrOffices
        {
            let nameCheck = item.firstname + " " + item.lastname
            print("NAME---\(name)--------\(nameCheck)")
            
            if name.trim().lowercased() == nameCheck.trim().lowercased() {
                isValid = false
                break
            }
        }
        for item in APP_DELEGATE.userObj.arrUbos
        {
            let nameCheck = item.firstname + " " + item.lastname
            print("NAME---\(name)--------\(nameCheck)")
            if name.trim().lowercased() == nameCheck.trim().lowercased() {
                isValid = false
                break
            }
        }
        return isValid
    }
}
