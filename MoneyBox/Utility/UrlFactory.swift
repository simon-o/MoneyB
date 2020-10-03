//
//  UrlFactory.swift
//  MoneyBox
//
//  Created by Antoine Simon on 03/10/2020.
//

import Foundation

enum Error: Swift.Error {
    case network(URLError)
    case unknown(URLResponse)
}

enum typeUrl: String {
    case post = "POST"
    case get = "GET"
}

enum apiPath: String {
    case login = "/users/login"
    case investorProducts = "/investorproducts"
}

struct UrlFactory {
    private let baseUrl = "https://api-test02.moneyboxapp.com"
    
    func makeURL<T>(type: typeUrl, apiPath: apiPath, accessToken: String = "", parameters: T?) -> URLRequest where T : Encodable{
        return makeURL(type: type, apiPath: apiPath.rawValue, accessToken: accessToken, parameters: parameters)
    }
    
    func makeURL<T>(type: typeUrl, apiPath: String, accessToken: String = "", parameters: T?) -> URLRequest where T : Encodable{
        var request = makeRequest(type: type, apiPath: apiPath, accessToken: accessToken)
        if type != .get {
            request.httpBody = try! JSONEncoder().encode(parameters)
        }
        return request
    }
    
    func makeURL(type: typeUrl, apiPath: apiPath, accessToken: String = "") -> URLRequest {
        return makeRequest(type: type, apiPath: apiPath.rawValue, accessToken: accessToken)
    }
    
    func makeURL(type: typeUrl, apiPath: String, accessToken: String = "") -> URLRequest {
        return makeRequest(type: type, apiPath: apiPath, accessToken: accessToken)
    }
    
    private func makeRequest(type: typeUrl, apiPath: String, accessToken: String = "") -> URLRequest{
        var request = URLRequest(url: URL(string: baseUrl + apiPath)!)
        request.httpMethod = type.rawValue
        request.setValue("8cb2237d0679ca88db6464", forHTTPHeaderField: "AppId")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("7.10.0", forHTTPHeaderField: "appVersion")
        request.setValue("3.0.0", forHTTPHeaderField: "apiVersion")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
