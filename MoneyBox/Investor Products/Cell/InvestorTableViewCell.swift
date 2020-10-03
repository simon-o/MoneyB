//
//  InvestorTableViewCell.swift
//  MoneyBox
//
//  Created by Antoine Simon on 03/10/2020.
//

import UIKit

protocol InvestorTableViewCellProtocol {
    func set(name: String)
    func set(planValue: String)
    func set(moneyBox: String)
}

final class InvestorTableViewCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel?
    @IBOutlet private weak var planValueLabel: UILabel?
    @IBOutlet private weak var moneyBoxLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension InvestorTableViewCell: InvestorTableViewCellProtocol {
    func set(name: String) {
        self.nameLabel?.text = name
    }
    
    func set(planValue: String) {
        self.planValueLabel?.text = planValue
    }
    
    func set(moneyBox: String) {
        self.moneyBoxLabel?.text = moneyBox
    }
    
    
}
