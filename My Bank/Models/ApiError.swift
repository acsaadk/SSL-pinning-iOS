//
//  ApiError.swift
//  My Bank
//
//  Created by Antonio Saad on 1/12/18.
//  Copyright © 2018 Antonio Saad. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class ApiError: Mappable, Error, CustomStringConvertible {
    
    private(set) public var timestamp: String!
    private(set) public var status: Int!
    private(set) public var error: String!
    private(set) public var message: String!
    private(set) public var path: String!
    private(set) public var exception: String?
    
    var description: String {
        return "\(self.error!) [\(self.timestamp!): \(self.path!)] (\(self.status!)): \(self.message!). \(self.exception ?? "")"
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.timestamp  <-  map["timestamp"]
        self.status     <-  map["status"]
        self.error      <-  map["error"]
        self.message    <-  map["message"]
        self.path       <-  map["path"]
        self.exception  <-  map["exception"]
    }
}
