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

struct FieldTextView: View {
    
    @StateObject var viewModel: FieldViewModel
    
    var body: some View {
        TextField("",
                  text: Binding(get: {
            viewModel.answer
        }, set: { value, _ in
            viewModel.answer = value
        }))
        .textFieldStyle(.roundedBorder)
    }
}

struct FieldOptionView: View {
    
    @StateObject var viewModel: FieldViewModel
    @State var options: [String]
    
    var body: some View {
        Picker(
            selection: Binding(get: {
                viewModel.answer.isEmpty ? "None" : viewModel.answer
            }, set: { value, _ in
                viewModel.answer = value == "None" ? "" : value
            }),
            label: Text(""),
            content: {
                ForEach(options, id: \.self) {
                Text($0)
                }
            }
        )
        .pickerStyle(.segmented)
    }
}

struct FieldMultiOptionView: View {
    
    @StateObject var viewModel: FieldViewModel
    @State var options: [String]
    
    var body: some View {
        ForEach(options, id: \.self) { option in
            Toggle(
                isOn: Binding(get: {
                    viewModel.isSelected(option: option)
                }, set: { value, _ in
                    viewModel.update(option: option, isSelected: value)
                })) {
                    Label(option, systemImage: "flag.fill")
                }.toggleStyle(.button)
        }
    }
}

struct FieldView: View {
    
    @StateObject var viewModel: FieldViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(viewModel.question)")
            switch viewModel.type {
            case .text:
                FieldTextView(viewModel: viewModel)
            case .options(let options):
                FieldOptionView(viewModel: viewModel, options: options)
            case .multiOptions(let options):
                FieldMultiOptionView(viewModel: viewModel, options: options)
            }
        }
    }
}

struct FieldView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            FieldView(
                viewModel: FieldViewModel(
                    id: 0,
                    question: "What do you like about Breeze?",
                    type: .text
                )
            )
            FieldView(
                viewModel: FieldViewModel(
                    id: 0,
                    question: "Which level of knowledge you have about Swift?",
                    type: .options(["None", "Low", "Medium", "High"])
                )
            )
            FieldView(
                viewModel: FieldViewModel(
                    id: 0,
                    question: "Which development experinces you have?",
                    type: .multiOptions(["None", "iOS", "Web", "Vapor", "NodeJS"])
                )
            )
        }.padding()
    }
}
