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
        print(#function)
    }

    // MARK: - Bind ViewModel

    func bind(reactor viewModel: SignInViewModel) {
        print("bind reactor")
        emailSignUpButton.rx.tap
            .debug("email button")
            .map{ Reactor.Action.tapSignInButton(.email) }
        .bind(to: viewModel.action)
        .disposed(by: disposeBag)
        
        
        viewModel.state
            .debug("viewmodel state")
            .filter { ($0.provider == .email )}
            .bind { [weak self] _ in
                let storyboard = UIStoryboard.init(name: "SignIn", bundle: nil)
                guard let vc = storyboard.instantiateViewController(withIdentifier: "EmailLoginViewController") as? EmailLoginViewController else { return }
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: self.disposeBag)
    }
}
