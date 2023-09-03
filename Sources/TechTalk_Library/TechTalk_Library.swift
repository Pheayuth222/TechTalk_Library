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


public extension Date {
    
    init(string: String, format: String = "yyyy/MM/dd HH:mm:ss") {
        let formatter = DateFormatter()
        formatter.timeZone = Calendar.current.timeZone
        formatter.dateFormat = format
        if let date = formatter.date(from: string) {
            self = date
        }
        else {
            self = Date()
        }
    }
    
    static var now: Date {
        let now = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let str = formatter.string(from: now)
        
        formatter.timeZone = Calendar.current.timeZone
        return formatter.date(from: str)!
    }
    
    static var nowWithoutTime: Date {
        let now = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let str = formatter.string(from: now)
        
        formatter.timeZone = Calendar.current.timeZone
        return formatter.date(from: str)!
    }
    
    func toString(format: String = "yyyy/MM/dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.amSymbol = "morning"
        formatter.pmSymbol = "afternoon"
        formatter.timeZone = Calendar.current.timeZone
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func beforeDay(_ day: Int) -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = Calendar.current.timeZone
        let date = calendar.date(byAdding: .day, value: -day, to: self)
        if let date = date {
            return date
        } else {
            return self
        }
    }
        
    func afterDay(_ day: Int) -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = Calendar.current.timeZone
        let date = calendar.date(byAdding: .day, value: day, to: self)
        if let date = date {
            return date
        } else {
            return self
        }
    }
    
    func beforeMonth(_ month: Int) -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = Calendar.current.timeZone
        let date = calendar.date(byAdding: .month, value: -month, to: self)
        if let date = date {
            return date
        } else {
            return self
        }
    }
        
    func afterMonth(_ month: Int) -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = Calendar.current.timeZone
        let date = calendar.date(byAdding: .month, value: month, to: self)
        if let date = date {
            return date
        } else {
            return self
        }
    }
    
    func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
    //HUB_LINK
    var sixMonthAgo: Date {
        return Calendar.current.date(byAdding: .month, value: -6, to: Date())!
    }
    var toDay: Date {
        return Calendar.current.date(byAdding: .day, value: 0, to: Date())!
    }

}
// MARK: - UIColors

public extension UIColor {
    
    var isLight: Bool {
        guard let components = cgColor.components else { return false }
        let redBrightness = components[0] * 299
        let greenBrightness = components[1] * 587
        let blueBrightness = components[2] * 114
        let brightness = (redBrightness + greenBrightness + blueBrightness) / 1000
        return brightness > 0.5
    }
    
    func isLight(threshold: Float) -> Bool {
        let originalCGColor = self.cgColor
        
        let RGBCGColor = originalCGColor.converted(to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil)
        guard let components = RGBCGColor?.components else {
            return false
        }
        guard components.count >= 3 else {
            return false
        }
        
        let com1 = components[0] * 299
        let com2 = components[1] * 587
        let com3 = components[2] * 114
        
        let brightness = Float((com1 + com2 + com3)) / 1000
        return (brightness > threshold)
    }
    
    class var base: UIColor {
        return UIColor.init(hexString: "#0c419b")
    }
    
    convenience init(hex: Int, alpha: CGFloat) {
        let r = CGFloat((hex & 0xFF0000) >> 16)/255
        let g = CGFloat((hex & 0xFF00) >> 8)/255
        let b = CGFloat(hex & 0xFF)/255
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
    
    convenience init(hex: Int) {
        self.init(hex: hex, alpha: 1.0)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return NSString(format:"#%06x", rgb) as String
    }
    
    convenience init(hexString: String, alpha: CGFloat = 1) {
        
        let hexString: String       = (hexString as NSString).trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner                 = Scanner(string: hexString as String)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha: alpha)
    }
    
    public convenience init(red: Int, green: Int, blue: Int, transparency: CGFloat = 1) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        var trans: CGFloat {
            if transparency > 1 {
                return 1
            } else if transparency < 0 {
                return 0
            } else {
                return transparency
            }
        }
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: trans)
    }
    
    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    
    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 1
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
    
    class func receiptNomalBgColor() -> UIColor {
        return UIColor.white
    }
    
    class func receiptNewBgColor() -> UIColor {
        return UIColor(hexString: "#EEF4FF")
    }
    
    //마감
    class func receiptDeadLineColor() -> UIColor {
        return UIColor(hexString: "#F5F5F5")
    }
     /// 기타영수증
    class func toxicGreenColor() -> UIColor {
        return UIColor(hexString: "#73DB2C")
    }
    
    class func jadeColor() -> UIColor {
        return UIColor(hexString: "#00a17d")
    }
    
    /// 법인
    class func dodgerBlueColor() -> UIColor {
        return UIColor(hexString: "#4286F5")
    }
    
     /// 개인
    class func marigoldColor() -> UIColor {
        return UIColor(hexString: "#ffc107")
    }
    
     /// 제로페이
    class func cobaltColor() -> UIColor {
        return UIColor(hexString: "#1c2887")
    }
    
     /// 티머니
    class func barneyPurpleColor() -> UIColor {
        return UIColor(hexString: "#950786")
    }
    
    // App Color
    class func twilightBlueColor() -> UIColor {
        return UIColor(hexString: "0c419a")
    }
    
    class func  warmgrayTextField () -> UIColor {
        return UIColor(hexString: "#BACADB",alpha: 0.15)
    }
    class func warningTextField () -> UIColor {
        return UIColor(hexString: "#F46A69",alpha: 0.15)
    }
    
    class func warmGreyTwo() -> UIColor {
        return UIColor(hexString: "#747474")
    }
    class func warmBlueColor () -> UIColor {
        return UIColor(hexString: "#4A80F6", alpha: 0.15)
    }
    class func disableButtonColor() -> UIColor {
        return UIColor(hexString: "979797")
    }
    class func lightOrangeColor() -> UIColor {
        return UIColor(hexString: "#FFF9EC")
    }
    class func lightPinkColor() -> UIColor {
        return UIColor(hexString: "#FEF0F0")
    }
    class func charcoalGrey() -> UIColor {
        return UIColor(hexString: "#3E4449")
    }
    class func lightCharCoalGrey () -> UIColor {
        return UIColor(hexString: "#3E4449",alpha: 0.5)
    }
    class func lightRed () -> UIColor {
        return UIColor(hexString: "#ff4c4f")
    }
    class func lineLightGrey() -> UIColor {
        return UIColor(hexString: "#E6E6E6")
    }
    class func colorValue() -> UIColor {
        return UIColor(hexString: "282828").withAlphaComponent(1.0)
    }
    class func colorNoValue() -> UIColor {
        return UIColor(hexString: "282828").withAlphaComponent(0.4)
    }
}

public extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

// MARK: - UIVIew

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
}

