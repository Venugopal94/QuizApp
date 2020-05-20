//
//  TopscoresVM.swift
//  FalabellaQuiz
//
//  Created by venu Gopal on 14/05/20.
//  Copyright © 2020 venu Gopal. All rights reserved.
//

import Foundation
class TopScoresVM {
    var allScores = [Score]()
    
    func getAllSavesScores(completion: @escaping ()-> Void) {
        guard let scores = RealmManager.shared.fetchSortedObjects(Score.self) as? [Score] else { return }
        allScores = scores
        completion()
    }
}
