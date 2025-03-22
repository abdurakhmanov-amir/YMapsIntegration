//
//  FavouriteAddressesView.swift
//  YMapsIntergation
//
//  Created by Amir on 20.03.2025.
//

import UIKit

class FavouriteAddressesView: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    private var tableViewSource: FavouriteTableViewSource!
    var addressManager: AddressManager
    
    init(_ addressManager: AddressManager) {
        self.addressManager = addressManager
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewSource = FavouriteTableViewSource(tableView, [])
        tableView.dataSource = tableViewSource
        tableView.reloadData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableViewSource.data = addressManager.getAddresses()
        tableView.reloadData()
    }
}

fileprivate class FavouriteTableViewSource: NSObject, UITableViewDataSource {
    
    var data: [AddressModel]
    
    init(_ tableView: UITableView, _ data: [AddressModel]) {
        tableView.register(UINib(nibName: FavouriteAddressCell.Identifier, bundle: nil), forCellReuseIdentifier: FavouriteAddressCell.Identifier)
        self.data = data
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteAddressCell.Identifier, for: indexPath) as! FavouriteAddressCell
        
        cell.setModel(data[indexPath.row])
        
        return cell
    }
}
