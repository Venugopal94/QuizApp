//
//  Score.swift
//  FalabellaQuiz
//
//  Created by venu Gopal on 11/05/20.
//  Copyright © 2020 venu Gopal. All rights reserved.
//

import Foundation
import RealmSwift

class Score: Object, Codable {
    @objc dynamic var score: Int = 0
}
