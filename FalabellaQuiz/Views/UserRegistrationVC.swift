//
//  UserRegistrationVC.swift
//  FalabellaQuiz
//
//  Created by venu Gopal on 14/05/20.
//  Copyright © 2020 venu Gopal. All rights reserved.
//

import UIKit

class UserRegistrationVC: UIViewController {
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    var isFromQuizScreen: Bool = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerButton.setTitle("Register", for: .normal)
        backButton.isHidden = true
        if isFromQuizScreen {
            registerButton.setTitle("Update", for: .normal)
            backButton.isHidden = false
            if let user = RealmManager.shared.fetchObjects(User.self)?.first as? User {
                ageTextField.text = user.age
                nameTextField.text = user.name
                genderTextField.text = user.gender
            }
        }
    }
    
    @IBAction func didTapOnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func didTapOnRegister(_ sender: Any) {
        self.view.endEditing(true)
        if ageTextField.text?.isEmpty ?? false || nameTextField.text?.isEmpty ?? false || ageTextField.text?.isEmpty ?? false {
            alert(message: StringConstants.fillAllFields, title: "Error")
        } else {
            RealmManager.shared.removeAllObjectsOfType(User.self)
            let user = User()
            user.age = ageTextField.text
            user.name = nameTextField.text
            user.gender = genderTextField.text
            RealmManager.shared.saveObject(user, update: false)
            if isFromQuizScreen {
                self.dismiss(animated: true, completion: nil)
            } else {
                guard let quizVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: QuizQuestionsPageVC.className) as? QuizQuestionsPageVC else { return }
                let nav = UINavigationController(rootViewController: quizVC)
                nav.navigationBar.isHidden = true
                nav.modalPresentationStyle = .fullScreen
                present(nav, animated: true, completion: nil)
            }
        }
    }
}

//MARK: UITextFieldDelegate
extension UserRegistrationVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
