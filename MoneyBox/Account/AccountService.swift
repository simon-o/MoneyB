//
//  AccountService.swift
//  MoneyBox
//
//  Created by Antoine Simon on 03/10/2020.
//

import Foundation
import Combine

protocol AccountServiceProtocol {
    func addMoney(amount: Int, productId: Int, accessToken: String) -> AnyPublisher<Result<AccountModel, Error>, URLError>
}

final class AccountService {

}

extension AccountService: AccountServiceProtocol {
    func addMoney(amount: Int, productId: Int, accessToken: String) -> AnyPublisher<Result<AccountModel, Error>, URLError> {
        return URLSession.shared.dataTaskPublisher(for: UrlFactory().makeURL(type: .post, apiPath: .individualAccount, accessToken: accessToken, parameters: AccountInfoModel(Amount: amount, InvestorProductId: productId)))
            .map { (data, response) -> Result<AccountModel, Error> in
                if let decoded = try? JSONDecoder().decode(AccountModel.self, from: data) {
                    return .success(decoded)
                }
                // MARK: Need to be replaced with data to send the error message
                return .failure(.unknown(response))
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}

// MARK: - Account Model

struct AccountModel: Codable {
    var Moneybox: Int
}

struct AccountInfoModel: Encodable {
    var Amount: Int
    var InvestorProductId: Int
}
