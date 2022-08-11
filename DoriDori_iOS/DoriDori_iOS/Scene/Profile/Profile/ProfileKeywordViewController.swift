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
    private var keywordisEdit: Bool = false
    
    let dummy = ["넷플릭스","강아지", "MBTI"]
   
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTextField()
        settingDummyData()
    }
    
    private func settingTextField() {
        keywordTextField.delegate = self
    }
    
    func settingDummyData() {
        dummy.forEach {
            let keywordView = ProfileKeywordView()
            keywordView.configure(title: $0)
            self.keywordStackView.addArrangedSubview(keywordView)
            keywordView.delegate = self
        }
    }

    func pushKeywordView(keyword: String) {
        let keywordView = ProfileKeywordView()
        keywordView.configure(title: keyword)
        self.keywordStackView.addArrangedSubview(keywordView)
        keywordView.delegate = self
    }
    
    func removeButtonisEnable(_ state: Bool) {
        keywordStackView.arrangedSubviews.forEach {
            guard let view = $0 as? ProfileKeywordView else { return }
            view.removeButton.isHidden = state
        }
    }
    
    @IBAction func tapProfileKeywordEdit(_ sender: UIButton) {
        keywordisEdit.toggle()
        let title = keywordisEdit ? "편집" : "편집 취소"
        sender.setTitle(title, for: .normal)
        removeButtonisEnable(keywordisEdit)
    }
}

extension ProfileKeywordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let keyword = textField.text {
            pushKeywordView(keyword: keyword)
        }
        self.view.endEditing(true)
        return true
    }

}

extension ProfileKeywordViewController: ProfileKeywordViewDelegate {
    func removeKeyword(_ view: ProfileKeywordView) {
        print("delegate remove", view)
        self.keywordStackView.removeArrangedSubview(view)
        view.removeFromSuperview()
    }
    
}
