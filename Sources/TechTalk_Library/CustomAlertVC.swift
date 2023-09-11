//
//  CustomAlertVC.swift
//  
//
//  Created by KOSIGN on 8/9/23.
//

import UIKit

public protocol CustomAlertDelegate: AnyObject {
    func okButtonAction(_ alert: CustomAlertVC, alertTag: Int)
    func cancelButtonAction(_ alert: CustomAlertVC, alertTag: Int)
}

public class CustomAlertVC: UIViewController {
    
    weak var delegate : CustomAlertDelegate?

    
    public var alertTag = 0
    public var isCancelBtnHidden = false
    public var alertTitle = ""
    public var alertMessage = ""
    public var okButtonTitle = "Ok"
    public var cancelButtonTitle = "Cancel"
    public var statusImage = UIImage.init(named: "smiley")
    
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var messegeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var alertView: UIView!
    
    public static func loadFromNib() -> CustomAlertVC {
        CustomAlertVC(nibName: "CustomAlertVC_iOS", bundle: Bundle.module)
    }
    
//    init() {
//        super.init(nibName: "CustomAlertVC", bundle: Bundle(for: CustomAlertVC.self))
//        self.modalPresentationStyle = .overCurrentContext
//        self.modalTransitionStyle = .crossDissolve
//
//    }
    
//    required public init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupAlert()
    }
    
    public func show() {
        if #available(iOS 13, *) {
            UIApplication.shared.windows.first?.rootViewController?.present(self, animated: true, completion: nil)
        } else {
            UIApplication.shared.keyWindow?.rootViewController!.present(self, animated: true, completion: nil)
        }
    }
    
    public func setupAlert() {
        titleLabel.text = alertTitle
        messegeLabel.text = alertMessage
        iconImageView.image = statusImage
        okButton.setTitle(okButtonTitle, for: .normal)
        cancelButton.setTitle(cancelButtonTitle, for: .normal)
        cancelButton.isHidden = isCancelBtnHidden
    }
    
    
    
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        delegate?.cancelButtonAction(self, alertTag: alertTag)
    }
    
    @IBAction func okAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        delegate?.okButtonAction(self, alertTag: alertTag)
    }
    

}
