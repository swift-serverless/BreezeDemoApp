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
import BreezeLambdaAPIClient

struct FormService {
    
    private let apiClient: BreezeLambdaAPIClient<FeedbackForm>
    
    private let session: SessionService
    
    private var token: String? {
        session.userSession?.jwtToken
    }
    
    init(session: SessionService) {
        guard var env = try? APIEnvironment.dev() else {
            fatalError("Invalid Environment")
        }
        env.logger = Logger()
        self.session = session
        self.apiClient = BreezeLambdaAPIClient<FeedbackForm>(env: env, path: "forms", additionalHeaders: [:])
    }
    
    func create(form: FeedbackForm) async throws -> FeedbackForm {
        try await apiClient.create(token: token, item: form)
    }
    
    func read(key: String) async throws -> FeedbackForm {
        try await apiClient.read(token: token, key: key)
    }
    
    func update(form: FeedbackForm) async throws -> FeedbackForm {
        try await apiClient.update(token: token, item: form)
    }
    
    func delete(form: FeedbackForm) async throws {
        guard let updatedAt = form.updatedAt,
              let createdAt = form.createdAt else {
            throw FormServiceError.invalidForm
        }
        try await apiClient.delete(token: token, key: form.key, createdAt: createdAt, updatedAt: updatedAt)
    }
    
    func list(startKey: String?, limit: Int?) async throws -> [FeedbackForm] {
        try await apiClient.list(token: token, exclusiveStartKey: startKey, limit: limit)
    }
}

struct APIEnvironment {
    static func dev() throws -> APIClientEnv {
        try APIClientEnv(session: URLSession.shared, baseURL: "<API GATEWAY BASE URL FROM SERVERLESS DEPLOY>")
    }
}

extension FeedbackForm: KeyedCodable {}

struct Logger: APIClientLogging {
    func log(request: URLRequest) {
        print(request)
    }
    
    func log(data: Data, for response: URLResponse) {
        print(response)
        let value = String(data: data, encoding: .utf8) ?? ""
        print(value)
    }
}

enum FormServiceError: Error {
    case invalidForm
}
