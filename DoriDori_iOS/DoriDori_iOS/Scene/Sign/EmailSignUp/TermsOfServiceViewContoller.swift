//
//  TermsOfServiceViewContoller.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/07/21.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

final class TermsOfServiceViewContoller: UIViewController, StoryboardView {
    typealias Reactor = TermsOfServiceViewModel
    
    @IBOutlet private weak var allAgreeButton: UIButton!
    @IBOutlet private weak var firstAgreeButton: UIButton!
    @IBOutlet private weak var secondAgreeButton: UIButton!
    @IBOutlet private weak var finalAgreeButton: UIButton!
    
    var disposeBag = DisposeBag()

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Bind ViewModel

    func bind(reactor viewModel: TermsOfServiceViewModel) {

    }
}
