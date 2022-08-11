//
//  ProfileKeywordViewController.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/08/09.
//

import UIKit

final class ProfileKeywordViewController: UIViewController {

    @IBOutlet private weak var keywordStackView: UIStackView!
    @IBOutlet private weak var keywordTextField: UITextField!
    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet private weak var startButtomBottomConstraint: NSLayoutConstraint!
    
    private var keywordisEdit: Bool = false
    private let keyboardUpButtomConstraint: CGFloat = 20
    private let keyboardDownButtomConstraint: CGFloat = 54
    
    let dummy = ["넷플릭스","강아지", "MBTI"]
   
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTextField()
        settingDummyData()
        keyboardSetting()
    }
    
    private func settingTextField() {
        keywordTextField.delegate = self
    }
    
    private func settingDummyData() {
        dummy.forEach {
            let keywordView = ProfileKeywordView()
            keywordView.configure(title: $0)
            self.keywordStackView.addArrangedSubview(keywordView)
            keywordView.delegate = self
        }
    }

    private func pushKeywordView(keyword: String) {
        let keywordView = ProfileKeywordView()
        keywordView.configure(title: keyword)
        self.keywordStackView.addArrangedSubview(keywordView)
        keywordView.delegate = self
    }
    
    private func removeButtonisEnable(_ state: Bool) {
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

//MARK: - textField 편집시 Keyboard 설정
extension ProfileKeywordViewController {
    private func keyboardSetting() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(_ sender: Notification) {
        if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.3, animations: {
                self.startButtomBottomConstraint.constant = self.keyboardUpButtomConstraint + keyboardSize.height
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.startButtomBottomConstraint.constant = self.keyboardDownButtomConstraint
            self.view.layoutIfNeeded()
        }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
