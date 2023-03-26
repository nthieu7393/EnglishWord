//
//  Authentication.swift
//  Quizzie
//
//  Created by hieu nguyen on 13/11/2022.
//

import Foundation

protocol Authentication {

    var authUid: String? { get }
    var alreadySignedIn: Bool { get }
    var user: UserInfo? { get }
    func signupWithEmail(email: String, password: String)
    func signInWithEmail(
        email: String,
        password: String,
        completionHandler: @escaping ((_ userInfo: UserInfo?, _ error: Error?) -> Void)
    )
    func signOut(completion: (_ error: Error?) -> Void)
}
