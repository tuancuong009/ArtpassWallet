//
//  IntroCollect.swift
//  ArtPassID
//
//  Created by QTS Coder on 11/28/19.
//  Copyright © 2019 QTS Coder. All rights reserved.
//

import UIKit

class IntroCollect: UICollectionViewCell {
    
    @IBOutlet weak var imgCell: UIImageView!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblR: UILabel!
    func configLabel()
   {
       /*
       let attributedString = NSMutableAttributedString(string: lblDesc.text!)

       // *** Create instance of `NSMutableParagraphStyle`
       let paragraphStyle = NSMutableParagraphStyle()
       paragraphStyle.alignment = .center
       // *** set LineSpacing property in points ***
       paragraphStyle.lineSpacing = 5 // Whatever line spacing you want in points

       // *** Apply attribute to string ***
       attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

       // *** Set Attributed String to your label ***
       lblDesc.attributedText = attributedString*/
   }
}
