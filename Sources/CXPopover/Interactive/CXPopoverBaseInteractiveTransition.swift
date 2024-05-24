//
//  CXPopoverBaseInteractiveTransition.swift
//  CXPopover
//
//  Created by Cunqi Xiao on 5/23/24.
//

import UIKit

class CXPopoverBaseInteractiveTransition: CXPopoverInteractiveTransition {
    
    // MARK: - Constants
    
    static let threshold = 0.5
    
    static let multiplier = 1.0
    
    // MARK: - Internal properties
    
    let edge: CXAnimationMetadata.Edge
    
    weak var presentingViewController: UIViewController?
    
    weak var presentedViewController: UIViewController?
    
    // MARK: - Initializer
    
    init(edge: CXAnimationMetadata.Edge) {
        self.edge = edge
    }
    
    func prepare() {
        
    }
}
