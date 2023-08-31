import UIKit

public struct TechTalk_Library {
    
    
    public init() {
    }
    
    public func customAlertPop(titleValue: String, mesString: String, viewController: UIViewController) {
           let alertController = UIAlertController(title: titleValue, message: mesString, preferredStyle: .alert)

           let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
           alertController.addAction(defaultAction)

           viewController.present(alertController, animated: true, completion: nil)
       }
    
}

