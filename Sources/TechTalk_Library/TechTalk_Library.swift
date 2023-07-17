import UIKit

public struct TechTalk_Library {
    public private(set) var text = "Hello, World!"

    public init() {
    }
    
    func manualError(err: NSError) -> NSError {
        // Custom NSError
    #if DEBUG
        print("Connection server error : \(err.domain)")
    #endif
        switch err.code  {
            
            /**  -1001 : request timed out
             -1003 : hostname could not be found
             -1004 : Can't connect to host
             -1005 : Network connection lost
             -1009 : No internet connection
             */
        case -1001, -1003, -1004: // request timed out
            let error = NSError(domain: "NSURLErrorDomain", code: err.code, userInfo: [NSLocalizedDescriptionKey : "connection_time_out"])
            return error
        case -1005 : // Network connection lost
            let error = NSError(domain: "NSURLErrorDomain", code: err.code, userInfo: [NSLocalizedDescriptionKey : "internet_connection_is_unstable_please_try_again_after_connecting"])
            return error
        case -1009 : // No internet connection
            let error = NSError(domain: "NSURLErrorDomain", code: err.code, userInfo: [NSLocalizedDescriptionKey : "internet_connection_is_unstable_please_try_again_after_connecting"])
            Shared.share.errorConnectionCode = err.code
            return error
        default :
            return err
        }
    }
  
