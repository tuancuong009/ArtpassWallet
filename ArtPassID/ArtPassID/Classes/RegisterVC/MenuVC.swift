//
//  MenuVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 4/19/19.
//  Copyright © 2019 QTS Coder. All rights reserved.
//

import UIKit

class MenuVC: UITableViewController {

    var arrNaviss = ["EOS WALLET", "TIER 1", "TIER 2","TIER 3","TIER 4", "SETTINGS", "MESSAGES", "FORGOT PASSWORD", "SIGN OUT", "ABOUT ARPASS", "TERMS & CONDITIONS", "DISCLAIMER"]
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        /*
        if indexPath.row == 8
        {
            self.showLogout(tableView.cellForRow(at: indexPath)!)
        }
        else{
            sideMenuController?.hideRightView(animated: true, completionHandler: {
                if indexPath.row == 1
                {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Tier1VC") as! Tier1VC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else if indexPath.row == 3
                {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Tier3VC") as! Tier3VC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else if indexPath.row == 4
                {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Tier4VC") as! Tier4VC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailMenuVC") as! DetailMenuVC
                    vc.titleNavi = self.arrNaviss[indexPath.row]
                    self.navigationController?.pushViewController(vc, animated: true)
                }
               
            })
            
        }*/
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
    }
}


extension MenuVC
{
    func showLogout(_ cell: UITableViewCell)
    {
        let alert = UIAlertController.init(title: APP_NAME, message: "Do you want to sign out?", preferredStyle: .actionSheet)
        let logout = UIAlertAction.init(title: "Sign out", style: .destructive) { (action) in
            APP_DELEGATE.initHome()
        }
        alert.addAction(logout)
        let cancel = UIAlertAction.init(title: "Cancel", style: .cancel) { (action) in
            
        }
        alert.addAction(cancel)
        if let presenter = alert.popoverPresentationController {
            presenter.sourceView = cell
            presenter.sourceRect = cell.bounds
        }
        self.present(alert, animated: true) {
            
        }
    }
}
