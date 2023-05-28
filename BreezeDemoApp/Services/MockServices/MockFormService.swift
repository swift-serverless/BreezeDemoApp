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

enum MockServiceError: Error {
    case cannotCreate
    case notFound
    case cannotUpdate
}

class MockFormService: FormServing {
    
    private var forms: [FeedbackForm] = []
    
    var delay: Duration = .milliseconds(500)
    
    func create(form: FeedbackForm) async throws -> FeedbackForm {
        try await Task.sleep(for: delay)
        if forms.firstIndex(where: { $0.key == form.key }) != nil {
            throw MockServiceError.cannotCreate
        }
        var newForm = form
        newForm.createdAt = Date().ISO8601Format()
        newForm.updatedAt = Date().ISO8601Format()
        forms.append(newForm)
        return newForm
    }
    
    func read(key: String) async throws -> FeedbackForm {
        try await Task.sleep(for: delay)
        let form = forms.first(where: { $0.key == key })
        guard let form else {
            throw MockServiceError.notFound
        }
        return form
    }
    
    func update(form: FeedbackForm) async throws -> FeedbackForm {
        try await Task.sleep(for: delay)
        let index = forms.firstIndex(where: { $0.key == form.key && $0.createdAt == form.createdAt && $0.updatedAt == form.updatedAt })
        if let index {
            forms.remove(at: index)
            var updatedForm = form
            updatedForm.updatedAt = Date().ISO8601Format()
            forms.insert(updatedForm, at: index)
            return updatedForm
        } else {
            throw MockServiceError.cannotUpdate
        }
    }
    
    func delete(form: FeedbackForm) async throws {
        try await Task.sleep(for: delay)
        let index = forms.firstIndex(where: { $0.key == form.key && $0.createdAt == form.createdAt && $0.updatedAt == form.updatedAt })
        if let index {
            forms.remove(at: index)
            return
        }
    }
    
    func list(startKey: String?, limit: Int?) async throws -> [FeedbackForm] {
        try await Task.sleep(for: delay)
        return forms
    }
}
