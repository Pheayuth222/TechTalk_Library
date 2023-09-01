import UIKit

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

