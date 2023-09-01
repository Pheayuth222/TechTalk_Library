import UIKit

public let HRToastDefaultDuration  =   3.0
public let HRToastFadeDuration     =   0.3
public let HRToastHorizontalMargin : CGFloat  =   17.0
public let HRToastVerticalMargin   : CGFloat  =   17.0

public let HRToastPositionDefault  =   "bottom"
public let HRToastPositionTop      =   "top"
public let HRToastPositionCenter   =   "center"
public let HRToastPositionCustom   =   "custom"
 // activity
public let HRToastActivityPositionDefault    = "center"

 // image size
public let HRToastImageViewWidth :  CGFloat  = 80.0
public let HRToastImageViewHeight:  CGFloat  = 80.0
 
 // label setting
public let HRToastMaxWidth       :  CGFloat  = 1.0;      // 80% of parent view width
public let HRToastMaxHeight      :  CGFloat  = 0.8;
public let HRToastFontSize       :  CGFloat  = 16.0
public let HRToastMaxTitleLines              = 0
public let HRToastMaxMessageLines            = 0

 // shadow appearance
public let HRToastShadowOpacity  : CGFloat   = 0.8
public let HRToastShadowRadius   : CGFloat   = 0.0
public let HRToastShadowOffset   : CGSize    = CGSize(width: CGFloat(4.0), height: CGFloat(4.0))

public let HRToastOpacity        : CGFloat   = 0.9
public let HRToastCornerRadius   : CGFloat   = 0.0

public var HRToastActivityView: UnsafePointer<UIView>?    =   nil
public var HRToastTimer: UnsafePointer<Timer>?          =   nil
public var HRToastView: UnsafePointer<UIView>?            =   nil


// Color Scheme
public let HRAppColor:UIColor = UIColor.init(hexString: "2f3030")

public let HRToastHidesOnTap       =   true
public let HRToastDisplayShadow    =   false

@IBDesignable
public class DesignableView: UIView {
}

@IBDesignable
public class DesignableButton: UIButton {
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if imageView != nil {
            imageEdgeInsets = UIEdgeInsets(top: 5, left: (bounds.width - 15), bottom: 5, right: 5)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (imageView?.frame.width)!)
        }
    }

    public override var isHighlighted: Bool {
        didSet {
            if (isHighlighted) {
                super.isHighlighted = false
            }
        }
    }

}

@IBDesignable
public class DesignableTextField: UITextField {
    
    @IBInspectable var insetX: CGFloat = 0
    @IBInspectable var insetY: CGFloat = 0
    
    // placeholder position
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }
    
    // text position
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }
}
public class TopAlignedLabel: UILabel {
    public override func drawText(in rect: CGRect) {
        if let stringText = text {
            let stringTextAsNSString = stringText as NSString
            let labelStringSize = stringTextAsNSString.boundingRect(with:
                CGSize(width: self.frame.width,height: CGFloat.greatestFiniteMagnitude),
                options: NSStringDrawingOptions.usesLineFragmentOrigin,
                attributes: [NSAttributedString.Key.font: font as Any],
                context: nil).size
            super.drawText(in: CGRect(x:0,y: 0,width: self.frame.width, height:ceil(labelStringSize.height)))
        } else {
            super.drawText(in: rect)
        }
    }
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }
}

@IBDesignable
public class DesignableLabel: UILabel {
    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    @IBInspectable
    var leftTextInset: CGFloat {
        set { textInsets.left = newValue }
        get { return textInsets.left }
    }
    
    @IBInspectable
    var rightTextInset: CGFloat {
        set { textInsets.right = newValue }
        get { return textInsets.right }
    }
    
    @IBInspectable
    var topTextInset: CGFloat {
        set { textInsets.top = newValue }
        get { return textInsets.top }
    }
    
    @IBInspectable
    var bottomTextInset: CGFloat {
        set { textInsets.bottom = newValue }
        get { return textInsets.bottom }
    }
    
    public override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top,
                                          left: -textInsets.left,
                                          bottom: -textInsets.bottom,
                                          right: -textInsets.right)
        return textRect.inset(by: invertedInsets)
    }
    
    public override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
}

@IBDesignable
public class DesignableImageView: UIImageView {
}

