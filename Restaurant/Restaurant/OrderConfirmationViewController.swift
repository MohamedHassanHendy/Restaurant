//
//  OrderConfirmationViewController.swift
//  Restaurant
//
//  
//

import UIKit


class OrderConfirmationViewController: UIViewController {
    
    @IBOutlet weak var timeRemainingLabel: UILabel!
    var minutesToPrepare: Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        timeRemainingLabel.text = "Thank you for your order! your wait time is approximately \(minutesToPrepare!) minutes."
    }



}
