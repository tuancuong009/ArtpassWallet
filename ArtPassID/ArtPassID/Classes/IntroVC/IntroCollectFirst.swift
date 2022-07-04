//
//  IntroCollectFirst.swift
//  ArtPassID
//
//  Created by QTS Coder on 2/5/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit

class IntroCollectFirst: UICollectionViewCell {

    @IBOutlet weak var lblText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configLabel()
    {
        let attributedString = NSMutableAttributedString(string: lblText.text!)

        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 15 // Whatever line spacing you want in points

        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

        // *** Set Attributed String to your label ***
        lblText.attributedText = attributedString
    }
}
