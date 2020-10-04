//
//  AccountPresenterTest.swift
//  MoneyBoxTests
//
//  Created by Antoine Simon on 04/10/2020.
//

import XCTest
import Combine
@testable import MoneyBox

class AccountPresenterTest: XCTestCase {
    let service = AccountServiceMock()
    let vc = AccountViewControllerMock()
    
    let model = ProductResponsesModel(Id: 3333, PlanValue: 12.0, Moneybox: 0.0, Product: ProductModel(FriendlyName: "Jack"))
    
    override func setUp() {
        
    }

    func test_setUp() {
        var completionCount = 0
        let presenter = AccountPresenter(service: service, accountInfo: model) {
            completionCount += 1
        }
        
        presenter.linkViewController(vc)
        presenter.viewDidLoad()
        
        XCTAssertEqual(vc.buttonTitle, "Add £10")
        XCTAssertEqual(vc.name, "Jack")
        XCTAssertEqual(vc.moneybox, "Moneybox: £0.00")
        XCTAssertEqual(vc.planValue, "Plan Value: £12.00")
        XCTAssertEqual(completionCount, 0)
    }
    
    func test_press() {
        var completionCount = 0
        let presenter = AccountPresenter(service: service, accountInfo: model) {
            completionCount += 1
        }
        
        presenter.linkViewController(vc)
        presenter.viewDidLoad()
        
        presenter.addPressed()
        
        XCTAssertEqual(service.amount, 10)
        XCTAssertEqual(service.productId, 3333)
        XCTAssertNotNil(service.accessToken)
    }
    
    func test_press_success() {
        var completionCount = 0
        let presenter = AccountPresenter(service: service, accountInfo: model) {
            completionCount += 1
            self.service.expectation.fulfill()
        }
        
        presenter.linkViewController(vc)
        presenter.viewDidLoad()
        
        presenter.addPressed()
        service.stateSub.send(.success(AccountModel.init(Moneybox: 30)))
        
        wait(for: [service.expectation], timeout: 10.0)
        XCTAssertEqual(vc.moneybox, "Moneybox: £30.00")
        XCTAssertEqual(completionCount, 1)
    }
    
   
    func test_press_failure() {
        var completionCount = 0
        let presenter = AccountPresenter(service: service, accountInfo: model) {
            completionCount += 1
        }
        
        presenter.linkViewController(vc)
        presenter.viewDidLoad()
        
        presenter.addPressed()
        service.stateSub.send(.failure(Error.unknown(URLResponse.init())))
        
        XCTAssertEqual(vc.moneybox, "Moneybox: £0.00")
        XCTAssertEqual(completionCount, 0)
    }
}

class AccountServiceMock: AccountServiceProtocol {
    var amount: Int?
    var productId: Int?
    var accessToken: String?
    let stateSub = PassthroughSubject<Result<AccountModel, Error>, URLError>()
    let expectation = XCTestExpectation(description: "async")
    
    func addMoney(amount: Int, productId: Int, accessToken: String) -> AnyPublisher<Result<AccountModel, Error>, URLError> {
        self.amount = amount
        self.productId = productId
        self.accessToken = accessToken
        return stateSub.eraseToAnyPublisher()
    }
}

class AccountViewControllerMock: AccountViewControllerProtocol {
    var buttonTitle: String?
    var name: String?
    var moneybox: String?
    var planValue: String?
    
    func setAddButton(title: String) {
        self.buttonTitle = title
    }
    
    func set(name: String) {
        self.name = name
    }
    
    func set(moneybox: String) {
        self.moneybox = moneybox
    }
    
    func set(planValue: String) {
        self.planValue = planValue
    }
}
