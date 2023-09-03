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
//
