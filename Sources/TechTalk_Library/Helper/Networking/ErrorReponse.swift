//
//  ErrorResponse.swift
//  
//
//  Created by KOSIGN on 10/7/23.
//

import Foundation

struct ErrorResponse : Decodable {
   let error : ErrorObject
   
   struct ErrorObject : Codable {
       var code            : String?
       var message         : String?
       var debug_message   : String?
       var sub_errors      : [SubError]?
   }
   
   struct SubError : Codable {
       let object  : String?
       let field   : String?
       let value   : String?
       let message : String?
   }
}
