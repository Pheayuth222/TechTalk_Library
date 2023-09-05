import UIKit

public class TechTalk_Library {
    
    
    public init() {
    }
    
    public func customAlertPop(titleValue: String, mesString: String, viewController: UIViewController) {
        let alertController = UIAlertController(title: titleValue, message: mesString, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    
}

//extension TechTalk_Library: CustomAlertDelegate {
//    func okButtonAction(_ alert: CustomAlertVC, alertTag: Int) {
//        if alertTag == 1 {
//            print("Single button alert: Ok button pressed")
//        } else {
//            print("Two button alert: Ok button pressed")
//        }
//        print(alert.alertTitle)
//    }
//
//    func cancelButtonAction(_ alert: CustomAlertVC, alertTag: Int) {
//        print("Cancel button pressed")
//    }
//
//}

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
    
    init() {
        super.init(nibName: "CustomAlertVC", bundle: Bundle(for: CustomAlertVC.self))
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
        
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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


public extension Date {
    
    var yesterday: Date { return Date().dayBefore }
    var tomorrow : Date { return Date().dayAfter }
    
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var day: Int {
        return Calendar.current.component(.day,  from: self)
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var year: Int {
        return Calendar.current.component(.year,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
    
    
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
    
    var weekdayOrdinal: Int {
        return Calendar.current.component(.weekday, from: self) // 0-6
    }
    
    var weekdayName: String {
        return formatToString(format: "E")
    }
    
    var monthName: String {
        return formatToString(format: "MMM")
    }
    
    func getYearString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "yyyy"
        let strDay = dateFormatter.string(from: self)
        return strDay
    }
    
    func getMonthName(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = format
        let strMonth = dateFormatter.string(from: self)
        return strMonth
    }
    
    func getDayString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "dd"
        let strDay = dateFormatter.string(from: self)
        return strDay
    }
    
    func formatToString(format: String) -> String {
        let dateformatter           = DateFormatter()
        dateformatter.dateFormat    = format
        dateformatter.timeZone      = Calendar.current.timeZone
        dateformatter.locale        = Locale(identifier: "en") // Calendar.current.locale
        
        return dateformatter.string(from: self)
    }
    
    /// Calculate 2 dates
    /// - Parameter comp: .month, .day, .year
    /// - Parameter date: date
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {

        let currentCalendar = Calendar.current

        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }

        return end - start
    }
   
    //All Date between two date
    static func datesBetweenInterval(startDate: Date, endDate: Date) -> [String] {
        var startDate = startDate
        let calendar = Calendar.current
        var arrDates : [String] = []
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"

        while startDate <= endDate {
            arrDates.append(fmt.string(from: startDate))
            startDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        }
        return arrDates
    }

 
    
    func getTimeString() -> String {
        let dateFormatter = DateFormatter()
        let lang = "en"
        dateFormatter.locale = Locale(identifier: lang)
        var formatString = ""
        switch lang {
        case "en":
            formatString = "hh:mm"
        case "zh", "ja":
            formatString = "HH : mm"
        default:
            break
        }
        dateFormatter.dateFormat = formatString
        let strTime = dateFormatter.string(from: self)
        return strTime
    }
 
    
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

// MARK: - Extension String

public extension String {
    
    func getEvidenceReceiptDetail() -> String { //ECT_RCPT_GB 3.하이패스 7.주유비 8.교통비 9.출장비
        
        switch self {
        case "3":
            return "하이패스"
        case "7":
            return "주유비"
        case "8":
            return "교통비"
        case "9":
            return "출장비"
        default:
            return "기타(간이)"
        }
    }
    
    func characterAtIndex(_ i: Int) -> Character? {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
    
    func range(fromNsRange nsrange: NSRange) -> Range<String.Index>? {
        guard let lowerBound = index(startIndex, offsetBy: nsrange.location, limitedBy: endIndex) else {
            return nil
        }
        guard let upperBound = index(lowerBound, offsetBy: nsrange.length, limitedBy: endIndex) else {
            return nil
        }

        return lowerBound..<upperBound
    }

    func nsrange(fromRange range: Range<String.Index>) -> NSRange {
        let location = distance(from: startIndex, to: range.lowerBound)
        let length = distance(from: range.lowerBound, to: range.upperBound)

        return NSMakeRange(location, length)
    }

    func range(fromUtf16NsRange nsrange: NSRange) -> Range<String.Index>? {
        guard let utf16LowerBound = utf16.index(utf16.startIndex, offsetBy: nsrange.location, limitedBy: utf16.endIndex) else {
            return nil
        }
        guard let utf16UpperBound = utf16.index(utf16LowerBound, offsetBy: nsrange.length, limitedBy: utf16.endIndex) else {
            return nil
        }

        guard let lowerBound = String.Index(utf16LowerBound, within: self) else {
            return range(fromUtf16NsRange: NSMakeRange(nsrange.location + 1, nsrange.length))
        }
        guard let upperBound = String.Index(utf16UpperBound, within: self) else {
            return range(fromUtf16NsRange: NSMakeRange(nsrange.location, nsrange.length + 1))
        }

        return lowerBound..<upperBound
    }

    func utf16Nsrange(fromRange range: Range<String.Index>) -> NSRange? {
        guard let utf16LowerBound = range.lowerBound.samePosition(in: utf16) else {
            return nil;
        }
        guard let utf16UpperBound = range.upperBound.samePosition(in: utf16) else {
            return nil;
        }
        let location = utf16.distance(from: utf16.startIndex, to: utf16LowerBound)
        let length = utf16.distance(from: utf16LowerBound, to: utf16UpperBound)

        return NSMakeRange(location, length)
    }
    
    func insert(_ string:String,ind:Int) -> String {
        return  String(self.prefix(ind)) + string + String(self.suffix(self.count-ind))
    }
    func formatEnglishTime() -> String {
        if self.isEmpty {
            return ""
        }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en")
        formatter.dateFormat = "HHmmss"
        let myTime = formatter.date(from: self)
        let _myTime = myTime?.getTimeString()
        return _myTime ?? ""
    }
    
    var splitLines: [String] {
        var result: [String] = []
        enumerateLines { line, _ in result.append(line) }
        return result
    }
    
    var trim: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var isNotEmpty: Bool {
        return self.trim != ""
    }
    
    var isInt: Bool {
        return Int(self) != nil
    }
    
    var toInt: Int {
        return Int(self) ?? 0
    }
    
    var toDouble: Double {
        return Double(self) ?? 0
    }
    
    var camelCased: String {
        return (self as NSString)
            .replacingOccurrences(of: "([A-Z])", with: " $1", options:
                .regularExpression, range: NSRange(location: 0, length: count))
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .capitalized
    }
    
    var toDictionary: [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                #if DEBUG
                print(error.localizedDescription)
                #endif
            }
        }
        return nil
    }
    
    var krCurrency: String {
        let currencyFormatter                   = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.groupingSeparator     = ","
        currencyFormatter.decimalSeparator      = "."
        currencyFormatter.currencySymbol        = ""
        currencyFormatter.numberStyle           = .currency
        currencyFormatter.locale                = .init(identifier: "en_US")
        return currencyFormatter.string(from: NSNumber(value: self.toDouble))?.components(separatedBy: ".")[0] ?? ""
    }
    
    var usdCurrency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.currencySymbol = ""
        formatter.locale = Locale(identifier: "en_US")
        
        let format = formatter.string(from: NSNumber(floatLiteral: (self as NSString).doubleValue))!
        
        if format.contains(".00"){
            return format.components(separatedBy: ".")[0]
        }else {
            return format
        }
    }
    var currency: String {
        let currencyFormatter                   = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.groupingSeparator     = ","
        currencyFormatter.decimalSeparator      = "."
        currencyFormatter.currencySymbol        = ""
        currencyFormatter.numberStyle           = .currency
        currencyFormatter.locale                = .init(identifier: "en_US")
        let currency = currencyFormatter.string(from: NSNumber(value: self.toDouble)) ?? ""
        if currency.contains(".00"){
            return currency.components(separatedBy: ".")[0]
        }else {
            return currency
        
        }
    }
    
    var html2String: String {
        guard let data = data(using: .utf8) else { return "" }
        do {
            let attributeString = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            
            return attributeString.string
        } catch let error as NSError {
            #if DEBUG
            print(error.localizedDescription)
            #endif
            return ""
        }
    }
    
    var html2AttrString: NSAttributedString {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            let attributeString = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            
            return attributeString
        } catch let error as NSError {
            #if DEBUG
            print(error.localizedDescription)
            #endif
            return NSAttributedString()
        }
    }
    
    func deleteHTMLTag(tag:String) -> String {
        return self.replacingOccurrences(of: "(?i)</?\(tag)\\b[^<]*>", with: "", options: .regularExpression, range: nil)
    }
   
    func deleteHTMLTags(tags:[String]) -> String {
        var mutableString = self
        for tag in tags {
            mutableString = mutableString.deleteHTMLTag(tag: tag)
        }
        return mutableString
    }
    
    mutating func replaced(of: String, with: String) {
        self = self.replacingOccurrences(of: of, with: with)
    }
    
    func replace(of: String, with: String) -> String {
        return self.replacingOccurrences(of: of, with: with)
    }
    func replaceDictionary(_ dictionary: [String: String]) -> String{
         var result = String()
         var i = -1
         for (of , with): (String, String)in dictionary{
             i += 1
             if i<1{
                 result = self.replacingOccurrences(of: of, with: with)
             }else{
                 result = result.replacingOccurrences(of: of, with: with)
             }
         }
       return result
    }
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    func generateDate(format: String, getType: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en")
        formatter.dateFormat = format
        let myDate = formatter.date(from: self)
        guard let _myDate = myDate else {return ""}
        switch getType {
        case "month":
            return _myDate.getMonthName(format: "MMMM")
        case "year":
            return _myDate.getYearString()
        case "day":
            return _myDate.getDayString()
        case "time":
            return _myDate.getTimeString()
        default:
            return ""
        }
    }
    
    func formatFromTimeStampToStringSeleDate(format: String) -> String {
        let getDate = DateFormatter()
        getDate.dateFormat = "yyyy-MM-dd HH:mm"
        let date = getDate.date(from: self)
        
        let dateFormatter          = DateFormatter()
        dateFormatter.dateFormat   = format
        dateFormatter.timeZone     = Calendar.current.timeZone
        dateFormatter.locale       = Locale(identifier: "en"/*"en_US_POSIX"*/) // Calendar.current.locale
        
        return dateFormatter.string(from: date ?? Date())
    }
    
    func formatToDate(format: String, locale: String = "en") -> Date {
        let dateFormatter           = DateFormatter()
        dateFormatter.dateFormat    = format
        dateFormatter.timeZone      = Calendar.current.timeZone
        dateFormatter.locale        = Locale(identifier: locale /*"en_US_POSIX"*/) // Calendar.current.locale
        
        return dateFormatter.date(from: self) ?? Date()
    }
    
    func format(format: String, fromFormat: String = "yyyy-MM-dd") -> String {
        let dateFormatter           = DateFormatter()
        dateFormatter.dateFormat    = format
        dateFormatter.timeZone      = Calendar.current.timeZone
        dateFormatter.locale        = Locale(identifier: "en") /*"en_US_POSIX"*/ // Calendar.current.locale
        
        let getDate = DateFormatter()
        getDate.dateFormat = fromFormat
        
        return dateFormatter.string(from: getDate.date(from: self) ?? Date())
    }
    
    
    var fromBase64: String? {
        guard let data = Data(base64Encoded: self, options: Data.Base64DecodingOptions(rawValue: 0)) else {
            return nil
        }
        return String(data: data as Data, encoding: String.Encoding.utf8)
    }
    
    var toBase64: String? {
        guard let data = self.data(using: String.Encoding.utf8) else {
            return nil
        }
        return data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
    }
    
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.height
    }
    
