//
//  UnderLineTextFieldDirector.swift
//  DoriDori_iOS
//
//  Created by Julia on 2022/11/19.
//

import Foundation

class UnderLineTextFieldDirector {
    func createEmailViewModel() -> UnderLineTextFieldViewModel {
        let viewModel = UnderLineTextFieldViewModel()
        viewModel.setUpTitleType(.email)
        viewModel.setUpInputType(.emailAddress)
        viewModel.setUpKeyboardType(.emailAddress)
        return viewModel
    }
    
    func createAuthNumberViewModel() -> UnderLineTextFieldViewModel {
        let viewModel = UnderLineTextFieldViewModel()
        viewModel.setUpTitleType(.authNumber)
        viewModel.setUpInputType(.oneTimeCode)
        viewModel.setUpKeyboardType(.numberPad)
        return viewModel
    }
    
    func createPasswordViewModel() -> UnderLineTextFieldViewModel {
        let viewModel = UnderLineTextFieldViewModel()
        viewModel.setUpTitleType(.password)
        viewModel.setUpInputType(.password)
        return viewModel
    }
    
    func createPasswordConfirmViewModel() -> UnderLineTextFieldViewModel {
        let viewModel = UnderLineTextFieldViewModel()
        viewModel.setUpTitleType(.passwordConfirm)
        viewModel.setUpInputType(.password)
        return viewModel
    }
    
    func createNicknameViewModel() -> UnderLineTextFieldViewModel {
        let viewModel = UnderLineTextFieldViewModel()
        viewModel.setUpTitleType(.nickname)
        viewModel.setUpInputType(.nickname)
        return viewModel
    }
    
    func createProfileViewModel() -> UnderLineTextFieldViewModel {
        let viewModel = UnderLineTextFieldViewModel()
        viewModel.setUpTitleType(.profile)
        return viewModel
    }
    
    func createKeywordViewModel() -> UnderLineTextFieldViewModel {
        let viewModel = UnderLineTextFieldViewModel()
        viewModel.setUpTitleType(.profileKeyword)
        return viewModel
    }
}
