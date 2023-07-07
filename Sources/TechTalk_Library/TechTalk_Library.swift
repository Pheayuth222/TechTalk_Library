import UIKit
public struct TechTalk_Library {
    public private(set) var text = "Hello, World!"

    public init() {
    }
    
    public func customAlertPop(titleValue: String, mesString: String, viewController: UIViewController) {
        viewController.customOneAlert(image: "", title: titleValue, message: mesString, yesTitle: "OK")
    }
    
}
