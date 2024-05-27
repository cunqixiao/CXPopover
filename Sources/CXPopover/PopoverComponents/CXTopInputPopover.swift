//
//  CXTopInputPopover.swift
//  CXPopover
//
//  Created by Cunqi Xiao on 5/25/24.
//

import Combine
import UIKit

public class CXTopInputPopover: CXPopoverController {
    public enum TextInputType {
        case textField, textView
    }
    
    // MARK: - Public properties
    
    public var delegate: (any CXTopInputPopoverDelegate)? {
        get {
            textInput.delegate
        }
        set {
            textInput.delegate = newValue
        }
    }
    
    // MARK: - Private properties
    
    private let textInput: TextInputView
    
    // MARK: - Initializers
    
    public init(type textInputType: TextInputType, title: String?, text: String?, actionButtonText: String? = nil, behavior: CXPopoverBehavior = .default) {
        self.textInput = TextInputView(
            textInputType: textInputType,
            title: title,
            text: text,
            actionButtonText: actionButtonText,
            behavior: behavior)
        let wrapper = PopoverContentViewWrapper(contentView: textInput)
        
        super.init(contentViewController: wrapper, behavior: textInput.behavior)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CXTopInputPopover {
    class TextInputView: UIView, CXPopoverContentViewRepresentable {
        
        // MARK: - Constants
        
        private static let insets = UIEdgeInsets(top: 8, left: 16, bottom: 16, right: 16)
        private static let containerInsets = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)
        private static let navigationBarHeight: CGFloat = 40
        private static let textViewHeight: CGFloat = 240
        private static let textFieldHeight: CGFloat = 48
        
        // MARK: - Internal properties
        
        let behavior: CXPopoverBehavior
        weak var delegate: (any CXTopInputPopoverDelegate)?

        // MARK: - Private properties
        
        private let textInputType: TextInputType
        private let title: String?
        private let actionButtonText: String?
        private let textSubject: CurrentValueSubject<String?, Never>
        private var cancellables = Set<AnyCancellable>()
        
        private lazy var textView: UITextView = {
            let textView = UITextView()
            textView.font = UIFont.preferredFont(forTextStyle: .body)
            textView.textColor = .label
            textView.textContainerInset = Self.containerInsets
            return textView
        }()
        
        private lazy var textField: UITextField = {
            let textField = UITextField()
            textField.font = UIFont.preferredFont(forTextStyle: .body)
            textField.textColor = .label
            textField.borderStyle = .roundedRect
            return textField
        }()
        
        private lazy var actionBarButtonItem = UIBarButtonItem()
        private lazy var navigationBar = UINavigationBar()
        
        private var textInputView: UIView & UITextInput {
            switch textInputType {
            case .textField:
                return textField
            case .textView:
                return textView
            }
        }
        
        // MARK: - Initializers
        
        init(textInputType: TextInputType, title: String?, text: String?, actionButtonText: String?, behavior: CXPopoverBehavior) {
            self.textInputType = textInputType
            self.title = title
            self.textSubject = CurrentValueSubject(text)
            self.actionButtonText = actionButtonText
            self.behavior = Self.overridePopoverBehavior(behavior: behavior)
            super.init(frame: .zero)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // MARK: - Override methods
        
        func popover(sizeForPopover containerSize: CGSize, safeAreaInsets: UIEdgeInsets) -> CGSize {
            var contentHeight = safeAreaInsets.top + Self.navigationBarHeight + Self.insets.top + Self.insets.bottom
            switch textInputType {
            case .textField:
                contentHeight += Self.textFieldHeight
            case .textView:
                contentHeight += Self.textViewHeight
            }
            
            return CGSize(width: containerSize.width, height: contentHeight)
        }
        
        // MARK: - Lifecycle
        
        func viewDidLoad() {
            setupViewsAndLayoutConstraints()
            setupNavigationBar()
            stylize()
            setupTextInput()
            delegate?.topInputPopover(didSetupNavigationBar: navigationBar, behavior: behavior)
            
            subscribeTextInputs()
        }
        
        func viewWillAppear() {
            textInputView.becomeFirstResponder()
        }
        
        func viewWillDisappear() {
            textInputView.resignFirstResponder()
        }
        
        // MARK: - Private methods
        
        private func setupViewsAndLayoutConstraints() {
            [navigationBar, textInputView].forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                addSubview($0)
            }
            
            NSLayoutConstraint.activate([
                navigationBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                navigationBar.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
                navigationBar.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
                
                textInputView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: Self.insets.top),
                textInputView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: Self.insets.left),
                textInputView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -Self.insets.right),
                textInputView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -Self.insets.bottom)
            ])
        }
        
        private func setupNavigationBar() {
            let navigationItem = UINavigationItem(title: title ?? "")
            
            let leftBarButtonItem =
            delegate?.topInputPopover(cancelBarButtonItemWith: behavior) ?? UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
            leftBarButtonItem.target = self
            leftBarButtonItem.action = #selector(didTapCancel)
            navigationItem.leftBarButtonItem = leftBarButtonItem
            
            actionBarButtonItem = delegate?.topInputPopover(actionBarButtonItemWith: behavior) ?? Self.makeActionBarButtonItem(actionButtonText)
            actionBarButtonItem.target = self
            actionBarButtonItem.action = #selector(didTapDone)
            navigationItem.rightBarButtonItem = actionBarButtonItem
            
            navigationBar.items = [navigationItem]
            navigationBar.standardAppearance.configureWithTransparentBackground()
        }
        
        private func stylize() {
            backgroundColor = behavior.popoverBackgroundColor
            textInputView.backgroundColor = .secondarySystemBackground
            
            // textField has `roundedRect` border style by default
            textView.layer.cornerRadius = behavior.cornerRadius
        }
        
        private func setupTextInput() {
            switch textInputType {
            case .textField:
                delegate?.topInputPopover(didSetupTextView: textView, behavior: behavior)
            case .textView:
                delegate?.topInputPopover(didSetupTextField: textField, behavior: behavior)
            }
        }
        
        @objc private func didTapCancel() {
            parentPopover?.dismiss(animated: true)
        }
        
        @objc private func didTapDone() {
            delegate?.topInputPopover(didFinishEditing: textSubject.value)
            parentPopover?.dismiss(animated: true)
        }
        
        private func subscribeTextInputs() {
            switch textInputType {
            case .textField:
                subscribeToTextField()
            case .textView:
                subscribeToTextView()
            }
            
            textSubject
                .map { !($0?.isEmpty ?? true) }
                .assign(to: \.isEnabled, on: actionBarButtonItem)
                .store(in: &cancellables)
        }
        
        private func subscribeToTextView() {
            textView.text = textSubject.value
            textView.textPublisher()
                .assign(to: \.value, on: textSubject)
                .store(in: &cancellables)
        }
        
        private func subscribeToTextField() {
            textField.text = textSubject.value
            textField.textPublisher()
                .assign(to: \.value, on: textSubject)
                .store(in: &cancellables)
        }
        
        private static func overridePopoverBehavior(behavior: CXPopoverBehavior) -> CXPopoverBehavior {
            var overridedBehavior = CXPopoverBehavior.default
            overridedBehavior.anchor = .top
            overridedBehavior.animationMetadata = .slide(moveIn: .top, moveOut: .top)
            overridedBehavior.ignoreSafeArea = true
            overridedBehavior.popoverBackgroundColor = behavior.popoverBackgroundColor
            overridedBehavior.backgroundMaskColor = behavior.backgroundMaskColor
            overridedBehavior.cornerRadius = behavior.cornerRadius
            overridedBehavior.isModal = behavior.isModal
            overridedBehavior.cornerRadius = behavior.cornerRadius
            
            return overridedBehavior
        }
        
        private static func makeActionBarButtonItem(_ actionButtonText: String?) -> UIBarButtonItem {
            guard let actionButtonText else {
                return UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
            }
            return UIBarButtonItem(title: actionButtonText, style: .plain, target: nil, action: nil)
        }
    }
}

extension UITextView {
    func textPublisher() -> AnyPublisher<String?, Never> {
        NotificationCenter.default
            .publisher(for: UITextView.textDidChangeNotification, object: self)
            .map { $0.object as? Self }
            .map { $0?.text }
            .eraseToAnyPublisher()
    }
}

extension UITextField {
    func textPublisher() -> AnyPublisher<String?, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .map { $0.object as? Self }
            .map { $0?.text }
            .eraseToAnyPublisher()
    }
}
