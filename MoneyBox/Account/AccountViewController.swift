//
//  AccountViewController.swift
//  MoneyBox
//
//  Created by Antoine Simon on 03/10/2020.
//

import UIKit

protocol AccountViewControllerProtocol: AnyObject {
    func setAddButton(title: String)
    func set(name: String)
    func set(moneybox: String)
    func set(planValue: String)
    func displayFailure()
}

final class AccountViewController: UIViewController {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var planValueLabel: UILabel!
    @IBOutlet private weak var moneyboxLabel: UILabel!
    @IBOutlet private weak var addButton: UIButton!
    
    private let presenter: AccountPresenterProtocol
   
    init(presenter: AccountPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: String(describing: AccountViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.linkViewController(self)
        presenter.viewDidLoad()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        presenter.addPressed()
    }
}

extension AccountViewController: AccountViewControllerProtocol {
    func setAddButton(title: String) {
        addButton.setTitle(title, for: .normal)
    }
    
    func set(name: String) {
        nameLabel.text = name
    }
    
    func set(moneybox: String) {
        moneyboxLabel.text = moneybox
    }
    
    func set(planValue: String) {
        planValueLabel.text = planValue
    }
    
    func displayFailure() {
        displayGenericErrorAlert()
    }
}
