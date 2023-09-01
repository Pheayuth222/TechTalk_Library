import UIKit

extension UITextField {
    
    var cursorOffset: Int? {
        guard let range = selectedTextRange else { return nil }
        return offset(from: beginningOfDocument, to: range.start)
    }
    var cursorIndex: String.Index? {
        guard let cursorOffset = cursorOffset else { return nil }
        return text?.index(text!.startIndex, offsetBy: cursorOffset, limitedBy: text!.endIndex)
    }
    
    func keepPasswordWhenBackSpace(textField: UITextField, range: NSRange, string: String) -> Bool {
        let nsString        = textField.text as NSString?
        let updatedString   = nsString?.replacingCharacters(in:range, with:string)
        
        textField.text      = updatedString
        
        //Setting the cursor at the right place
        let selectedRange           = NSMakeRange(range.location + string.count, 0)
        let from                    = textField.position(from: textField.beginningOfDocument, offset:selectedRange.location)
        let to                      = textField.position(from: from!, offset:selectedRange.length)
        textField.selectedTextRange = textField.textRange(from: from!, to: to!)
        
        //Sending an action
        textField.sendActions(for: UIControl.Event.editingChanged)
        
        return false
    }
    func setDoneInputAccessory(_ target: Any?, action: Selector?) {
        let numberToolbar = UIToolbar()
        numberToolbar.barStyle = UIBarStyle.default
        numberToolbar.isTranslucent = true
        numberToolbar.tintColor = UIColor.dodgerBlueColor()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        numberToolbar.items = [spaceButton,
                               UIBarButtonItem(title: "done", style: UIBarButtonItem.Style.done, target: target , action: action)
        ]
        numberToolbar.sizeToFit()
        self.inputAccessoryView = numberToolbar
    }
}
class FirstLineUITextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 0)

        override open func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: padding)
        }

        override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: padding)
        }

        override open func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: padding)
        }
}

extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}
