//
//  InvestorProductsService.swift
//  MoneyBox
//
//  Created by Antoine Simon on 03/10/2020.
//

import Foundation
import Combine

protocol InvestorProductsServiceProtocol {
    func getInvestorProducts(accessToken: String) -> AnyPublisher<Result<InverstorProductsModel, Error>, URLError>
}

final class InvestorProductsService {

}

extension InvestorProductsService: InvestorProductsServiceProtocol {
    func getInvestorProducts(accessToken: String) -> AnyPublisher<Result<InverstorProductsModel, Error>, URLError> {
        return URLSession.shared.dataTaskPublisher(for: UrlFactory().makeURL(type: .get, apiPath: apiPath.investorProducts.rawValue, accessToken: accessToken, parameters: LoginSessionModel(BearerToken: "")))
               .map { (data, response) -> Result<InverstorProductsModel, Error> in
                   if let decoded = try? JSONDecoder().decode(InverstorProductsModel.self, from: data) {
                       return .success(decoded)
                   }
                   // MARK: Need to be replaced with data to send the error message
                   return .failure(.unknown(response))
           }
           .receive(on: DispatchQueue.main)
           .eraseToAnyPublisher()
       }
}



// MARK: - Inverstor Products
struct InverstorProductsModel: Codable {
    var TotalPlanValue: Double
    var ProductResponses: [ProductResponsesModel]
}

struct ProductResponsesModel: Codable {
    var Id: Int
    var PlanValue: Double
    var Moneybox: Double
    var Product: ProductModel
}

struct ProductModel: Codable {
    var FriendlyName: String
}
