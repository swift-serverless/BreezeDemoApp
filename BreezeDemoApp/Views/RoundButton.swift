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

struct RoundButton: View {
    var text: String
    var color: Color = .orange
    @Binding var enabled: Bool
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.body)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .greatestFiniteMagnitude)
                .background(enabled ? color: Color.gray)
                .cornerRadius(25.0)
        }
        .disabled(!enabled)
    }
}

struct RoundButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            RoundButton(text: "Text", enabled: .constant(true)) {
                print("click")
            }.padding()
            
        RoundButton(text: "Text", enabled: .constant(false)) {
                print("click")
            }.padding()
        }
    }
}
