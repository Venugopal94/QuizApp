//
//  NetworkHandler.swift
//  SingularityDemoApp
//
//  Created by venu Gopal on 03/05/20.
//  Copyright © 2020 venu Gopal. All rights reserved.
//

enum NetWorkErrors: String {
    case noInternent = "Current you are viewing offline data please connect to view realTime data"
}
enum ApiEndPoints: String {
    case lockDetails = "/test/lockDetails"
    case roomList = "/test/roomsList"
}

enum MethodType: String {
    case get = "GET"
    case post = "POST"
}
import Foundation
class NetworkHandler: NSObject {
    static let sharedInstance: NetworkHandler = {
        return NetworkHandler()
    }()
    private var urlSession: URLSession?
    private var defaultHeadersList: [String : String]?
    private final let newProdUrl = "https://storage.googleapis.com/sodimac-8590a.appspot.com/App%20Test%20Assignment/app_test_assignment_quiz.json"
    
    override init() {
        super.init()
        // Initialise reachability
        initialiseDefaultHeader()
    }
    private func initialiseDefaultHeader() {
        defaultHeadersList = [String: String]()
        self.defaultHeadersList?["Accept"] = "application/json"
        self.defaultHeadersList?["Content-Type"] = "application/json"
    }
    
    
    //dataRequest which sends request to given URL and convert to Decodable Object
    func dataRequest<T: Decodable>(method: MethodType, body: [String : AnyObject]?, params: String, objectType: T.Type, completion: @escaping (_ responseModel: T?, _ error: String?) -> Void) {

        let session = URLSession.shared
        let requestURL = newProdUrl
        guard let restUrl = URL(string: requestURL) else {
            return
        }
        //now create the URLRequest object using the url object
        let request = requestMethod(method.rawValue as NSString, withParameters: body, requestURL : restUrl)
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            guard error == nil else {
                completion(nil, error?.localizedDescription)
                return
            }
            do {
                if let responseData = data {
                    let decodedObject = try JSONDecoder().decode(objectType.self, from: responseData)
                    completion(decodedObject, nil)
                }
            } catch let error {
                completion(nil, error.localizedDescription)
            }
        })
        
        task.resume()
    }
    func requestMethod(_ method: NSString, withParameters params: [String:AnyObject]?, requestURL:URL) -> URLRequest {
        
        let url: URL = requestURL
        let request: NSMutableURLRequest = NSMutableURLRequest(url: url)
        
        request.httpMethod = method as String
        // update Session Token, if available
        if !method.isEqual(to: "GET") {
            if let params = params {
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions(rawValue: 0))
                } catch {
                    print(error)
                    request.httpBody = nil
                }
            }
        }
        request.allHTTPHeaderFields = self.defaultHeadersList
        request.httpMethod = method as String
        return request as URLRequest
    }
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    func encodeObjectToDictionary<T: Codable>(object: T) -> [String: Any] {
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(object)
            guard let json = String(data: jsonData, encoding: .utf8), let  dict = self.convertStringToDictionary(text: json) else {
                return [:]
            }
            return dict
        } catch {
            print(error)
        }
        return [:]
    }
}
