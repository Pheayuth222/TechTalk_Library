import UIKit
public struct MyLibrary {
    public private(set) var text = "Hello, World!"

    public init() {
    }
    
    private func alert(_ title: String? = nil,message: String? = nil) -> UIAlertController {
        UIAlertController(title: title,message: message,preferredStyle: .alert)
    }
}
