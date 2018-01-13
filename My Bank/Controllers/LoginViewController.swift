//
//  LoginViewController.swift
//  My Bank
//
//  Created by Antonio Saad on 1/12/18.
//  Copyright © 2018 Antonio Saad. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftValidator

class LoginViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func onLoginTapped(_ sender: Any) {
        self.validator.validate { (errors) in
            if errors.count < 1 {
                SVProgressHUD.setDefaultMaskType(.black)
                SVProgressHUD.show()
                User.login(with: self.username.text!, and: self.password.text!, completion: { (me, error) in
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
                        print(#function, "Logged In!!!")
                        SVProgressHUD.showSuccess(withStatus: "Logged in")
                        SVProgressHUD.dismiss(withDelay: 1.2)
                        let vC = UIStoryboard(name: "Product", bundle: nil).instantiateInitialViewController()!
                        self.present(vC, animated: true, completion: nil)
                    }
                })
            }else {
                SVProgressHUD.setDefaultMaskType(.black)
                SVProgressHUD.showError(withStatus: "Username or password are empty")
                SVProgressHUD.dismiss(withDelay: 1.2)
            }
        }
    }
    
    private let validator: Validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        self.validator.registerField(self.username, rules: [RequiredRule()])
        self.validator.registerField(self.password, rules: [RequiredRule()])
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
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
