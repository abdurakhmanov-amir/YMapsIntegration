//
//  ViewController.swift
//  YMapsIntergation
//
//  Created by Amir on 15.03.2025.
//

import UIKit

class ViewController: UIViewController, UIViewControllerTransitioningDelegate  {

    @IBOutlet var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.addTarget(self, action: #selector(click), for: .touchUpInside)
        
    }

    @objc func click() {
        let vc = ViewController3()
//        self.navigationController?.pushViewController(vc, animated: true)
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        self.present(vc, animated: true)
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PanToDismissController(presentedViewController: presented, presenting: presenting)
    }
}

