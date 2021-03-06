//
//  UISearchBar+Extension.swift
//  DeezerAPITest
//
//  Created by Emin Roblack on 04/02/2020.
//  Copyright © 2020 Emin Roblack. All rights reserved.
//

import UIKit

extension UISearchBar {
    func stylize() {
    let searchTextField = self.value(forKey: "searchField") as? UITextField
    searchTextField?.backgroundColor = .clear
        barTintColor = .semanticHeader
        setImage(UIImage(named: "clear"), for: .clear, state: .normal)
        setImage(UIImage(named: "search"), for: .search, state: .normal)
        placeholder = "Enter artist name..."
        tintColor = .semanticTextStandard
        searchTextField?.textColor = .semanticTextStandard
    }
}
