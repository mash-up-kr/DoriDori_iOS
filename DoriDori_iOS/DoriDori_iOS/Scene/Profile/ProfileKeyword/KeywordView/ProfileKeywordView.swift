//
//  ProfileKeywordView.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/08/11.
//

import Foundation
import UIKit
import RxSwift

protocol ProfileKeywordViewDelegate: AnyObject {
    func removeKeyword(_ sender: ProfileKeywordView)
}

final class ProfileKeywordView: UIView {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet private weak var view: UIView!
    var tagName: String = ""
    
    weak var delegate: ProfileKeywordViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
        view.clipsToBounds = false
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadView()
    }
    
    private func loadView() {
        guard let view = Bundle.main.loadNibNamed("ProfileKeywordView",
                                       owner: self, options: nil)?.first as? UIView
                                        else { return }
        view.frame = bounds
        addSubview(view)
    }
    
    func configure(title: String) {
        self.titleLabel.text = title
        self.tagName = title
        
    }
        
    @IBAction func tapRemoveButton(_ sender: UIButton) {
        delegate?.removeKeyword(self)
    }
    
}
