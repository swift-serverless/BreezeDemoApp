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
import Combine
import JWTDecode
import KeychainAccess

fileprivate let keychain = Keychain(service: "\(Bundle.main.bundleIdentifier!).session").accessibility(.whenUnlocked)

final class SessionService: ObservableObject {
    
    @Published private(set) var isLoggedIn: Bool
    
    private(set) var userSession: UserSession?
    
    func store(session: UserSession?) {
        let encoder = JSONEncoder()
        do {
            if let session = session,
               let jwt = Self.jwt(session: session) {
                self.userSession = session
                self.isLoggedIn = !jwt.expired
                keychain[data: "session"] = try encoder.encode(session)
            } else {
                self.userSession = session
                self.isLoggedIn = false
                keychain[data: "session"] = nil
            }
            
        } catch {
            print("\(error.localizedDescription)")
        }
    }
    
    private static func retrieve() throws -> UserSession? {
        guard let data = keychain[data: "session"] else {
            return nil
        }
        let decoder = JSONDecoder()
        let session: UserSession = try decoder.decode(UserSession.self, from: data)
        return session
    }
    
    static let shared = SessionService()
    
    private static func jwt(session: UserSession) -> JWT? {
        guard let jwt = try? decode(jwt: session.jwtToken) else {
            return nil
        }
        return jwt
    }
    
    private init() {
        do {
            if let session = try Self.retrieve(),
               let jwt = Self.jwt(session: session) {
                self.userSession = session
                self.isLoggedIn = !jwt.expired
            } else {
                self.userSession = nil
                self.isLoggedIn = false
            }
        } catch {
            print("\(error.localizedDescription)")
            self.userSession = nil
            self.isLoggedIn = false
        }
    }
    
    func logout() {
        self.store(session: nil)
    }
}
