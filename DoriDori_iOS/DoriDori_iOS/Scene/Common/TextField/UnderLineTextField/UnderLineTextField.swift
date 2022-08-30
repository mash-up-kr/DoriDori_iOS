//
//  UnderLineTextField.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/07/06.
//

import UIKit
import RxSwift
import RxCocoa

protocol UnderLineTextFieldDelegate: AnyObject {
    func addKeyword(_ keyword: String)
}

class UnderLineTextField: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var underLineView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    //글자수 카운트
    @IBOutlet weak var stringCountStackView: UIStackView!
    @IBOutlet weak var nowStringCountLabel: UILabel!
    @IBOutlet weak var totalStringCountLabel: UILabel!
    
    //인증번호
    @IBOutlet weak var authNumbertimerLabel: UILabel!
    @IBOutlet weak var authNumberResendStackView: UIStackView!
    @IBOutlet weak var authNumberResendButton: UIButton!
    
    weak var delegate: UnderLineTextFieldDelegate?
    private let disposeBag = DisposeBag()
    var viewModel = UnderLineTextFieldViewModel() {
        didSet {
            configure(viewModel: viewModel)
            bind()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadView()
        textField.delegate = self
    }
    
    private func loadView() {
        guard let view = Bundle.main.loadNibNamed("UnderLineTextField",
                                                  owner: self, options: nil)?.first as? UIView
        else { return }
        view.frame = bounds
        addSubview(view)
    }
    
    private func bind() {
        textField.rx.controlEvent([.editingDidBegin, .editingChanged])
            .asObservable()
            .bind(onNext: { [weak self] _ in
                self?.underLineView.backgroundColor = UIColor(named: "lime300")
                self?.errorLabel.text = ""
                self?.iconImageView.image = UIImage()
            }).disposed(by: disposeBag)
        
        textField.rx.controlEvent(.editingDidEnd)
            .asObservable()
            .bind(onNext: { [weak self] _ in
                self?.underLineView.backgroundColor = UIColor(named: "gray800")
            }).disposed(by: disposeBag)
        
    }
    
    private func configure(viewModel: UnderLineTextFieldViewModel) {
        if viewModel.titleLabelType != .profile && viewModel.titleLabelType != .profileKeyword {
            titleLabel.text = viewModel.titleLabelType.rawValue
        }
//        errorLabel.text = viewModel.errorMessage.rawValue
        textField.textContentType = viewModel.inputContentType
        textField.returnKeyType = viewModel.returnKeyType
        textField.isSecureTextEntry = viewModel.isSecureTextEntry
        textField.keyboardType = viewModel.keyboardType
        textField.placeholder = viewModel.inputPlaceHolder.rawValue
        stringCountStackView.isHidden = viewModel.stringCountIsHidden
        totalStringCountLabel.text = "\(viewModel.totalStringCount)"
        authNumbertimerLabel.isHidden = viewModel.authNumberTimer
        authNumberResendStackView.isHidden = viewModel.authNumberResend
    }
    
}

extension UnderLineTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           guard let textFieldText = textField.text,
                 let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                       return false
               }
        let changeText = textFieldText.replacingCharacters(in: rangeOfTextToReplace, with: string)
        let totalCount = self.viewModel.totalStringCount
        if changeText.count <= totalCount {
            self.nowStringCountLabel.text = String(changeText.count)
        }
        if !self.viewModel.stringCountIsHidden {
            return changeText.count <= totalCount
        } else {
            return true
        }
       }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.viewModel.titleLabelType == .profileKeyword {
            guard let keyword = textField.text else { return false }
            if !keyword.isEmpty {
                delegate?.addKeyword(keyword)
                textField.text = ""
                nowStringCountLabel.text = "0"
            }
        }
        return true
    }
}
