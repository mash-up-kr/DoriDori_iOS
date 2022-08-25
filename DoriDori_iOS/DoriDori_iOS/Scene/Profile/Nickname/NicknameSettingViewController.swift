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
    
    private let viewModel: NicknameSettingViewModel = .init()
    private var disposeBag = DisposeBag()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        settingViewModel()
        bind(viewModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureSignUpNavigationBar()
    }
    // MARK: - Bind
    private func settingViewModel() {
        nicknameTextField.viewModel = UnderLineTextFieldViewModel(titleLabelType: .nickname,
                                                               keyboardType: .default)

    }
    
    private func bind( _ viewModel: NicknameSettingViewModel) {
        let input = NicknameSettingViewModel.Input(nickname: nicknameTextField.textField.rx.text.orEmpty.asObservable())
        
        let output = viewModel.transform(input: input)
        output.buttonOutput.bind(onNext: { [weak self] isValid in
            self?.confirmButton.isEnabled = isValid
            let titleColor = isValid ? UIColor(named: "darkGray") : UIColor(named: "gray300")
            self?.confirmButton.setTitleColor(titleColor, for: .normal)
            self?.confirmButton.backgroundColor = isValid ? UIColor(named: "lime300") : UIColor(named: "gray800")
        }).disposed(by: disposeBag)
        
        confirmButton.rx.tap.bind { [weak self] _ in
            guard let vc = self?.storyboard?.instantiateViewController(withIdentifier: "ProfileUploadViewController") as? ProfileUploadViewController
            else { return }
            self?.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)
        
    }
    
    
    
    
}