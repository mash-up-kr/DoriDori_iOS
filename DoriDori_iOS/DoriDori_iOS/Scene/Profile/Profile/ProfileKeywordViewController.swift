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
    
    let dummyData = ["MBTI", "HIddd", "어렵당"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeywordStackView()
        settingTextField()
    }
    
    private func settingTextField() {
        keywordTextField.delegate = self
    }
    
    private func setupKeywordStackView() {
        dummyData.forEach {
            let keywordView = ProfileKeywordView()
            keywordView.configure(title: $0)
            self.keywordStackView.addArrangedSubview(keywordView)
        }
    }
    
    func settingKeyword(_ keyword: String) {
        let keywordView = ProfileKeywordView()
        keywordView.configure(title: keyword)
        self.keywordStackView.addArrangedSubview(keywordView)
    }
    
    @IBAction func tapEditButton(_ sender: UIButton) {
        //지우기 버튼이 활성화 되야 함..
    }
}

extension ProfileKeywordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(textField.text ?? "gg")
        if let keyword = textField.text {
            settingKeyword(keyword)
        }
        return true
    }

}
