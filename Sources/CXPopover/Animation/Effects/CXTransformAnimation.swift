//
//  File.swift
//  
//
//  Created by Cunqi Xiao on 5/22/24.
//

import UIKit

class CXTransformAnimation: CXBasePopoverAnimation {
    
    public override func setup(context: any UIViewControllerContextTransitioning, from fromVC: UIViewController, to toVC: UIViewController) {
        super.setup(context: context, from: fromVC, to: toVC)
        if isPresenting {
            toVC.view.transform = setupTransform(frame: context.finalFrame(for: toVC))
        } else {
            fromVC.view.transform = setupTransform(frame: context.finalFrame(for: fromVC))
        }
    }
    
    public override func update(context: any UIViewControllerContextTransitioning, from fromVC: UIViewController, to toVC: UIViewController) {
        if isPresenting {
            toVC.view.transform = updateTransform(frame: context.finalFrame(for: toVC))
        } else {
            fromVC.view.transform = updateTransform(frame: context.finalFrame(for: fromVC))
        }
    }
    
    func setupTransform(frame: CGRect) -> CGAffineTransform {
        .identity
    }
    
    func updateTransform(frame: CGRect) -> CGAffineTransform {
        .identity
    }
}
