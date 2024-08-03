import UIKit
import FirebaseStorage
import SideMenu

class ToDoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!

    var user: User?
    var tasks: [ToDo] = []
    var menu: SideMenuNavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        print("ToDoViewController loaded")
        
        setupSideMenu()
        fetchTasks()
    }
    
   func setupSideMenu() {
       let storyboard = UIStoryboard(name: "Main", bundle: nil)
       let menuVC = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
       menuVC.user = user
       menu = SideMenuNavigationController(rootViewController: menuVC)
       menu?.leftSide = true
       SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view)
       SideMenuManager.default.leftMenuNavigationController = menu
   }
    
    @IBAction func menuTapped(_ sender: UIBarButtonItem) {
          present(menu!, animated: true, completion: nil)
      }

    private func fetchTasks() {
        guard let user = user else { return }
        DBManager.shared.getTasks(userID: user.userID) { result in
            switch result {
            case .success(let tasks):
                self.tasks = tasks
                self.collectionView.reloadData()
            case .failure(let error):
                print("Failed to fetch tasks: \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func addTaskTapped(_ sender: UIButton) {
        print("Add task button tapped")
        let alert = UIAlertController(title: "Add New Task", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Task Name"
        }
        alert.addTextField { textField in
            textField.placeholder = "Task Description"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
        guard let self = self,
              let taskName = alert.textFields?[0].text, !taskName.isEmpty,
              let taskDescription = alert.textFields?[1].text, !taskDescription.isEmpty,
              let user = self.user else {
            print("Invalid input or user not set")
            return
        }
        
        let taskID = UUID().uuidString
        let newTask = ToDo(taskID: taskID, name: taskName, description: taskDescription, status: -1, createdBy: user.userID)
        
        DBManager.shared.addTask(userID: user.userID, task: newTask) { result in
            switch result {
                case .success:
                    print("Task added successfully")
                    self.fetchTasks()
                case .failure(let error):
                    print("Failed to add task: \(error.localizedDescription)")
                }
            }
        }
            
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    @IBAction func deleteTask(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: point) else { return }
        
        let task = tasks[indexPath.row]
        
        DBManager.shared.deleteTask(userID: task.createdBy, taskID: task.taskID) { result in
            switch result {
            case .success:
                self.tasks.remove(at: indexPath.row)
                self.collectionView.deleteItems(at: [indexPath])
                print("Task deleted successfully")
            case .failure(let error):
                print("Failed to delete task: \(error.localizedDescription)")
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasks.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaskCell", for: indexPath) as! TaskCollectionViewCell
        let task = tasks[indexPath.row]
        print("task: \(task.name) , \(task.description)")
        cell.configure(name: task.name, description: task.description, task: task)
        return cell
    }

}
