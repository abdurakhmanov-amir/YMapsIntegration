//
//  MapView.swift
//  YMapsIntergation
//
//  Created by Amir on 16.03.2025.
//

import UIKit
import YandexMapsMobile

class MapView: UIViewController {
    
    lazy var mapView: YMKMapView = YMKMapView(frame: mapContainerView.bounds)

    @IBOutlet var mapContainerView: UIView!
    @IBOutlet var searchContainerView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapContainerView.addSubview(mapView)
        
        let position = YMKCameraPosition(target: YMKPoint(latitude: 41.319976, longitude: 69.239237), zoom: 12, azimuth: 0, tilt: 0)
        mapView.mapWindow.map.move(with: position)
        
        searchContainerView.layer.borderWidth = 1
        searchContainerView.layer.borderColor = CGColor(red: 241.0/255.0, green: 241.0/255.0, blue: 241.0/255.0, alpha: 1.0)
    }
}
