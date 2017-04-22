//
//  UITextFieldExtensions.swift
//  DreamLister
//
//  Created by Ruben Sissing on 22/04/2017.
//  Copyright © 2017 Ruben Sissing. All rights reserved.
//

import UIKit

extension UITextField {
    class func connectFields(fields:[UITextField]) -> Void {
        guard let last = fields.last else {
            return
        }
        for i in 0 ..< fields.count - 1 {
            fields[i].returnKeyType = .next
            fields[i].addTarget(fields[i+1], action: #selector(UIResponder.becomeFirstResponder), for: .editingDidEndOnExit)
        }
        last.returnKeyType = .go
        last.addTarget(last, action: #selector(UIResponder.resignFirstResponder), for: .editingDidEndOnExit)
    }
}
