//
//  AddressManager.swift
//  YMapsIntergation
//
//  Created by Amir on 20.03.2025.
//

import Foundation

protocol AddressManager {
    func save(_ address: AddressModel)
    
    func getAddresses() -> [AddressModel]
    
    func delete(_ address: AddressModel)
}
