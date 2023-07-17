//
//  Constant.swift
//  
//
//  Created by KOSIGN on 10/7/23.
//

import Foundation
import UIKit

typealias Completion                = ()                -> Void

public func manualError(err: NSError) -> NSError {
    // Custom NSError
#if DEBUG
    print("Connection server error : \(err.domain)")
#endif
    switch err.code  {
        
        /**  -1001 : request timed out
         -1003 : hostname could not be found
         -1004 : Can't connect to host
         -1005 : Network connection lost
         -1009 : No internet connection
         */
    case -1001, -1003, -1004: // request timed out
        let error = NSError(domain: "NSURLErrorDomain", code: err.code, userInfo: [NSLocalizedDescriptionKey : "connection_time_out"])
        return error
    case -1005 : // Network connection lost
        let error = NSError(domain: "NSURLErrorDomain", code: err.code, userInfo: [NSLocalizedDescriptionKey : "internet_connection_is_unstable_please_try_again_after_connecting"])
        return error
    case -1009 : // No internet connection
        let error = NSError(domain: "NSURLErrorDomain", code: err.code, userInfo: [NSLocalizedDescriptionKey : "internet_connection_is_unstable_please_try_again_after_connecting"])
        Shared.share.errorConnectionCode = err.code
        return error
    default :
        return err
    }
}
public enum HTTPMethod : String {
    case GET    = "GET"
    case POST   = "POST"
    case PUT    = "PUT"
    case PATCH  = "PATCH"
    case DELETE = "DELETE"
}

enum XAppVersion : String {
   case base = "20210705"
   case appType = "iOS"
}
enum UserDefaultKey : String {
    case appLang            = "appLang"
    case isAutoLogin        = "isAutoLogin"
    case username           = "username"
    case password           = "password"
    case accessToken        = "accessToken"
    case tokenType          = "tokenType"
}
enum NotifyKey : String {
    case reloadLocalize                     = "reloadLocalize"
    
}
