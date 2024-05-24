//
//  CXPopoverInteractiveExample.swift
//  CXPopoverExamples
//
//  Created by Cunqi Xiao on 5/23/24.
//

import UIKit

import CXPopover

class CXPopoverInteractiveExample: CXPopoverExample {
    override func didTapMenuButton() {
        let content = PopoverContent()
        let popover = CXPopoverController(content: content, presentationBehavior: content.behavior)
        present(popover, animated: true)
    }
}

// MARK: - PopoverContent

extension CXPopoverInteractiveExample {
    class PopoverContent: UIViewController, CXPopoverLayoutProvider {
        let behavior: CXPresentationBehavior = {
            var metadata = CXAnimationMetadata.slide(moveIn: .top, moveOut: .top)
            metadata.isInteractiveAnimationDisabled = false
            
            var behavior = CXPresentationBehavior.default
            behavior.anchor = .top
            behavior.animationMetadata = metadata
            return behavior
        }()
        
        func popover(sizeForPopover containerSize: CGSize, safeAreaInsets: UIEdgeInsets) -> CGSize {
            CGSize(width: containerSize.width, height: 300)
        }
    }
}
