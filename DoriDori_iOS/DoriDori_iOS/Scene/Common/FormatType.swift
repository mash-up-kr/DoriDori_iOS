//
//  FormatType.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/07/26.
//

import UIKit

enum FormatType {
    case hash
    case decimal
    
    private var numberFormatter: NumberFormatter {
        let numberFormatter: NumberFormatter  = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter
    }
}


extension FormatType {
    
    func numberToDecimal(number: NSNumber) -> String? {
        return numberFormatter.string(from: number)
    }
    
    func setAttributeText(_ text: String) -> NSAttributedString? {
        let textArray = text.map { String($0) }
        
        guard let hashIndex = textArray.firstIndex(of: "#") else {
            return nil
        }
        
        var blankIndex: Int = 0
        
        for i in (hashIndex...textArray.count-1) {
            if textArray[safe: i] == " " {
                blankIndex = i-1
                break
            }
        }
        
        if blankIndex <= 0 {
            blankIndex = text.count-1
        }
        
        let hashString = textArray[(hashIndex)...blankIndex].joined()
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.foregroundColor, value: UIColor.lime300, range: (text as NSString).range(of: hashString))
        return attributedString
    }
}

