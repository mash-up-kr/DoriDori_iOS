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

final class EmailCertificationViewController: UIViewController, StoryboardView {
    typealias Reactor = EmailCertificationViewModel
    

    var disposeBag = DisposeBag()

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSignUpNavigationBar()
    }

    // MARK: - Bind ViewModel

    func bind(reactor viewModel: EmailCertificationViewModel) {

    }
    

    
    @IBAction func tapConfirmButton(_ sender: UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "PasswordInputViewController") as? PasswordInputViewController
        else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
