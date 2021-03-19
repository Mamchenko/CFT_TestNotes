//
//  CreateNoteViewController.swift
//  CFT_test_zametki
//
//  Created by Anatoliy Mamchenko on 18.03.2021.
//

import UIKit
import SnapKit

class CreateNoteViewController: UIViewController {
    
    let database = Database()
        
    let titleTextfield: UITextField = {
        let label = UITextField()
        label.placeholder = "заголовок:"
        label.backgroundColor = .placeholderText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let noteTextfield: UITextField = {
        let label = UITextField()
        label.placeholder = "заметка:"
        label.backgroundColor = .placeholderText
        label.layer.cornerRadius = 10
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let imageViewer: UIImageView = {
        let view = UIImageView ()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        view.sizeToFit()
        return view
    }()
    
    let takePictureButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.borderWidth = 0.3
        button.backgroundColor = .systemOrange
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.black.cgColor
        button.setTitle("добавить фото", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let saveNoteButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.backgroundColor = .systemOrange
        button.layer.borderWidth = 0.3
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.black.cgColor
        button.setTitle("сохранить заметки", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureConstraints()
    }
    
    // MARK: ConfigureUI 
    func configureUI () {
        view.backgroundColor = .systemYellow
        [titleTextfield, noteTextfield, imageViewer, takePictureButton, saveNoteButton].forEach({view.addSubview($0)})
        [titleTextfield, noteTextfield].forEach({$0.becomeFirstResponder()})
        titleTextfield.delegate = self
        noteTextfield.delegate = self
    }
       
    // MARK: ConfigureConstraints
    func configureConstraints () {
        imageViewer.snp.makeConstraints { (make) in
            make.leading.equalTo(self.view.snp.leading).offset(32)
            make.trailing.equalTo(self.view.snp.trailing).offset(-32)
            make.top.equalTo(self.view.snp.top).offset(96)
            make.height.equalTo(self.view).multipliedBy(0.3)
        }
        
        takePictureButton.snp.makeConstraints { (make) in
            make.leading.equalTo(self.view.snp.leading).offset(48)
            make.trailing.equalTo(self.view.snp.trailing).offset(-48)
            make.top.equalTo(imageViewer.snp.bottom).offset(8)
            make.height.equalTo(self.view).multipliedBy(0.1)
        }
        
        titleTextfield.snp.makeConstraints { (make) in
            make.leading.equalTo(self.view.snp.leading).offset(48)
            make.trailing.equalTo(self.view.snp.trailing).offset(-48)
            make.top.equalTo(takePictureButton.snp.bottom).offset(16)
            make.height.equalTo(self.view).multipliedBy(0.03)
        }
        
        noteTextfield.snp.makeConstraints { (make) in
            make.leading.equalTo(self.view.snp.leading).offset(48)
            make.trailing.equalTo(self.view.snp.trailing).offset(-48)
            make.top.equalTo(titleTextfield.snp.bottom).offset(16)
            make.height.equalTo(self.view).multipliedBy(0.03)
        }
        
        saveNoteButton.snp.makeConstraints { (make) in
            make.leading.equalTo(self.view.snp.leading).offset(48)
            make.trailing.equalTo(self.view.snp.trailing).offset(-48)
            make.top.equalTo(noteTextfield.snp.bottom).offset(16)
            make.height.equalTo(self.view).multipliedBy(0.1)
        }
        
        takePictureButton.addTarget(self, action: #selector(takePictureByPickerViewController), for: .touchUpInside)
        saveNoteButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
    }
    
    // MARK: Create Button Action
    @objc func takePictureByPickerViewController () {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    
    @objc func saveButtonAction ()  {
        database.createObject(imageData: imageViewer.image?.pngData(), tittle: titleTextfield.text ?? " ", note: noteTextfield.text ?? " ")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        titleTextfield.text = ""
        noteTextfield.text = ""
        imageViewer.image = nil
        navigationController?.popViewController(animated: true)
        
    }
}
// MARK: UITextfield Delegate
extension CreateNoteViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        noteTextfield.resignFirstResponder()
        titleTextfield.resignFirstResponder()
        return true 
    }
}

// MARK: UIImagePickerControllerDelegate
extension CreateNoteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        guard let photo = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        imageViewer.image = photo
    }
}


