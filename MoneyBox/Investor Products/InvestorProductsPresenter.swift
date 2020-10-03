//
//  InvestorProductsPresenter.swift
//  MoneyBox
//
//  Created by Antoine Simon on 03/10/2020.
//

import Foundation
import Combine
import UIKit

protocol InvestorProductsPresenterProtocol {
    func linkViewController(_ vc: InvestorProductsTableViewControllerProtocol)
    func viewDidLoad()
    func buildCell(cell: InvestorTableViewCellProtocol, index: Int)
    func buildHeader(header: InvestorProductsHeader)
    func getProductsCount() -> Int
}

final class InvestorProductsPresenter {
    private weak var viewController: InvestorProductsTableViewControllerProtocol?
    private let service: InvestorProductsServiceProtocol
    private var cancellable: AnyCancellable?
    private var cancellable2: AnyCancellable?
    private let user: LoginModel
    @Published private var investorModel: InverstorProductsModel?
    
    init(service: InvestorProductsServiceProtocol, user: LoginModel) {
        self.service = service
        self.user = user
    }
}

extension InvestorProductsPresenter: InvestorProductsPresenterProtocol {
    func getProductsCount() -> Int {
        return investorModel?.ProductResponses.count ?? 0
    }
    
    func linkViewController(_ vc: InvestorProductsTableViewControllerProtocol) {
        self.viewController = vc
    }
    
    func viewDidLoad() {
        cancellable2 = $investorModel.receive(on: DispatchQueue.main)
            .sink { result in
                if !(result?.ProductResponses.isEmpty ?? true) {
                    self.viewController?.reloadTableView()
                }
            }
        
        cancellable = service.getInvestorProducts(accessToken: UserDefaults.standard.getToken()).sink(receiveCompletion: { (error) in
            print(error)
        }, receiveValue: { (result) in
            print(result)
            switch result {
            case let .failure(error):
                print(error)
            case let .success(model):
                self.investorModel = model
            }
        })
    }
     
    func buildCell(cell: InvestorTableViewCellProtocol, index: Int) {
        cell.set(name: investorModel?.ProductResponses[index].Product.FriendlyName ?? "")
        cell.set(planValue: String(format: "Plan Value: £%.2f" ,investorModel?.ProductResponses[index].PlanValue ?? ""))
                 cell.set(moneyBox: String(format: "Moneybox: £%.2f" ,investorModel?.ProductResponses[index].Moneybox ?? ""))
    }
    
    func buildHeader(header: InvestorProductsHeader) {
        header.set(nameLabel: String(format: "Hello %@ %@ !", user.User.LastName, user.User.FirstName ))
        header.set(planValueLabel: String(format: "Total Plan Value: £%.2f", investorModel?.TotalPlanValue ?? 0.0))
    }
}
