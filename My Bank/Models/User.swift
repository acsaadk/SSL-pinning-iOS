//
//  User.swift
//  My Bank
//
//  Created by Antonio Saad on 1/12/18.
//  Copyright © 2018 Antonio Saad. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class User : Mappable {
    
    private(set) public var name: String!
    private(set) public var surname: String!
    private(set) public var customerId: String!
    private(set) public var email: String!
    private(set) public var mobile: String!
    private(set) public var phone: String?
    
    private(set) public static var token: String?
    private(set) public static var me: User?
    
    required init?(map: Map) {
        
    }
    
    private init(username customerId: String) {
        self.customerId = customerId
    }
    
    func mapping(map: Map) {
        self.name       <-  map["name"]
        self.surname    <-  map["surname"]
        self.customerId <-  map["customer_id"]
        self.email      <-  map["email"]
        self.mobile     <-  map["mobile"]
        self.phone      <-  map["phone"]
    }
    
    func products(completion: ((_ products: [Product]?, _ error: Error?) -> Void)? = nil) {
        Product.products(by: self, completion: completion)
    }
    
    func logout() {
        User.token = nil
    }
    
    static func signup(user customerId: String, named name: String, _ surname: String, email: String, mobile: String, phone: String?, password: String, completion: ((_ error: Error?) -> Void)? = nil) {
        let body: Parameters = [
            "name": name,
            "surname": surname,
            "customer_id": customerId,
            "email": email,
            "mobile": mobile,
            "phone": phone ?? mobile,
            "password": password
        ]
        AFManager.shared.afManager.request("\(AFManager.API_DOMAIN)/api/1.0/customer/sign-up", method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
            .validate().response { (response) in
            guard response.error == nil else {
                if let data = response.data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [String : Any] {
                    completion?(Mapper<ApiError>().map(JSON: json)!)
                }else {
                    completion?(response.error)
                }
                return
            }
            completion?(nil)
        }
    }
    
    static func login(with user: String, and password: String, completion: ((_ me: User?, _ error: Error?) -> Void)? = nil) {
        let body: Parameters = [
            "customerId": user,
            "password": password
        ]
        
        AFManager.shared.afManager.request("\(AFManager.API_DOMAIN)/login", method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
            .validate().response { (response) in
            guard response.error == nil else {
                if let data = response.data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [String : Any] {
                    completion?(nil, Mapper<ApiError>().map(JSON: json)!)
                }else {
                    completion?(nil, response.error)
                }
                return
            }
            User.getMe(user, response.response?.allHeaderFields["Authorization"] as! String, completion: completion)
        }
    }
    
    private static func getMe(_ username: String, _ bearer: String, completion: ((_ me: User?, _ error: Error?) -> Void)? = nil) {
        let headers: HTTPHeaders = [
            "Authorization": bearer
        ]
        AFManager.shared.afManager.request("\(AFManager.API_DOMAIN)/api/1.0/customer/\(username)/get", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate().responseObject { (response: DataResponse<User>) in
                guard response.result.isSuccess == true, response.error == nil else {
                    if let data = response.data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [String : Any] {
                        completion?(nil, Mapper<ApiError>().map(JSON: json)!)
                    }else {
                        completion?(nil, response.error)
                    }
                    return
                }
                User.me = response.result.value
                User.token = bearer
                completion?(User.me, nil)
        }
    }
    
}
