//
//  NicknameSettingViewController.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/08/08.
//

import UIKit
import RxSwift

final class NicknameSettingViewController: UIViewController {
    
    @IBOutlet private weak var nicknameTextField: UnderLineTextField!
    @IBOutlet private weak var confirmButton: UIButton!
    @IBOutlet private weak var buttomBottomConstraint: NSLayoutConstraint!
    
    private let viewModel: NicknameSettingViewModel = .init()
    private var disposeBag = DisposeBag()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        settingViewModel()
        bind(viewModel)
        keyboardSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "입장하기"
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    // MARK: - Bind
    private func settingViewModel() {
        nicknameTextField.viewModel = UnderLineTextFieldViewModel(titleLabelType: .nickname,
                                                                  keyboardType: .default)
        
    }
    
    private func bind( _ viewModel: NicknameSettingViewModel) {
        let input = NicknameSettingViewModel.Input(
            nickname: nicknameTextField.textField.rx.text.orEmpty.asObservable(),
            tappedConfirm: confirmButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        output.buttonOutput.bind(onNext: { [weak self] isValid in
            self?.buttonValid(isValid)
        }).disposed(by: disposeBag)
        
        output.errorMsg.emit(onNext: { [weak self] str in
            self?.nicknameTextField.errorLabel.isHidden = false
            self?.nicknameTextField.errorLabel.text = str
            self?.nicknameTextField.underLineView.backgroundColor = UIColor(named: "red500")
            self?.buttonValid(false)
        }).disposed(by: disposeBag)
        
        output.nicknameOutput.drive(onNext: { [weak self] success in
            if success {
                
                guard let vc = self?.storyboard?.instantiateViewController(withIdentifier: "ProfileIntroViewController") as? ProfileIntroViewController
                else { return }
                self?.navigationController?.pushViewController(vc, animated: true)
            } else {
                print("닉네임 설정 실패")
            }
        }).disposed(by: disposeBag)
        
        output.defaultProfile.bind { output in
            let msg = output ? "기본 프로필 사진 성공" : "실패"
            print(msg)
        }.disposed(by: disposeBag)
    }
    
    private func buttonValid(_ isValid: Bool) {
        self.confirmButton.isEnabled = isValid
        let titleColor = isValid ? UIColor(named: "darkGray") : UIColor(named: "gray300")
        self.confirmButton.setTitleColor(titleColor, for: .normal)
        self.confirmButton.backgroundColor = isValid ? UIColor(named: "lime300") : UIColor(named: "gray800")
    }
}

extension NicknameSettingViewController {
        func keyboardSetting() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        let keyboardButtonSpace: Int = 20
        if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.3, animations: {
                self.buttomBottomConstraint.constant = CGFloat(keyboardButtonSpace) + keyboardSize.height
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        let buttonButtomConstraintSize: Int = 54
        UIView.animate(withDuration: 0.3) {
            self.buttomBottomConstraint.constant = CGFloat(buttonButtomConstraintSize)
            self.view.layoutIfNeeded()
        }
        
    }
}

