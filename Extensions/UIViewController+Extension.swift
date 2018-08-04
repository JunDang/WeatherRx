//
//  UIViewController+Extension.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-08-02.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import Foundation
import UIKit

public extension UIViewController {
    func displayErrorMessage(userMessage: String, handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: "Error Message", message: userMessage, preferredStyle: .alert)
        let action = UIAlertAction(
            title: "OK",
            style: .default,
            handler: handler)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
   }
}
