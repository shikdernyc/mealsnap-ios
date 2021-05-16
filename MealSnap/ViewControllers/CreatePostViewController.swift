//
//  CreatePostViewController.swift
//  MealSnap
//
//  Created by Asif Shikder on 4/7/21.
//

import UIKit

private enum LayoutTableViewCell {
    case Title
    case Description
    case PreviewImage
}

private class LayoutTableViewUtil {
    private let tableView: UITableView
    
    static let CellId : [LayoutTableViewCell: String] = [
        .Title: "CreatePostTitleInput",
        .Description: "CreatePostDescriptionTextField",
        .PreviewImage: "CreatePostPreviewImageView"
    ]

    static func DequeueCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: LayoutTableViewUtil.CellId[.Title]!, for: indexPath)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: LayoutTableViewUtil.CellId[.Description]!, for: indexPath)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: LayoutTableViewUtil.CellId[.PreviewImage]!, for: indexPath)
            return cell
        }
    }
    
    init(tableView: UITableView) {
        self.tableView = tableView
    }
    
    func titleCell() -> CreatePostTitleTextInputCell {
        return self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! CreatePostTitleTextInputCell
    }
    
    func descriptionCell() -> CreatePostDescriptionTextViewCell {
        return self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! CreatePostDescriptionTextViewCell
    }
    
    func imagePreviewCell() -> CreatePostImageViewCell {
        return self.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! CreatePostImageViewCell
    }
}

class CreatePostViewController: UIViewController {
    @IBOutlet weak var layoutTableView: UITableView!
    private var layoutUtil : LayoutTableViewUtil!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUtil = LayoutTableViewUtil(tableView: layoutTableView)
        layoutTableView.delegate = self
        layoutTableView.dataSource = self
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
        let titleCell = layoutUtil.titleCell()
        let descriptionCell = layoutUtil.descriptionCell()
        let imageCell = layoutUtil.imagePreviewCell()
        guard let targetImage = imageCell.image() else{
            self.showError(message: "Please select an image")
            return
        }
        guard titleCell.inputValue().count != 0 else {
            self.showError(message: "Title is required")
            return
        }
        guard descriptionCell.inputValue().count != 0 else {
            self.showError(message: "Description is required")
            return
        }
        guard let imageData = targetImage.jpegData(compressionQuality: 1) else {
            showError(message: "Something went wrong")
            print("Unable to convert image to Data")
            return
        }
        UserGallery.AddImage(title: titleCell.inputValue(), description: descriptionCell.inputValue(), imageData: imageData) { result in
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
        AlertComponent.showError(on: self, message: message)
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

extension CreatePostViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension CreatePostViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return LayoutTableViewUtil.DequeueCell(tableView: tableView, indexPath: indexPath)
    }
}

extension CreatePostViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            self.cancelUpload()
            return
        }
        layoutUtil.imagePreviewCell().setImage(to: image)
        return
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        self.cancelUpload()
    }
}
