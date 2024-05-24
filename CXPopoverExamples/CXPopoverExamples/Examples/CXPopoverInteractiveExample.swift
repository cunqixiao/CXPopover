//
//  CXPopoverInteractiveExample.swift
//  CXPopoverExamples
//
//  Created by Cunqi Xiao on 5/23/24.
//

import UIKit

import CXPopover

final class CXPopoverInteractiveExample: CXPopoverExample {
    
    // MARK: - Private properties
    
    private lazy var popover: CXPopoverController = {
        let content = PopoverContent()
        return CXPopoverController(content: content, popoverBehavior: content.behavior)
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popover.interactiveCoordinator.preparePresentingTransition(self)
    }
}

// MARK: - PopoverContent

extension CXPopoverInteractiveExample {
    class PopoverContent: UIViewController, CXPopoverLayoutProvider {
        let behavior: CXPopoverBehavior = {
            var metadata = CXPopoverAnimationMetadata.slide(moveIn: .right, moveOut: .right)
            
            var behavior = CXPopoverBehavior.default
            behavior.anchor = .trailing
            behavior.animationMetadata = metadata
            behavior.interactiveAnimationMode = .both
            return behavior
        }()
        
        func popover(sizeForPopover containerSize: CGSize, safeAreaInsets: UIEdgeInsets) -> CGSize {
            CGSize(width: 300, height: containerSize.height)
        }
    }
}
