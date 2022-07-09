//
//  TextFieldTestViewController.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/07/10.
//

import UIKit

class TextFieldTestViewController: UIViewController {

    @IBOutlet weak var textFieldStackView: UIStackView!
    
    var textFieldData: [UnderLineData] = [
        UnderLineData(type: .email),
        UnderLineData(type: .password)
    ]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldData.enumerated().forEach {
            let makeView = UnderLineTextField()
            makeView.data = $1
            makeView.delegate = self
            if $0 == 0 {
                makeView.textField.becomeFirstResponder()
            }
            textFieldStackView.insertArrangedSubview(makeView, at: $0)
        }
    }
}

extension TextFieldTestViewController: UnderLineTextFieldDelegate {
    func underLineDidEnd(sender: UITextField) {
        var state: Bool = true
        textFieldData.forEach {
            if $0.validState == false {
                state = false
            }
        }
    }
    
    func underLineDidChange(sender: UITextField) {
        var state: Bool = true
        textFieldData.forEach {
            if $0.validState == false {
                state = false
            }
        }
    }
}
 
