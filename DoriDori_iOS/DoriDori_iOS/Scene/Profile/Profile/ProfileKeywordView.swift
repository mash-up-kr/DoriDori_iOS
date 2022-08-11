//
//  ProfileKeywordView.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/08/11.
//

import Foundation
import UIKit

protocol ProfileKeywordViewDelegate: AnyObject {
    func removeKeyword(_ sender: ProfileKeywordView)
}

class ProfileKeywordView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    public weak var delegate: ProfileKeywordViewDelegate?
    
    var index: Int = 0
    
    override init(frame: CGRect) {
            super.init(frame: frame)
            loadView()
        }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadView()
    }
    
    private func loadView() {
        let view = Bundle.main.loadNibNamed("ProfileKeywordView",
                                       owner: self,
                                       options: nil)?.first as! UIView
        view.frame = bounds
        addSubview(view)
    }
    
    func configure(title: String) {
        self.titleLabel.text = title
    }
        
    
    @IBAction func tapRemoveButton(_ sender: UIButton) {
        delegate?.removeKeyword(self)
        print("remove")
    }
    
}
