//
//  UnderLineTextField.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/07/06.
//

import UIKit
import CoreData

public enum UnderLineType: String {
    case email = "이메일"
    case password = "비밀번호"
    case nickname = "닉네임"
    case authNumber = "인증번호"
}

public struct UnderLineData {
    public let type: UnderLineType
    public var filledState: Bool?
    
    public init(type: UnderLineType, filledState: Bool? = nil) {
        self.type = type
        self.filledState = filledState
    }
}

public protocol UnderLineTextFieldDelegate: AnyObject {
    func underLineDidChange(sender: UITextField)
}

public class UnderLineTextField: UIView {
    
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var textField: UITextField!
    @IBOutlet public weak var lineView: UIView!
    @IBOutlet public weak var errorLabel: UILabel!
    @IBOutlet public weak var iconImageView: UIImageView!
    public weak var delegate: UnderLineTextFieldDelegate?
        
    public var data: UnderLineData? {
        didSet {
            guard let data = data else { return }
            configure(infoData: data)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
        self.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadView()
    }
    
    convenience init(infoData: UnderLineData) {
        self.init(frame: .zero)
        configure(infoData: infoData)
    }

    private func loadView() {
//        guard let xibName = NSStringFromClass(self.classForCoder).components(separatedBy: ".").last,
//              let view = Bundle.module.loadNibNamed(xibName, owner: self, options: nil)?.first as? UIView else { return }
        let view = Bundle.main.loadNibNamed("UnderLineTextField", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
    
    private func loadViewFromNib(nib: String) -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nib, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    private func configure(infoData: UnderLineData) {
        let typeValue = infoData.type.rawValue
        switch infoData.type {
        case .email, .password:
            self.titleLabel.text = typeValue
            self.textField.placeholder = "\(typeValue) 입력"
        case .nickname:
            self.titleLabel.text = "닉네임"
            self.textField.placeholder = "도리를 찾아서"
        case .authNumber:
            self.titleLabel.text = "인증번호"
            self.textField.placeholder = "6자리 숫자"
        }
    }
    
    @objc func textFieldDidChange(sender: UITextField) {
        if sender.text?.isEmpty == false{
            lineView.backgroundColor = UIColor(red: 0.0, green: 195.0 / 255.0, blue: 98.0 / 255.0, alpha: 1.0)
            data?.filledState = true
        } else {
            lineView.backgroundColor = UIColor(red: 229.0 / 255.0, green: 230.0 / 255.0, blue: 233.0 / 255.0, alpha: 1.0)
            data?.filledState = false
        }
        delegate?.underLineDidChange(sender: sender)
    }
}
