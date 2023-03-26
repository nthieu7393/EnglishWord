//
//  Injector+Extensions.swift
//  Quizzie
//
//  Created by hieu nguyen on 30/11/2022.
//

protocol DIProtocol {
    
    func register<Service>(type: Service.Type, service: Any)
    func resolve<Service>(type: Service.Type) -> Service?
}

final class ServiceDIContainer: DIProtocol {
    
    static let shared = ServiceDIContainer()
    
    private var servicesDic = [String: Any]()
    
    func register<Service>(type: Service.Type, service: Any) {
        servicesDic[String(describing: type)] = service
    }
    
    func resolve<Service>(type: Service.Type) -> Service? {
        return servicesDic[String(describing: type)] as? Service
    }
}
