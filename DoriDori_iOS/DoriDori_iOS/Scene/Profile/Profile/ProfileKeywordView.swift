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
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var view: UIView!
    
    public weak var delegate: ProfileKeywordViewDelegate?
    
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
