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


final class WelcomeViewController: UIViewController, StoryboardView {
        
    typealias Reactor = WelcomeViewModel
    
    @IBOutlet private weak var emailLoginButton: UIButton!
    @IBOutlet private weak var emailSignUpButton: UIButton!
    
    var disposeBag = DisposeBag()

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func router(to: SignInButtonType) {
        let storyboard = UIStoryboard.init(name: "SignIn", bundle: nil)
        switch to {
        case .emailSignIn:
            guard let vc = storyboard.instantiateViewController(withIdentifier: "EmailSignInViewController") as? EmailSignInViewController else { return }
            navigationController?.pushViewController(vc, animated: true)

        case .emailSignup:
            guard let vc = storyboard.instantiateViewController(withIdentifier: "TermsOfServiceViewContoller") as? TermsOfServiceViewContoller else { return }
            navigationController?.pushViewController(vc, animated: true)
        }

    }

    // MARK: - Bind ViewModel

    func bind(reactor viewModel: WelcomeViewModel) {
        
        emailLoginButton.rx.tap
            .map { .emailSignInButtonDidTap }
            .distinctUntilChanged()
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)
        
        emailSignUpButton.rx.tap
            .map { .emailSignupButtonDidTap }
            .distinctUntilChanged()
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
