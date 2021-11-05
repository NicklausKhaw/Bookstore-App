//
//  CreateViewController.swift
//  Bookstore App
//
//  Created by Nicklaus Khaw on 06/10/2021.
//

import UIKit
import CoreData

class CreateViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var imagePicker = UIImagePickerController()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var books:[Book]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CreateViewController.imageTapped(gesture:)))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        
        nameTextField.delegate = self
        authorTextField.delegate = self
        descriptionTextView.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        if (gesture.view as? UIImageView) != nil{
            print("Image Tapped")
            
            let vc = UIImagePickerController()
            vc.sourceType = .photoLibrary
            vc.delegate = self
            vc.allowsEditing = true
            present(vc, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            imageView.image = image
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        NotificationCenter.default.addObserver(self, selector: #selector(CreateViewController.updateTextView(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        NotificationCenter.default.addObserver(self, selector: #selector(CreateViewController.updateTextView(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func updateTextView(notification: Notification) {
        print(notification)
        if let userInfo = notification.userInfo {
            let keyboardFrameScreenCoordinates = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
                
            let keyboardFrame = self.view.convert(keyboardFrameScreenCoordinates, to: view.window)
                
            if notification.name == UIResponder.keyboardWillHideNotification {
                view.frame.origin.y = 0
            } else if notification.name == UIResponder.keyboardWillChangeFrameNotification {
                view.frame.origin.y = -keyboardFrame.height + 50
            }
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        if nameTextField.text == "" || authorTextField.text == "" || descriptionTextView.text == "" {
            let alert = UIAlertController(title: "Please enter all the details to continue", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
        } else {
            
            let png = self.imageView.image?.pngData()
            let newBook = Book(context: self.context)
            
            newBook.picture = png
            newBook.name = nameTextField.text!
            newBook.author = authorTextField.text!
            newBook.bookDescription = descriptionTextView.text!
            newBook.date = Date()
            
            do {
                try self.context.save()
            } catch {
                print(error.localizedDescription)
            }

            _ = navigationController?.popViewController(animated: true)
        }
    }
}
