//
//  UITableViewCell+UICollectionViewCell.swift
//  BizMemo
//
//  Created by Obi-Voin Kenobi on 6/26/19.
//  Copyright © 2019 Bunnavitou. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    public static var IDENTIFIER: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell {
    
    public static var IDENTIFIER: String {
        return String(describing: self)
    }
}
