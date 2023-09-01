import UIKit

extension String {
    
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
}

extension String {
    
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
   
}

extension String {
    
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
}

extension String {
    
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
