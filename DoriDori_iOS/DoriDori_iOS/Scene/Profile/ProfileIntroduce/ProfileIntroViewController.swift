//
//  ProfileIntroViewController.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/08/25.
//

import UIKit
import RxSwift


final class ProfileIntroViewController: UIViewController {
    
    @IBOutlet private weak var profileIntroTextField: UnderLineTextField!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var buttonBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var navigationBackButton: UIButton!
    
    private let viewModel: ProfileIntroViewModel = .init()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingViewModel()
        bind(viewModel)
        keyboardSetting()
        settingNavigation()
    }
    
    private func settingNavigation() {
        self.navigationController?.navigationBar.isHidden = true
        let navi = navigationBackButton.rx.tap.asObservable()
        navi.bind { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
    }
    
    // MARK: - Bind
    private func settingViewModel() {
        profileIntroTextField.viewModel = UnderLineTextFieldViewModel(titleLabelType: .profile,
                                                                      keyboardType: .default)
    }
    
    private func bind(_ viewModel: ProfileIntroViewModel) {
        
        let input = ProfileIntroViewModel.Input(profile: profileIntroTextField.textField.rx.text.orEmpty.asObservable(),
                                                profileStringCount: profileIntroTextField.viewModel.totalStringCount)
        
        let output = viewModel.transform(input: input)
        output.btnInEnable.bind(onNext: { [weak self] isValid in
            self?.nextButton.isEnabled = isValid
            self?.nextButton.backgroundColor = isValid ? UIColor(named: "lime300") : UIColor(named: "")
            let buttonTitleColor = isValid ? UIColor(named: "darkGray") : UIColor(named: "lime300")
            self?.nextButton.setTitleColor(buttonTitleColor, for: .normal)
        }).disposed(by: disposeBag)
        
        
        nextButton.rx.tap.withLatestFrom(input.profile)
            .bind { [weak self] intro in
                self?.profileIntroTextField.textField.resignFirstResponder()
                guard let vc = self?.storyboard?.instantiateViewController(withIdentifier: "ProfileKeywordSettingViewController") as? ProfileKeywordSettingViewController else { return }
                vc.profileIntro = intro
                self?.navigationController?.pushViewController(vc, animated: true)
            }.disposed(by: disposeBag)
        
    }

}

extension ProfileIntroViewController {
    func keyboardSetting() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(_ sender: Notification) {
        let keyboardButtonSpace: Int = 10
        if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.3, animations: {
                self.buttonBottomConstraint.constant = CGFloat(keyboardButtonSpace) + keyboardSize.height
                self.view.layoutIfNeeded()
            })
        }
    }

    @objc func keyboardWillHide(_ sender: Notification) {
        let buttonButtomConstraintSize: Int = 54
        UIView.animate(withDuration: 0.3) {
            self.buttonBottomConstraint.constant = CGFloat(buttonButtomConstraintSize)
            self.view.layoutIfNeeded()
        }
        
    }
}



