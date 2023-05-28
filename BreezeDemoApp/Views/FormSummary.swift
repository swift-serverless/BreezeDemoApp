//
//  FormSummary.swift
//  BreezeDemoApp
//
//  Created by Andrea Scuderi on 27/05/2023.
//

import SwiftUI
import SharedModel

struct FormSummary: View {
    
    let form: FeedbackForm
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(form.key).bold()
            Text("Created: \(form.createdAt ?? "")")
            Text("Updated: \(form.updatedAt ?? "")")
        }.fontWeight(.light)
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
        ],
        createdAt: Date().ISO8601Format(.iso8601),
        updatedAt: Date().ISO8601Format(.iso8601)
    )
    
    static var previews: some View {
        FormSummary(form: form)
    }
}
