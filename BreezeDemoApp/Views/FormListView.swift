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
    
    @State private var fillingForm = false
    @StateObject var viewModel = FormListViewModel()
    
    var body: some View {
        NavigationStack {
            List(viewModel.forms, id: \.self.key) { form in
                NavigationLink {
                    FormView(viewModel: FormViewModel(feedbackForm: form))
                        .navigationTitle(form.key)
                        .onDisappear {
                            viewModel.read(key: form.key)
                        }
                } label: {
                    VStack(alignment: .leading) {
                        Text(form.updatedAt ?? "")
                        Text(form.key).fontWeight(.light)
                    }
                }
            }
            .refreshable {
                viewModel.list()
            }
            .listStyle(.plain)
                .navigationBarItems(
                    trailing: Button(action: {
                        fillingForm.toggle()
                    }, label: {
                        Text("+")
                    })
            )
            .navigationTitle("Forms")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            viewModel.list()
        }
        .navigationViewStyle(.stack)
        .sheet(isPresented: $fillingForm) {
            FormView(viewModel: FormViewModel()).onDisappear {
                viewModel.list()
            }
        }
    }
}

struct FormListView_Previews: PreviewProvider {
    static var previews: some View {
        FormListView()
    }
}
