//
//  FormSummary.swift
//  BreezeDemoApp
//
//  Created by Andrea Scuderi on 27/05/2023.
//

import SwiftUI
import SharedModel

struct FormSummaryField: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title).font(.caption)
            Text(value).font(.system(size: 13, weight: .bold))
        }
    }
}

struct FormSummaryContent: View {
    
    let fields: [FieldViewModel]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            ForEach(fields, id: \.id) {
                Text("\($0.question)")
                Text("\($0.answer)").bold()
            }
        }
        .font(.caption)
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.orange, lineWidth: 1)
        )
    }
}

struct FormSummary: View {
    
    let form: FeedbackForm
    let fields: [FieldViewModel]
    
    init(form: FeedbackForm) {
        self.form = form
        var fields = [FieldViewModel]()
        for (index, field) in form.fields.enumerated() {
            fields.append(FieldViewModel(id: index, field: field))
        }
        self.fields = fields
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            FormSummaryField(title: "Key:", value: form.key)
            FormSummaryField(title: "CreatedAt:", value: form.createdAt ?? "")
            FormSummaryField(title: "UpdatedAt:", value: form.updatedAt ?? "")
            FormSummaryContent(fields: fields)
        }
    }
}

struct FormSummary_Previews: PreviewProvider {
    
    static let form = FeedbackForm(
        key: UUID().uuidString,
        name: "Swift, Serverless and AWS Survey",
        fields: [
            Field(
                question: "What is the main benefit of Serverless computing?",
                choices: ["Cost savings 💰", "Performance ⚡️", "Scalability 🚀", "Infrastructure as a Code 💨"],
                selected: ["Scalability 🚀", "Performance ⚡️"],
                type: .multiOption
            ),
            Field(
                question: "If you start a new project, whould you use Serverless on AWS?",
                choices: ["No", "Very likely", "Yes"],
                selected: ["Yes"],
                type: .option
            ),
            Field(
                question: "Would you change your favourite coding language to start a Serverless project?",
                choices: ["No, I ❤️ Swift!", "Yes, but 😓", "Yes, I'm 💪"],
                selected: ["No, I ❤️ Swift!"],
                type: .option
            ),
            Field(
                question: "As a Swift developer, what could help you to get into Serverless?",
                choices: ["Tutorials 📚", "Starting tool 💻", "A course 👩🏻‍🏫"],
                selected: ["Starting tool 💻"],
                type: .multiOption
            ),
            Field(
                question: "Comments",
                answer: "I want to try Breeze",
                type: .text
            )
        ],
        createdAt: Date().ISO8601Format(.iso8601),
        updatedAt: Date().ISO8601Format(.iso8601)
    )
    
    static var previews: some View {
        FormSummary(form: form)
    }
}
