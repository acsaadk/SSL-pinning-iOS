//
//  UIViewControllerExtension.swift
//  My Bank
//
//  Created by Antonio Saad on 1/13/18.
//  Copyright © 2018 Antonio Saad. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentRootViewController() {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
    }
}
