//
//  CXAnchoredPopoverExample.swift
//  CXPopoverExamples
//
//  Created by Cunqi Xiao on 5/24/24.
//

import UIKit

import CXPopover

final class CXAnchoredPopoverExample: CXPopoverExample {
    
    // MARK: - Override methods
    
    override func didTapMenuButton(sender: UIButton) {
        
        sender.present(ContentView(), preferredEdge: .top)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButtonX)),
                                              UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(didTapAddButtonY))]
    }
    
    @objc func didTapAddButtonX() {
        buttonXPosition.constant += 10
    }
    
    @objc func didTapAddButtonY() {
        buttonYPosition.constant += 10
    }
}

// MARK: - Popover Content

extension CXAnchoredPopoverExample {
    class ContentView: UIView, CXPopoverContentViewRepresentable {
        
        // MARK: - Initializer
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapToDismiss)))
            backgroundColor = .systemBackground
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
