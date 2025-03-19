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
    
    private var currentGeometry: YMKGeometry
    private var completionHandler: (AddressModel) -> Void
    
    private var suggestions: [AddressModel] = []
    private var tableViewSource: SuggestionsTableViewSource!
    
    @Published private var searchedText = ""
    
    private var searchManager: YMKSearchManager!
    private var searchSession: YMKSearchSession!
    
    private var cancelables: [AnyCancellable] = []
    
    
    init(_ currentGeometry: YMKGeometry,  _ completionHanler: @escaping (AddressModel) -> Void) {
        self.currentGeometry = currentGeometry
        self.completionHandler = completionHanler
        
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        self.currentGeometry = YMKGeometry()
        self.completionHandler = {address in }
        
        super.init(coder: coder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchContainerView.layer.borderWidth = 1
        searchContainerView.layer.borderColor = CGColor(red: 241.0/255.0, green: 241.0/255.0, blue: 241.0/255.0, alpha: 1.0)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableViewSource = SuggestionsTableViewSource(tableView, [])
        tableView.dataSource = tableViewSource
        tableView.reloadData()
        
        searchManager = YMKSearchFactory.instance().createSearchManager(with: .combined)
        
        searchTextField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
        
        $searchedText
            .debounce(for: .seconds(3), scheduler: DispatchQueue.main)
            .sink {value in
                
                if (value.count == 0) {
                    return
                }
                
                self.search(value)
            }
            .store(in: &cancelables)
    }
    
    
    @objc private func searchTextChanged(textField: UITextField) {
        self.searchedText = textField.text ?? ""
    }
    
    
    private func search(_ searchText: String) {
        searchSession = searchManager.submit(withText: searchText,
                             geometry: currentGeometry,
                             searchOptions: YMKSearchOptions(),
                             responseHandler: searchResponseHandler)
        
    }

    
    private func searchResponseHandler(response: YMKSearchResponse?, error: Error?) {
        if let error {
            print(error)
            
            return
        }
        
        guard let response = response else {
            return
        }
        
        if (response.collection.children.count == 0) {
            return
        }
        
        let searchItems = response.collection.children
        
        self.tableViewSource.data = searchItems.map { searchItem in
            let address = AddressModel(searchItem)
            address.selectedHandler = searchItemSelected
            
            return address
        }
        
        self.tableView.reloadData()
    }
    
    
    private func searchItemSelected(_ selectedAddress: AddressModel) {
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