    // Request data task with API and response data & error as completion
    public func fetch<I: Encodable, O: Decodable>(shouldShowLoading  : Bool = true,
                                           apiKey             : String = "",
                                           urlStr             : String = "",
                                           httpMethod         : HTTPMethod = .POST,
                                           access_token       : String = "",
                                           body               : I,
                                           responseType       : O.Type,
                                           completion         : @escaping (Result<O?, NSError>) -> Void) {
        
        if shouldShowLoading {
            DispatchQueue.main.async {
                LoadingView.show()
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
        }
        
//        print("====> Access_Token \(access_token)")
        
        let request = self.getURLRequest(apiKey     : apiKey,
                                         urlStr     : urlStr,
                                         body       : body,
                                         httpMethod : httpMethod)
        
        DataAccess.session.dataTask(with: request) { (data, response, error) in
            
            //ShowLoadingimagView
            if shouldShowLoading {
                DispatchQueue.main.async {
                    LoadingView.hide()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
            
            //MARK: - Check Data, Response Error
            guard
                let url = response?.url,
                let httpResponse = response as? HTTPURLResponse,
                let fields = httpResponse.allHeaderFields as? [String: String]
            else {
                
                if let nsError = error as NSError? {
                #if DEBUG
                    print("""
                    \(nsError.code) | \(nsError.localizedDescription)
                    """)
                #endif
                    
                } else {
                    let nsError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "error_occurred_during_process"])
                #if DEBUG
                    print("""
                    \(nsError.code) | \(nsError.localizedDescription)
                    """)
                    
                    self.manualError(err: (error as? NSError)!)
                    
                #endif
                }
                return
            }
            
            guard let data = data else {
                
                let nsError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "error_occurred_during_process"])
            #if DEBUG
                print("""
                \(nsError.code) | \(nsError.localizedDescription)
                """)
            #endif
                
                return
            }
            
            let decodedDataString  = String(data: data, encoding: String.Encoding.utf8)?.removingPercentEncoding
            
            
            guard let responseData = decodedDataString == nil ? data : decodedDataString?.data(using: .utf8) else {
                let nsError = NSError(domain: "ClientError", code: 168, userInfo: [NSLocalizedDescriptionKey : "Could not convert string to data."])
                
            #if DEBUG
                print("""
                \(nsError.code) | \(nsError.localizedDescription)
                """)
            #endif
                return
            }
            
            #if DEBUG
            Log("""
                \(request.url!) | \(apiKey)
                \(responseData.prettyPrinted)
                """)
            #endif
            
            
            let responseDataDic = responseData.dataToDic
            let errorObject = try? JSONDecoder().decode(ErrorResponse.self, from: responseData)
            guard let responseObject = try? JSONDecoder().decode(responseType, from: responseData) else {
                
                if responseData.prettyPrinted == "{\n\n}" {
                    print("Pretty Print nnnn")
                } else {
                    // Error: Reponse Error has no key "error"
                    let message = errorObject?.error.message ?? ""
                    let error = NSError(domain: "ClientError", code: 168, userInfo: [NSLocalizedDescriptionKey : message])
                    
                    Log.e("""
                                            \(request.url!) | \(apiKey)
                                            Error mapping data.
                                            Response:
                                            \(responseData.prettyPrinted)
                                            """)
                    
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
                return
            }
            
            // Set cookie to use with Web
            let cookies = HTTPCookie.cookies(withResponseHeaderFields: fields, for: url)
            HTTPCookieStorage.shared.setCookies(cookies, for: url, mainDocumentURL: nil)
            for cookie in cookies {
                var cookieProperties        = [HTTPCookiePropertyKey: Any]()
                cookieProperties[.name]     = cookie.name
                cookieProperties[.value]    = cookie.value
                cookieProperties[.domain]   = cookie.domain
                cookieProperties[.path]     = cookie.path
                cookieProperties[.version]  = cookie.version
                cookieProperties[.expires]  = Date().addingTimeInterval(31536000)
                
                Shared.share.jSessionId     = "\(cookie.name)=\(cookie.value)"
                
                if let cookie = HTTPCookie(properties: cookieProperties) {
                    HTTPCookieStorage.shared.setCookie(cookie)
                }
                
                #if DEBUG
                print("name: \(cookie.name) value: \(cookie.value)")
                #endif
            }
            
            //MARK: - Check ERROR:
            if let dic = responseDataDic["error"] {
                let error       = NSError(domain: "ClientError", code: 168, userInfo: [NSLocalizedDescriptionKey : dic])
                let errorDic    = dic as? NSDictionary
                
                if let errorCode = errorDic?["code"] as? String {
                    if errorCode == "ERP_REQUEST_TIMEOUT" {
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                    // Token and Session Expired
                    else if errorCode == "SESSION_EXPIRED" {
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                        
                    } else if errorCode == "ERP_SERVICE_ERROR" || errorCode == "BAD_REQUEST" {
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                    
                    else {
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                }
            } else {
                if let codeError = responseDataDic["code"] as? String {
                    let error    = NSError(domain: "ClientError", code: 168, userInfo: [NSLocalizedDescriptionKey : codeError])
                    if codeError == "UNAUTHORIZED" {
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                }
                else {
                    DispatchQueue.main.async {
                        completion(.success(responseObject))
                    }
                }
            }
            
        }.resume()
        
    }
    
    //MARK: - GET REQUEST URL -
    public func getURLRequest<T: Encodable>(apiKey: String = "",
                                             urlStr: String = "",
                                             body: T,
                                             httpMethod : HTTPMethod = .POST) -> URLRequest {
        
        func queryString<T:Encodable>(body:T) -> String {
            let request     = body
            guard let str   = request.asJSONString() else { return "" }
            return str
        }
        
        var url : URL!
        
//        if apiKey == .getSearchPayer || apiKey == .getBill || apiKey == .getPaymentInfo || apiKey == .getCreatePayer || apiKey == .getPayment || apiKey == .getCustomer{
//            url = URL(string: "\(Shared.share.baseUrl ?? "")/\(apiKey.rawValue)\(urlStr)")
//        } else if apiKey == .AppSetting {
//            url = URL(string: "\(APIKey.AppSettingURL)\(APIKey.AppSetting.rawValue)\(APIKey.AppID)?os=iOS")
//        } else {
//            url = URL(string: "\(Shared.share.baseUrl ?? "")/\(apiKey.rawValue)")
//        }
        
        
        var request         = URLRequest(url: url!)
        request.httpMethod  = httpMethod.rawValue
        
        let strQuery = queryString(body: body)
        
        if httpMethod != .GET {
            request.httpBody = strQuery.data(using: .utf8)
        }
        
        guard let cookies = HTTPCookieStorage.shared.cookies(for: request.url!) else {
            return request
        }
    
        
        request.allHTTPHeaderFields = HTTPCookie.requestHeaderFields(with: cookies)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.addValue("\(XAppVersion.base.rawValue)", forHTTPHeaderField: "X-App-Version")
        request.addValue("\(Shared.language.rawValue)", forHTTPHeaderField: "Accept-Language")
        request.addValue("\(XAppVersion.appType.rawValue)", forHTTPHeaderField: "X-App-Type")
        
        var saveAccessToken = UserDefaults.standard.string( forKey: "saveAccessToken")  ?? ""
        var saveTokenType   = UserDefaults.standard.string(  forKey: "saveTokenType")    ?? ""
        
        saveAccessToken = Shared.share.access_token ?? ""
        saveTokenType   = Shared.share.access_token_type ?? ""
        if let _ = Shared.share.access_token {
            request.addValue("\(saveTokenType) \(saveAccessToken)", forHTTPHeaderField: "Authorization")
            //            request.addValue("Bearer \(saveAccessToken) \(saveTokenType)", forHTTPHeaderField: "Authorization")
        }
        
        Log.r("""
            Request: \(request)
            Header : \(String(describing: request.allHTTPHeaderFields))
            Method : \(String(describing: request.httpMethod))
            BODY   : \(strQuery)
            """)
        return request
    }
    
}

