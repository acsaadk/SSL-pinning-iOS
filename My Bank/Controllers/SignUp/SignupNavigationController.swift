//
//  SignupNavigationController.swift
//  My Bank
//
//  Created by Antonio Saad on 1/12/18.
//  Copyright © 2018 Antonio Saad. All rights reserved.
//

import UIKit
import SVProgressHUD

class SignupNavigationController: UINavigationController {
    
    public var name: String!
    public var surname: String!
    public var email: String!
    public var phone: String?
    public var mobile: String!
    public var username: String!
    public var password: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func signup() {
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        User.signup(user: self.username, named: self.name, self.surname, email: self.email, mobile: self.mobile, phone: self.phone, password: self.password) { (error) in
            if let error = error {
                if let apiError = error as? ApiError {
                    SVProgressHUD.showError(withStatus: apiError.message)
                    SVProgressHUD.dismiss(withDelay: 2)
                }else {
                    SVProgressHUD.showError(withStatus: "Something went wrong. Please, try again!")
                    SVProgressHUD.dismiss(withDelay: 1)
                }
                print(#function, String(describing: error))
            }else {
                self.dismiss(animated: true, completion: {
                    print(#function, "Signed up!!!")
                    SVProgressHUD.showSuccess(withStatus: "You have been registered successfully!")
                    SVProgressHUD.dismiss(withDelay: 2)
                })
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
