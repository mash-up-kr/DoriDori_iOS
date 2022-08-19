//
//  UnderLineTextField.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/07/06.
//

import UIKit
import RxSwift
import RxCocoa

class UnderLineTextField: DesignView {
    
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var textField: UITextField!
    @IBOutlet public weak var underLineView: UIView!
    @IBOutlet public weak var errorLabel: UILabel!
    @IBOutlet public weak var iconImageView: UIImageView!
    
    //글자수 카운트
    @IBOutlet weak var stringCountStackView: UIStackView!
    @IBOutlet weak var nowStringCountLabel: UILabel!
    @IBOutlet weak var totalStringCountLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    var viewModel = UnderLineTextFieldViewModel() {
        didSet {
            configure(viewModel: viewModel)
            bind(viewModel: viewModel)
        }
    }

    override func loaded() {
        super.loaded()
    }
    
    private func bind(viewModel: UnderLineTextFieldViewModel) {
            
        let input = UnderLineTextFieldViewModel.Input(
            inputString: textField.rx.text.orEmpty.filter({ !$0.isEmpty })
                                        .distinctUntilChanged()
                                        .asObservable()
        )
        
        let output = viewModel.transform(input: input)
        let outputValidObservable = output.inputIsValid.asObservable().share()
        let changeObservable = textField.rx.controlEvent([.editingDidBegin, .editingChanged]).asObservable()

        changeObservable.bind(onNext: { [weak self] _ in
            self?.underLineView.backgroundColor = UIColor(named: "lime300")
            self?.textField.tintColor = UIColor(named: "lime300")
            self?.iconImageView.isHidden = true
            self?.errorLabel.isHidden = true
        }).disposed(by: disposeBag)
        
        let editingEndObservable = textField.rx.controlEvent([.editingDidEnd]).asObservable()
    
        editingEndObservable.flatMap { [weak self] _ -> Observable<Bool> in
            self?.underLineView.backgroundColor = UIColor(named: "gray800")
            self?.iconImageView.isHidden = true
            return outputValidObservable
        }.bind(onNext: { [weak self] isValid in
            self?.iconImageView.isHidden = isValid
            self?.errorLabel.isHidden = isValid
            if isValid {
                self?.underLineView.backgroundColor = UIColor(named: "lime300")
                self?.textField.tintColor = UIColor(named: "lime300")
            }
            else {
                self?.underLineView.backgroundColor = .red
                self?.textField.tintColor = .red
                self?.iconImageView.image = UIImage(named: "error")
            }
        }).disposed(by: disposeBag)

    }

    
    func configure(viewModel: UnderLineTextFieldViewModel) {
        titleLabel.text = viewModel.titleLabelType.rawValue
        errorLabel.text = viewModel.errorMessage.rawValue
        textField.textContentType = viewModel.inputContentType
        textField.returnKeyType = viewModel.returnKeyType
        textField.isSecureTextEntry = viewModel.isSecureTextEntry
        textField.keyboardType = viewModel.keyboardType
        textField.placeholder = viewModel.inputPlaceHolder.rawValue
        stringCountStackView.isHidden = viewModel.stringCountIsHidden
        totalStringCountLabel.text = "\(viewModel.totalStringCount)"
    }
    
}

