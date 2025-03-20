//
//  MapSearchManager.swift
//  YMapsIntergation
//
//  Created by Amir on 20.03.2025.
//

import Foundation
import YandexMapsMobile

class MapSearchManager: SearchManager {
    private let searchManager: YMKSearchManager
    private var searchSession: YMKSearchSession?
    private var completionSource: TaskCompletionSource<[AddressModel]>?
    
    var selectedAddress: AddressModel?
    
    init() {
        self.searchManager = YMKSearchFactory.instance().createSearchManager(with: .combined)
    }
    
    
    func search(_ searchText: String, _ currentGeometry: YMKGeometry) async -> [AddressModel] {
        DispatchQueue.main.async {
            self.searchSession = self.searchManager.submit(withText: searchText,
                                 geometry: currentGeometry,
                                 searchOptions: YMKSearchOptions(),
                                 responseHandler: self.searchResponseHandler)
        }
        
        if let completionSource = completionSource {
            completionSource.SetResult([])
        }
        
        completionSource = TaskCompletionSource()
        return await completionSource!.WaitForCompletion()
    }
    
    
    private func searchResponseHandler(response: YMKSearchResponse?, error: Error?) {
        guard let completionSource else {
            return
        }
        
        if let error {
            print(error)
            completionSource.SetResult([])
            
            return
        }
        
        guard let response = response else {
            completionSource.SetResult([])
            return
        }
        
        if (response.collection.children.count == 0) {
            completionSource.SetResult([])
            return
        }
        
        let searchItems = response.collection.children
        
        let addresses = searchItems.map { searchItem in
            let address = AddressModel(searchItem)
            
            return address
        }
        
        completionSource.SetResult(addresses)
    }
}
