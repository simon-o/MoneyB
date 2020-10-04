//
//  LoginPresenter.swift
//  MoneyBox
//
//  Created by Antoine Simon on 03/10/2020.
//

import Foundation
import Combine

protocol LoginPresenterProtocol {
    func linkViewController(_ vc: LoginViewControllerProtocol)
    func loginButtonPressed()
    func viewDidLoad()
    func getModel() -> LoginModel?
}

final class LoginPresenter {
    private weak var viewController: LoginViewControllerProtocol?
    private let service: LoginServiceProtocol
    private var cancellable: AnyCancellable?
    private var cancellable2: AnyCancellable?
    private let userDefault: UserDefaults
    @Published private var loginModel: LoginModel?
    
    init(service: LoginServiceProtocol = LoginService(), userDefault: UserDefaults = .standard) {
        self.service = service
        self.userDefault = userDefault
    }
    
    private func save(token: String) {
        if !token.isEmpty {
            userDefault.save(token: token)
        }
    }
    
    private func requestLogin(){
        cancellable = service.loginUser(email: viewController?.getEmail() ?? "", password: viewController?.getPassword() ?? "").sink(receiveCompletion: { (error) in
            print(error)
            return
        }, receiveValue: { (result) in
            switch result {
            case .failure(_):
                self.viewController?.loginFailure()
            case let .success(model):
                print("Success \(model)")
                self.loginModel = model
            }
        })
    }
    
}

extension LoginPresenter: LoginPresenterProtocol {
    func getModel() -> LoginModel? {
        return loginModel
    }
    
    func viewDidLoad() {
        viewController?.setButton(title: "Login")
        cancellable2 = $loginModel.receive(on: DispatchQueue.main)
            .map {return ($0?.Session.BearerToken ?? "") }
            .sink { result in
                if !result.isEmpty {
                    self.save(token: result)
                    self.viewController?.loginSuccess()
                }
            }
    }
    
    func loginButtonPressed() {
        requestLogin()
    }
    
    func linkViewController(_ vc: LoginViewControllerProtocol) {
        self.viewController = vc
    }
}
