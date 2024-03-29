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
    
    @IBOutlet private weak var personalInfoAgreeLabel: UILabel!
    @IBOutlet private weak var personalInfoAgreeButton: UIButton!
    @IBOutlet private weak var personalInfoAgreeContent: UITextView!
    
    @IBOutlet private weak var locationAgreeLabel: UILabel!
    @IBOutlet private weak var locationAgreeButton: UIButton!
    @IBOutlet private weak var locationAgreeContent: UITextView!
    
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var navigationBackButton: UIButton!
    
    private var viewModel: TermsOfServiceViewModel = .init()
    private var termsIds: [String] = []
    private var disposeBag = DisposeBag()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(viewModel: viewModel)
        settingTextViewInset()
        settingNavigation()
    }

    private func settingNavigation() {
        self.navigationController?.navigationBar.isHidden = true
        let navi = navigationBackButton.rx.tap.asObservable()
        navi.bind { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
    }
    
    private func settingTextViewInset() {
        let edgeInsets = UIEdgeInsets(top: 16, left: 12, bottom: 16, right: 12)
        useAgreeContent.textContainerInset = edgeInsets
        locationAgreeContent.textContainerInset = edgeInsets
        personalInfoAgreeContent.textContainerInset = edgeInsets
    }
    
    private func bind(viewModel: TermsOfServiceViewModel) {
        let input = TermsOfServiceViewModel.Input(allAgree: allAgreeButton.rx.tap.asObservable(),
                                                  useAgree: useAgreeButton.rx.tap.asObservable(),
                                                  personalInfoAgree: personalInfoAgreeButton.rx.tap.asObservable(),
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
        
        output.personalInfoAgreeOutput.drive(onNext: {[weak self] isValid in
            let buttonImage = isValid ? UIImage(named: "checkbox") : UIImage(named: "checkbox_outline")
            self?.personalInfoAgreeButton.setImage(buttonImage, for: .normal)
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
                self?.termsIds.append(data.id)
            }
        }).disposed(by: disposeBag)
        
        output.locationContent.bind(onNext: { [weak self] data in
            DispatchQueue.main.async {
                self?.locationAgreeLabel.text = data.title
                self?.locationAgreeContent.text = data.content
                self?.termsIds.append(data.id)
            }
        }).disposed(by: disposeBag)
        
        output.personalInfoContent.bind(onNext: { [weak self] data in
            DispatchQueue.main.async {
                self?.personalInfoAgreeLabel.text = data.title
                self?.personalInfoAgreeContent.text = data.content
                self?.termsIds.append(data.id)
            }
        }).disposed(by: disposeBag)
        
        nextButton.rx.tap.bind { [weak self] _ in
            guard let self = self else { return }
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "EmailSignUpViewController") as? EmailSignUpViewController
            else { return }
            vc.termsIds = self.termsIds
            self.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)
    }
    
    
 
}
