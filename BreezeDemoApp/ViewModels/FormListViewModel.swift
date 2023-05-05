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


enum Operation {
    case create(FeedbackForm)
    case read(FeedbackForm)
    case update(FeedbackForm)
    case delete(String)
}

class FormListViewModel: ObservableObject {

    private var bag = Set<AnyCancellable>()

    let service: FormService = FormService()
    
    @Published var forms: [FeedbackForm] = []
    @Published var error: Error? {
        didSet {
            if let error {
                print(error)
            }
        }
    }
    
    func form(key: String) -> FeedbackForm {
        forms.first(where: { $0.key == key })!
    }
    
    func onChange(_ operation: Operation) {
        switch operation {
        case .create(let form):
            forms.removeAll { $0.key == form.key }
            forms.append(form)
        case .read(let form):
            forms.removeAll { $0.key == form.key }
            forms.append(form)
        case .update(let form):
            forms.removeAll { $0.key == form.key }
            forms.append(form)
        case .delete(let key):
            forms.removeAll { $0.key == key }
        }
        forms = forms.sorted(by: { $0.key < $1.key })
    }
    
    func read(key: String, completion: @escaping () -> Void) {
        Task { @MainActor in
            do {
                let readedForm = try await service.read(key: key)
                onChange(.read(readedForm))
                completion()
            } catch {
                self.error = error
            }
        }
    }
    
    func list(completion: @escaping () -> Void) {
        Task { @MainActor in
            do {
                let list = try await service.list(startKey: nil, limit: 100)
                self.forms = list.sorted(by: { $0.key < $1.key })
                completion()
            } catch {
                self.error = error
            }
        }
    }
}