@IBDesignable public class ButtonCustomWithRightImage: UIButton {
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if imageView != nil {
            imageEdgeInsets = UIEdgeInsets(top: 5, left: (bounds.width - 18), bottom: 5, right: 5)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: ((imageView?.frame.width)! + 5))
        }
    }
    public override var isHighlighted: Bool {
        didSet {
            if (isHighlighted) {
                super.isHighlighted = false
            }
        }
    }
}


public enum ViewBorder: String {
    case left, right, top, bottom
}

public extension UIView {
    
    func add(border: ViewBorder, color: UIColor, width: CGFloat) {
        let borderLayer = CALayer()
        borderLayer.backgroundColor = color.cgColor
        borderLayer.name = border.rawValue
        switch border {
        case .left:
            borderLayer.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        case .right:
            borderLayer.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        case .top:
            borderLayer.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        case .bottom:
            borderLayer.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        }
        self.layer.addSublayer(borderLayer)
    }
    
    func remove(border: ViewBorder) {
        guard let sublayers = self.layer.sublayers else { return }
        var layerForRemove: CALayer?
        for layer in sublayers {
            if layer.name == border.rawValue {
                layerForRemove = layer
            }
        }
        if let layer = layerForRemove {
            layer.removeFromSuperlayer()
        }
    }
    
}

