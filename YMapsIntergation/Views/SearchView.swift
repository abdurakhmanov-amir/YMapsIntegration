//
//  SearchView.swift
//  YMapsIntergation
//
//  Created by Amir on 18.03.2025.
//

import UIKit
import YandexMapsMobile

class SearchView: UIViewController {

    @IBOutlet var searchContainerView: UIView!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchContainerView.layer.borderWidth = 1
        searchContainerView.layer.borderColor = CGColor(red: 241.0/255.0, green: 241.0/255.0, blue: 241.0/255.0, alpha: 1.0)
        
//        var searchInstance = YMKSearch.sharedInstance()
    }
}
