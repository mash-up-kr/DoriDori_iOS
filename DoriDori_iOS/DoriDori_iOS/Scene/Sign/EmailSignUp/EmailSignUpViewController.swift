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
    

    var disposeBag = DisposeBag()

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Bind ViewModel

    func bind(reactor viewModel: EmailSignUpViewModel) {

    }
}
