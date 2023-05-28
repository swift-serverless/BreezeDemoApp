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
            ZStack {
                ScrollView(.vertical) {
                    Text(viewModel.form.name).font(.title)
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(viewModel.form.questions, id: \.self.id) {
                            FieldView(viewModel: $0)
                        }
                        if viewModel.form.isNew {
                            RoundButton(
                                text: "Submit",
                                enabled: $viewModel.isValid,
                                action: viewModel.create
                            )
                        } else {
                            VStack {
                                RoundButton(
                                    text: "Update",
                                    enabled: $viewModel.isValid,
                                    action: viewModel.update
                                )
                                RoundButton(
                                    text: "Delete",
                                    color: .red,
                                    enabled: .constant(true),
                                    action: viewModel.delete
                                )
                            }
                        }
                    }.padding()
                }
                .tint(.orange)
                .padding()
                .navigationTitle(viewModel.form.id)
                .alert(isPresented: $viewModel.hasError) {
                    Alert(
                        title: Text("\(viewModel.error?.localizedDescription ?? "")"),
                        primaryButton: .default(
                            Text("OK"), action: {
                                self.viewModel.error = nil
                            }),
                        secondaryButton: .cancel() {
                            self.viewModel.error = nil
                        })
                }
                if viewModel.isLoading {
                    LoadingView()
                }
            }
        }
}

struct FormView_Previews: PreviewProvider {
    
    static let service = MockFormService()
    
    static var previews: some View {
        FormView(
            viewModel: FormViewModel(
                service: service,
                feedbackForm: .empty(),
                onChange: { value in
                    print(value)
                }
            )
        )
    }
}
