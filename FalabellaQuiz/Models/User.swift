//
//  User.swift
//  FalabellaQuiz
//
//  Created by venu Gopal on 14/05/20.
//  Copyright © 2020 venu Gopal. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object, Codable {
    @objc dynamic var name: String?
    @objc dynamic var age: String?
    @objc dynamic var gender: String?
}
