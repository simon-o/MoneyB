//
//  InvestorProductsHeader.swift
//  MoneyBox
//
//  Created by Antoine Simon on 03/10/2020.
//

import UIKit
protocol InvestorProductsHeaderProtocol: AnyObject {
    func set(nameLabel: String)
    func set(planValueLabel: String)
}

class InvestorProductsHeader: UIView {
    @IBOutlet private weak var nameLabel: UILabel?
    @IBOutlet private weak var planValueLabel: UILabel?
    @IBOutlet private weak var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }

    func setUp() {
        Bundle.main.loadNibNamed(String(describing: InvestorProductsHeader.self), owner: self, options: nil)
        addSubviewFillingParent(contentView)
    }
}

extension InvestorProductsHeader: InvestorProductsHeaderProtocol {
    func set(nameLabel: String) {
        self.nameLabel?.text = nameLabel
    }
    
    func set(planValueLabel: String) {
        self.planValueLabel?.text = planValueLabel
    }
}
