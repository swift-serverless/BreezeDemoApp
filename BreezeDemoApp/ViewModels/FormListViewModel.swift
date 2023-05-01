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
    
    func read(key: String) {
        Task { @MainActor in
            do {
                let readedForm = try await service.read(key: key)
                if let index = self.forms.firstIndex(where: { $0.key == key }) {
                    self.forms.remove(at: index)
                    self.forms.insert(readedForm, at: index)
                }
            } catch {
                self.error = error
            }
        }
    }
    
    func list() {
        Task { @MainActor in
            do {
                self.forms = try await service.list(startKey: nil, limit: 100)
            } catch {
                self.error = error
            }
        }
    }
}
