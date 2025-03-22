//
//  SmallModelController.swift
//  YMapsIntergation
//
//  Created by Amir on 20.03.2025.
//

import UIKit

class SmallModalController: UIPresentationController {
    private let panViewHeight: CGFloat = 26
    
    private var panView: UIView!
    private var slashView: UIView!
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        setupPan()
        setupSlashView()
    }
    
    override var shouldPresentInFullscreen: Bool {
        return false
    }
    

    override var frameOfPresentedViewInContainerView: CGRect {
        let size = containerView?.frame.size ?? presentingViewController.view.frame.size

        return CGRect(origin: .zero, size: size)
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()

        guard let containerView else { return }
        guard let presentedView else { return }

        let containerSize = containerView.bounds.size
        let preferredSize = presentedViewController.preferredContentSize
        containerView.frame = CGRect(x: 0, y: containerSize.height - preferredSize.height,
                                     width: containerSize.width, height: preferredSize.height)
        presentedView.frame = containerView.frame
        
        presentedView.addSubview(panView)
        
        panView.leadingAnchor.constraint(equalTo: presentedView.leadingAnchor).isActive = true
        panView.trailingAnchor.constraint(equalTo: presentedView.trailingAnchor).isActive = true
        panView.topAnchor.constraint(equalTo: presentedView.topAnchor).isActive = true
        panView.heightAnchor.constraint(equalToConstant: panViewHeight).isActive = true
        
        panView.addSubview(slashView)
        
        slashView.translatesAutoresizingMaskIntoConstraints = false
        slashView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        slashView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        slashView.topAnchor.constraint(equalTo: panView.topAnchor, constant: 8).isActive = true
        slashView.centerXAnchor.constraint(equalTo: panView.centerXAnchor).isActive = true
        
        presentedView.clipsToBounds = true
        presentedView.layer.cornerRadius = 16
    }
    
    
    func setupPan() {
        panView = UIView()
        panView.translatesAutoresizingMaskIntoConstraints = false
        panView.backgroundColor = UIColor.white
    }
    
    
    func setupSlashView() {
        slashView = UIView()
        slashView.backgroundColor = UIColor(red: 208.0/255.0, green: 207.0/255.0, blue: 207.0/255.0, alpha: 1.0)
        slashView.layer.cornerRadius = 2
    }
}
