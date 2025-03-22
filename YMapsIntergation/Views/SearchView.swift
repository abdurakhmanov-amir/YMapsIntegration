//
//  SearchView.swift
//  YMapsIntergation
//
//  Created by Amir on 18.03.2025.
//

import UIKit
import Combine
import YandexMapsMobile

class SearchView: UIViewController, ObservableObject {

    @IBOutlet var searchContainerView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchTextField: UITextField!
    
    var currentGeometry: YMKGeometry!
    var completionHandler: ((AddressModel) -> Void)!
    
    private var tableViewSource: SuggestionsTableViewSource!
    
    @Published private var searchedText = ""
    
    private var cancelables: [AnyCancellable] = []
    
    private var mapSearchManager: SearchManager
    
    
    init(_ searchManager: SearchManager) {
        self.mapSearchManager = searchManager
        
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchContainerView.layer.borderWidth = 1
        searchContainerView.layer.borderColor = CGColor(red: 241.0/255.0, green: 241.0/255.0, blue: 241.0/255.0, alpha: 1.0)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableViewSource = SuggestionsTableViewSource(tableView, [])
        tableView.dataSource = tableViewSource
        tableView.reloadData()
        
        searchTextField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
        
        $searchedText
            .debounce(for: .seconds(3), scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink {value in
                
                if (value.count == 0) {
                    return
                }
                
                Task {
                    let addresses = await self.mapSearchManager.search(value, self.currentGeometry)
                    for address in addresses {
                        address.selectedHandler = self.searchItemSelected
                    }
                    self.tableViewSource.data = addresses
                    self.tableView.reloadData()
                }
            }
            .store(in: &cancelables)
    }
    
    
    @objc private func searchTextChanged(textField: UITextField) {
        self.searchedText = textField.text ?? ""
    }

    
    private func searchItemSelected(_ selectedAddress: AddressModel) {
        mapSearchManager.selectedAddress = selectedAddress
        completionHandler(selectedAddress)
        dismiss(animated: true)
    }
}


fileprivate class SuggestionsTableViewSource: NSObject, UITableViewDataSource {
    
    var data: [AddressModel]
    
    init(_ tableView: UITableView, _ data: [AddressModel]) {
        tableView.register(UINib(nibName: SearchSuggestionCell.Identifier, bundle: nil), forCellReuseIdentifier: SearchSuggestionCell.Identifier)
        self.data = data
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchSuggestionCell.Identifier, for: indexPath) as! SearchSuggestionCell
        
        cell.prepare()
        cell.setModel(data[indexPath.row])
        
        return cell
    }
}
