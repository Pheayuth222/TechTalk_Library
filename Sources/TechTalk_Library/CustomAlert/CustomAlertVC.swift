//
//  CustomAlertVC.swift
//  
//
//  Created by KOSIGN on 5/9/23.
//

import UIKit

protocol CustomAlertDelegate: AnyObject {
    func okButtonAction(_ alert: CustomAlertVC, alertTag: Int)
    func cancelButtonAction(_ alert: CustomAlertVC, alertTag: Int)
}

class CustomAlertVC: UIViewController {
    
    weak var delegate : CustomAlertDelegate?
    
    var alertTag = 0
    var isCancelBtnHidden = false
    
    var alertTitle = ""
    var alertMessage = ""
    var okButtonTitle = "Ok"
    var cancelButtonTitle = "Cancel"
    var statusImage = UIImage.init(named: "smiley")
    
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var messegeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var alertView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAlert()
    }
    
    func show() {
        if #available(iOS 13, *) {
            UIApplication.shared.windows.first?.rootViewController?.present(self, animated: true, completion: nil)
        } else {
            UIApplication.shared.keyWindow?.rootViewController!.present(self, animated: true, completion: nil)
        }
    }
    
    func setupAlert() {
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
