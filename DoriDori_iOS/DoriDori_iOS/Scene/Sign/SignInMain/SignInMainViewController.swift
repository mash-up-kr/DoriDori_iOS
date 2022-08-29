//
//  SignInViewController.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/07/09.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit


final class SignInMainViewController: UIViewController, StoryboardView {
        
    typealias Reactor = SignInMainViewModel
    
    @IBOutlet private weak var emailLoginButton: UIButton!
    @IBOutlet private weak var emailSignUpButton: UIButton!
    
    var disposeBag = DisposeBag()

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    private func router(to: SignInButtonType) {
        let storyboard = UIStoryboard.init(name: "SignIn", bundle: nil)
        let st = UIStoryboard.init(name: "Profile", bundle: nil)
        var targetVC: UIViewController = .init()
        switch to {
        case .emailSignIn:
            guard let vc = st.instantiateViewController(withIdentifier: "NicknameSettingViewController") as? NicknameSettingViewController else { return }
            navigationController?.pushViewController(vc, animated: true)

        case .emailSignup:
            guard let vc = storyboard.instantiateViewController(withIdentifier: "TermsOfServiceViewContoller") as? TermsOfServiceViewContoller else { return }
            navigationController?.pushViewController(vc, animated: true)
        }

    }

    // MARK: - Bind ViewModel

    func bind(reactor viewModel: SignInMainViewModel) {
        
        emailLoginButton.rx.tap
            .map { .emailSignInButtonDidTap }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)
        
        emailSignUpButton.rx.tap
            .map { .emailSignupButtonDidTap }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)
        
        reactor?.pulse(\.$buttonType)
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] in
                self?.router(to: $0)
            })
            .disposed(by: disposeBag)

    }
}
