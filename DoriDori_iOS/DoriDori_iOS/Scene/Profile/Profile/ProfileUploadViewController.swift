//
//  ProfileUploadViewController.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/08/09.
//

import UIKit

class ProfileUploadViewController: UIViewController {

    @IBOutlet private weak var profileView: UIImageView!
    @IBOutlet private weak var uploadPictureButton: UIButton!
    private let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureSignUpNavigationBar()
    }
    
    private func openLibrary() {
        imagePicker.modalPresentationStyle = .fullScreen
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: false)
    }
    
    @IBAction func tapPhotoUpload(_ sender: UIButton) {
        openLibrary()
    }
    
}

extension ProfileUploadViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileView.layer.cornerRadius = profileView.frame.height / 2
            profileView.contentMode = .scaleToFill
            profileView.image = image
        }
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
}
