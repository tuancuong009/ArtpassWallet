//
//  TabbarVC.swift
//  ArtPassID
//
//  Created by QTS Coder on 2/5/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit

class TabbarVC: UITabBarController {
    class customeTabBar: UITabBar {
            
            override func sizeThatFits(_ size: CGSize) -> CGSize {
                
                var sizeThatFits = super.sizeThatFits(size)
                if #available(iOS 11.0, *) {
                    let window = UIApplication.shared.keyWindow
                    let bottomPadding = window?.safeAreaInsets.bottom ?? 0.0
                    sizeThatFits.height = 70 + bottomPadding
                }
                else{
                    sizeThatFits.height = 70
                }
                
                
                return sizeThatFits
                
            }
            
        }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = UIColor.clear
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        self.delegate = self
        let tab1UnSelect = UIImage.init(named: "tab1")!.withRenderingMode(.alwaysOriginal)
        let tab1Select = UIImage.init(named: "tab1_2")!.withRenderingMode(.alwaysOriginal)
        self.tabBar.items?[0].selectedImage = tab1Select
        self.tabBar.items?[0].image = tab1UnSelect
        self.tabBar.items?[0].title = "artpass ID".uppercased()
       let tab2UnSelect = UIImage.init(named: "tab2")!.withRenderingMode(.alwaysOriginal)
       let tab2Select = UIImage.init(named: "tab2_2")!.withRenderingMode(.alwaysOriginal)
       self.tabBar.items?[1].selectedImage = tab2Select
       self.tabBar.items?[1].image = tab2UnSelect
        self.tabBar.items?[1].title = "Connections".uppercased()
        let tab3UnSelect = UIImage.init(named: "tab3")!.withRenderingMode(.alwaysOriginal)
       let tab3Select = UIImage.init(named: "tab3_2")!.withRenderingMode(.alwaysOriginal)
       self.tabBar.items?[2].selectedImage = tab3Select
       self.tabBar.items?[2].image = tab3UnSelect
        self.tabBar.items?[2].title = "Transactions".uppercased()
        let tab4UnSelect = UIImage.init(named: "tab4")!.withRenderingMode(.alwaysOriginal)
       let tab4Select = UIImage.init(named: "tab4_2")!.withRenderingMode(.alwaysOriginal)
       self.tabBar.items?[3].selectedImage = tab4Select
       self.tabBar.items?[3].image = tab4UnSelect
        self.tabBar.items?[3].title = "Profile".uppercased()
        //self.tabBar.items?[2].badgeValue = "2"
        //self.tabBar.items?[2].badgeColor = Common.hexStringToUIColor("8B1A4B")
        // Do any additional setup after loading the view.
        //
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "NunitoSans-SemiBold", size: 10) as Any, NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "NunitoSans-SemiBold", size: 10) as Any, NSAttributedString.Key.foregroundColor: Common.hexStringToUIColor("6c63ff")], for: .selected)
        object_setClass(self.tabBar, customeTabBar.self)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TabbarVC: UITabBarControllerDelegate
{
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let vc = viewController as? UINavigationController {
            Common.hideBusy()
            vc.popToRootViewController(animated: true)
        }
    }
}
