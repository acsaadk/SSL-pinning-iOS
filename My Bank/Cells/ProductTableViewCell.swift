//
//  ProductTableViewCell.swift
//  My Bank
//
//  Created by Antonio Saad on 1/12/18.
//  Copyright © 2018 Antonio Saad. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var balance: UILabel!
    @IBOutlet weak var status: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func render(with product: Product) {
        self.name.text = product.name.rawValue
        self.balance.text = String(format: "$%.2f", product.balance)
        self.status.text = product.status
    }

}
