//
//  Transaction.swift
//  My Bank
//
//  Created by Antonio Saad on 1/12/18.
//  Copyright © 2018 Antonio Saad. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class Transaction: Mappable {
    
    enum Channel: Int, CustomStringConvertible {
        case atm = 1
        case web = 2
        case app = 3
        case pos = 4
        case mobileWallet = 5
        
        var description: String {
            switch self {
            case .atm:
                return "ATM"
            case .web:
                return "Web"
            case .app:
                return "App"
            case .pos:
                return "POS"
            case .mobileWallet:
                return "Mobile wallet"
            }
        }
    }
    
    enum TransactionType: Int, CustomStringConvertible {
        case withdrawal = 1
        case deposit = 2
        case pos = 3
        case online = 4
        case transfer = 5
        
        func factor() -> Float {
            if self == .deposit {
                return 1.0
            }
            return -1.0
        }
        
        var description: String {
            switch self {
            case .withdrawal:
                return "Withdrawal"
            case .deposit:
                return "Deposit"
            case .pos:
                return "POS"
            case .online:
                return "Online"
            case .transfer:
                return "Transfer"
            }
        }
    }
    
    private(set) public var channel: Channel!
    private(set) public var unsignedAmount: Float!
    private(set) public var date: Date!
    private(set) public var status: String!
    private(set) public var type: TransactionType!
    private(set) public var transactionNumber: Int!
    weak private(set) public var product: Product!
    
    public var amount: Float {
        return self.unsignedAmount * self.type.factor()
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.channel            <-  (map["channel_id"], EnumTransform<Channel>())
        self.unsignedAmount     <-  map["amount"]
        self.date               <-  (map["date"], DateTransformer(formatString: "yyyy-MM-dd'T'HH:mm:ss.SSSZ"))
        self.status             <-  map["status"]
        self.type               <-  (map["type"], EnumTransform<TransactionType>())
        self.transactionNumber  <-  map["transaction_number"]
    }
    
    static func transactions(by product: Product, count limit: Int = 5, completion: ((_ transactions: [Transaction]?, _ error: Error?) -> Void)? = nil) {
        let headers: HTTPHeaders? = ["Authorization": (User.token)!]
        AFManager.shared.afManager.request("\(AFManager.API_DOMAIN)/api/1.0/transaction/getLast/\(limit)/\(product.user.customerId!)/\(product.id!)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate().responseArray { (response: DataResponse<[Transaction]>) in
            guard response.result.isSuccess == true, response.error == nil else {
                if let data = response.data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [String : Any] {
                    completion?(nil, Mapper<ApiError>().map(JSON: json)!)
                }else {
                    completion?(nil, response.error)
                }
                return
            }
            let transactions = response.result.value?.map({ (transaction) -> Transaction in
                transaction.product = product
                return transaction
            })
            completion?(transactions, nil)
        }
    }
    
    static func transfer(from product: Product, amount: Float, completion: ((_ error: Error?) -> Void)? = nil) {
        let headers: HTTPHeaders? = ["Authorization": (User.token)!]
        let body: Parameters = [
            "customer_id" : product.user.customerId!,
            "channel_id" : Channel.mobileWallet.rawValue,
            "amount" : amount,
            "type" : TransactionType.transfer.rawValue,
            "product_number": product.id!
        ]
        AFManager.shared.afManager.request("\(AFManager.API_DOMAIN)/api/1.0/transaction/save", method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
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
}
