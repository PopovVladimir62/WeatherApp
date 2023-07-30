//
//  UITxtField + Ext.swift
//  WearherMVVMRx
//
//  Created by Владимир on 25.07.2023.
//

import Foundation
import UIKit
import Combine

extension UISearchTextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { $0.object as? UITextField }
            .map { $0.text ?? "" }
            .eraseToAnyPublisher()
    }
}
