//    Copyright 2023 (c) Andrea Scuderi - https://github.com/swift-sprinter
//
//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at
//
//        http://www.apache.org/licenses/LICENSE-2.0
//
//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.

import Foundation
import AuthenticationServices
import Combine
import JWTDecode


class LoginService: NSObject {
    
    let session: SessionService
    
    private let onLoginCompletion: (Bool) -> Void
    
    init(session: SessionService, completion: @escaping (Bool) -> Void) {
        self.session = session
        self.onLoginCompletion = completion
        super.init()
    }
}

extension LoginService: ASAuthorizationControllerDelegate {
    
    enum LoginServiceError: Error {
        case missingUserInfo
    }
    
    func storeUserSession(credential: ASAuthorizationAppleIDCredential) throws {
        if let data = credential.identityToken,
           let token = String(data: data, encoding: .utf8) {
            let userSession = UserSession.init(jwtToken: token)
            session.store(session: userSession)
        }
    }
    
    func storeUser(credential: ASAuthorizationAppleIDCredential) throws {
        
        guard let email = credential.email,
              let name = credential.fullName else {
            throw LoginServiceError.missingUserInfo
        }
        
        let userData = UserInfo(
            email: email,
            name: name,
            userId: credential.user)
        print("\(userData.email)")
    }
    
    private func registerNewAccount(credential: ASAuthorizationAppleIDCredential) {
        do {
            try storeUser(credential: credential)
            try storeUserSession(credential: credential)
            self.onLoginCompletion(true)
        } catch {
            print("\(error.localizedDescription)")
            self.onLoginCompletion(false)
        }
    }
    
    private func signInWithExistingAccount(credential: ASAuthorizationAppleIDCredential) {
    
        do {

            try storeUserSession(credential: credential)
            self.onLoginCompletion(true)
        } catch {
            print("\(error.localizedDescription)")
            self.onLoginCompletion(false)
        }
    }
    
    
    func didCompleteWithAuthorization(authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            if let data = appleIDCredential.identityToken,
               let token = String(data: data, encoding: .utf8),
               let jwt = try? decode(jwt: token) {
                print(jwt)
            }
            
            if let _ = appleIDCredential.email, let _ = appleIDCredential.fullName {
                registerNewAccount(credential: appleIDCredential)
            } else {
                signInWithExistingAccount(credential: appleIDCredential)
            }
        default:
            break
        }
    }
    
    func didCompleteWithError(error: Error) {
        print(error)
    }
}
