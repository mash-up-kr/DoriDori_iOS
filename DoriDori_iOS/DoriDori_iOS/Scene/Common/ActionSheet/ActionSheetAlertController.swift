//
//  ActionSheetAlertController.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/17.
//
import UIKit

struct ActionSheetAction {
    let title: String
    let action: ((UIAlertAction) -> Void)?
    
    init(
        title: String,
        action: ((UIAlertAction) -> Void)?) {
        self.title = title
        self.action = action
    }
}

final class ActionSheetAlertController {
    
    private let title: String?
    private let message: String?
    private let actionModels: [ActionSheetAction]
    private let neededCancel: Bool
    private let tintColor: UIColor
    
    init(
        title: String? = nil,
        message: String? = nil,
        actionModels: ActionSheetAction...,
        neededCancel: Bool = true,
        tintColor: UIColor = .lime300
    ) {
        self.title = title
        self.message = message
        self.actionModels = actionModels
        self.neededCancel = neededCancel
        self.tintColor = tintColor
    }
    
    func configure() -> UIAlertController {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .actionSheet
        )
        self.actionModels.forEach { actionModel in
            alertController.addAction(
                UIAlertAction(
                    title: actionModel.title,
                    style: .default,
                    handler: actionModel.action
                )
            )
        }
        if self.neededCancel {
            alertController.addAction(UIAlertAction(title: "취소", style: .cancel))
        }
        alertController.view.tintColor = self.tintColor
        return alertController
    }
}