    func substringWithRange(_ start: Int, end: Int) -> String {
        if (start < 0 || start > self.count) {
            return ""
        }
        else if end < 0 || end > self.count {
            return ""
        }
        let range = (self.index(self.startIndex, offsetBy: start) ..< self.index(self.startIndex, offsetBy: end))
        return String(self[range])
    }
    
    subscript(_ range: CountableRange<Int>) -> String {
        let idx1 = index(startIndex, offsetBy: max(0, range.lowerBound))
        let idx2 = index(startIndex, offsetBy: min(self.count, range.upperBound))
        return String(self[idx1..<idx2])
    }
    
    
    func lastIndexOf(target: String)->Int?{
        if let range = self.range(of: target, options: .backwards, range: nil, locale: nil) {
            return distance(from: self.startIndex, to: range.lowerBound)
        } else {
            return nil
        }
    }
    
    func lastRangeOf(target: String)->String.Index?{
        if let range = self.range(of: target, options: .backwards, range: nil, locale: nil) {
            return range.lowerBound
        } else {
           return nil
       }
    }
    
    func formatKRWCurrency() -> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        formatter.roundingMode = .down
        formatter.currencySymbol = ""
        formatter.locale = Locale(identifier: "en_US")

        let format = formatter.string(from: NSNumber(floatLiteral: (self as NSString).doubleValue))!
        return format
    }
    
    func formatNewKRWCur() -> String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 2
            formatter.roundingMode = .down
            formatter.currencySymbol = ""
            formatter.decimalSeparator = "."
            formatter.groupingSeparator         = ","
            formatter.locale = Locale(identifier: "en_US")

            let format = formatter.string(from: NSNumber(floatLiteral: (self as NSString).doubleValue))!
            return format
        }

    
    func formatKrwCurrency() -> String {
        var number                          : NSNumber = NSNumber()
        let formatter                       = NumberFormatter()
        formatter.numberStyle               = .decimal
        formatter.currencySymbol            = ""
        formatter.currencyGroupingSeparator = ","
        formatter.currencyDecimalSeparator  = ","
        formatter.decimalSeparator          = ","
        formatter.currencyCode              = ""
        formatter.groupingSeparator         = ","
 
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        if let regex = try? NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive) {
            amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        }
            
        if let myInteger = Int(((amountWithPrefix as NSString) as String)) {
            number = NSNumber(value: myInteger)
        }
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number) ?? ""
    }
    
    // Ex: 4519-****-****-2580
    func getFormatCardNumber() -> String {
        
        if self.count >= 5 {
            let firstIndex = self.index(self.startIndex, offsetBy: 5)
            let lastIndex = self.index(self.endIndex, offsetBy: -5)

            let firstDigit = self.index(before: firstIndex)
            let lastDigit = self.index(after: lastIndex)
            
            let startDigit = self.prefix(upTo: firstDigit)
            let endDigit = self.suffix(from: lastDigit)
            
            return String(startDigit) + "-****-****-" + String(endDigit)
        }
        else {
            return self
        }
    }
    
    // Ex: 102-00-0000 || 102-001-0000
    func getFormatCompanyNumber() -> String {
        return self // Get format from Server Feedback from Mr.Kim
//        if self.count >= 5 {
//            let firstIndex = self.index(self.startIndex, offsetBy: 4)
//            let lastIndex = self.index(self.endIndex, offsetBy: -5)
//
//            let firstDigit = self.index(before: firstIndex)
//            let lastDigit = self.index(after: lastIndex)
//
//            let startDigit = self.prefix(upTo: firstDigit)
//            let endDigit = self.suffix(from: lastDigit)
//
//            let dropLast4 = self.dropLast(4)
//            let middleString = dropLast4.dropFirst(3)
//
//            return String(startDigit) + "-\(middleString)-" + String(endDigit)
//        }
//        else {
//            return self
//        }
    }
    
    func getLast4Characters() -> String {
        if self.count > 4 {
            let product = self.suffix(4)
            return String(product)
        }
        else {
            return self
        }
    }
    
    func stringHeightWithFontSize(_ font:UIFont, width: CGFloat) -> CGFloat {
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping;
        let attributes = [NSAttributedString.Key.font:font,
                          NSAttributedString.Key.paragraphStyle:paragraphStyle.copy()]
        
        let text = self as NSString
        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: attributes, context:nil)
        return rect.size.height
    }
    
    /*
     TODO : Return array of string that match with Regular expression
     added by sambo
     */

    func matchesForRegexInText(_ regex: String!, text: String!) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = text as NSString
            let results = regex.matches(in: text, options: [], range: NSMakeRange(0, nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        }
        catch let error as NSError {
            #if DEBUG
            print("invalid regex: \(error.localizedDescription)")
            #endif
            return []
        }catch{
            #if DEBUG
            print("Error")
            #endif
            return []
        }
    }
    
    // KT Format Account number
    func formatAccountNumber() -> String {
        
        let format1 = self.replace(of: "-", with: "")
        let format = format1.replace(of: " ", with: "")
        
        if format.count <= 3 {
            return format
        }
        
        let firstDigits = format.substringWithRange(0, end: 3)
        
        if format.count <= 6 {
            return format
        }
        
        let secondDigits = format.substringWithRange(3, end: 6)
        
        let thirdDigits = format.substringWithRange(6, end: self.count)
        
        return "\(firstDigits) - \(secondDigits) - \(thirdDigits)"
        
    }
    
    /*
     TODO : For Korea Phone number formate
     added by sambo
     */
    func formatKRPhoneNumber() -> String{ //숫자만 남겨놓고 모두 제거
        
        var phone = matchesForRegexInText("[0-9]", text: self).joined(separator: "")
        
        if phone.count == 9 {
            phone = phone.substringWithRange(0, end: 2) + "-" + phone.substringWithRange(2, end: 5) + "-" + phone.substringWithRange(5, end: 9)
        }else if phone.count == 10 {
            if phone.substringWithRange(0, end: 2) == "02" { //지역번호 서울인 경우
                phone = phone.substringWithRange(0, end: 2) + "-" + phone.substringWithRange(2, end: 6) + "-" + phone.substringWithRange(6, end: 10)
            }else {
                phone = phone.substringWithRange(0, end: 3) + "-" + phone.substringWithRange(3, end: 6) + "-" + phone.substringWithRange(6, end: 10)
            }
        }else if phone.count == 11 {
            phone = phone.substringWithRange(0, end: 3) + "-" + phone.substringWithRange(3, end: 7) + "-" + phone.substringWithRange(7, end: 11)
        }
        return phone
    }
    func formatHintPhoneNumber(isNoPlusSymbol: Bool = true) -> String {
        
        var phone = matchesForRegexInText("[0-9]", text: self).joined(separator: "")
        let plusSymbol = isNoPlusSymbol ? "" : "+"
        
        if phone.count == 9 {
            phone = plusSymbol + phone.substringWithRange(0, end: 2) + "-" + "****" + "-" + phone.substringWithRange(5, end: 9)
        }else if phone.count == 10 {
            if phone.substringWithRange(0, end: 2) == "02" { //지역번호 서울인 경우
                phone = plusSymbol + phone.substringWithRange(0, end: 2) + "-" + "****" + "-" + phone.substringWithRange(6, end: 10)
            }else {
                phone = plusSymbol + phone.substringWithRange(0, end: 3) + "-" + "****" + "-" + phone.substringWithRange(6, end: 10)
            }
        }else if phone.count == 11 {
            phone = plusSymbol + phone.substringWithRange(0, end: 3) + "-" + "****" + "-" + phone.substringWithRange(7, end: 11)
        }
        return phone
    }
    
    func formatUSDCurrency() -> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.currencySymbol = ""
        formatter.locale = Locale(identifier: "en_US")

        let format = formatter.string(from: NSNumber(floatLiteral: (self as NSString).doubleValue))!
        return format

    }
    
    func formatYearMonthDay() -> String {
        
        if self.count < 8 {
            return self
        }
        else {
            let reg = self.matchesForRegexInText("[0-9]", text: self).joined(separator: "")
            let myNSString = reg as NSString
            
            let year    = myNSString.substring(with: NSRange(location: 0, length: 4))
            let month   = myNSString.substring(with: NSRange(location: 4, length: 2))
            let day     = myNSString.substring(with: NSRange(location: 6, length: 2))
            
            return "\(year).\(month).\(day)"
        }
    }

    func formatDateTimeWithoutWeekDay() -> String {
        //"ADTN_ITM3" : "20200208150000"
        
        if self.count < 12 {
            return formatYearMonthDay()
        }
        else {
            let myNSString = self as NSString
            let year    = myNSString.substring(with: NSRange(location: 0, length: 4))
            let month   = myNSString.substring(with: NSRange(location: 4, length: 2))
            let day     = myNSString.substring(with: NSRange(location: 6, length: 2))
            let hour    = myNSString.substring(with: NSRange(location: 8, length: 2))
            let minute  = myNSString.substring(with: NSRange(location: 10, length: 2))
            let second  = myNSString.substring(with: NSRange(location: 12, length: 2))
            if self.count == 12 {
               return "\(year).\(month).\(day) \(hour):\(minute)"
            }else {
//                return "\(year).\(month).\(day) \(hour):\(minute)"
                  return "\(year).\(month).\(day) \(hour):\(minute):\(second)"
            }
        }
        
    }
    func replaceWithRegular(_ string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: .regularExpression, range: nil)
    }
    func getHourAndMinute() -> String {
        let time = self.replaceWithRegular("[-: ]", replacement: "")
        
        var hourAndMinute = ""
        
        if (time.count == 4 || time.count == 6) {
            let hours   = (time as NSString).substring(with: NSRange(location: 0, length: 2))
            let minutes = (time as NSString).substring(with: NSRange(location: 2, length: 2))
            
            hourAndMinute = "\(hours):\(minutes)"
        }
        else {
            let hours   = (time as NSString).substring(with: NSRange(location: 8, length: 2))
            let minutes = (time as NSString).substring(with: NSRange(location: 10, length: 2))
            
            hourAndMinute = "\(hours):\(minutes)"
        }
        
        return hourAndMinute
    }

    
    
    func getTimeFormat() -> String {
        let myNSString = self as NSString
        var newTime = ""
        if self.count == 6 {
            newTime = myNSString.substring(with: NSRange(location: 0, length: 2)) + ":"
            newTime += myNSString.substring(with: NSRange(location: 2, length: 2))
            return newTime
        }
        return ""
    }
    func substringWithRange(_ start: Int, location: Int) -> String
    {
        if (start < 0 || start > self.count)
        {
            #if DEBUG
                print("start index \(start) out of bounds")
            #endif
            return ""
        }
        else if location < 0 || start + location > self.count
        {
            #if DEBUG
                print("end index \(start + location) out of bounds")
            #endif
            return ""
        }
        let range = (self.index(self.startIndex, offsetBy: start) ..< self.index(self.startIndex, offsetBy: start + location))
        return String(self[range])
    }
    
    var isDigit: Bool {
        CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: self))
    }
    
    func masked(replacementCharacter: Character = "*") -> String {
        var maskedString = String()
        for character in self {
            if String(character).isDigit {
                maskedString.append(replacementCharacter)
            } else {
                maskedString.append(character)
            }
        }
        return maskedString
    }
    
    mutating func insert(string:String,ind:Int) {
        self.insert(contentsOf: string, at:self.index(self.startIndex, offsetBy: ind) )
    }
    
    func applyPatternOnNumbers(pattern: String, replacementCharacter: Character) -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(encodedOffset: index)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacementCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
    
    func formattingNumber(_ num: Double) -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.decimalSeparator = "."
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: num as NSNumber)!
    }
    
    func formattedDateFromString(dateString: String, withFormat format: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd-MM-yyyy"

        if let date = inputFormatter.date(from: dateString) {
            
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = format
            outputFormatter.locale = Locale(identifier: "en")
            return outputFormatter.string(from: date)
        }

        return nil
    }
    
}

