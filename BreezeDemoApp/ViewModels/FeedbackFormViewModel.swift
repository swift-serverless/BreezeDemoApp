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
import SharedModel

enum QuestionType {
    case text
    case options([String])
    case multiOptions([String])
}

class FieldViewModel: Identifiable, ObservableObject {
    let id: Int
    let question: String
    let type: QuestionType
    var answer: String {
        didSet {
            objectWillChange.send()
        }
    }
    
    var selected: [String] {
        answer.split(separator: ",").map { String($0) }
    }
    
    func isSelected(option: String) -> Bool {
        let set = Set(answer.split(separator: ",").map { String($0) })
        return set.contains(option)
    }
    
    func update(option: String, isSelected: Bool) {
        var set = Set(answer.split(separator: ",").map { String($0) })
        if isSelected {
            set.insert(option)
        } else {
            set.remove(option)
        }
        answer = Array(set).joined(separator: ",")
    }
    
    init(id: Int, question: String, type: QuestionType, answer: String = "") {
        self.id = id
        self.question = question
        self.type = type
        self.answer = answer
    }
    
    init(id: Int, field: Field) {
        self.id = id
        self.question = field.question
        switch field.type {
        case .text:
            self.answer = field.answer ?? ""
            self.type = .text
        case .option:
            self.answer = field.selected?.joined(separator: ",") ?? ""
            self.type = .options(field.choices ?? [])
        case .multiOption:
            self.answer = field.selected?.joined(separator: ",") ?? ""
            self.type = .multiOptions(field.choices ?? [])
        }
    }
}

class FeedbackFormViewModel: ObservableObject {
    
    private var bag = Set<AnyCancellable>()
    
    let id: String
    let name: String
    @Published var questions: [FieldViewModel]
    
    var createdAt: String? {
        didSet {
            objectWillChange.send()
        }
    }
    
    var isNew: Bool {
        createdAt == nil
    }
    var updatedAt: String?
    
    let defaultQuestions = [
        FieldViewModel(
            id: 0,
            question: "Which level of knowledge you have about Swift?",
            type: .options(["None", "Low", "Medium", "High"])
        ),
        FieldViewModel(
            id: 1,
            question: "Which level of knowledge you have about Serverless?",
            type: .options(["None", "Low", "Medium", "High"])
        ),
        FieldViewModel(
            id: 2,
            question: "Which level of knowledge you have about AWS?",
            type: .options(["None", "Low", "Medium", "High"])
        ),
        FieldViewModel(
            id: 3,
            question: "Which development experinces you have?",
            type: .multiOptions(["None", "iOS", "Web", "Vapor", "NodeJS"])
        ),
        FieldViewModel(
            id: 4,
            question: "What do you like about Breeze?",
            type: .text
        )
    ]
    
    init(feedbackForm: FeedbackForm? = nil) {
        if let feedbackForm {
            self.name = feedbackForm.name
            self.id = feedbackForm.key
            self.questions = []
            for (index, field) in feedbackForm.fields.enumerated() {
                self.questions.append(FieldViewModel(id: index, field: field))
            }
            self.createdAt = feedbackForm.createdAt
            self.updatedAt = feedbackForm.updatedAt
        } else {
            self.name = "Swift, Serverless and AWS Survey"
            self.id = UUID().uuidString
            self.questions = defaultQuestions
            self.createdAt = nil
            self.updatedAt = nil
        }
        
        for question in questions {
            question.objectWillChange.sink { _ in
                self.objectWillChange.send()
            }.store(in: &bag)
        }
    }
    
    func isValid() -> Bool {
        questions.reduce(true) { partialResult, question in
            partialResult && !question.answer.isEmpty
        }
    }
}

extension FeedbackFormViewModel {
    
    func buildFeedbackForm() -> FeedbackForm {
        let fields = questions.map { question in
            
            switch question.type {
            case .multiOptions(let options):
                return Field(
                    question: question.question,
                    answer: nil,
                    choices: options,
                    selected: question.answer.split(separator: ",").map { String($0) },
                    type: .multiOption
                )
            case .options(let options):
                return Field(
                    question: question.question,
                    answer: nil,
                    choices: options,
                    selected: question.answer.split(separator: ",").map { String($0) },
                    type: .option
                )
            case .text:
                return Field(
                    question: question.question,
                    answer: question.answer.isEmpty ? nil : question.answer,
                    choices: nil,
                    selected: nil,
                    type: .text
                )
            }
        }
        return FeedbackForm(
            key: id,
            name: name,
            fields: fields,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
