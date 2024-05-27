//
//  CXTopTextViewPopoverDelegate.swift
//  CXPopover
//
//  Created by Cunqi Xiao on 5/26/24.
//

import UIKit

public protocol CXTopInputPopoverDelegate: AnyObject {
    
    func topInputPopover(didSetupTextInput inputView: UIView & UITextInput, textInputType: CXTopInputPopover.TextInputType, behavior: CXPopoverBehavior)
    
    func topInputPopover(didSetupNavigationBar navigationBar: UINavigationBar, behavior: CXPopoverBehavior)
    
    func topInputPopover(didFinishEditing text: String?)
    
    func topInputPopover(cancelBarButtonItemWith behavior: CXPopoverBehavior) -> UIBarButtonItem?
    
    func topInputPopover(actionBarButtonItemWith behavior: CXPopoverBehavior) -> UIBarButtonItem?
}

// MARK: - Optional

public extension CXTopInputPopoverDelegate {
    func topInputPopover(didSetupTextInput inputView: UIView & UITextInput,
                         textInputType: CXTopInputPopover.TextInputType,
                         behavior: CXPopoverBehavior) {}
    
    func topInputPopover(didSetupNavigationBar navigationBar: UINavigationBar, behavior: CXPopoverBehavior) {}
    
    func topInputPopover(cancelBarButtonItemWith behavior: CXPopoverBehavior) -> UIBarButtonItem? {
        nil
    }
    
    func topInputPopover(actionBarButtonItemWith behavior: CXPopoverBehavior) -> UIBarButtonItem? {
        nil
    }
}
