//
//  ErrorView.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/08/21.
//

import UIKit

final class ErrorView: UIView {
    
    @IBOutlet private weak var mainTitleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var refreshButton: UIButton!

    private var refresh: () -> Void
    
    init(refresh: @escaping () -> Void) {
        self .refresh = refresh
        super.init(frame: .zero)
        loadView()
        refreshButton.layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func loadView() {
        guard let view = Bundle.main.loadNibNamed("ErrorView", owner: self, options: nil)?.first as? UIView else { return }
        view.frame = bounds
        addSubview(view)
    }
    
    func configureRefresh(refresh: @escaping () -> Void) {
        self .refresh = refresh
    }
    
    @IBAction func tappedRefreshButton(_ sender: UIButton) {
        refresh()
    }
    
}
