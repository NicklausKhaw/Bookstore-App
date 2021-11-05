//
//  DetailViewController.swift
//  Bookstore App
//
//  Created by Nicklaus Khaw on 12/10/2021.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var barButton: UIBarButtonItem!
    
    var row: Int?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var books:[Book]?
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchBooks()
        print(books![row!].name!)
        
        let imageData = books![row!].picture!
        let imageBase64String = imageData.base64EncodedString()
         
        let newImageData = Data(base64Encoded: imageBase64String)
        if let newImageData = newImageData {
            imageView.image = UIImage(data: newImageData)
        }
        
        nameTextField.delegate = self
        authorTextField.delegate = self
        descriptionTextView.delegate = self
        
        nameTextField.text = books![row!].name!
        nameTextField.isUserInteractionEnabled = false
        authorTextField.text = books![row!].author!
        authorTextField.isUserInteractionEnabled = false
        descriptionTextView.text = books![row!].bookDescription!
        descriptionTextView.isUserInteractionEnabled = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    func fetchBooks(){
        do {
            self.books = try context.fetch(Book.fetchRequest())
        }
        catch {
            
        }
        
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
    
    @IBAction func barButtonPressed(_ sender: Any) {
        if barButton.title == "Edit" {
            editPressed()
        } else {
            if nameTextField.text == "" || authorTextField.text == "" || descriptionTextView.text == "" {
                let alert = UIAlertController(title: "Please enter all the details to continue", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default)
                
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
                
            } else {
                donePressed()
            }
        }
    }
    
    func editPressed() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(DetailViewController.imageTapped(gesture:)))
        imageView.addGestureRecognizer(tapGesture)
        
        imageView.isUserInteractionEnabled = true
        nameTextField.isUserInteractionEnabled = true
        authorTextField.isUserInteractionEnabled = true
        descriptionTextView.isUserInteractionEnabled = true
        
        barButton.title = "Done"
    }
    
    func donePressed() {
        
        let book = self.books![row!]
        let png = self.imageView.image?.pngData()
        
        book.picture = png
        book.name = nameTextField.text!
        book.author = authorTextField.text!
        book.bookDescription = descriptionTextView.text!
        
        do {
            try self.context.save()
        } catch {
            print(error.localizedDescription)
        }
        
        nameTextField.isUserInteractionEnabled = false
        authorTextField.isUserInteractionEnabled = false
        descriptionTextView.isUserInteractionEnabled = false
        imageView.isUserInteractionEnabled = false
        
        barButton.title = "Edit"
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        NotificationCenter.default.addObserver(self, selector: #selector(DetailViewController.updateTextView(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
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
}
