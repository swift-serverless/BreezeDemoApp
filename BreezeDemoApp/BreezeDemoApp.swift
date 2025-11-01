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

import SwiftUI

@main
struct BreezeDemoApp: App {

    @StateObject var session: SessionService = .shared
    @State private var isLoggedIn: Bool = false
    
    var body: some Scene {
        WindowGroup {
            VStack {
                if !isLoggedIn {
                    LoginView(loginService: LoginService(session: session) { value in
                        print(value)
                    })
                } else {
                    FormListView(service: FormServiceBuilder.build()) {
                        Task {
                            await session.logout()
                        }
                    }.tint(.orange)
                }
            }.task {
                for await isLoggedIn in session.isLoggedIn {
                    self.isLoggedIn = isLoggedIn
                }
            }
        }
    }
}
