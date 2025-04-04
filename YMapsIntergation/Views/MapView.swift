//
//  MapView.swift
//  YMapsIntergation
//
//  Created by Amir on 16.03.2025.
//

import UIKit
import YandexMapsMobile

class MapView: UIViewController, UIViewControllerTransitioningDelegate {
    let defaultCameraPoint = YMKPoint(latitude: 41.319976, longitude: 69.239237)
    
    lazy var mapView: YMKMapView = YMKMapView(frame: mapContainerView.bounds)
    
    var selectedAddress: AddressModel?

    @IBOutlet var mapContainerView: UIView!
    @IBOutlet var searchContainerView: UIView!
    @IBOutlet var searchLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapContainerView.addSubview(mapView)
        
        let position = YMKCameraPosition(target: YMKPoint(latitude: 41.319976, longitude: 69.239237), zoom: 12, azimuth: 0, tilt: 0)
        mapView.mapWindow.map.move(with: position)
        
        searchContainerView.layer.borderWidth = 1
        searchContainerView.layer.borderColor = CGColor(red: 241.0/255.0, green: 241.0/255.0, blue: 241.0/255.0, alpha: 1.0)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showSearch))
        searchContainerView.addGestureRecognizer(tapGesture)
    }
    
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        if presented is SearchView {
            return PanToDismissController(presentedViewController: presented, presenting: presenting)
        }
        else {
            return SmallModalController(presentedViewController: presented, presenting: presenting)
        }
        
    }
    
    
    @objc private func showSearch() {
        
        let searchView = DependenciesProvider.ResolveView(SearchView.self)
        
        guard let searchView else {
            return
        }
        
        let currentGeometry = YMKVisibleRegionUtils.toPolygon(with: mapView.mapWindow.map.visibleRegion)
        searchView.currentGeometry = currentGeometry
        searchView.completionHandler = searchCompletionHandler
        searchView.modalPresentationStyle = .custom
        searchView.transitioningDelegate = self
        
        self.present(searchView, animated: true)
    }
    

    private func searchCompletionHandler(_ selectedAddress: AddressModel) {
        self.searchLabel.text = selectedAddress.title
        let cameraPoint = selectedAddress.geometry?.point ?? defaultCameraPoint
        let position = YMKCameraPosition(target: cameraPoint, zoom: 14, azimuth: 0, tilt: 0)
        mapView.mapWindow.map.move(with: position)
        
        let detailsView = DependenciesProvider.ResolveView(AddressDetailView.self)
        
        guard let detailsView else {
            return
        }
        
        detailsView.selectedAddress = selectedAddress
        detailsView.modalPresentationStyle = .custom
        detailsView.transitioningDelegate = self
        detailsView.closeHandler = closeDetailsHandler
        
        self.present(detailsView, animated: true)
    }
    
    private func closeDetailsHandler() {
        
    }
}
