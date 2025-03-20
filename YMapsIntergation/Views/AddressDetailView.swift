//
//  AddressDetailView.swift
//  YMapsIntergation
//
//  Created by Amir on 20.03.2025.
//

import UIKit

class AddressDetailView: UIViewController {
    let prefferedContentHeight = 200
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var panView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var addToFavouriteButton: UIButton!
    
    var selectedAddress: AddressModel!
    var addressManager = MapAddressManager()
    var storedAddresses: [AddressModel]!
    
    var closeHandler: (() -> Void)?
    var addToFavouriteHandler: (() -> Void)?
    
    
    init(_ selectedAddress: AddressModel) {
        self.selectedAddress = selectedAddress
        
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preferredContentSize = CGSize(width: Int(UIScreen.main.bounds.width), height: prefferedContentHeight)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        addToFavouriteButton.addTarget(self, action: #selector(addToFavouriteButtonTapped), for: .touchUpInside)
        
        guard let selectedAddress else {
            return
        }
        
        titleLabel.text = selectedAddress.title
        addressLabel.text = selectedAddress.address
        
        storedAddresses = addressManager.getAddresses()
    }
    
    
    func setDetailView(address: AddressModel) {
        titleLabel.text = address.title
        addressLabel.text = address.address
    }
    
    
    func setupButtons() {
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        addToFavouriteButton.addTarget(self, action: #selector(addToFavouriteButtonTapped), for: .touchUpInside)
    }
    
    
    @objc private func closeButtonTapped() {
        guard let closeHandler else {
            return
        }
        
        dismiss(animated: true)
        closeHandler()
    }
    
    
    @objc private func addToFavouriteButtonTapped() {
        addressManager.save(selectedAddress)
    }
}
