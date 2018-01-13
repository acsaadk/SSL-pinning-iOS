//
//  ProductListViewController.swift
//  My Bank
//
//  Created by Antonio Saad on 1/12/18.
//  Copyright © 2018 Antonio Saad. All rights reserved.
//

import UIKit
import SVProgressHUD

class ProductListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func onLogoutTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Log out", message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let logOutAction = UIAlertAction(title: "Log out", style: .destructive) { action in
            User.me?.logout()
            self.presentRootViewController()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(logOutAction)
        self.present(alertController, animated: true)
    }
    
    
    fileprivate var products: [Product]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        User.me?.products(completion: { (products, error) in
            if let error = error {
                if let apiError = error as? ApiError {
                    SVProgressHUD.showError(withStatus: apiError.message)
                    SVProgressHUD.dismiss(withDelay: 2)
                    if apiError.status == 401 {
                        User.me?.logout()
                        self.presentRootViewController()
                    }
                }else {
                    SVProgressHUD.showError(withStatus: "Something went wrong. Please, try again!")
                    SVProgressHUD.dismiss(withDelay: 1)
                }
                print(#function, String(describing: error))
            }else {
                if let products = products, products.count < 1 {
                    SVProgressHUD.showInfo(withStatus: "No products associated to this account")
                    SVProgressHUD.dismiss(withDelay: 2)
                }else {
                    self.products = products
                    self.tableView.reloadData()
                    SVProgressHUD.dismiss()
                }
                
            }
        })
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

}

extension ProductListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell") as! ProductTableViewCell
        cell.render(with: self.products![indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 63
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vC = UIStoryboard(name: "Transaction", bundle: nil).instantiateInitialViewController() as! TransactionListViewController
        vC.product = self.products![indexPath.row]
        self.navigationController?.pushViewController(vC, animated: true)
    }
}
