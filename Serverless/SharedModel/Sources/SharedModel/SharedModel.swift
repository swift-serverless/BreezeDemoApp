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

public enum FieldType: String, Codable {
    case text
    case option
    case multiOption
}

public struct Field: Codable {
    public let question: String
    public let answer: String?
    public let choices: [String]?
    public let selected: [String]?
    public let type: FieldType
    
    public init(question: String, answer: String? = nil, choices: [String]? = nil, selected: [String]? = nil, type: FieldType) {
        self.question = question
        self.answer = answer
        self.choices = choices
        self.selected = selected
        self.type = type
    }
}

public struct Form: Codable {
    
    public var key: String
    public let name: String
    public let fields: [Field]
    public var createdAt: String?
    public var updatedAt: String?
    
    public init(key: String, name: String, fields: [Field], createdAt: String? = nil, updatedAt: String? = nil) {
        self.key = key
        self.name = name
        self.fields = fields
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    enum CodingKeys: String, CodingKey {
        case key = "formKey"
        case name
        case fields
        case createdAt
        case updatedAt
    }
}
