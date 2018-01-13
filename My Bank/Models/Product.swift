//
//  Product.swift
//  My Bank
//
//  Created by Antonio Saad on 1/12/18.
//  Copyright © 2018 Antonio Saad. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class Product : Mappable {
    
    enum ProductType: String {
        case savingsAccounts = "Savings Account"
        case checkingAccounts = "Checking Account"
    }

    public var name: ProductType!
    public var status: String!
    private(set) public var id: String!
    private(set) public var balance: Float!
    weak private(set) public var user: User!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.id         <-  map["product_number"]
        self.name       <- (map["product_name"], EnumTransform<ProductType>())
        self.balance    <-  map["balance"]
        self.status     <- map["status"]
    }
    
    static func products(by user: User, completion: ((_ products: [Product]?, _ error: Error?) -> Void)? = nil) {
        let headers: HTTPHeaders? = ["Authorization": (User.token)!]
        AFManager.shared.afManager.request("\(AFManager.API_DOMAIN)/api/1.0/product/\(user.customerId!)/get", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate().responseArray { (response: DataResponse<[Product]>) in
                guard response.result.isSuccess == true, response.error == nil else {
                    if let data = response.data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [String : Any] {
                        completion?(nil, Mapper<ApiError>().map(JSON: json)!)
                    }else {
                        completion?(nil, response.error)
                    }
                    return
                }
                let products = response.result.value?.map({ (product) -> Product in
                    product.user = user
                    return product
                })
                completion?(products, nil)
        }
    }
    
    func transactions(limiting by: Int = 5, completion: ((_ transactions: [Transaction]?, _ error: Error?) -> Void)? = nil) {
        Transaction.transactions(by: self, count: by, completion: completion)
    }
    
}
