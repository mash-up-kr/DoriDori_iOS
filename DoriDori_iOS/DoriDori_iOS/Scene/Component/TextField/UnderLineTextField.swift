//
//  UnderLineTextField.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/07/06.
//

import UIKit
import CoreData
import RxSwift
import RxCocoa


public protocol UnderLineTextFieldDelegate: AnyObject {
    func underLineDidChange(sender: UITextField)
    func underLineDidEnd(sender: UITextField)
}

public class UnderLineTextField: UIView {
    
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var textField: UITextField!
    @IBOutlet public weak var lineView: UIView!
    @IBOutlet public weak var errorLabel: UILabel!
    @IBOutlet public weak var iconImageView: UIImageView!
    public weak var delegate: UnderLineTextFieldDelegate?
    
    private let disposeBag = DisposeBag()

    public var data: UnderLineData? {
        didSet {
            guard let data = data else { return }
            configure(infoData: data)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
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
        case .email:
            self.titleLabel.text = typeValue
            self.textField.placeholder = "\(typeValue) 입력"
            self.textField.addTarget(self, action: #selector(emailFieldDidChange), for: .editingChanged)
//            self.textField.addTarget(self, action: #selector(emailFieldDidEnd), for: .editingDidEnd)
        case .password:
            self.titleLabel.text = typeValue
            self.textField.placeholder = "\(typeValue) 입력"
            self.textField.addTarget(self, action: #selector(passwordFieldDidChange), for: .editingChanged)
        case .nickname:
            self.titleLabel.text = "닉네임"
            self.textField.placeholder = "도리를 찾아서"
        case .authNumber:
            self.titleLabel.text = "인증번호"
            self.textField.placeholder = "6자리 숫자"
        }
    }
    
    @objc func emailFieldDidChange(sender: UITextField) {
        if sender.text?.validateEmail() == true { // 이메일 유효되면
            lineView.backgroundColor = UIColor(named: "lime300")
            data?.validState = true
        } else { // 비어있으면
            lineView.backgroundColor = UIColor(named: "gray800")
            data?.validState = false
        }
        delegate?.underLineDidChange(sender: sender)
    }
    
    @objc func emailFieldDidEnd(sender: UITextField) {
        if sender.text?.validateEmail() == false {
            lineView.backgroundColor = UIColor(named: "red500")
            data?.validState = false
        }
        delegate?.underLineDidEnd(sender: sender)
    }
    
    @objc func passwordFieldDidChange(sender: UITextField) {
        if sender.text?.validatePassword() == true {
            lineView.backgroundColor = UIColor(named: "lime300")
            data?.validState = true
        } else { // 비어있으면
            lineView.backgroundColor = UIColor(named: "gray800")
            data?.validState = false
        }
        delegate?.underLineDidChange(sender: sender)
    }
}

extension String {
    func validateEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: self)
    }
    func validatePassword() -> Bool {
        let passwordreg =  ("(?=.*[A-Za-z])(?=.*[0-9]).{6,20}")
        let passwordtesting = NSPredicate(format: "SELF MATCHES %@", passwordreg)
        return passwordtesting.evaluate(with: self)
    }
}

