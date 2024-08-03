import UIKit
import FirebaseAuth
import FirebaseStorage

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!

    override func viewDidLoad() {
           super.viewDidLoad()
           passwordTextField.isSecureTextEntry = true
           profileImageView.isUserInteractionEnabled = true
           let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectProfileImage))
           profileImageView.addGestureRecognizer(tapGesture)
        
            passwordTextField.delegate = self
            emailTextField.delegate = self
            passwordTextField.returnKeyType = .done
            emailTextField.returnKeyType = .done
       }

       @objc func selectProfileImage() {
           let imagePicker = UIImagePickerController()
           imagePicker.delegate = self
           imagePicker.sourceType = .photoLibrary
           present(imagePicker, animated: true, completion: nil)
       }

       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           if let selectedImage = info[.originalImage] as? UIImage {
               profileImageView.image = selectedImage
           }
           dismiss(animated: true, completion: nil)
       }

       func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           dismiss(animated: true, completion: nil)
       }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        guard let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text, let profileImage = profileImageView.image, !name.isEmpty, !email.isEmpty, !password.isEmpty else {
                    print("One or more text fields are empty")
                    self.showToast(message: "One or more text fields are empty")
                    return
                }

                DBManager.shared.registerUser(name: name, email: email, password: password) { result in
                    switch result {
                    case .success(let user):
                        self.uploadProfileImage(profileImage) { url in
                            if let url = url {
                                DBManager.shared.saveUserToDB(user: user, profileImageUrl: url) { result in
                                    switch result {
                                    case .success:
                                        print("Registration and image upload succeeded")
                                        self.dismiss(animated: true, completion: nil)
                                    case .failure(let error):
                                        print("Failed to save user data: \(error.localizedDescription)")
                                    }
                                }
                            }
                        }
                    case .failure(let error):
                        print("Registration failed: \(error.localizedDescription)")
                        self.handleAuthError(error)
                    }
                }
            }

            private func uploadProfileImage(_ image: UIImage, completion: @escaping (URL?) -> Void) {
                guard let imageData = image.jpegData(compressionQuality: 0.75) else {
                    completion(nil)
                    return
                }

                let storageRef = Storage.storage().reference().child("profile_images/\(UUID().uuidString).jpg")
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"

                storageRef.putData(imageData, metadata: metadata) { metadata, error in
                    if let error = error {
                        print("Failed to upload image: \(error.localizedDescription)")
                        completion(nil)
                        return
                    }

                    storageRef.downloadURL { url, error in
                        if let error = error {
                            print("Failed to retrieve download URL: \(error.localizedDescription)")
                            completion(nil)
                            return
                        }
                        completion(url)
                    }
                }
            }

            private func handleAuthError(_ error: Error) {
                if let authError = error as NSError? {
                    switch authError.code {
                    case AuthErrorCode.emailAlreadyInUse.rawValue:
                        self.showToast(message: "The email address is already in use")
                        print("The email address is already in use.")
                    case AuthErrorCode.invalidEmail.rawValue:
                        self.showToast(message: "The email address is badly formatted")
                        print("The email address is badly formatted.")
                    case AuthErrorCode.weakPassword.rawValue:
                        self.showToast(message: "The password must be at least 6 characters")
                        print("The password must be 6 characters long or more.")
                    default:
                        self.showToast(message: "Error")
                        print("Error: \(authError.localizedDescription)")
                    }
                }
            }
    
    @IBAction func alreadyHaveAccountTapped(_ sender: UIButton) {
        // Navigate back to the login screen
        print("Already have account tapped")
        self.dismiss(animated: true, completion: nil)
    }
    
    // UITextFieldDelegate method
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Dismiss the keyboard
        return true
    }
    
}
