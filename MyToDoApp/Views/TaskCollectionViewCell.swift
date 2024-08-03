import UIKit

class TaskCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var taskDescriptionLabel: UILabel!
    @IBOutlet weak var vImage: UIImageView!
    @IBOutlet weak var xImage: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    var task: ToDo!
    
    override func awakeFromNib() {
           super.awakeFromNib()
       }
       
       private func setupGestureRecognizers() {
           // Remove existing gesture recognizers to avoid duplicates
           //vImage.gestureRecognizers?.forEach { vImage.removeGestureRecognizer($0) }
          // xImage.gestureRecognizers?.forEach { xImage.removeGestureRecognizer($0) }
           
           let vImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(vImageTapped))
           vImage.isUserInteractionEnabled = true
           vImage.addGestureRecognizer(vImageTapGesture)
           
           let xImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(xImageTapped))
           xImage.isUserInteractionEnabled = true
           xImage.addGestureRecognizer(xImageTapGesture)
       }

       @objc private func vImageTapped() {
           updateTaskStatus(newStatus: 1)
       }
           
       @objc private func xImageTapped() {
           updateTaskStatus(newStatus: 0)
       }
       
       private func updateTaskStatus(newStatus: Int) {
           task.status = newStatus
           DBManager.shared.updateTask(task: task) { result in
               switch result {
               case .success:
                   print("Task updated successfully")
                   self.updateUI()
               case .failure(let error):
                   print("Failed to update task: \(error.localizedDescription)")
               }
           }
       }
       
       private func updateUI() {
           // Update status label based on task status
           switch task.status {
           case 1:
               statusLabel.text = "Done!"
               statusLabel.textColor = UIColor(red: 0, green: 0.7, blue: 0.2, alpha: 1)
               xImage.isHidden = true
               vImage.isHidden = true
           case 0:
               statusLabel.text = "Canceled!"
               statusLabel.textColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
               xImage.isHidden = true
               vImage.isHidden = true
           default:
               statusLabel.text = ""
               xImage.isHidden = false
               vImage.isHidden = false
           }
       }
       
       func configure(name: String, description: String, task: ToDo) {
           taskNameLabel.text = name
           taskDescriptionLabel.text = description + "\t"
           self.task = task
           setupGestureRecognizers()
           updateUI()

       }
   }
