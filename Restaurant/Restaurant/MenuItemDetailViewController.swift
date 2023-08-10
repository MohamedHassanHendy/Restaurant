//
//  MenuItemDetailViewController.swift
//  Restaurant
//
// 
//

import UIKit

protocol AddToOrderDelegate {
    func added(menuItem: MenuItem)
}

class MenuItemDetailViewController: UIViewController {
    // Since the detail screen will never be presented without a MenuItem object in place, you can define the property as an implicitly unwrapped optional
    var menuItem: MenuItem
    init?(coder: NSCoder, menuItem: MenuItem) {
            self.menuItem = menuItem
            super.init(coder: coder)
        }
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    var delegate: AddToOrderDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addToOrderButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        setupDelegate()
    }

    func updateUI(){
        titleLabel.text = menuItem.name
        priceLabel.text = menuItem.price.formatted(.currency(code: "usd"))
        descriptionLabel.text = menuItem.description
        
        addToOrderButton.layer.cornerRadius = 5.0 // making the button conner rounded
        
        MenuController.shared.fetchImage(url: menuItem.imageURL) { (image) in
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
    
    func setupDelegate(){
        if let navController = tabBarController?.viewControllers?.last as? UINavigationController{
            if let orderTableViewController = navController.viewControllers.first as? OrderTableViewController{
                delegate = orderTableViewController
            }
        }
        
    }
    
    @IBAction func orderButtonTapped(_ sender: UIButton) {
       
        UIView.animate(withDuration: 0.5, delay: 0,
               usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1,
               options: [], animations: {
                self.addToOrderButton.transform =
                   CGAffineTransform(scaleX: 2.0, y: 2.0)
                self.addToOrderButton.transform =
                   CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: nil)
        MenuController.shared.order.menuItems.append(menuItem)
        delegate?.added(menuItem: menuItem)
    }

}
