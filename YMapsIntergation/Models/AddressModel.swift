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
    
    var selectedHandler: ((AddressModel) -> Void)?
    
    init(_ suggestItem: YMKSuggestItem) {
        title = suggestItem.title.text
        address = suggestItem.subtitle?.text ?? ""
    }
    
    
    init(_ searchItem: YMKGeoObjectCollectionItem) {
        title = searchItem.obj?.name ?? ""
        address = searchItem.obj?.descriptionText ?? ""
        geometry = searchItem.obj?.geometry as? YMKGeometry
    }
    
    init(_ title: String, _ address: String, _ longitude: Double, _ latitude: Double) {
        self.title = title
        self.address = address
        self.geometry = YMKGeometry(point: YMKPoint(latitude: latitude, longitude: longitude))
    }
    
    
    func itemSelected() {
        guard let selectedHandler else {
            return
        }
        
        selectedHandler(self)
    }
}
