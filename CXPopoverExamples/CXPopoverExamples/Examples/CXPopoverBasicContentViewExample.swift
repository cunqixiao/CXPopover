//
//  CXPopoverBasicContentViewExample.swift
//  CXPopoverExamples
//
//  Created by Cunqi Xiao on 5/24/24.
//

import UIKit

import CXPopover

final class CXPopoverBasicContentViewExample: CXPopoverExample {
    
    // MARK: - Lifecycle
    
    override func didTapMenuButton() {
        let contentView = ContentView()
        
        var popoverBehavior = CXPopoverBehavior.default
        popoverBehavior.animationMetadata = .zoom()
        popoverBehavior.animationMetadata.bounces = true
        
        let popover = CXPopoverController(contentView: contentView, behavior: popoverBehavior)
        present(popover, animated: true)
    }
    
}

// MARK: - Content View

extension CXPopoverBasicContentViewExample {
    class ContentView: UIView, CXPopoverContentViewRepresentable {
        
        // MARK: - Initializer
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapToDismiss)))
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // MARK: - CXPopoverLayoutProvider
        
        func popover(sizeForPopover containerSize: CGSize, safeAreaInsets: UIEdgeInsets) -> CGSize {
            CGSize(width: 200, height: 200)
        }
        
        // MARK: - Private properties
        
        @objc private func tapToDismiss() {
            dismissPopover(animated: true)
        }
    }
}
