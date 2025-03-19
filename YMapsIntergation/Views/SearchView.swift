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
    @IBOutlet weak var searchTextField: UITextField!
    
    var topRightMapPoint: YMKPoint!
    var bottomLeftMapPoint: YMKPoint!
    var currentGeometry: YMKGeometry!
    
    var suggestions: [AddressModel] = []
    var tableViewSource: SuggestionsTableViewSource!
    
    @Published var searchedText = ""
    
    var suggestSession: YMKSearchSuggestSession!
    var searchManager: YMKSearchManager!
    var searchSession: YMKSearchSession!
    
    var cancelables: [AnyCancellable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchContainerView.layer.borderWidth = 1
        searchContainerView.layer.borderColor = CGColor(red: 241.0/255.0, green: 241.0/255.0, blue: 241.0/255.0, alpha: 1.0)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableViewSource = SuggestionsTableViewSource(tableView, [])
        tableView.dataSource = tableViewSource
        tableView.reloadData()
        
        searchManager = YMKSearchFactory.instance().createSearchManager(with: .combined)
        suggestSession = searchManager.createSuggestSession()
        
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
    
    @objc func searchTextChanged(textField: UITextField) {
        self.searchedText = textField.text ?? ""
    }
    
    func search(_ searchText: String) {
        let suggestOptions = YMKSuggestOptions()
        
        searchSession = searchManager.submit(withText: searchText,
                             geometry: currentGeometry,
                             searchOptions: YMKSearchOptions(),
                             responseHandler: searchResponseHandler)
        
    }
    
    func searchResponseHandler(response: YMKSuggestResponse?, error: Error?) {
        if let error {
            print(error)
            
            return
        }
        
        if (response == nil || response?.items.count == 0) {
            return
        }
        
        self.tableViewSource.data = response!.items.map { suggestion in
            return AddressModel(suggestion)
        }
        
        self.tableView.reloadData()
    }
    
    func searchResponseHandler(response: YMKSearchResponse?, error: Error?) {
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
            return AddressModel(searchItem)
        }
        
        self.tableView.reloadData()
    }
}

class SuggestionsTableViewSource: NSObject, UITableViewDataSource {
    
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
