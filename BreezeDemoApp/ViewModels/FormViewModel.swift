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
    let service: FormServing
    private var onChange: (Operation) -> Void
    @Published var form: FeedbackFormViewModel
    @Published var isValid: Bool = false
    @Published var error: Error? {
        didSet {
            if error != nil {
                hasError = true
            } else {
                hasError = false
            }
        }
    }
    @Published var isLoading: Bool = false
    @Published var hasError: Bool = false
    
    private let clock = ContinuousClock()
    
    init(service: FormServing, feedbackForm: FeedbackForm, onChange: @escaping (Operation) -> Void) {
        self.service = service
        self.onChange = onChange
        self.form = FeedbackFormViewModel(feedbackForm: feedbackForm)
        self.isValid = self.form.isValid()
        form.objectWillChange.sink { _ in
            self.isValid = self.form.isValid()
        }.store(in: &bag)
    }
    
    func delete() {
        let feedbackForm = form.buildFeedbackForm()
        isLoading = true
        Task { @MainActor in
            let time = await clock.measure {
                do {
                    try await service.delete(form: feedbackForm)
                    onChange(.delete(form.id))
                    form = FeedbackFormViewModel(feedbackForm: .empty())
                } catch {
                    self.error = error
                }
            }
            print("Deleted in \(time)")
            isLoading = false
        }
    }
    
    func update() {
        let feedbackForm = form.buildFeedbackForm()
        isLoading = true
        Task { @MainActor in
            let time = await clock.measure {
                do {
                    let updatedForm = try await service.update(form: feedbackForm)
                    form = FeedbackFormViewModel(feedbackForm: updatedForm)
                    onChange(.update(updatedForm))
                } catch {
                    self.error = error
                }
            }
            print("Updated in \(time)")
            isLoading = false
        }
    }
    
    func create() {
        let feedbackForm = form.buildFeedbackForm()
        isLoading = true
        Task { @MainActor in
            let time = await clock.measure {
                do {
                    let createdForm = try await service.create(form: feedbackForm)
                    form = FeedbackFormViewModel(feedbackForm: createdForm)
                    onChange(.create(createdForm))
                } catch {
                    self.error = error
                }
            }
            print("Created in \(time)")
            isLoading = false
        }
    }
}
