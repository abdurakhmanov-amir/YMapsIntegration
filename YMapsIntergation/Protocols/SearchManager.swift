//
//  SearchManager.swift
//  YMapsIntergation
//
//  Created by Amir on 20.03.2025.
//

import Foundation
import YandexMapsMobile

protocol SearchManager {
    var selectedAddress: AddressModel? {get set}
    
    func search(_ searchText: String, _ currentGeometry: YMKGeometry) async -> [AddressModel]
}
