//
//  DataAccess.swift
//  
//
//  Created by KOSIGN on 10/7/23.
//

import Foundation
import UIKit

public class DataAccess {
    
    public static var sharedInstance    = DataAccess()
    
    // The Network access for request, response, upload and download task
    public static var sessionConfig    : URLSessionConfiguration!
    public static var session          : URLSession!
    
    static var shared : DataAccess = {
        // Timeout Configuration
        sessionConfig                               = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest     = 120.0
        sessionConfig.timeoutIntervalForResource    = 120.0
        session = URLSession(configuration: sessionConfig)
        return sharedInstance
    }()
    

    
    public init() {}
    
    public func showHideLoading(isShow: Bool) {
        DispatchQueue.main.async {
            if isShow {
                LoadingView.show()
            }
            else {
                LoadingView.hide()
            }
        }
    }
    
    
}

