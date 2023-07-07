//
//  AlertOneChoiceVC.swift
//  WeBill
//
//  Created by Huort Seanghay on 12/5/23.
//

import UIKit

typealias Completion_Bool           = (Bool)            -> Void

class AlertOneChoiceVC: UIViewController {

    @IBOutlet weak var alertImage: UIImageView!
    @IBOutlet weak var alertTitle: UILabel!
    @IBOutlet weak var alertDescription: UILabel!
    
    @IBOutlet weak var heightAlertConstraint: NSLayoutConstraint!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var bottomConstraintConBtn: NSLayoutConstraint!
    @IBOutlet weak var heightContentView: NSLayoutConstraint!
    
    var imageString         = ""
    var titleString         = ""
    var messageString       = ""
    var confirmbtnString    = ""
    var isHide  : Bool = true
    
    var confirmAction       : Completion_Bool = { _ in }
    var cancelAction        : Completion_Bool = { _ in }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialized()
        cancelButton.isHidden = isHide
        heightAlertConstraint.constant = 360
        bottomConstraintConBtn.constant = -50
    }
    
    @IBAction func didTapConfirmAction(_ sender: Any) {
        self.dismiss(animated: true)
        cancelAction(true)
    }
    
    @IBAction func didTapCancelAction(_ sender: Any) {
        self.dismiss(animated: true)
        confirmAction(true)
    }
    @IBAction func dismissAction(_ sender: UIButton) {
//        self.dismiss(animated: true)
    }
    
    //MARK: - Private Func
    private func initialized() {
        alertImage?.image       = UIImage(named: imageString)
        alertTitle?.text        = titleString
        alertDescription?.text  = messageString
        confirmButton?.setTitle(confirmbtnString, for: .normal)


    }
    
}

extension UIViewController {
    //for pop up
    func callCommonPopup(withStorybordName storyboard: String, identifier: String) -> UIViewController {
            let vc = UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: identifier)
            vc.modalPresentationStyle                       = .overFullScreen
            vc.modalTransitionStyle                         = .crossDissolve
            vc.providesPresentationContextTransitionStyle   = true
            vc.definesPresentationContext                   = true
            return vc
        }
    
    func customOneAlert(image:String, title: String, message:String, yesTitle: String, completion: @escaping Completion_Bool = {_ in}) {
        
        let vc = self.callCommonPopup(withStorybordName: "AlertOneChoiceSB", identifier: "AlertOneChoiceVC") as! AlertOneChoiceVC
        vc.imageString      = image
        vc.titleString      = title
        vc.messageString    = message
        vc.confirmbtnString = yesTitle
        
        
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        vc.providesPresentationContextTransitionStyle = true
        vc.definesPresentationContext = true
        vc.confirmAction = { _ in
            completion(true)
        }
        vc.cancelAction = { _ in
            completion(false)
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func customTwoAlert(image:String, title: String, message:String, yesTitle: String, completion: @escaping Completion_Bool = {_ in}) {
        
        let vc = self.callCommonPopup(withStorybordName: "AlertOneChoiceSB", identifier: "AlertOneChoiceVC") as! AlertOneChoiceVC
        vc.imageString      = image
        vc.titleString      = title
        vc.messageString    = message
        vc.confirmbtnString = yesTitle
//        vc.heightContentView.constant = 333
        vc.cancelButton.isHidden = true
    
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        vc.providesPresentationContextTransitionStyle = true
        vc.definesPresentationContext = true
        vc.confirmAction = { _ in
            completion(true)
        }
        self.present(vc, animated: true, completion: nil)
    }
    
}