public extension UIView {
   
       
    func bound() {
        self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.3,
            initialSpringVelocity: 0.1,
            options: UIView.AnimationOptions.beginFromCurrentState,
            animations: {
                self.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
    
    func gone() {
        DispatchQueue.main.async {
            self.isHidden = true
        }
    }
    
    func visible() {
        DispatchQueue.main.async {
            self.isHidden = false
        }
    }
    
    var isGone: Bool {
        return self.isHidden == true
    }
    
    var isVisible: Bool {
        return self.isHidden == false
    }
    
    @IBInspectable
    var circular: Bool {
        get {
            return false
        }
        set {
            layer.cornerRadius = min(bounds.width, bounds.height) / 2
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var cornerAllRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            if #available(iOS 11.0, *) {
                layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    @IBInspectable
     var cornerTopRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            if #available(iOS 11.0, *) {
                layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    @IBInspectable
     var cornerBottomRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            if #available(iOS 11.0, *) {
                layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    @IBInspectable
     var cornerLeftRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            if #available(iOS 11.0, *) {
                layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    @IBInspectable
     var cornerRightRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            if #available(iOS 11.0, *) {
                layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    @IBInspectable
     var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
     var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
     var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
     var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
     var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
     var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    @IBInspectable
    /// Corner radius of view; also inspectable from Storyboard.
    var maskToBounds: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
    }
    
    func dashStyle(){
        self.layer.layoutIfNeeded()
        let shapeLayer = CAShapeLayer()
        let selfBounds = self.frame.size
        
        let newBounds = CGRect(x: 0, y: 0, width: selfBounds.width, height: selfBounds.height)
        
        
        shapeLayer.name = "dash"
        shapeLayer.position = CGPoint(x: selfBounds.width / 2, y: selfBounds.height / 2)
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor =  UIColor.gray.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [4, 2]
        self.layer.addSublayer(shapeLayer)
        shapeLayer.bounds = newBounds
        shapeLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: newBounds.width, height: newBounds.height), cornerRadius: self.cornerRadius).cgPath
    }
    
     func underline(forColor: UIColor) {
        let border = CALayer()
        let underlineHeight: CGFloat = 1.0
        
        border.borderColor = forColor.cgColor
        let selfSize = self.frame.size
        border.frame = CGRect(x: 0, y: selfSize.height - underlineHeight, width: selfSize.width, height: selfSize.height)
        
        border.borderWidth = underlineHeight
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
     func makeToast(message msg: String, duration: Double, position: String) {
        let toast = self.viewForMessage(msg, title: nil, image: nil)
        self.showToast(toast: toast!, duration: duration, position: position)
    }
     func showToast(toast: UIView, duration: Double, position: String) {
        let existToast = objc_getAssociatedObject(self, &HRToastView) as! UIView?
        if existToast != nil {
            if let timer: Timer = objc_getAssociatedObject(existToast!, &HRToastTimer) as? Timer {
                timer.invalidate();
            }
            self.hideToast(toast: existToast!, force: false);
        }
        
        toast.center = self.centerPointForPosition(position, toast: toast)
        toast.alpha = 0.0
        
        if HRToastHidesOnTap {
            let tapRecognizer = UITapGestureRecognizer(target: toast, action: #selector(UIView.handleToastTapped(_:)))
            toast.addGestureRecognizer(tapRecognizer)
            toast.isUserInteractionEnabled = true;
            toast.isExclusiveTouch = true;
        }
        
        self.addSubview(toast)
        objc_setAssociatedObject(self, &HRToastView, toast, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        
        UIView.animate(withDuration: HRToastFadeDuration,
                       delay: 0.0, options: ([.curveEaseOut, .allowUserInteraction]),
                       animations: {
                        toast.alpha = 1.0
        },
                       completion: { (finished: Bool) in
                        let timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(UIView.toastTimerDidFinish(_:)), userInfo: toast, repeats: false)
                        objc_setAssociatedObject(toast, &HRToastTimer, timer, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        })
    }
    @objc func handleToastTapped(_ recognizer: UITapGestureRecognizer) {
        self.hideToast(toast: recognizer.view!)
    }
    @objc func toastTimerDidFinish(_ timer: Timer) {
        self.hideToast(toast: timer.userInfo as! UIView)
    }
    func hideToast(toast: UIView) {
        self.isUserInteractionEnabled = true
        self.hideToast(toast: toast, force: false);
    }
    func centerPointForPosition(_ position: String, toast: UIView) -> CGPoint {
        let toastSize = toast.bounds.size
        let viewSize  = self.bounds.size
        switch position {
        case HRToastPositionTop:
            return CGPoint(x: viewSize.width/2, y: toastSize.height/2 + HRToastVerticalMargin)
        case HRToastPositionDefault:
            return CGPoint(x: viewSize.width/2, y: viewSize.height - toastSize.height/2)
        case HRToastPositionCenter:
            return CGPoint(x: viewSize.width/2, y: viewSize.height/2)
        case HRToastPositionCustom :
            return CGPoint(x: viewSize.width/2, y: viewSize.height - toastSize.height/2 - (56 ))
        default:
            #if DEBUG
            print("Warning: Invalid position for toast.")
            #endif
            return self.centerPointForPosition(HRToastPositionDefault, toast: toast)
        }
    }
    func hideToast(toast: UIView, force: Bool) {
        let completeClosure = { (finish: Bool) -> () in
            toast.removeFromSuperview()
            objc_setAssociatedObject(self, &HRToastTimer, nil, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        if force {
            completeClosure(true)
        } else {
            UIView.animate(withDuration: HRToastFadeDuration,
                           delay: 0.0,
                           options: ([.curveEaseIn, .beginFromCurrentState]),
                           animations: {
                            toast.alpha = 0.0
            },
                           completion:completeClosure)
        }
    }
     func viewForMessage(_ msg: String?, title: String?, image: UIImage?) -> UIView? {
        if msg == nil && title == nil && image == nil { return nil }
        
        var msgLabel: UILabel?
        var titleLabel: UILabel?
        var imageView: UIImageView?
        
        let wrapperView = UIView()
        wrapperView.autoresizingMask = ([.flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin])
        wrapperView.layer.cornerRadius = HRToastCornerRadius
        wrapperView.backgroundColor = UIColor.black.withAlphaComponent(HRToastOpacity)
        
        if HRToastDisplayShadow {
            wrapperView.layer.shadowColor = UIColor.black.cgColor
            wrapperView.layer.shadowOpacity = Float(HRToastShadowOpacity)
            wrapperView.layer.shadowRadius = HRToastShadowRadius
            wrapperView.layer.shadowOffset = HRToastShadowOffset
        }
        
        if image != nil {
            imageView = UIImageView(image: image)
            imageView!.contentMode = .scaleAspectFit
            imageView!.frame = CGRect(x: 18.0, y: HRToastVerticalMargin, width: CGFloat(HRToastImageViewWidth), height: CGFloat(HRToastImageViewHeight))
        }
        
        var imageWidth: CGFloat, imageHeight: CGFloat, _ : CGFloat
        if imageView != nil {
            imageWidth = imageView!.bounds.size.width
            imageHeight = imageView!.bounds.size.height
            //      imageLeft = HRToastHorizontalMargin
        } else {
            imageWidth  = 18.0; imageHeight = 0.0
        }
        
        if title != nil {
            titleLabel = UILabel()
            titleLabel!.numberOfLines = HRToastMaxTitleLines
            titleLabel!.font = UIFont.boldSystemFont(ofSize: HRToastFontSize)
            titleLabel!.textAlignment = .center
            titleLabel!.lineBreakMode = .byWordWrapping
            titleLabel!.textColor = UIColor.white
            titleLabel!.backgroundColor = UIColor.clear
            titleLabel!.alpha = 1.0
            titleLabel!.text = title
            
            // size the title label according to the length of the text
            let maxSizeTitle = CGSize(width: (self.bounds.size.width * HRToastMaxWidth) - imageWidth, height: self.bounds.size.height * HRToastMaxHeight);
            let expectedHeight = title!.stringHeightWithFontSize(UIFont.systemFont(ofSize: HRToastFontSize), width: maxSizeTitle.width)
            titleLabel!.frame = CGRect(x: 18.0, y: 0.0, width: maxSizeTitle.width, height: expectedHeight)
        }
        
        if msg != nil {
            msgLabel = UILabel();
            msgLabel!.numberOfLines = HRToastMaxMessageLines
            msgLabel!.font = UIFont.systemFont(ofSize: HRToastFontSize)
            msgLabel!.lineBreakMode = .byWordWrapping
            msgLabel!.textAlignment = .left
            msgLabel!.textColor = UIColor.white
            msgLabel!.backgroundColor = UIColor.clear
            msgLabel!.alpha = 1.0
            msgLabel!.text = msg
            
            let maxSizeMessage = CGSize(width: (self.bounds.size.width * HRToastMaxWidth) - imageWidth, height: self.bounds.size.height * HRToastMaxHeight)
            let expectedHeight = msg!.stringHeightWithFontSize(UIFont.systemFont(ofSize: HRToastFontSize), width: maxSizeMessage.width)
            msgLabel!.frame = CGRect(x: 15.0, y: 0.0, width: maxSizeMessage.width, height: expectedHeight)
        }
        
        var titleWidth: CGFloat, titleHeight: CGFloat, titleTop: CGFloat, titleLeft: CGFloat
        if titleLabel != nil {
            titleWidth = titleLabel!.bounds.size.width
            titleHeight = titleLabel!.bounds.size.height
            titleTop = HRToastVerticalMargin
            titleLeft = 18.0
        } else {
            titleWidth = 0.0; titleHeight = 0.0; titleTop = 0.0; titleLeft = 0.0
        }
        
        var msgWidth: CGFloat, msgHeight: CGFloat, msgTop: CGFloat, msgLeft: CGFloat
        if msgLabel != nil {
            msgWidth = msgLabel!.bounds.size.width
            msgHeight = msgLabel!.bounds.size.height
            msgTop = titleTop + titleHeight + HRToastVerticalMargin
            msgLeft = 18.0
        } else {
            msgWidth = 0.0; msgHeight = 0.0; msgTop = 0.0; msgLeft = 0.0
        }
        
        let largerWidth = max(titleWidth, msgWidth)
        let largerLeft  = max(titleLeft, msgLeft)
        
        // set wrapper view's frame
        let wrapperWidth  = max(imageWidth + HRToastHorizontalMargin * 2, largerLeft + largerWidth + HRToastHorizontalMargin)
        let wrapperHeight = max(msgTop + msgHeight + HRToastVerticalMargin, imageHeight + HRToastVerticalMargin * 2)
        wrapperView.frame = CGRect(x: 0.0, y: 0.0, width: wrapperWidth, height: wrapperHeight)
        
        // add subviews
        if titleLabel != nil {
            titleLabel!.frame = CGRect(x: titleLeft, y: titleTop, width: titleWidth, height: titleHeight)
            wrapperView.addSubview(titleLabel!)
        }
        if msgLabel != nil {
            msgLabel!.frame = CGRect(x: msgLeft, y: msgTop, width: msgWidth, height: msgHeight)
            wrapperView.addSubview(msgLabel!)
        }
        if imageView != nil {
            wrapperView.addSubview(imageView!)
        }
        
        return wrapperView
    }
}
