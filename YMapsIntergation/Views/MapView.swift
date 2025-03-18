//
//  MapView.swift
//  YMapsIntergation
//
//  Created by Amir on 16.03.2025.
//

import UIKit
import YandexMapsMobile

class MapView: UIViewController, UIViewControllerTransitioningDelegate {
    
    lazy var mapView: YMKMapView = YMKMapView(frame: mapContainerView.bounds)

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
        return PanToDismissController(presentedViewController: presented, presenting: presenting)
    }
    
    
    @objc func showSearch() {
        let vc = SearchView()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        self.present(vc, animated: true)
    }

}
