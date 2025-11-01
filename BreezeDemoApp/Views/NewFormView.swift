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

struct NewFormView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    let service: FormServing
    @State var viewModel: FormListViewModel
    @Binding var isLoading: Bool
    @Binding var showSheet: Bool
    
    var body: some View {
        ZStack {
            NavigationStack {
                FormView(
                    viewModel: FormViewModel(
                        service: service,
                        feedbackForm: .empty(),
                        onLoading: { isLoading = $0 },
                        onChange: { operation in
                            viewModel.onChange(operation)
                            showSheet.toggle()
                        })
                )
                .navigationTitle("New Form")
                .navigationBarTitleDisplayMode(.inline)
            }
            if isLoading {
                LoadingView()
            }
        }
    }
}

#Preview {
    @Previewable @State var isLoading = false
    @Previewable @State var showSheet = false
    
    let service = MockFormService()
    let viewModel = FormListViewModel(service: service)
    NewFormView(
        service: service,
        viewModel: viewModel,
        isLoading: $isLoading,
        showSheet: $showSheet
    )
}
