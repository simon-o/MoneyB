//
//  InvestorProductsPresenterTest.swift
//  MoneyBoxTests
//
//  Created by Antoine Simon on 04/10/2020.
//

import XCTest
import Combine
@testable import MoneyBox

class InvestorProductsPresenterTest: XCTestCase {

    let service = InvestorProductsServiceMock()
    let vc = InvestorProductsViewControllerMock()
    let cell = InvestorTableViewCellMock()
    let header = InvestorProductsHeaderMock()
    
    let loginModel = LoginModel(Session: LoginSessionModel(BearerToken: "qwerty"), User: UserModel(FirstName: "AA", LastName: "BB"))
    let investModel = InverstorProductsModel(TotalPlanValue: 100.0, ProductResponses: [ProductResponsesModel(Id: 123, PlanValue: 100.0, Moneybox: 0.0, Product: ProductModel(FriendlyName: "ISA"))])

    func test_setUp() {
        let presenter = InvestorProductsPresenter(service: service, user: loginModel)
        
        presenter.linkViewController(vc)
        presenter.viewDidLoad()
        
        presenter.buildHeader(header: header)
        
        XCTAssertEqual(vc.reloadCount, 0)
        XCTAssertEqual(vc.displayFailureCount, 0)
        
        XCTAssertEqual(header.name, "Hello BB AA !")
        XCTAssertEqual(header.plan, "Total Plan Value: £0.00")
    }
    
    func test_cell_success() {
        let presenter = InvestorProductsPresenter(service: service, user: loginModel)
        
        presenter.linkViewController(vc)
        presenter.viewDidLoad()
        
        service.stateSub.send(.success(investModel))
        wait(for: [vc.expectation], timeout: 10.0)
        
        presenter.buildCell(cell: cell, index: 0)
        
        XCTAssertEqual(cell.name, "ISA")
        XCTAssertEqual(cell.plan, "Plan Value: £100.00")
        XCTAssertEqual(vc.displayFailureCount, 0)
        XCTAssertEqual(vc.reloadCount, 1)
    }
    
    func test_cell_failure() {
        let presenter = InvestorProductsPresenter(service: service, user: loginModel)
        
        presenter.linkViewController(vc)
        presenter.viewDidLoad()
        
        service.stateSub.send(.failure(.unknown(.init())))
        wait(for: [vc.expectation], timeout: 10.0)
        
        presenter.buildCell(cell: cell, index: 0)
        
        XCTAssertEqual(cell.name, "")
        XCTAssertEqual(cell.plan, "Plan Value: £0.00")
        XCTAssertEqual(vc.displayFailureCount, 1)
        XCTAssertEqual(vc.reloadCount, 0)
    }
}

class InvestorProductsHeaderMock: InvestorProductsHeaderProtocol {
    var name: String?
    var plan: String?
    
    func set(nameLabel: String) {
        self.name = nameLabel
    }
    
    func set(planValueLabel: String) {
        self.plan = planValueLabel
    }
}

class InvestorProductsViewControllerMock: InvestorProductsTableViewControllerProtocol {
    var reloadCount = 0
    var displayFailureCount = 0
    let expectation = XCTestExpectation(description: "async")
    
    func reloadTableView() {
        reloadCount += 1
        expectation.fulfill()
    }
    
    func displayFailure() {
        displayFailureCount += 1
        expectation.fulfill()
    }
}

class InvestorTableViewCellMock: InvestorTableViewCellProtocol {
    var name: String?
    var plan: String?
    var moneyBox: String?
    let expectation = XCTestExpectation(description: "async")
    
    func set(name: String) {
        self.name = name
    }
    
    func set(planValue: String) {
        self.plan = planValue
    }
    
    func set(moneyBox: String) {
        self.moneyBox = moneyBox
        expectation.fulfill()
    }
}

class InvestorProductsServiceMock: InvestorProductsServiceProtocol {
    var accessToken: String?
    let stateSub = PassthroughSubject<Result<InverstorProductsModel, Error>, URLError>()
    
    func getInvestorProducts(accessToken: String) -> AnyPublisher<Result<InverstorProductsModel, Error>, URLError> {
        self.accessToken = accessToken
        return stateSub.eraseToAnyPublisher()
    }
}
