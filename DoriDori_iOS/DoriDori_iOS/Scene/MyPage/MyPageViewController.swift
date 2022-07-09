//
//  MyPageViewController.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/07/09.
//

import UIKit
import RxSwift
import RxCocoa

final class MyPageViewController: UIViewController {

    var disposeBag = DisposeBag()

    // MARK: - Life cycle
    
    init(myPageCoordinator: Coordinator) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemPink
    }

    // MARK: - Bind ViewModel

    func bind(viewModel: MyPageViewModel) {

    }
}
