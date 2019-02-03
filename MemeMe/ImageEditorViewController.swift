//
//  ViewController.swift
//  MemeMe
//
//  Created by Davit Mirzoyan on 2/3/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

protocol ImageEditorInteracting {
}

final class ImageEditorViewController: UIViewController {

    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    private let isCameraAvailable = UIImagePickerController.isSourceTypeAvailable(.camera) ? true : false
    
    private var interactor: ImageEditorInteracting {
        return ImageEditorInteractor(router: ImageEditorRouter(display: self))
    }
    
    private var textAttributes: [NSAttributedString.Key: Any] {
        return [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.strokeWidth: 2,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraButton.isEnabled = isCameraAvailable
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        registerForKeyboardNotifications()
        
        applyStyle()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        resignFromKeyboardNotifications()
    }
    
    private func applyStyle() {
        applyTextFieldStyle()
    }
    
    private func applyTextFieldStyle() {
        topTextField.defaultTextAttributes = textAttributes
        bottomTextField.defaultTextAttributes = textAttributes
        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    func resignFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            bottomTextField.isFirstResponder,
            keyboardFrameIsChanged(userInfo)
        else { return }
        
        view.frame.origin.y -= keyboardSize.cgRectValue.height
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        guard
            let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            bottomTextField.isFirstResponder
        else { return }
        
        view.frame.origin.y += keyboardSize.cgRectValue.height
    }
    
    private func keyboardFrameIsChanged(_ keyboardInfo: [AnyHashable : Any]) -> Bool {
        let keyboardSizeAtStart = keyboardInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue
        let keyboardSizeAtEnd = keyboardInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        
        return keyboardSizeAtStart != keyboardSizeAtEnd
    }
    
    @IBAction func selectAnImageFromLibrary(_ sender: Any) {
        openImagePicker()
    }
    
    @IBAction func takeAPhoto(_ sender: Any) {
    }
    
    private func openImagePicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension ImageEditorViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
}
