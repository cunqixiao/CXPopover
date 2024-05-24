//
//  CXPopoverAnimationCoordinator.swift
//  CXPopover
//
//  Created by Cunqi Xiao on 5/22/24.
//

import UIKit

public protocol CXPopoverAnimationCoordinator: AnyObject {
    
    // MARK: - Properties
    
    var duration: TimeInterval { get }
    
    var isPresenting: Bool { get }
    
    // MARK: - Methods
    
    func setup(context: UIViewControllerContextTransitioning, from fromVC: UIViewController, to toVC: UIViewController)

    func update(context: UIViewControllerContextTransitioning, from fromVC: UIViewController, to toVC: UIViewController)
    
    func cleanup(context: UIViewControllerContextTransitioning, from fromVC: UIViewController, to toVC: UIViewController)
}
