//
//  ProfileUploadViewController.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/08/09.
//

import UIKit
import Photos
import RSKImageCropper

class ProfileUploadViewController: UIViewController {
    
    @IBOutlet private weak var profileView: UIImageView!
    @IBOutlet private weak var imageUploadButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureSignUpNavigationBar()
    }
    
    private func openLibrary() {
        let pickerController = UIImagePickerController()
        pickerController.modalPresentationStyle = .fullScreen
        pickerController.sourceType = .photoLibrary
        pickerController.allowsEditing = false
        pickerController.delegate = self
        present(pickerController, animated: false)
    }
    
    private func requestPHPhotoLibraryAuthorization(completion: @escaping () -> Void) {
        if #available(iOS 14, *) {
            switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                    switch status {
                    case .authorized, .limited:
                        completion()
                        print("권한이 부여 됬습니다. 앨범 사용이 가능합니다")
                    case .denied:
                        print("권한이 거부 됬습니다. 앨범 사용 불가합니다.")
                    default:
                        print("그 밖의 권한이 부여 되었습니다.")
                    }
                }
            case .authorized: //모든 권한 허용
                completion()
            case .limited: //선택한 사진만 허용
                print("limited")
            case .denied: //거부
                print("denined")
            default:
                print("Unimplemented")
            }
        }
        else { //14이전
            switch PHPhotoLibrary.authorizationStatus() {
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({ (status) in
                    switch status {
                    case .authorized:
                        print("권한이 부여 됬습니다. 앨범 사용이 가능합니다")
                    case .denied:
                        print("권한이 거부 됬습니다. 앨범 사용 불가합니다.")
                    default:
                        print("그 밖의 권한이 부여 되었습니다.")
                    }
                })
            case .restricted:
                print("restricted")
            case .denied:
                print("denined")
            case .authorized:
                print("autorized")
            default:
                print("unKnown")
            }
            
        }
    }
    
   
    
    @IBAction func tapPhotoUpload(_ sender: UIButton) {
        self.requestPHPhotoLibraryAuthorization {
            self.openLibrary()
        }
    }
    
    
}

extension ProfileUploadViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    private func setCrop(image: UIImage) {
        print("setCrop")
        let imageCropVC = RSKImageCropViewController(image: image, cropMode: .circle)
        imageCropVC.moveAndScaleLabel.text = "사진을 잘라주세요."
        imageCropVC.cancelButton.setTitle("취소", for: .normal)
        imageCropVC.chooseButton.setTitle("선택", for: .normal)
        imageCropVC.delegate = self
        self.present(imageCropVC, animated: true)
    }
  
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.dismiss(animated: false, completion: nil)
            setCrop(image: image)
        }
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
}

extension ProfileUploadViewController: RSKImageCropViewControllerDelegate {


    func imageCropViewController(_ controller: RSKImageCropViewController,
                                 didCropImage croppedImage: UIImage,
                                 usingCropRect cropRect: CGRect,
                                 rotationAngle: CGFloat) {
        DispatchQueue.main.async {
            self.profileView.layer.cornerRadius = self.profileView.frame.width / 2
            self.profileView.clipsToBounds = true
            self.profileView.contentMode = .scaleAspectFill
            self.profileView.image = croppedImage
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        dismiss(animated: true, completion: nil)
    }

}


