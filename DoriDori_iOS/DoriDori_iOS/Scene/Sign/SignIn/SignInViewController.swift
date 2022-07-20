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


final class SignInViewController: UIViewController, StoryboardView {
        
    typealias Reactor = SignInViewModel
    
    @IBOutlet weak var appleLoginButton: UIButton!
    @IBOutlet weak var kakaoLoginButton: UIButton!
    @IBOutlet weak var emailLoginButton: UIButton!
    @IBOutlet weak var emailSignUpButton: UIButton!
    
    var disposeBag = DisposeBag()

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    private func router(to: SignInButtonType) {
        let storyboard = UIStoryboard.init(name: "SignIn", bundle: nil)
        var targetVC: UIViewController = .init()
        switch to {
        case .apple:
            print("apple")
        case .kakao:
            print("kakao")
        case .email:
            guard let vc = storyboard.instantiateViewController(withIdentifier: "EmailSignInViewController") as? EmailSignInViewController else { return }
            targetVC = vc
            navigationController?.pushViewController(targetVC, animated: true)

        case .emailSignup:
            guard let vc = storyboard.instantiateViewController(withIdentifier: "EmailSignUpViewController") as? EmailSignUpViewController else { return }
            targetVC = vc
            navigationController?.pushViewController(targetVC, animated: true)
        }

    }

    // MARK: - Bind ViewModel

    func bind(reactor viewModel: SignInViewModel) {
        
        kakaoLoginButton.rx.tap
            .map { .kakaoLoginButtonDidTap }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)
        
        appleLoginButton.rx.tap
            .map { .appleLoginButtonDidTap }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)
        
        emailLoginButton.rx.tap
            .map { .emailLoginButtonDidTap }
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