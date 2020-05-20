//
//  UIViewController+Extension.swift
//  FalabellaQuiz
//
//  Created by venu Gopal on 14/05/20.
//  Copyright © 2020 venu Gopal. All rights reserved.
//

import UIKit

extension UIViewController {
    func alert(message: String, title: String = "") {
      let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
      let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
      alertController.addAction(OKAction)
      self.present(alertController, animated: true, completion: nil)
    }
}
