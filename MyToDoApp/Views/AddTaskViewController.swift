import UIKit

class AddTaskViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!

    var userID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func saveTaskTapped(_ sender: UIButton) {
        guard let userID = userID,
              let name = nameTextField.text, !name.isEmpty,
              let description = descriptionTextField.text, !description.isEmpty else {
            // Show error if any field is empty
            self.showToast(message: "Please fill in all fields")
            return
        }

        let taskID = UUID().uuidString
        let task = ToDo(taskID: taskID, name: name, description: description, status: nil, createdBy: userID)
        DBManager.shared.addTask(userID: userID, task: task) { result in
            switch result {
            case .success:
                print("taskkkkk")
                self.dismiss(animated: true, completion: nil)
            case .failure(let error):
                self.showToast(message: "Failed to add task: \(error.localizedDescription)")
            }
        }
    }

    func showToast(message: String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
