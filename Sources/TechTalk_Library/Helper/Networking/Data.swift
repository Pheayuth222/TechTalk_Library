//
//  Data.swift
//  
//
//  Created by KOSIGN on 17/7/23.
//

import Foundation

extension Data {
    
    // - For Print Response Data
    var prettyPrinted: String {
        return MyJson.prettyPrint(value: self.dataToDic)
    }
    var dataToDic: NSDictionary {
        guard let dic: NSDictionary = (try? JSONSerialization.jsonObject(with: self, options: [])) as? NSDictionary else {
            return [:]
        }
        
        return dic
    }
}

extension Encodable {
    
    func asJSONString() -> String? {
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData    = try jsonEncoder.encode(self)
            let jsonString  = String(data: jsonData, encoding: .utf8)
            return jsonString
        } catch {
            return nil
        }
    }
    
}


struct MyJson {
    
    // Print JSON Data
    static func prettyPrint(value: AnyObject) -> String {
        if JSONSerialization.isValidJSONObject(value) {
            if let data = try? JSONSerialization.data(withJSONObject: value, options: JSONSerialization.WritingOptions.prettyPrinted) {
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return string as String
                }
            }
        }
        return ""
    }
}
