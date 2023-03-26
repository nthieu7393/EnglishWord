//
//  FirebaseAuthentication.swift
//  Quizzie
//
//  Created by hieu nguyen on 13/11/2022.
//

import Foundation
import Firebase

class FirebaseAuthentication: Authentication {

    var authUid: String? {
        return Auth.auth().currentUser?.uid
    }

    var user: UserInfo? {
        guard let currentUser = Auth.auth().currentUser else {
            return nil
        }
        let userInfo = UserInfo(
            displayName: currentUser.displayName,
            providerId: currentUser.providerID,
            avatarId: nil,
            email: currentUser.email)
        return userInfo
    }

    var alreadySignedIn: Bool {
        guard let id = authUid else { return false }
        return !id.isEmpty
    }

    func signupWithEmail(email: String, password: String) {
        Auth.auth().createUser(
            withEmail: email,
            password: password
        ) { [weak self] authResult, error in
        }
    }

    func signInWithEmail(
        email: String,
        password: String,
        completionHandler: @escaping ((_ userInfo: UserInfo?, _ error: Error?) -> Void)
    ) {
        Auth.auth().signIn(
            withEmail: email,
            password: password
        ) { info, error in
            if let error = error, let errorCode = AuthErrorCode.Code(rawValue: error._code) {
                if let error = self.defineError(errorCode: errorCode) {
                    completionHandler(nil, error)
                }
            } else {
                completionHandler(UserInfo(
                    displayName: info?.additionalUserInfo?.username,
                    providerId: info?.additionalUserInfo?.providerID,
                    avatarId: nil,
                    email: nil
                ), nil)
            }
        }
    }

    func signOut(completion: (_ error: Error?) -> Void) {
        do {
           try Auth.auth().signOut()
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    private func defineError(errorCode: AuthErrorCode.Code) -> Error? {
        switch errorCode {
        case .wrongPassword:
            return AuthError.wrongPassword
        case .emailAlreadyInUse:
            return AuthError.emailAlreadyInUse
        case .invalidEmail:
            return AuthError.invalidEmail
        case .unverifiedEmail:
            return AuthError.unverifiedEmail
        case .tooManyRequests:
            return AuthError.tooManyRequests
        default:
            return nil
        }
    }
}
