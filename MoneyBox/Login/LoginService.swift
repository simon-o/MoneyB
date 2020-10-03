//
//  LoginService.swift
//  MoneyBox
//
//  Created by Antoine Simon on 03/10/2020.
//

import Foundation
import Combine

protocol LoginServiceProtocol {
    func loginUser(email: String, password: String) -> AnyPublisher<Result<LoginModel, Error>, URLError>
}

class LoginService {

}

extension LoginService: LoginServiceProtocol {
    func loginUser(email: String, password: String) -> AnyPublisher<Result<LoginModel, Error>, URLError> {
        return URLSession.shared.dataTaskPublisher(for: UrlFactory().makeURL(type: .post, apiPath: .login, parameters: LoginInfoModel(Email: email, Password: password, Idfa: "ANYTHING")))
            .map { (data, response) -> Result<LoginModel, Error> in
                if let decoded = try? JSONDecoder().decode(LoginModel.self, from: data) {
                    return .success(decoded)
                }
                // MARK: Need to be replaced with data to send the error message
                return .failure(.unknown(response))
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}

// MARK: - Login
struct LoginModel: Codable {
    var Session: LoginSessionModel
    var User: UserModel
}

struct UserModel: Codable {
    var FirstName: String
    var LastName: String
}

struct LoginSessionModel: Codable {
    var BearerToken: String
}

struct LoginInfoModel: Encodable {
    var Email: String
    var Password: String
    var Idfa: String
}

