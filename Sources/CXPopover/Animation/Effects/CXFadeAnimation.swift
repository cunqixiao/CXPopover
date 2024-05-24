//
//  CXFadeAnimation.swift
//  CXPopover
//
//  Created by Cunqi Xiao on 5/22/24.
//

import UIKit

class CXFadeAnimation: CXBasePopoverAnimation {
    
    // MARK: - Override methods
    
    public override func setup(context: any UIViewControllerContextTransitioning, from fromVC: UIViewController, to toVC: UIViewController) {
        super.setup(context: context, from: fromVC, to: toVC)
        if isPresenting {
            toVC.view.alpha = 0
        }
    }
    
    public override func update(context: any UIViewControllerContextTransitioning, from fromVC: UIViewController, to toVC: UIViewController) {
        if isPresenting {
            toVC.view.alpha = 1
        } else {
            fromVC.view.alpha = 0
        }
    }
}
