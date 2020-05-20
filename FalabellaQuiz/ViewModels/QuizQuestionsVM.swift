//
//  QuizQuestionsVM.swift
//  FalabellaQuiz
//
//  Created by venu Gopal on 10/05/20.
//  Copyright © 2020 venu Gopal. All rights reserved.
//

import Foundation

class QuizQuestionsVM {
    
    var allQuizQuestions: [QuizQuestion]?
    
    func getAllQuizQuestions(completion: @escaping (_ error: String?)-> Void) {
        
        if let questionsArray = RealmManager.shared.fetchObjects(QuizQuestion.self) as? [QuizQuestion], !questionsArray.isEmpty {
            self.allQuizQuestions = questionsArray
            completion(nil)
            return
        }
        NetworkHandler.sharedInstance.dataRequest(method: .get, body: [:], params: "", objectType: [QuizQuestion].self) { (responseModel, error) in
            if error == nil {
                DispatchQueue.main.async {
                    self.allQuizQuestions = responseModel
                    RealmManager.shared.saveObjects(responseModel ?? [QuizQuestion](), update: false)
                    completion(nil)
                }
            } else {
                completion(error)
            }
        }
    }
}
