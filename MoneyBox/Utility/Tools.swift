//
//  Tools.swift
//  MoneyBox
//
//  Created by Antoine Simon on 03/10/2020.
//

import Foundation
import UIKit

extension String {
    var localizedString: String {
        return NSLocalizedString(self, comment: "")
    }
}
extension UserDefaults {
    enum Constants {
        static let token = "token"
    }
    
    func save(token: String) {
        UserDefaults.standard.set(token, forKey: Constants.token)
    }
    
    func getToken() -> String {
        return UserDefaults.standard.string(forKey: Constants.token) ?? ""
    }
}

extension UIView {

    func addSubviewFillingParent(_ view: UIView, marginTop: CGFloat = 0, marginLeading: CGFloat = 0, marginBottom: CGFloat = 0, marginTrailing: CGFloat = 0) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        NSLayoutConstraint.activate([topAnchor.constraint(equalTo: view.topAnchor, constant: marginTop),
                                     trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: marginTrailing),
                                     bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: marginBottom),
                                     leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: marginLeading)])
    }
}
