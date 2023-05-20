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

import UIKit
import SwiftUI
import AuthenticationServices

struct LoginView: View {
    
    var loginService: LoginService
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Text("Breeze Demo App")
                    .foregroundColor(.black)
                    .font(.title)
                Text("💨")
                    .font(.system(size: 100))
                Spacer()
                SignInWithAppleButton(.signIn) { request in
                    request.requestedScopes = [.email, .fullName]
                } onCompletion: { result in
                    switch result {
                    case .success(let autorization):
                        loginService.didCompleteWithAuthorization(authorization: autorization)
                    case .failure(let error):
                        loginService.didCompleteWithError(error: error)
                    }
                }
                .frame(height: 50)
                .padding()
                Spacer()
            }
        }
    }
}
