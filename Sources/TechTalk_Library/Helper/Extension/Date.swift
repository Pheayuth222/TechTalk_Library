import Foundation


extension Date {
    
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

    
    var localizedDate: (dateString: String, timeString: String, fulltimeString: String) {
        let calendar    = Calendar.current
        let component   = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        
        let year        = String(format: "%04d", component.year!)
        let month       = String(format: "%02d", component.month!)
        let fullMonth   = self.getMonthName(format: "MMMM")
        let day         = String(format: "%02d", component.day!)
        let hour        = String(format: "%02d", component.hour!)
        let minute      = String(format: "%02d", component.minute!)
        let second      = String(format: "%02d", component.second!)
        
        var dateString      = "\(year)년 \(month)월 \(day)일"
        let timeString      = "\(hour):\(minute)"
        let fullTimeString  = "\(hour):\(minute):\(second)"
        
        dateString = "\(fullMonth.substringWithRange(0, end: 3)) \(day) \(year)"
        
        return (dateString, timeString, fullTimeString)
    }
 
}

extension Date {
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