// MARK: - NSAttributedString

extension NSAttributedString {
    
    var splitLines : [NSAttributedString] {
        var result = [NSAttributedString]()
        let separatedStrings = string.splitLines
        var range = NSRange(location: 0, length: 0)
        for string in separatedStrings {
            range.length = NSAttributedString(string: string).length
            let attributedString = attributedSubstring(from: range)
            result.append(attributedString)
            range.location += range.length + NSAttributedString(string: "\n").length
        }
        return result
    }
    
    func components(separatedBy separator: String) -> [NSAttributedString] {
        var result = [NSAttributedString]()
        let separatedStrings = string.components(separatedBy: separator)
        var range = NSRange(location: 0, length: 0)
        for string in separatedStrings {
            range.length = NSAttributedString(string: string).length
            let attributedString = attributedSubstring(from: range)
            result.append(attributedString)
            range.location += range.length + NSAttributedString(string: separator).length
        }
        return result
    }
    
    func contains(_ character: String) -> Bool {
        return self.string.contains(character)
    }
    
    func replace(of: String, with: String) -> NSMutableAttributedString {
        let mutableAttributedString = mutableCopy() as! NSMutableAttributedString
        let mutableString = mutableAttributedString.mutableString
        
        while mutableString.contains(of) {
            let rangeOfStringToBeReplaced = mutableString.range(of: of)
            mutableAttributedString.replaceCharacters(in: rangeOfStringToBeReplaced, with: with)
        }
        return mutableAttributedString
    }
    
