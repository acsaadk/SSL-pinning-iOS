//
//  ContactInfoViewController.swift
//  My Bank
//
//  Created by Antonio Saad on 1/12/18.
//  Copyright © 2018 Antonio Saad. All rights reserved.
//

import UIKit
import SwiftValidator
import SVProgressHUD

class ContactInfoViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var mobile: UITextField!
    
    private let validator: Validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        self.validator.registerField(self.email, rules: [RequiredRule(), EmailRule()])
        self.validator.registerField(self.mobile, rules: [RequiredRule()])
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
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        var shouldPerformSegue = true
        if identifier == "ContactInfoSegue" {
            self.validator.validate({ (errors) in
                shouldPerformSegue = errors.count < 1
                if shouldPerformSegue == true {
                    let navigationController = self.navigationController as! SignupNavigationController
                    navigationController.email = self.email.text!
                    navigationController.phone = self.phone.text!
                    navigationController.mobile = self.mobile.text!
                }else {
                    SVProgressHUD.setDefaultMaskType(.black)
                    SVProgressHUD.showError(withStatus: "Please check the info you entered and try again")
                    SVProgressHUD.dismiss(withDelay: 1.2)
                }
            })
        }
        return shouldPerformSegue
    }

}
