//
//  NetworkProvider.swift
//  Quizzie
//
//  Created by hieu nguyen on 03/01/2023.
//

import Foundation

enum NetworkResult<T> {
    case success(T)
    case failure(Error)
    case empty
}

final class NetworkProvider<T: NetworkRequest> {
    
    private let urlSession = URLSession.shared
    
    init() {}
    
    func load(request: T, completion: @escaping (NetworkResult<Data>) -> Void) {
        call(
            request: request.request,
            dispathQueue: DispatchQueue.global(qos: .utility),
            completion: completion
        )
    }
    
    func load<U>(
        request: T,
        decodeType: U.Type,
        completion: @escaping (NetworkResult<U>) -> Void) where U: Decodable {
            call(
                request: request.request,
                dispathQueue: DispatchQueue.global(qos: .utility)) { result in
                    switch result {
                    case .success(let data):
                        do {
                            let resp = try JSONDecoder().decode(decodeType, from: data)
                            completion(NetworkResult.success(resp))
                        } catch {
                            completion(NetworkResult.failure(error))
                        }
                    case .failure(let error):
                        completion(NetworkResult.failure(error))
                    case .empty:
                        completion(.empty)
                    }
                    
                }
        }
}

extension NetworkProvider {
    
    func call(
        request: URLRequest,
        dispathQueue: DispatchQueue,
        completion: @escaping (NetworkResult<Data>) -> Void) {
            urlSession.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(NetworkResult.failure(error))
                } else if let data = data {
                    completion(NetworkResult.success(data))
                }
            }.resume()
        }
}
