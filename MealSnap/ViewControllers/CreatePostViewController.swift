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
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    func styleInput(view: UIView) {
        view.layer.borderWidth = 0.3
        view.layer.cornerRadius = 7
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor.gray.cgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleInput(view: descriptionTextView)
        styleInput(view: titleInput)
        descriptionTextView.layer.borderColor = UIColor.gray.cgColor
        self.openImagePicker()
    }
    
    private func onPostSuccessful() {
        DispatchQueue.main.async {
            guard let userGalleryVC = self.storyboard?.instantiateViewController(identifier: StoryboardId.GalleryViewController.rawValue) else {
                self.showError(message: "Unable to navigate to user gallery")
                return
            }
            self.navigationController?.pushViewController(userGalleryVC, animated: true)
        }
    }
    
    @IBAction func handleSave() {
        print("Trying to save")
        self.closeErrorMessage()
        guard let targetImage = imagePreviewImageView.image else{
            self.showError(message: "Please select an image")
            return
        }
        guard titleInput.text?.count != 0 else {
            self.showError(message: "Title is required")
            return
        }
        guard descriptionTextView.text.count != 0 else {
            self.showError(message: "Description is required")
            return
        }
        guard let imageData = targetImage.jpegData(compressionQuality: 1) else {
            showError(message: "Something went wrong")
            print("Unable to convert image to Data")
            return
        }
        UserGallery.AddImage(title: titleInput.text!, description: descriptionTextView.text!, imageData: imageData) { result in
            switch (result){
            case .success(let galleryImage):
                print(galleryImage)
                self.onPostSuccessful()
                return
            case .failure(let error):
                switch(error){
                case .APIError(let message):
                    self.showError(message: message)
                    return
                }
            }
        }
    }
    
    func showError(message: String) -> Void {
        DispatchQueue.main.async {
            print("Showing error message")
            self.errorMessageLabel.text = message
            self.errorMessageLabel.isHidden = false
        }
    }
    
    func closeErrorMessage() -> Void {
        DispatchQueue.main.async {
            if self.errorMessageLabel.isHidden == false {
                self.errorMessageLabel.isHidden = true
            }
        }
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
