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
    @IBOutlet var locationImageView: UIImageView!
    
    func setModel(_ model: AddressModel) {
        self.model = model
        
        titleLabel.text = self.model.title
        addressLabel.text = self.model.address
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(itemSelected))
        contentView.addGestureRecognizer(tapRecognizer)
    }
    
    
    func prepare() {
        locationImageView.image = UIImage(named: "location-filled")?.withRenderingMode(.alwaysTemplate)
        locationImageView.tintColor = UIColor(red: 241.0/255.0, green: 241.0/255.0, blue: 241.0/255.0, alpha: 1.0)
    }
    
    
    @objc private func itemSelected() {
        model.itemSelected()
    }
}
