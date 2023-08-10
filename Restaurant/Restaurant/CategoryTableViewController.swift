//
//  CategoryTableViewController.swift
//  Restaurant
//
//

import UIKit
import UserNotifications

class CategoryTableViewController: UITableViewController {
    
    let menuController = MenuController()
    var categories = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        Task.init {
                    do {
                        let categories = try await
                           menuController.fetchCategories()
                        updateUI(with: categories)
                    } catch {
                        displayError(error,title: "Failed to Fetch Categories")
                    }
                }
            }
            func updateUI(with categories: [String]) {
                self.categories = categories
                self.tableView.reloadData()
            }
            func displayError(_ error: Error, title: String) {
                guard let _ = viewIfLoaded?.window else { return }
                let alert = UIAlertController(title: title, message:
                   error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss",
                   style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                guard let _ = viewIfLoaded?.window else { return }
            }
    //  Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
            return 1
            }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCellIdentifier", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].capitalized

        return cell
        
    }
func configureCell(_ cell: UITableViewCell, forCategoryAt indexPath:IndexPath) {
    let category = categories[indexPath.row]
    var content = cell.defaultContentConfiguration()
    content.text = category.capitalized
    cell.contentConfiguration = content
}
    
   // MARK: - Navigation

    
    @IBSegueAction func showMenu(_ coder: NSCoder, sender: Any?) -> MenuTableViewController? {
        guard let cell = sender as? UITableViewCell, let indexPath =
               tableView.indexPath(for: cell) else {
                return nil
            }
            let category = categories[indexPath.row]
            return MenuTableViewController(coder: coder, category:category)
        }
    // Notification Implimentation
    /// Checking if The app Got a user permission for Notification
    func initNotificationSetupCheck() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert])
        { (success, error) in
            if success {
                print("Permission Granted")
            } else {
                print("There was a problem!")
            }
        }
    }
 

}
