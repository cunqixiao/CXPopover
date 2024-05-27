//
//  CXTopTextViewPopoverDelegate.swift
//  CXPopover
//
//  Created by Cunqi Xiao on 5/26/24.
//

import UIKit

public protocol CXTopTextViewPopoverDelegate: AnyObject {
    
    func textViewPopover(didSetupTextView textView: UITextView, behavior: CXPopoverBehavior)
    
    func textViewPopover(didSetupNavigationBar navigationBar: UINavigationBar, behavior: CXPopoverBehavior)
    
    func textViewPopover(didFinishEditing text: String?)
    
    func textViewPopover(cancelBarButtonItemWith behavior: CXPopoverBehavior) -> UIBarButtonItem?
    
    func textViewPopover(actionBarButtonItemWith behavior: CXPopoverBehavior) -> UIBarButtonItem?
}

// MARK: - Optional

public extension CXTopTextViewPopoverDelegate {
    func textViewPopover(didSetupTextView textView: UITextView, behavior: CXPopoverBehavior) {}
    
    func textViewPopover(didSetupNavigationBar navigationBar: UINavigationBar, behavior: CXPopoverBehavior) {}
    
    func textViewPopover(cancelBarButtonItemWith behavior: CXPopoverBehavior) -> UIBarButtonItem? {
        nil
    }
    
    func textViewPopover(actionBarButtonItemWith behavior: CXPopoverBehavior) -> UIBarButtonItem? {
        nil
    }
}
