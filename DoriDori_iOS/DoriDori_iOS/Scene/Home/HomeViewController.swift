//
//  HomeViewController.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/07/09.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController {

    // MARK: - Variable
    var disposeBag = DisposeBag()
    
    // MARK: - UIView
    let homeHeaderView: HomeHeaderView = HomeHeaderView()
    

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(homeHeaderView)
        homeHeaderView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(44)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(300)
        }
    }

    // MARK: - Bind ViewModel

    func bind(viewModel: HomeViewModel) {

    }
}
