//
//  CreatePostViewController.swift
//  MealSnap
//
//  Created by Asif Shikder on 4/7/21.
//

import UIKit

class CreatePostViewController: UIViewController {
    
    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var imagePreviewImageView: UIImageView!
    
    func styleInput(view: UIView) {
        view.layer.borderWidth = 0.3
        view.layer.cornerRadius = 7
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor.gray.cgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        descriptionTextView
        styleInput(view: descriptionTextView)
        styleInput(view: titleInput)
        descriptionTextView.layer.borderColor = UIColor.gray.cgColor
        self.openImagePicker()
    }
    
    @IBAction func handleSave() {
        print("Trying to save")
        let imageData = imagePreviewImageView.image?.jpegData(compressionQuality: 1)?.base64EncodedString()
    }
    
    func openImagePicker() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.sourceType = .camera
        }else{
            picker.sourceType = .photoLibrary
        }
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func cancelUpload() {
        self.navigationController?.popViewController(animated: true)
    }

}

extension CreatePostViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            self.cancelUpload()
            return
        }
        imagePreviewImageView.image = image
        imagePreviewImageView.contentMode = .scaleAspectFill
        imagePreviewImageView.layer.cornerRadius = 7
        return
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        self.cancelUpload()
    }
}
