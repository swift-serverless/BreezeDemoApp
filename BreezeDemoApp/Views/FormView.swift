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
import Combine

struct FormView: View {
    
    @StateObject var viewModel: FormViewModel

    var body: some View {
        ScrollView(.vertical) {
            Text(viewModel.form.name).font(.title)
            LazyVStack(alignment: .leading, spacing: 10) {
                ForEach(viewModel.form.questions, id: \.self.id) {
                    FieldView(viewModel: $0)
                }
                if viewModel.form.isNew {
                    RoundButton(text: "Submit",
                                enabled: $viewModel.isValid) {
                        viewModel.create {
                            print("CREATED")
                        }
                    }
                } else {
                    VStack {
                        RoundButton(text: "Update",
                                    enabled: $viewModel.isValid) {
                            viewModel.update {
                                print("UDATED")
                            }
                        }
                        RoundButton(text: "Delete",
                                    color: .red,
                                    enabled: .constant(true)) {
                            viewModel.delete {
                                print("DELETED")
                            }
                        }
                    }
                }
            }.padding()
        }
        .tint(.orange)
        .padding()
        .navigationTitle(viewModel.form.id)
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        FormView(viewModel: FormViewModel(
            feedbackForm: .empty(),
            onChange: { value in
                print(value)
            })
        )
    }
}
