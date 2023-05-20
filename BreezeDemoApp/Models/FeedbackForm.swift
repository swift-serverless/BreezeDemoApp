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
                    question: "What is the main benefit of Serverless computing?",
                    choices: ["Cost savings 💰", "Performance ⚡️", "Scalability 🚀", "Infrastructure as a Code 💨"],
                    type: .multiOption
                ),
                Field(
                    question: "If you start a new project, whould you use Serverless on AWS?",
                    choices: ["No", "Very likely", "Yes"],
                    type: .option
                ),
                Field(
                    question: "Would you change your favourite coding language to start a Serverless project?",
                    choices: ["No, I ❤️ Swift!", "Yes, but 😓", "Yes, I'm 💪"],
                    type: .option
                ),
                Field(
                    question: "As a Swift developer, what could help you to get into Serverless?",
                    choices: ["Tutorials 📚", "Starting tool 💻", "A course 👩🏻‍🏫"],
                    type: .multiOption
                ),
                Field(
                    question: "Comments",
                    type: .text
                )
            ]
        )
    }
}
