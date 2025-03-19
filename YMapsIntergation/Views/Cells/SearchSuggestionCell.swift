//
//  SearchSuggestionCell.swift
//  YMapsIntergation
//
//  Created by Amir on 19.03.2025.
//

import UIKit

class SearchSuggestionCell: UITableViewCell {
    
    static let Identifier = "SearchSuggestionCell"
    
    private var model: AddressModel!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    
    func setModel(_ model: AddressModel) {
        self.model = model
        
        titleLabel.text = self.model.title
        addressLabel.text = self.model.address
    }
    
    func prepare() {
        
    }
}
