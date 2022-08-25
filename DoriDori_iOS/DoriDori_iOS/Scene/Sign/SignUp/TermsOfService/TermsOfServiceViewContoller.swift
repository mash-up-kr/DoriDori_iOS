//
//  TermsOfServiceViewContoller.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/07/21.
//

import UIKit
import RxSwift
import RxCocoa

final class TermsOfServiceViewContoller: UIViewController {
    
    @IBOutlet private weak var allAgreeButton: UIButton!
    @IBOutlet private weak var allAgreeOutLineView: UIView!
    
    @IBOutlet private weak var useAgreeLabel: UILabel!
    @IBOutlet private weak var useAgreeButton: UIButton!
    @IBOutlet private weak var useAgreeContent: UITextView!
    
    @IBOutlet private weak var locationAgreeLabel: UILabel!
    @IBOutlet private weak var locationAgreeButton: UIButton!
    @IBOutlet private weak var locationAgreeContent: UITextView!
    
    @IBOutlet private weak var nextButton: UIButton!
    
    private var viewModel: TermsOfServiceViewModel = .init()
    private var disposeBag = DisposeBag()
    private var agreeBool: Bool = false
    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(viewModel: viewModel)
        settingTextViewInset()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureSignUpNavigationBar()
    }
    
    private func settingTextViewInset() {
        let edgeInsets = UIEdgeInsets(top: 16, left: 12, bottom: 16, right: 12)
        useAgreeContent.textContainerInset = edgeInsets
        locationAgreeContent.textContainerInset = edgeInsets
    }
    
    private func bind(viewModel: TermsOfServiceViewModel) {
        let input = TermsOfServiceViewModel.Input(allAgree: allAgreeButton.rx.tap.asObservable(),
                                                  useAgree: useAgreeButton.rx.tap.asObservable(),
                                                  locationAgree: locationAgreeButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
        
        // Button
        output.allAgreeOutput.drive(onNext: { [weak self] isValid in
            self?.allAgreeOutLineView.ibBorderColor = isValid ? UIColor(named: "lime300") : UIColor(named: "gray700")
            let buttonImage = isValid ? UIImage(named: "checkbox") : UIImage(named: "checkbox_outline")
            self?.allAgreeButton.setImage(buttonImage, for: .normal)
        }).disposed(by: disposeBag)
        
        output.useAgreeOutput.drive(onNext: {[weak self] isValid in
            let buttonImage = isValid ? UIImage(named: "checkbox") : UIImage(named: "checkbox_outline")
            self?.useAgreeButton.setImage(buttonImage, for: .normal)
        }).disposed(by: disposeBag)
        
        output.locationAgreeOutput.drive(onNext: {[weak self] isValid in
            let buttonImage = isValid ? UIImage(named: "checkbox") : UIImage(named: "checkbox_outline")
            self?.locationAgreeButton.setImage(buttonImage, for: .normal)
        }).disposed(by: disposeBag)
        
        output.buttonOutput.bind(onNext: { [weak self] isValid in
            self?.nextButton.backgroundColor = isValid ? UIColor(named: "lime300") : UIColor(named: "gray700")
            let titleColor = isValid ? UIColor(named: "darkGray") : UIColor(named: "gray300")
            self?.nextButton.setTitleColor(titleColor, for: .normal)
            self?.nextButton.isEnabled = isValid
        }).disposed(by: disposeBag)
        
        //Content
        output.useContent.bind(onNext: { [weak self] data in
            DispatchQueue.main.async {
                self?.useAgreeLabel.text = data.title
                self?.useAgreeContent.text = data.content
            }
        }).disposed(by: disposeBag)
        
        output.locationContent.bind(onNext: { [weak self] data in
            DispatchQueue.main.async {
                self?.locationAgreeLabel.text = data.title
                self?.locationAgreeContent.text = data.content
            }
        }).disposed(by: disposeBag)
        
        nextButton.rx.tap.bind { [weak self] _ in
            guard let vc = self?.storyboard?.instantiateViewController(withIdentifier: "EmailSignUpViewController") as? EmailSignUpViewController
            else { return }
            self?.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)
    }
    
    
 
}
