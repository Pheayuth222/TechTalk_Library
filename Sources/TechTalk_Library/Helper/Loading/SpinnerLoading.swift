//
//  SpinnerLoading.swift
//  WeBill
//
//  Created by Bong Kokkheang on 14/6/23.
//

import Foundation
import UIKit

public class SpinnerLoading: UIView {
    
    let spinnerView  = JTMaterialSpinner()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func setup() {
        // Customize the line width
        spinnerView.circleLayer.lineWidth = 2.5
        
        // Change the color of the line
        spinnerView.circleLayer.strokeColor = UIColor.blue.cgColor
        
        // Change the duration of the animation
        spinnerView.animationDuration = 2.5
        
        frame =  CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50)
        
        spinnerView.frame = CGRect(x: UIScreen.main.bounds.size.width/2 - bounds.height/4, y: bounds.height/4, width: 25, height: 25)
        
        self.addSubview(spinnerView)
    }
    
    public func start() {
        spinnerView.beginRefreshing()
    }
    
    public func end() {
        spinnerView.endRefreshing()
    }
}