    func remove(of: String) -> NSMutableAttributedString {
        let mutableAttributedString = mutableCopy() as! NSMutableAttributedString
        let mutableString = mutableAttributedString.mutableString
        
        while mutableString.contains(of) {
            let rangeOfStringToBeReplaced = mutableString.range(of: of)
            mutableAttributedString.replaceCharacters(in: rangeOfStringToBeReplaced, with: "")
        }
        return mutableAttributedString
    }
    
    var trim : NSAttributedString {
        let invertedSet = CharacterSet.whitespacesAndNewlines.inverted
        let startRange = string.rangeOfCharacter(from: invertedSet)
        let endRange = string.rangeOfCharacter(from: invertedSet, options: .backwards)
        guard let startLocation = startRange?.upperBound, let endLocation = endRange?.lowerBound else {
            return NSAttributedString(string: string)
        }
        let location = string.distance(from: string.startIndex, to: startLocation) - 1
        let length = string.distance(from: startLocation, to: endLocation) + 2
        let range = NSRange(location: location, length: length)
        return attributedSubstring(from: range)
    }
    
    func heightWithConstrainedWidth(width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil)
        
        return boundingBox.height
    }
    
    func bold(_ isBold: Bool, in range: NSRange) -> NSAttributedString {
        let attrString = NSMutableAttributedString(attributedString: self)
        let substring = NSMutableAttributedString(attributedString: attrString.attributedSubstring(from: range))
        
        substring.enumerateAttribute(.font, in: NSRange(location: 0, length: substring.length), options: [.longestEffectiveRangeNotRequired]) { (value, range, stop) in
            if var font = value as? UIFont {
                /* Using Matrix because Korean characters is not support italic. */
                let italic = font.fontDescriptor.object(forKey: UIFontDescriptor.AttributeName(rawValue: "NSCTFontMatrixAttribute")) != nil
//                var styles: UIFontDescriptor.SymbolicTraits = []
                
                if isBold {
                    font = UIFont.systemFont(ofSize: font.pointSize, weight: .bold)
//                    styles.insert(.traitBold)
                }
                else {
                    font = UIFont.systemFont(ofSize: font.pointSize, weight: .regular)
                }
                
                if italic {
//                    styles.insert(.traitItalic)
                    let matrix = CGAffineTransform(a: 1, b: 0, c: CGFloat(tanf(Float(10 * (Double.pi / 180)))), d: 1, tx: 0, ty: 0)
                    let descriptor = font.fontDescriptor.withMatrix(matrix)
                    font = UIFont(descriptor: descriptor, size: font.pointSize)
                }
                
//                if let descriptor = font.fontDescriptor.withSymbolicTraits(styles) {
//                    let font = UIFont(descriptor: descriptor, size: font.pointSize)
                    substring.addAttribute(.font, value: font, range: range)
//                }
            }
        }
        
        attrString.replaceCharacters(in: range, with: substring)
        return attrString
    }
    
    func italic(_ isItalic: Bool, in range: NSRange) -> NSAttributedString {
        let attrString = NSMutableAttributedString(attributedString: self)
        let substring = NSMutableAttributedString(attributedString: attrString.attributedSubstring(from: range))
        
        substring.enumerateAttribute(.font, in: NSRange(location: 0, length: substring.length), options: [.longestEffectiveRangeNotRequired]) { (value, range, stop) in
            if var font = value as? UIFont, let fontFace = font.fontDescriptor.object(forKey: .face) as? String {
//                var styles: UIFontDescriptor.SymbolicTraits = []
                
                if UIAccessibility.isBoldTextEnabled {
                    // English: Heavy, Korean: Bold
                    if fontFace.lowercased().contains("heavy") || fontFace.lowercased().contains("bold") { // || fontFace.contains("Semibold") {
                        font = UIFont.systemFont(ofSize: font.pointSize, weight: .bold)
//                        styles.insert(.traitBold)
                    }
                    else {
                        font = UIFont.systemFont(ofSize: font.pointSize, weight: .regular)
                    }
                }
                else {
                    // English: Semibold, Korean: Bold
                    if fontFace.lowercased().contains("semibold") || fontFace.lowercased().contains("bold") {
                        font = UIFont.systemFont(ofSize: font.pointSize, weight: .bold)
//                        styles.insert(.traitBold)
                    }
                    else {
                        font = UIFont.systemFont(ofSize: font.pointSize, weight: .regular)
                    }
                }
                
                if isItalic {
                    /* Using Matrix because Korean characters is not support italic. */
                    let matrix = CGAffineTransform(a: 1, b: 0, c: CGFloat(tanf(Float(10 * (Double.pi / 180)))), d: 1, tx: 0, ty: 0)
                    let descriptor = font.fontDescriptor.withMatrix(matrix)
                    font = UIFont(descriptor: descriptor, size: font.pointSize)
                    
//                    styles.insert(.traitItalic)
                }
                
//                if let descriptor = font.fontDescriptor.withSymbolicTraits(styles) {
//                    let font = UIFont(descriptor: descriptor, size: font.pointSize)
                    substring.addAttribute(.font, value: font, range: range)
//                }
            }
        }
        
        attrString.replaceCharacters(in: range, with: substring)
        return attrString
    }
    
    func underline(_ isUnderline: Bool, in range: NSRange) -> NSAttributedString {
        let attrString = NSMutableAttributedString(attributedString: self)
        
        if isUnderline {
            attrString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        }
        else {
            attrString.removeAttribute(.underlineStyle, range: range)
        }
        
        return attrString
    }
    
    func strikethrough(_ isStrikethrough: Bool, in range: NSRange) -> NSAttributedString {
        let attrString = NSMutableAttributedString(attributedString: self)
        
        if isStrikethrough {
            attrString.addAttribute(.strikethroughStyle, value: 2, range: range)
        }
        else {
            attrString.removeAttribute(.strikethroughStyle, range: range)
        }
        
        return attrString
    }
   
}

