//
//  LoginViewController.swift
//  MoneyBox
//
//  Created by Antoine Simon on 03/10/2020.
//

import UIKit

protocol LoginViewControllerProtocol: AnyObject {
    func getEmail() -> String
    func getPassword() -> String
    func loginSuccess()
    func loginFailure()
    func setButton(title: String)
}

final class LoginViewController: UIViewController {
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var buttonLogin: UIButton!
    
    private let presenter: LoginPresenterProtocol
    
    init(presenter: LoginPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: String(describing: LoginViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.text = "test+ios@moneyboxapp.com"
        passwordTextField.text = "P455word12"
        
        presenter.linkViewController(self)
        presenter.viewDidLoad()
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        presenter.loginButtonPressed()
    }
}

extension LoginViewController: LoginViewControllerProtocol {
    func loginFailure() {
        displayGenericErrorAlert()
    }
    
    func loginSuccess() {
        if let user = self.presenter.getModel() {
            let service = InvestorProductsService()
            let presenter = InvestorProductsPresenter(service: service, user: user)
            let vc = InvestorProductsTableViewController(presenter: presenter)
            navigationController?.pushViewController(vc, animated: true)
        } else {
            loginFailure()
        }
    }
    
    func getEmail() -> String {
        return emailTextField.text ?? ""
    }
    
    func getPassword() -> String {
        return passwordTextField.text ?? ""
    }
    
    func setButton(title: String) {
        buttonLogin.setTitle(title, for: .normal)
    }
}
