//
//  AccountPresenter.swift
//  MoneyBox
//
//  Created by Antoine Simon on 03/10/2020.
//

import Foundation
import Combine

protocol AccountPresenterProtocol {
    func linkViewController(_ vc: AccountViewControllerProtocol)
    func viewDidLoad()
    func addPressed()
}

final class AccountPresenter {
    private weak var viewController: AccountViewControllerProtocol?
    private let service: AccountServiceProtocol
    private var cancellable: AnyCancellable?
    private var cancellable2: AnyCancellable?
    private let userDefault: UserDefaults
    private var model: ProductResponsesModel
    private let completion: (() -> Void)
    @Published private var accountInfo: AccountModel?
    
    init(service: AccountServiceProtocol = AccountService(), accountInfo: ProductResponsesModel, userDefault: UserDefaults = .standard, completion: @escaping (() -> Void)) {
        self.service = service
        self.userDefault = userDefault
        self.model = accountInfo
        self.completion = completion
    }
}

extension AccountPresenter: AccountPresenterProtocol {
    func linkViewController(_ vc: AccountViewControllerProtocol) {
        self.viewController = vc
    }
    
    func setUp(moneybox: Double, plan: Double) {
        viewController?.set(name: model.Product.FriendlyName)
        viewController?.set(moneybox:  String(format: "Moneybox: £%.2f" ,moneybox))
        viewController?.set(planValue:  String(format: "Plan Value: £%.2f" ,plan))
    }
    
    func viewDidLoad() {
        setUp(moneybox: model.Moneybox, plan: model.PlanValue)
        viewController?.setAddButton(title: "Add £10")
        
        cancellable2 = $accountInfo.receive(on: DispatchQueue.main)
            .sink { result in
                if (result?.Moneybox != nil) {
                    self.setUp(moneybox: Double(result?.Moneybox ?? 0), plan: self.model.PlanValue)
                    self.completion()
                }
            }
    }
    
    func addPressed() {
        cancellable = service.addMoney(amount: 10, productId: model.Id, accessToken: UserDefaults.standard.getToken()).sink(receiveCompletion: { (error) in
            print(error)
        }, receiveValue: { (result) in
            switch result {
            case .failure(_):
                self.viewController?.displayFailure()
            case let .success(model):
                self.accountInfo = model
            }
        })
    }
}
