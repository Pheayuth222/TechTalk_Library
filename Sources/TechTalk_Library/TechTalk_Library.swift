import UIKit

public struct TechTalk_Library {
    
    
    public init() {
    }
    
    public func alert(_ title: String? = nil,message: String? = nil) -> UIAlertController {
        UIAlertController(title: title,message: message,preferredStyle: .alert)
    }
    
}

