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
    
    private let viewModel: ProfileIntroViewModel = .init()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingViewModel()
        bind(viewModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "입장하기"
        navigationController?.navigationBar.topItem?.title = ""
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
        
        nextButton.rx.tap.bind { [weak self] _ in
            guard let vc = self?.storyboard?.instantiateViewController(withIdentifier: "ProfileKeywordViewController") as? ProfileKeywordViewController else { return }
            self?.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)
        
    }

}