// MARK: - UIDevice

public struct ScreenSize {
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

public struct DeviceType {
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 480.0 && ScreenSize.SCREEN_WIDTH == 320.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0 && ScreenSize.SCREEN_WIDTH == 320.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0 && ScreenSize.SCREEN_WIDTH == 375.0
    static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0 && ScreenSize.SCREEN_WIDTH == 414.0
    static let IS_IPHONE_X          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0 && ScreenSize.SCREEN_WIDTH == 375.0
    static let IS_IPHONE_X_MAX      = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 896.0 && ScreenSize.SCREEN_WIDTH == 414.0
}

public extension UIDevice {
    
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        return identifier
    }()
}


// MARK: - Numberic

public extension Double {
    
    var isZero: Bool {
        return self == 0
    }
    
    var isNotZero: Bool {
        return self != 0
    }
    
    var toString: String {
        return String(self)
    }
}

public extension CGFloat {
    
    var isZero: Bool {
        return self == 0
    }
    
    var isNotZero: Bool {
        return self != 0
    }
}

public extension Int {
    
    var toString: String {
        return String(self)
    }
}


// MARK: - Array

public extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
    func chunked(by chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }
}

public struct Array2D<T> {
    
    public let columns      : Int
    public let rows         : Int
    fileprivate var array   : [T]
    
