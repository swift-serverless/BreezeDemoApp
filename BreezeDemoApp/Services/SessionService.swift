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
import JWTDecode
@preconcurrency import KeychainAccess

fileprivate let keychain = Keychain(service: "\(Bundle.main.bundleIdentifier!).session").accessibility(.whenUnlocked)

actor SessionService: ObservableObject {
    
    let isLoggedIn: AsyncStream<Bool>
    private let isLoggedInContinuation: AsyncStream<Bool>.Continuation
    
    private(set) var userSession: UserSession?
    
    func store(session: UserSession?) {
        let encoder = JSONEncoder()
        do {
            if let session = session,
               let jwt = Self.jwt(session: session) {
                self.userSession = session
                self.isLoggedInContinuation.yield(!jwt.expired)
                keychain[data: "session"] = try encoder.encode(session)
            } else {
                self.userSession = session
                self.isLoggedInContinuation.yield(false)
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
    
    @MainActor static let shared = SessionService()
    
    private static func jwt(session: UserSession) -> JWT? {
        guard let jwt = try? decode(jwt: session.jwtToken) else {
            return nil
        }
        return jwt
    }
    
    private init() {
        (self.isLoggedIn, self.isLoggedInContinuation) = AsyncStream<Bool>.makeStream()
        do {
            if let session = try Self.retrieve(),
               let jwt = Self.jwt(session: session) {
                self.userSession = session
                self.isLoggedInContinuation.yield(!jwt.expired)
            } else {
                self.userSession = nil
                self.isLoggedInContinuation.yield(false)
            }
        } catch {
            print("\(error.localizedDescription)")
            self.userSession = nil
            self.isLoggedInContinuation.yield(false)
        }
    }
    
    func logout() {
        self.store(session: nil)
    }
}
