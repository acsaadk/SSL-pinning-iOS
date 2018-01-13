//
//  PersonalInfoViewController.swift
//  My Bank
//
//  Created by Antonio Saad on 1/12/18.
//  Copyright © 2018 Antonio Saad. All rights reserved.
//

import UIKit
import SwiftValidator
import SVProgressHUD

class PersonalInfoViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var surname: UITextField!
    
    @IBAction func onCancelTapped(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    private let validator: Validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        self.validator.registerField(self.name, rules: [RequiredRule()])
        self.validator.registerField(self.surname, rules: [RequiredRule()])
        // Do any additional setup after loading the view.
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        if identifier == "PersonalInfoSegue" {
            self.validator.validate({ (errors) in
                shouldPerformSegue = errors.count < 1
                if shouldPerformSegue == true {
                    let navigationController = self.navigationController as! SignupNavigationController
                    navigationController.name = self.name.text!
                    navigationController.surname = self.surname.text!
                }else {
                    SVProgressHUD.setDefaultMaskType(.black)
                    SVProgressHUD.showError(withStatus: "The name or surname are invalid or empty")
                    SVProgressHUD.dismiss(withDelay: 1.2)
                }
            })
        }
        return shouldPerformSegue
    }

}
