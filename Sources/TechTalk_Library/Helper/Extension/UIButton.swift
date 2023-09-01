//
//  UIButton.swift
//  SimpleCert
//
//  Created by         TUYNUY         on 10/25/19.
//  Copyright © 2019 Webcash. All rights reserved.
//

import UIKit

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        self.setBackgroundImage(colorImage, for: forState)
    }
    
    func setUnderline(spacing: CGFloat = 1, height: CGFloat = 1, color: UIColor? = nil) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect.init(x: 0, y: self.frame.size.height + spacing, width: self.frame.size.width, height: height)
        bottomLine.backgroundColor = color == nil ? self.titleLabel?.textColor.cgColor : color?.cgColor
        self.layer.addSublayer(bottomLine)
        
    }
}
