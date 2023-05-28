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

struct FormListView: View {
    
    private let service: FormServing
    @ObservedObject var viewModel: FormListViewModel
    @State private var path: [String] = []
    @State var showSheet: Bool = false
    @State var isLoading: Bool = false
    
    init(service: FormServing, close: @escaping () -> Void) {
        self.close = close
        self.service = service
        self.viewModel = FormListViewModel(service: service)
    }
    
    var close: () -> Void
    
    var body: some View {
        NavigationStack(path: $path) {
            List(viewModel.forms, id: \.self.key) { form in
                NavigationLink(value: form.key) {
                    FormSummary(form: form)
                }
                .navigationDestination(for: String.self) { key in
                    FormView(viewModel: FormViewModel(
                        service: service,
                        feedbackForm: viewModel.form(key: key),
                        onChange: { operation in
                        viewModel.onChange(operation)
                        path = []
                    }))
                    .navigationTitle(form.key)
                }
            }
            .refreshable {
                viewModel.list()
            }
            .listStyle(.plain)
            .navigationBarItems(
                trailing: Button(action: {
                    showSheet.toggle()
                }, label: {
                    Text("+")
                })
            )
            .navigationTitle("Forms")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Logout") {
                        close()
                    }
                }
            }
        }
        .onAppear {
            viewModel.list()
        }
        .navigationViewStyle(.stack)
        .sheet(isPresented: $showSheet) {
            FormView(
                viewModel: FormViewModel(
                    service: service,
                    feedbackForm: .empty(),
                    onChange: { operation in
                    viewModel.onChange(operation)
                    showSheet.toggle()
                })
            )
        }
    }
}

struct FormListView_Previews: PreviewProvider {
    
    static let service = MockFormService()
    
    static var previews: some View {
        FormListView(service: service, close: {})
    }
}
