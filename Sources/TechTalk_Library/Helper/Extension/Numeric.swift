import UIKit

extension Double {
    
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

extension CGFloat {
    
    var isZero: Bool {
        return self == 0
    }
    
    var isNotZero: Bool {
        return self != 0
    }
}

extension Int {
    
    var toString: String {
        return String(self)
    }
}
