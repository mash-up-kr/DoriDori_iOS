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

public class UnderLineTextField: UIView {
    
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var textField: UITextField!
    @IBOutlet public weak var lineView: UIView!
    @IBOutlet public weak var errorLabel: UILabel!
    @IBOutlet public weak var iconImageView: UIImageView!
    
    public let boolSubject: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    private let disposeBag = DisposeBag()
    
    public var data: TextFieldData? {
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
    
    convenience init(infoData: TextFieldData) {
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
    
    private func configure(infoData: TextFieldData) {
        let typeValue = infoData.type.rawValue
        switch infoData.type {
        case .email:
            self.titleLabel.text = typeValue
            self.textField.placeholder = "\(typeValue) 입력"
            self.textField.keyboardType = .emailAddress
        case .password:
            self.titleLabel.text = typeValue
            self.textField.placeholder = "\(typeValue) 입력"
            self.textField.isSecureTextEntry = true
        case .nickname:
            self.titleLabel.text = "닉네임"
            self.textField.placeholder = "도리를 찾아서"
        case .authNumber:
            self.titleLabel.text = "인증번호"
            self.textField.placeholder = "6자리 숫자"
        }
    }
    
    //MARK: - RxBinding
    public func rxBind() {
        rxBindInput()
        rxBindOutput()
    }
    
    private func rxBindInput() {
        guard let stringSubject = data?.stringSubject else { return }
        textField.rx.text.orEmpty
            .bind(to: stringSubject)
            .disposed(by: disposeBag)
        
        stringSubject
            .map {
                switch self.data?.type{
                case .email: return self.emailValidateCheck($0)
                case .password: return self.passwordValidateCheck($0)
                default: return false
                }
            }
            .bind(to: boolSubject)
            .disposed(by: disposeBag)
    }
    
    private func rxBindOutput() {
        boolSubject.subscribe(onNext: { check in
            if check {
                self.lineView.backgroundColor = UIColor(named: "lime300")
            }
        }).disposed(by: disposeBag)
    }
}

//MARK: - type validation
extension UnderLineTextField {
    func emailValidateCheck(_ value: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: value)
    }
            
    func passwordValidateCheck(_ value: String) -> Bool {
        let passwordreg = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{6,20}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", passwordreg)
        return predicate.evaluate(with: value)
    }
}
