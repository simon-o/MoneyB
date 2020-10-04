//
//  LoginPresenterTest.swift
//  MoneyBoxTests
//
//  Created by Antoine Simon on 03/10/2020.
//

import XCTest
import Combine
@testable import MoneyBox

class LoginPresenterTest: XCTestCase {

    let service = LoginServiceMock()
    let vc = LoginViewControllerMock()
    
    let model = LoginModel(Session: LoginSessionModel(BearerToken: "qwerty"), User: UserModel(FirstName: "AA", LastName: "BB"))
    
    override func setUp() {
        
    }
    
    func test_setup() {
        let presenter = LoginPresenter(service: service)
        
        presenter.linkViewController(vc)
        presenter.viewDidLoad()
        
        XCTAssertEqual(vc.title, "Login")
    }
    
    func test_success() {
        let presenter = LoginPresenter(service: service)
        
        presenter.linkViewController(vc)
        presenter.viewDidLoad()
        
        presenter.loginButtonPressed()
        service.stateSub.send(.success(model))
        
        wait(for: [vc.expectation], timeout: 10.0)
        XCTAssertEqual(service.email, vc.getEmail())
        XCTAssertEqual(service.password, vc.getPassword())
        XCTAssertEqual(vc.getSuccessCount, 1)
        XCTAssertEqual(UserDefaults.standard.getToken(), "qwerty")
    }
    
    func test_failure() {
        let presenter = LoginPresenter(service: service)
        
        presenter.linkViewController(vc)
        presenter.viewDidLoad()
        
        presenter.loginButtonPressed()
        service.stateSub.send(.failure(Error.unknown(URLResponse.init())))
        
        wait(for: [vc.expectation], timeout: 10.0)
        XCTAssertEqual(service.email, vc.getEmail())
        XCTAssertEqual(service.password, vc.getPassword())
        XCTAssertEqual(vc.getSuccessCount, 0)
        XCTAssertEqual(vc.getFailureCount, 1)
    }
}

class LoginViewControllerMock: LoginViewControllerProtocol {
    var getSuccessCount = 0
    var getFailureCount = 0
    var title: String?
    let expectation = XCTestExpectation(description: "async")
    
    func getEmail() -> String {
        return "email"
    }
    
    func getPassword() -> String {
        return "password"
    }
    
    func loginSuccess() {
        getSuccessCount += 1
        expectation.fulfill()
    }
    
    func loginFailure() {
        getFailureCount += 1
        expectation.fulfill()
    }
    
    func setButton(title: String) {
        self.title = title
    }
}

class LoginServiceMock: LoginServiceProtocol {
    var email: String?
    var password: String?
    let stateSub = PassthroughSubject<Result<LoginModel, Error>, URLError>()
    
    func loginUser(email: String, password: String) -> AnyPublisher<Result<LoginModel, Error>, URLError> {
        self.email = email
        self.password = password
        return stateSub.eraseToAnyPublisher()
    }
}
