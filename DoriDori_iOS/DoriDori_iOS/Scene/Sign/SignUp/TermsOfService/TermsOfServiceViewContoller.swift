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
    
    @IBOutlet private weak var finalAgreeButton: UIButton!
    
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
        output.useContent.bind(onNext: { [weak self] data in
            DispatchQueue.main.async {
                self?.useAgreeLabel.text = data.title
                self?.useAgreeContent.text = data.content
            }
        }).disposed(by: disposeBag)

        output.locationContent.bind(onNext: { [weak self] data in
            print(data.content)
            DispatchQueue.main.async {
                self?.locationAgreeLabel.text = data.title
                self?.locationAgreeContent.text = data.content
            }
            
        }).disposed(by: disposeBag)
        
//            let output = viewModel.transform(input: input)
//        output.isValidButton.bind { [weak self] isValid in
//            //Setting allAgree
//            self?.allAgreeButton.isSelected = isValid
//            let buttonImage = isValid ? UIImage(named: "checkbox") : UIImage(named: "checkbox_outline")
//            let toogleColor = isValid ? UIColor(named: "lime300") : UIColor(named: "gray800")
//            let buttonTitleColor = isValid ? UIColor(named: "darkGray") : UIColor(named: "gray300")
//            self?.allAgreeButton.setImage(buttonImage, for: .selected)
//            self?.allAgreeOutLineView.ibBorderColor = toogleColor
//            //Setting finalAgree
//            self?.finalAgreeButton.isEnabled = isValid
//            self?.finalAgreeButton.backgroundColor = toogleColor
//            self?.finalAgreeButton.setTitleColor(buttonTitleColor, for: .normal)
//            //Setting Other
//            self?.compulsoryAgreeButton.setImage(buttonImage, for: .normal)
//            self?.currentLocationAgreeButton.setImage(buttonImage, for: .normal)
//        }.disposed(by: disposeBag)
    }

    
    
    @IBAction func tapConfirmButton(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "Profile", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "NicknameSettingViewController") as? NicknameSettingViewController
        else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    

    
}
