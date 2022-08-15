//
//  EmailSignUpViewController.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/07/20.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

final class EmailSignUpViewController: UIViewController, StoryboardView {
    typealias Reactor = EmailSignUpViewModel
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var authNumberTextField: UITextField!
    
    private let repository: EmailCertificationRepository = .init()
    var disposeBag = DisposeBag()


    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        authNumberTextField.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureSignUpNavigationBar()
    }

    // MARK: - Bind ViewModel

    func bind(reactor viewModel: EmailSignUpViewModel) {

    }
    

    
    @IBAction func tapConfirmButton(_ sender: UIButton) {
        repository.requestEmail(email: "kji980926@gmail.com")
            .catch({ error in
                print(error) // TODO: 서버 에러
                return .empty()
            })
            .subscribe()
            .disposed(by: self.disposeBag)
            
//        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "PasswordInputViewController") as? PasswordInputViewController
//        else { return }
//        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension EmailSignUpViewController: UITextFieldDelegate {
    
}
