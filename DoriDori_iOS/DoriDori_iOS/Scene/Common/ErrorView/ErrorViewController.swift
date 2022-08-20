//
//  ErrorViewController.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/08/21.
//

import UIKit

final class ErrorViewController: UIViewController {

    @IBOutlet private weak var errorView: ErrorView!
    private let refresh: () -> Void
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorView.configureRefresh { [weak self] in
            self?.refresh()
        }
    }
    
    init(refresh: @escaping () -> Void) {
        self .refresh = refresh
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
