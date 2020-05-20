//
//  PageContentViewController.swift
//  FalabellaQuiz
//
//  Created by venu Gopal on 10/05/20.
//  Copyright © 2020 venu Gopal. All rights reserved.
//

import UIKit
import RealmSwift
enum AnswerOptions: Int {
    case A = 0
    case B
    case C
    case D
    
    func getString() -> String  {
        switch self {
        case .A:
            return "A"
        case .B:
            return "B"
        case .C:
            return "C"
        case .D:
            return "D"
        }
    }
}
typealias NextDidTapBlock = (() -> Void)
var score: Int = 0
class PageContentViewController: UIViewController {
    struct UIConstants {
        let collectionViewPadding: CGFloat = 40
        let optionsCellHeight: CGFloat = 100
        let questionNoString = "Question No. "
    }
    @IBOutlet weak var questionNumber: UILabel!
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var timer: UILabel!
    @IBOutlet weak var pointsEarned: UILabel!
    @IBOutlet weak var choicesCollectionView: UICollectionView!
    
    var pageIndex: Int = 0
    var counter = 10
    var options = [String]()
    let uiConstants = UIConstants()
    var nextDidTap: NextDidTapBlock?
    var quizQuestion: QuizQuestion?
    var selectedAnswerIndex: Int?
    var isSelectedAnswerCorrect: Bool = false
    var testTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        counter = 10
        invalidateTimer()
        startTimer()
        setUpView()
    }
    
    func setUpView() {
        questionNumber.text = uiConstants.questionNoString + "\(pageIndex)"
        pointsEarned.text = "\(score)"
        question.text = quizQuestion?.question
        options = Array(quizQuestion?.options ?? List<String>())
    }
    
    func startTimer() {
        testTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        timer.text = "10"
    }
    
    func invalidateTimer() {
        if let testTime = testTimer {
            testTime.invalidate()
        }
    }
    
    @objc func updateCounter() {
        if counter > 0 {
            counter = counter - 1
            timer.text = "\(counter)"
        } else {
            gotoNextQuestion()
        }
    }
    
    func gotoNextQuestion() {
        invalidateTimer()
        counter = 10
        nextDidTap?()
    }
    
    func registerCells()  {
        choicesCollectionView.register(UINib(nibName: OptionCell.className, bundle: nil), forCellWithReuseIdentifier: OptionCell.className)
    }
    
    // MARK: IBOutlets
    @IBAction func tapOnScores(_ sender: Any) {
        guard let topScoreVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: TopScoresVC.className) as? TopScoresVC else {
            return
        }
        
        present(topScoreVC, animated: true, completion: nil)
    }
    
    @IBAction func onNextDidTap(_ sender: Any) {
        score = isSelectedAnswerCorrect ? score + 20 : score - 10
        gotoNextQuestion()
    }
    @IBAction func editProfileTapped(_ sender: Any) {
        guard let profileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: UserRegistrationVC.className) as? UserRegistrationVC else {
            return
        }
        profileVC.isFromQuizScreen = true
        present(profileVC, animated: true, completion: nil)
    }
}

// MARK: UICollectionView Delegate methods

extension PageContentViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OptionCell.className, for: indexPath) as? OptionCell else {
            return UICollectionViewCell()
        }
        cell.isSelected = selectedAnswerIndex == indexPath.row ? true : false
        cell.option = options[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width / 2 - uiConstants.collectionViewPadding, height: uiConstants.optionsCellHeight)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedAnswer = AnswerOptions(rawValue: indexPath.row)
        selectedAnswerIndex = indexPath.row
        isSelectedAnswerCorrect = selectedAnswer?.getString() == quizQuestion?.answer
        collectionView.reloadData()
    }
}

