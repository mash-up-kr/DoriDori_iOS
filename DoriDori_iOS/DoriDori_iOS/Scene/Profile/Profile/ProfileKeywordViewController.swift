//
//  ProfileKeywordViewController.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/08/09.
//

import UIKit


class ProfileKeywordViewController: UIViewController {

    @IBOutlet private weak var keywordStackView: UIStackView!
    @IBOutlet private weak var keywordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTextField()
    }
    
    private func settingTextField() {
        keywordTextField.delegate = self
    }

    //뒤에 추가됨
    func settingKeyword(keyword: String) {
        let keywordView = ProfileKeywordView()
        keywordView.configure(title: keyword)
        self.keywordStackView.addArrangedSubview(keywordView)
        keywordView.delegate = self

    }
    
}

extension ProfileKeywordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(textField.text ?? "gg")
        if let keyword = textField.text {
            settingKeyword(keyword: keyword)
        }
        return true
    }

}

extension ProfileKeywordViewController: ProfileKeywordViewDelegate {
    func removeKeyword(_ view: ProfileKeywordView) {
        print("delegate remove", view)
        self.keywordStackView.removeArrangedSubview(view)
        view.removeFromSuperview() //hierarchy에서 제거하기 위함
    }
    
}
