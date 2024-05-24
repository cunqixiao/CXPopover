//
//  CXPopoverInteractiveExample.swift
//  CXPopoverExamples
//
//  Created by Cunqi Xiao on 5/23/24.
//

import UIKit

import CXPopover

class CXPopoverInteractiveDismissalOnlyExample: CXPopoverExample {
    override func didTapMenuButton() {
        let content = PopoverContent()
        let popover = CXPopoverController(content: content, presentationBehavior: content.behavior)
        present(popover, animated: true)
    }
}

// MARK: - PopoverContent

extension CXPopoverInteractiveDismissalOnlyExample {
    class PopoverContent: UIViewController, CXPopoverLayoutProvider {
        let behavior: CXPresentationBehavior = {
            var metadata = CXAnimationMetadata.slide(moveIn: .top, moveOut: .top)
            
            var behavior = CXPresentationBehavior.default
            behavior.anchor = .top
            behavior.animationMetadata = metadata
            behavior.interactiveAnimationMode = .dismissal
            return behavior
        }()
        
        func popover(sizeForPopover containerSize: CGSize, safeAreaInsets: UIEdgeInsets) -> CGSize {
            CGSize(width: containerSize.width, height: 300)
        }
    }
}
