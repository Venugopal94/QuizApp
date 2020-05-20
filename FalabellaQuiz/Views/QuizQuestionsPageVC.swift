//
//  ViewController.swift
//  FalabellaQuiz
//
//  Created by venu Gopal on 10/05/20.
//  Copyright © 2020 venu Gopal. All rights reserved.
//

import UIKit
import RealmSwift

class QuizQuestionsPageVC: BaseViewController, UIPageViewControllerDataSource {
    
    struct UIConstants {
        let maxNumberOfQuestions = 10
    }
    
    let uiConstants = UIConstants()
    let viewModel = QuizQuestionsVM()
    var pageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        getQuizes()
    }
    
    func getQuizes() {
        showSpinner(onView: self.view)
        viewModel.getAllQuizQuestions {[weak self] error in
            self?.removeSpinner()
            DispatchQueue.main.async {
                self?.setViewControllers([self?.getViewControllerAtIndex(index: 0)] as? [UIViewController], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
            }
        }
        
    }
    
    // MARK:- UIPageViewControllerDataSource Methods
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    // MARK:- Other Methods
    func getViewControllerAtIndex(index: NSInteger) -> PageContentViewController
    {
        // Create a new view controller and pass suitable data.
        pageIndex += 1;
        if (pageIndex > uiConstants.maxNumberOfQuestions) {
            pageIndex = 1
            alert(message: StringConstants.testCompleted, title: "Message")
            let scoreObject = Score()
            scoreObject.score = score
            DispatchQueue.main.async {
                RealmManager.shared.saveObject(scoreObject, update: false)
            }
        }
        let pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageContentViewController") as! PageContentViewController
        let randomQuestion = viewModel.allQuizQuestions?.randomElement()
        pageContentViewController.quizQuestion = randomQuestion
        pageContentViewController.pageIndex = pageIndex
        pageContentViewController.nextDidTap = { [weak self] in
            self?.setViewControllers([self?.getViewControllerAtIndex(index: index)] as? [UIViewController], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
        }
        
        return pageContentViewController
    }
}

