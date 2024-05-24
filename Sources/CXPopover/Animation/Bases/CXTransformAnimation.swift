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
            let transform = setupTransform(frame: context.finalFrame(for: toVC))
            print("Transform: \(toVC.view.transform) Before toVC: \(toVC.view.frame)")
            toVC.view.transform = .identity
            print("Transform: \(toVC.view.transform) Mid toVC: \(toVC.view.frame)")
            toVC.view.transform = transform
            print("Transform: \(toVC.view.transform) After toVC: \(toVC.view.frame)")
        } else {
            fromVC.view.transform = setupTransform(frame: context.finalFrame(for: fromVC))
        }
    }
    
    public override func update(context: any UIViewControllerContextTransitioning, from fromVC: UIViewController, to toVC: UIViewController) {
        if isPresenting {
            toVC.view.transform = updateTransform(frame: context.finalFrame(for: toVC))
        } else {
            let transform = updateTransform(frame: context.finalFrame(for: fromVC))
            
            print("Dismiss Transform: \(fromVC.view.transform) Before fromVC: \(fromVC.view.frame)")
            fromVC.view.transform = transform
            print("Dismiss Transform: \(fromVC.view.transform) After fromVC: \(fromVC.view.frame)")
        }
    }
    
    override func cleanup(context: any UIViewControllerContextTransitioning, from fromVC: UIViewController, to toVC: UIViewController) {
        // reset transform in csae the popover was persisted,
        // this can help `CGAffineTransform` to calculate correct frame always
        if isPresenting {
            toVC.view.transform = .identity
        } else {
            fromVC.view.transform = .identity
        }
    }
    
    func setupTransform(frame: CGRect) -> CGAffineTransform {
        .identity
    }
    
    func updateTransform(frame: CGRect) -> CGAffineTransform {
        .identity
    }
}
