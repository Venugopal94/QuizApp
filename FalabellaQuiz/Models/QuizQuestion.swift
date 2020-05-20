//
//  QuizQuestion.swift
//  FalabellaQuiz
//
//  Created by venu Gopal on 10/05/20.
//  Copyright © 2020 venu Gopal. All rights reserved.
//

import Foundation
import RealmSwift

class QuizQuestion: Object, Codable {
    @objc dynamic var question: String?
    var options: List<String> = List<String>()
    @objc dynamic var answer: String?
}
