//
//  MenuTableViewController.swift
//  Restaurant
//
//  
//

import UIKit

class MenuTableViewController: UITableViewController {
    // Since this view controller will never be displayed without category data, we can make the property an implicitly unwrapped optional.
    let category: String
    let menuController = MenuController()
    var menuItems = [MenuItem]()
    init?(coder: NSCoder, category: String) {
            self.category = category
            super.init(coder: coder)
        }
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setting the title as the category name
        title = category.capitalized
        Task.init {
                    do {
                        let menuItems = try await
                           menuController.fetchMenuItems(forCategory: category)
                        updateUI(with: menuItems)
                    } catch {
                        displayError(error, title: "Failed to Fetch Menu Items for \(self.category)")
                    }
                }
    }
    
    func updateUI(with menuItems: [MenuItem]) {
            self.menuItems = menuItems
            self.tableView.reloadData()
        }
        func displayError(_ error: Error, title: String) {
            guard let _ = viewIfLoaded?.window else { return }
            let alert = UIAlertController(title: title, message:
               error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss",
               style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menuItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCellIdentifier", for: indexPath)
        let menuItem = menuItems[indexPath.row]
        cell.textLabel?.text = menuItem.name
        cell.detailTextLabel?.text = menuItem.price.formatted(.currency(code: "usd"))
        
        MenuController.shared.fetchImage(url: menuItem.imageURL) { (image) in
            guard let image = image else { return }
            DispatchQueue.main.async {
                
                // “For table view cells, you'll need to make an additional check. Recall that, in longer lists of data, cells will be recycled and reused as you scroll up and down the table. Since you don't want to put the wrong image into a recycled cell, check which index path the cell is now located. If it's changed, you can skip setting the image view.
                if let currentIndexPath = self.tableView.indexPath(for: cell), currentIndexPath != indexPath { return }
                cell.imageView?.image = image
            }
        }
        return cell
    }
    
    // Increasing the hight for cell
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    // MARK: - Navigation

    
    
    @IBSegueAction func showMenuItem(_ coder: NSCoder, sender: Any?) -> MenuItemDetailViewController? {
        guard let cell = sender as? UITableViewCell, let indexPath =
                tableView.indexPath(for: cell) else {
            return nil
        }
        let menuItem = menuItems[indexPath.row]
        return MenuItemDetailViewController(coder: coder, menuItem:menuItem)
    }
}
