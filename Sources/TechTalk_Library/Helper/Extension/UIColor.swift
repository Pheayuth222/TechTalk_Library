import UIKit

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
