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

class FormViewModel: ObservableObject {
    
    private var bag = Set<AnyCancellable>()
    
    let service: FormService = FormService()
    @Published var form: FeedbackFormViewModel
    @Published var isValid: Bool = false
    @Published var error: Error? {
        didSet {
            if let error {
                print(error)
            }
        }
    }
    
    init(feedbackForm: FeedbackForm? = nil) {
        self.form = FeedbackFormViewModel(feedbackForm: feedbackForm)
        self.isValid = self.form.isValid()
        form.objectWillChange.sink { _ in
            self.isValid = self.form.isValid()
        }.store(in: &bag)
    }
    
    func delete(completion: @escaping () -> Void) {
        Task { @MainActor in
            do {
                try await service.delete(key: form.id)
                form = FeedbackFormViewModel()
                completion()
            } catch {
                self.error = error
            }
        }
    }
    
    func update(completion: @escaping () -> Void) {
        let feedbackForm = form.buildFeedbackForm()
        Task { @MainActor in
            do {
                let updatedForm = try await service.update(form: feedbackForm)
                form = FeedbackFormViewModel(feedbackForm: updatedForm)
                completion()
            } catch {
                self.error = error
            }
        }
    }
    
    func create(completion: @escaping () -> Void) {
        let feedbackForm = form.buildFeedbackForm()
        Task { @MainActor in
            do {
                let createdForm = try await service.create(form: feedbackForm)
                form = FeedbackFormViewModel(feedbackForm: createdForm)
                completion()
            } catch {
                self.error = error
            }
        }
    }
}