    public init(columns: Int, rows: Int, initialValue: T) {
        self.columns = columns
        self.rows = rows
        array = .init(repeating: initialValue, count: rows*columns)
    }
    
    public subscript(column: Int, row: Int) -> T {
        get {
            precondition(column < columns, "Column \(column) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
            precondition(row < rows, "Row \(row) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
            return array[row*columns + column]
        }
        set {
            precondition(column < columns, "Column \(column) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
            precondition(row < rows, "Row \(row) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
            array[row*columns + column] = newValue
        }
    }
}

public struct Array1D<T> {
    
    public let rows: Int
    fileprivate var array: [T]
    
    public init(rows: Int, initialValue: T) {
        self.rows = rows
        array = .init(repeating: initialValue, count: rows)
    }
    
    public subscript(row: Int) -> T {
        get {
            return array[row]
        }
        set {
            array[row] = newValue
        }
    }
}
//TODO:-Check unique Arr
public extension Sequence where Element: Hashable {

    /// Returns true (unique) if no element is equal to any other element.
    func isDistinct() -> Bool {
        var set = Set<Element>()
        for e in self {
            if set.insert(e).inserted == false { return false }
        }
        return true
    }
}
//TODO:-Remove Duplicate Arr
public extension Array where Element: Hashable {
    
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
//TODO:-Get duplicate Array
public extension Array where Element: Hashable {
    ///Return duplicate array
    func duplicates() -> Array {
        let groups = Dictionary(grouping: self, by: {$0})
        let duplicateGroups = groups.filter {$1.count > 1}
        let duplicates = Array(duplicateGroups.keys)
        return duplicates
    }
}

// MARK: - UIViewController

public extension UIViewController {
   
    func PopupVC(storyboard: String, identifier: String) -> UIViewController {
        let vc = UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: identifier)
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        vc.providesPresentationContextTransitionStyle = true
        vc.definesPresentationContext = true
        return vc
    }
    
    func VC(sbName: String, identifier: String) -> UIViewController {
        return UIStoryboard(name: sbName, bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    
    func navController(sbName: String, identifier: String) -> UINavigationController {
        return UIStoryboard(name: sbName, bundle: nil).instantiateViewController(withIdentifier: identifier) as! UINavigationController
    }
    
    func popupVcFullScreen(storyboard: String, identifier: String) -> UIViewController {
        let vc = UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: identifier)
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.providesPresentationContextTransitionStyle = true
        vc.definesPresentationContext = true
        return vc
    }
    
    func convertStr12toStr25(_ str12: String) -> String {
        if str12.isEmpty {
            return "000000"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HHmmss"
        if str12.count == 4 {
            dateFormatter.dateFormat = "hhmm"
        }
        else {
            dateFormatter.dateFormat = "hmmss"
        }
        
        guard let date = dateFormatter.date(from: str12) else {
            return "000000"
        }
        dateFormatter.dateFormat = "HHmmss"
        let date24 = dateFormatter.string(from: date)
        return date24
    }
    
    
    func hightlightSearchText(fullText: String, searchText: String, fontSize: CGFloat, colorHex: String = "3E4449") -> NSMutableAttributedString {
        
        //process highlight color on search result
        var managerNameMutableString = NSMutableAttributedString()
        managerNameMutableString = NSMutableAttributedString(string: searchText, attributes: [NSAttributedString.Key.font: UIFont.init(name: "AppleSDGothicNeo-SemiBold", size: fontSize)!])
        managerNameMutableString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.init(hexString: colorHex)], range: NSMakeRange(0,searchText.count))
        
        let range : NSRange = (searchText as NSString).range(of: fullText, options:.caseInsensitive)
        managerNameMutableString.setAttributes([NSAttributedString.Key.font: UIFont.init(name: "AppleSDGothicNeo-SemiBold", size: fontSize)!,NSAttributedString.Key.foregroundColor: UIColor.base], range: range)
        return managerNameMutableString
    }
    
    func attrColor(labelFullText: UILabel, searchText: String) -> NSMutableAttributedString {
        let range = ((labelFullText.text ?? "") as NSString).range(of: searchText)
        let attributedString = NSMutableAttributedString(string: labelFullText.text ?? "")
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 39, green: 107, blue: 252), range: range)
        
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: labelFullText.font.pointSize, weight: .regular), range: range)
        
        return attributedString
    }
    
    func attrColorWelcome(labelFullText: UILabel, searchText: String,color:UIColor) -> NSMutableAttributedString {
        let range = ((labelFullText.text ?? "") as NSString).range(of: searchText)
        let attributedString = NSMutableAttributedString(string: labelFullText.text ?? "")
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value:color, range: range)
        
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.init(name: "AppleSDGothicNeo-Medium", size: 22) as Any, range: range)
        
        return attributedString
    }
    
    
}
