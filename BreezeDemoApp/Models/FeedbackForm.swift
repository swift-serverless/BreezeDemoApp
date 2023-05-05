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

import SharedModel
import Foundation

typealias FeedbackForm = Form

extension Form {
    static func empty() -> Form {
        Form(
            key: UUID().uuidString,
            name: "Swift, Serverless and AWS Survey",
            fields: [
                Field(
                    question: "Your knowledge about Swift?",
                    choices: ["None", "Low", "Medium", "High"],
                    type: .option
                ),
                Field(
                    question: "Your knowledge about Serverless?",
                    choices: ["None", "Low", "Medium", "High"],
                    type: .option
                ),
                Field(
                    question: "Your knowledge about AWS?",
                    choices: ["None", "Low", "Medium", "High"],
                    type: .option
                ),
                Field(
                    question: "Your main development field?",
                    choices: ["None", "iOS", "Lambda", "Vapor", "SwiftUI", "Swift"],
                    type: .multiOption
                ),
                Field(
                    question: "Did you try Breeze?",
                    choices: ["None", "Yes", "No"],
                    type: .option
                ),
                Field(
                    question: "Do you plan to try Breeze? Why? When?",
                    type: .text
                )
            ]
        )
    }
}
