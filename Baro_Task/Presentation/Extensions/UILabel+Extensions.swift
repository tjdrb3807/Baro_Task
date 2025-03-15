//
//  UILabel+Extensions.swift
//  Baro_Task
//
//  Created by 전성규 on 3/15/25.
//

import UIKit

extension UILabel {
    func setTitleLabelColor() {
        guard let text = self.text, let _ = text.last else { return }
        
        let attributedString = NSMutableAttributedString(string: text)
        let lastCharRange = NSRange(location: text.count - 1, length: 1)
        
        attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: lastCharRange)
        
        self.attributedText = attributedString
    }
}
