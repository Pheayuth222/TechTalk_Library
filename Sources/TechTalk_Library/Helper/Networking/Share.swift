//
//  Share.swift
//  
//
//  Created by KOSIGN on 10/7/23.
//

import Foundation
import UIKit
enum LanguageCode: String {
    case Korean     = "ko"
    case English    = "en"
    case Khmer      = "km"
}


struct Shared {
    
    //MARK:- singleton
    static var share = Shared()
    
    private init() { }
    
    static var language     : LanguageCode = .Khmer
    var jSessionId          : String?
    var access_token_type   : String?
    var access_token        : String?
    
    var saveUsername        : String?
    var savePassword        : String?
    
    
    var policy_url          : String?
    var term_url            : String?
    var customer_support    : String?
    var isForAppleTester    = false
    var baseUrl             : String?
    var secret_key_from_Mg           : String?
    var bill_url            : String?
    
    var device_token        = ""
    
    
    var errorConnectionCode = 0
    
    var height1 :CGFloat = 500
    
    static var safeAreaBottom : CGFloat {
        let root = UIApplication.shared.keyWindow?.rootViewController
        
        var safeAreaBottom  : CGFloat = 0.0
        
        if #available(iOS 11.0, *) {
            safeAreaBottom  = root?.view.safeAreaInsets.bottom ?? 0.0
        } else {
            // Fallback on earlier versions
        }
        
        return safeAreaBottom
    }

}
