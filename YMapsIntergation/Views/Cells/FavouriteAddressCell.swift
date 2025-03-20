//
//  FavouriteAddressCell.swift
//  YMapsIntergation
//
//  Created by Amir on 20.03.2025.
//

import UIKit

class FavouriteAddressCell: UITableViewCell {
    static let Identifier = "FavouriteAddressCell"
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    
    var address: AddressModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setModel(_ address: AddressModel) {
        self.address = address
        
        titleLabel.text = address.title
        addressLabel.text = address.address
    }
}
