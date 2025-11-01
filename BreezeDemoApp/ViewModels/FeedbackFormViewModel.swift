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
import SharedModel

enum QuestionType {
    case text
    case options([String])
    case multiOptions([String])
}

@Observable
class FieldViewModel: Identifiable {
    let id: Int
    let question: String
    let type: QuestionType
    var answer: String
    
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

@Observable
class FeedbackFormViewModel: Identifiable {
    let id: String
    let name: String
    var questions: [FieldViewModel]
    var createdAt: String?
    var updatedAt: String?
    var isValid: Bool = false
    var isNew: Bool {
        createdAt == nil
    }
    
    init(feedbackForm: FeedbackForm) {
        self.name = feedbackForm.name
        self.id = feedbackForm.key
        self.questions = []
        self.createdAt = feedbackForm.createdAt
        self.updatedAt = feedbackForm.updatedAt
        for (index, field) in feedbackForm.fields.enumerated() {
            self.questions.append(FieldViewModel(id: index, field: field))
        }
        self.startObserving()
    }
    
    func questionsAreNotEmpty() -> Bool {
        questions.reduce(true) { partialResult, question in
            partialResult && !question.answer.isEmpty
        }
    }
    
    private func startObserving() {
        self.isValid = self.questionsAreNotEmpty()
        withObservationTracking {
            _ = questions.count
            for question in questions {
                let _ = question.answer.isEmpty
            }
        } onChange: {
            Task { @MainActor in
                self.startObserving()
            }
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
