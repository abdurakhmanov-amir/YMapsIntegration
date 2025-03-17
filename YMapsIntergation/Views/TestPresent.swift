//
//  TestPresent.swift
//  YMapsIntergation
//
//  Created by Amir on 17.03.2025.
//

import UIKit

class TestPresent: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        var frame: CGRect = .zero
        frame.size = size(forChildContentContainer: presentedViewController,
                          withParentContainerSize: containerView!.bounds.size)
        
        frame.origin.y = containerView!.frame.height*(1.0/3.0)
        
        return frame
    }
}
