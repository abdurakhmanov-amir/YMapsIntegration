//
//  AddressModel.swift
//  YMapsIntergation
//
//  Created by Amir on 19.03.2025.
//

import YandexMapsMobile

class AddressModel {
    private(set) var title: String
    private(set) var address: String
    private(set) var geometry: YMKGeometry?
    
    init(_ suggestItem: YMKSuggestItem) {
        title = suggestItem.title.text
        address = suggestItem.subtitle?.text ?? ""
    }
    
    init(_ searchItem: YMKGeoObjectCollectionItem) {
        title = searchItem.obj?.name ?? ""
        address = searchItem.obj?.descriptionText ?? ""
        geometry = searchItem.obj?.geometry as? YMKGeometry
    }
}
