//
//  AFManager.swift
//  My Bank
//
//  Created by Antonio Saad on 1/13/18.
//  Copyright © 2018 Antonio Saad. All rights reserved.
//

import Foundation
import Alamofire

// Code taken from: https://infinum.co/the-capsized-eight/how-to-make-your-ios-apps-more-secure-with-ssl-pinning

class AFManager {
    
    private var urlSession: URLSession!
    private var serverTrustPolicy: ServerTrustPolicy!
    private var serverTrustPolicies: [String: ServerTrustPolicy]!
    private(set) public var afManager: SessionManager!
    
    private(set) public static var shared: AFManager! = AFManager()
    
    public static let API_DOMAIN: String = Bundle.main.infoDictionary!["API_DOMAIN"] as! String
    
    private init() {
        self.setCerticate()
    }
    
    private func setCerticate() {
        let pathToCert = Bundle.main.path(forResource: "mybank-client", ofType: "der")
        let localCertificate: NSData = NSData(contentsOfFile: pathToCert!)!
        self.configureAlamoFireSSLPinningWithCertificateData(certificateData: localCertificate)
    }
    
    func configureAlamoFireSSLPinningWithCertificateData(certificateData: NSData) {
        self.serverTrustPolicy = ServerTrustPolicy.pinCertificates(
            // Getting the certificate from the certificate data
            certificates: [SecCertificateCreateWithData(nil, certificateData)!],
            // Choose to validate the complete certificate chain, not only the certificate itself
            validateCertificateChain: true,
            // Check that the certificate mathes the host who provided it
            validateHost: true
        )
        
        self.serverTrustPolicies = [
            "localhost": self.serverTrustPolicy!
        ]
        
        self.afManager = SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: self.serverTrustPolicies)
        )
    }
}
