//
//  Loading.swift
//  InitProjectExc
//
//  Created by huort seanghaY on 29/4/23.
//

import Foundation
import UIKit

public class LoadingView: UIView {
    
    static var spinnerView  = JTMaterialSpinner()
    static let window       = UIApplication.shared.keyWindow!
    static let view         = UIView(frame: window.bounds)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public class func show() {

        let height  = UIScreen.main.bounds.size.height
        let width   = UIScreen.main.bounds.size.width
        let center  = CGPoint(x: width / 2, y: height / 2)
        
        spinnerView.isHidden = false
        spinnerView.frame                   = CGRect(x: 0, y: 0, width: 40, height: 40)
        spinnerView.center                  = center
        spinnerView.layer.zPosition         = 9999
        spinnerView.circleLayer.lineWidth   = 5
//        spinnerView.circleLayer.strokeColor = Shared.share.barTintColor.cgColor
        spinnerView.circleLayer.strokeColor = UIColor.white.cgColor
        spinnerView.beginRefreshing()
        
        view.backgroundColor  = UIColor.black.withAlphaComponent(0.7)
        view.layer.zPosition  = 9998
        
        window.addSubview(view)
        window.addSubview(spinnerView)
    }
    
    public class func hide() {
        view.removeFromSuperview()
        spinnerView.isHidden = true
//        spinnerView.endRefreshing()
    }
}
