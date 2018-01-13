//
//  TransactionListViewController.swift
//  My Bank
//
//  Created by Antonio Saad on 1/12/18.
//  Copyright © 2018 Antonio Saad. All rights reserved.
//

import UIKit
import SVProgressHUD

class TransactionListViewController: UIViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func onCreateTransferTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Transfer", message: "Enter the amount to transfer", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.keyboardType = .decimalPad
            textField.placeholder = "0.00"
        }
        let transferAction = UIAlertAction(title: "Accept", style: .default) { (action) in
            SVProgressHUD.setDefaultMaskType(.black)
            if let amount = alert.textFields?[0].text {
                guard let amountFloat = Float(amount), amountFloat > 0.00 else {
                    SVProgressHUD.showError(withStatus: "Amount must be greater than 0.00")
                    SVProgressHUD.dismiss(withDelay: 1.2)
                    return
                }
                Transaction.transfer(from: self.product, amount: amountFloat, completion: { (error) in
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
                        self.viewDidAppear(true)
                    }
                })
            }else {
                SVProgressHUD.showError(withStatus: "You must specify a valid amount")
                SVProgressHUD.dismiss(withDelay: 1.2)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(transferAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    public var product: Product!
    public var transactions: [Transaction]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.name.text = self.product.name.rawValue
        self.status.text = self.product.status
        self.number.text = self.product.id
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        self.product.transactions(limiting: 5) { (transactions, error) in
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
                if let transactions = transactions, transactions.count < 1 {
                    SVProgressHUD.showInfo(withStatus: "No transactions registered")
                    SVProgressHUD.dismiss(withDelay: 2)
                }else {
                    self.transactions = transactions
                    self.tableView.reloadData()
                    SVProgressHUD.dismiss()
                }
            }
        }
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

extension TransactionListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transactions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell") as! TransactionTableViewCell
        cell.render(with: self.transactions![indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
}
