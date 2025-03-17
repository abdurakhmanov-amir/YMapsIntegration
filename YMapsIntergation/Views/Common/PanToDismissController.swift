//
//  PanToDismissController.swift
//  YMapsIntergation
//
//  Created by Amir on 18.03.2025.
//

import UIKit

class PanToDismissController: UIPresentationController {
    var dimmingView: UIView!
    var panView: UIView!
    
    private var originalY: CGFloat = 0
    
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        setupDimmingView()
        setupPan()
    }
    
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let container = containerView else { return super.frameOfPresentedViewInContainerView }
        let width = container.bounds.size.width
        let height : CGFloat = container.bounds.size.height - 56

        return CGRect(x: 0, y: container.bounds.size.height - height, width: width, height: height)
    }
    
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    
    override func presentationTransitionWillBegin() {
        guard let dimmingView = dimmingView else { return }

        containerView?.addSubview(dimmingView)
        presentedView?.addSubview(panView)
        
        dimmingView.topAnchor.constraint(equalTo: containerView!.topAnchor).isActive = true
        dimmingView.bottomAnchor.constraint(equalTo: containerView!.bottomAnchor).isActive = true
        dimmingView.leadingAnchor.constraint(equalTo: containerView!.leadingAnchor).isActive = true
        dimmingView.trailingAnchor.constraint(equalTo: containerView!.trailingAnchor).isActive = true
        
        panView.leadingAnchor.constraint(equalTo: presentedView!.leadingAnchor).isActive = true
        panView.trailingAnchor.constraint(equalTo: presentedView!.trailingAnchor).isActive = true
        panView.topAnchor.constraint(equalTo: presentedView!.topAnchor).isActive = true
        panView.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        let viewPan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
        panView?.addGestureRecognizer(viewPan)
        
        presentedView?.clipsToBounds = true
        presentedView?.layer.cornerRadius = 16

        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 1.0
            return
        }

        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1.0
        })
    }
    
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 0.0
            return
        }

        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        })
    }
    
    
    private func setBackToOriginalPosition() {
        presentedViewController.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
            self.presentedViewController.view.frame.origin.y = self.originalY
            self.presentedViewController.view.layoutIfNeeded()
        }, completion: nil)
    }

    
    private func moveAndDismissPresentedView() {
        presentedViewController.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
            self.presentedViewController.view.frame.origin.y = self.presentedViewController.view.frame.height
            self.presentedViewController.view.layoutIfNeeded()
        }, completion: { _ in
            self.presentingViewController.dismiss(animated: true, completion: nil)
        })
     }

    
    func setupDimmingView() {
        dimmingView = UIView()
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        dimmingView.alpha = 0.0

        let recognizer = UITapGestureRecognizer(target: self,
                                      action: #selector(handleTap(recognizer:)))
        dimmingView.addGestureRecognizer(recognizer)
    }
    
    
    func setupPan() {
        panView = UIView()
        panView.translatesAutoresizingMaskIntoConstraints = false
        panView.backgroundColor = UIColor.green
        panView.alpha = 1
    }
    

   @objc func handleTap(recognizer: UITapGestureRecognizer) {
       presentingViewController.dismiss(animated: true)
   }
    
    
    @objc private func viewPanned(_ sender: UIPanGestureRecognizer) {
        let translate = sender.translation(in: self.presentedView)
        
        switch sender.state {
            case .began:
                originalY = presentedViewController.view.frame.origin.y
            case .changed:
                if originalY + translate.y > 0 {
                    presentedViewController.view.frame.origin.y = originalY + translate.y
                }
            case .ended:
                let presentedViewHeight = presentedViewController.view.frame.height
                let newY = presentedViewController.view.frame.origin.y

                if newY < presentedViewHeight * 0.25 {
                    setBackToOriginalPosition()
                } else {
                    moveAndDismissPresentedView()
                }
            default:
                break
        }
    }
}
