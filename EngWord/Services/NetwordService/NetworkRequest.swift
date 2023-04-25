//
//  NetworkService.swift
//  Quizzie
//
//  Created by hieu nguyen on 03/01/2023.
//

import Foundation

enum RequestMethod: String {
    case `get` = "GET"
    case post = "POST"
}

protocol NetworkRequest {
    var baseUrl: String { get }
    var path: String { get }
    var parameters: [String: Any]? { get }
    var method: RequestMethod { get }
    var headers: [String: String]? { get }
}

extension NetworkRequest {
    
    private var url: URL? {
        var urlComponents = URLComponents(string: baseUrl)
        urlComponents?.path = path
        if method == .get {
            guard let params = parameters as? [String: String] else {
                fatalError("parameters for GET http method must conform to [String: String]")
            }
            if !params.isEmpty {
                urlComponents?.queryItems = params.map {
                    URLQueryItem(name: $0, value: $1)
                }
            }
        }
        return urlComponents?.url
    }
    
    var request: URLRequest {
        guard let url = url else {
            fatalError("URL could not be built")
        }
        var request = URLRequest(url: url)
        headers?.forEach({ (key: String, value: String) in
            request.addValue(value, forHTTPHeaderField: key)
        })
//        request.addValue("687f879fd7mshc6f17304318d6b7p15771ajsnf6ef45c79755", forHTTPHeaderField: "X-RapidAPI-Key")
//        request.addValue("wordsapiv1.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")
        return request
    }
}
