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
    
    var closeHandler: (() -> Void)?
    var addToFavouriteHandler: (() -> Void)?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preferredContentSize = CGSize(width: Int(UIScreen.main.bounds.width), height: prefferedContentHeight)
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
        
        closeHandler()
    }
    
    
    @objc private func addToFavouriteButtonTapped() {
        guard let addToFavouriteHandler else {
            return
        }
        
        addToFavouriteHandler()
    }
}
