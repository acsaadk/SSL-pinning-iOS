//
//  TransactionTableViewCell.swift
//  My Bank
//
//  Created by Antonio Saad on 1/12/18.
//  Copyright © 2018 Antonio Saad. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var channel: UILabel!
    @IBOutlet weak var type: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func render(with transaction: Transaction) {
        self.number.text = "\(transaction.transactionNumber!)"
        self.amount.text = String(format: "$%.2f", transaction.amount)
        self.date.text = self.render(date: transaction.date)
        self.status.text = transaction.status
        self.channel.text = String(describing: transaction.channel!)
        self.type.text = String(describing: transaction.type!)
    }
    
    private func render(date: Date) -> String {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        return "\(year)-\(((month < 10) ? "0\(month)" : "\(month)"))-\(((day < 10) ? "0\(day)" : "\(day)")) \(((hour < 10) ? "0\(hour)" : "\(hour)")):\(((minute < 10) ? "0\(minute)" : "\(minute)"))"
    }

}
