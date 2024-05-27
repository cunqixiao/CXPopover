//
//  CXPopoverTopTextViewExample.swift
//  CXPopoverExamples
//
//  Created by Cunqi Xiao on 5/25/24.
//

import UIKit

import CXPopover

final class CXPopoverTopTextViewExample: CXPopoverExample {
    
    override func didTapMenuButton() {
        let popover = CXTopTextViewPopover(title: "Comments", text: nil)
        popover.delegate = self
        present(popover, animated: true)
    }
    
}

extension CXPopoverTopTextViewExample: CXTopTextViewPopoverDelegate {
    func textViewPopover(didFinishEditing text: String?) {
    }

    func textViewPopover(actionBarButtonItemWith behavior: CXPopoverBehavior) -> UIBarButtonItem? {
        return UIBarButtonItem(barButtonSystemItem: .compose, target: nil, action: nil)
    }
}
