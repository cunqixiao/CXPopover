//
//  CXTopTextViewPopover.swift
//  CXPopover
//
//  Created by Cunqi Xiao on 5/25/24.
//

import Combine
import UIKit

public class CXTopTextViewPopover: CXPopoverController {
    
    // MARK: - Public properties
    
    public var delegate: (any CXTopTextViewPopoverDelegate)? {
        get {
            textViewPopover.delegate
        }
        set {
            textViewPopover.delegate = newValue
        }
    }
    
    // MARK: - Private properties
    
    private let textViewPopover: TextView
    
    // MARK: - Initializers
    
    public init(title: String?, text: String?, actionButtonText: String? = nil,  behavior: CXPopoverBehavior = .default) {
        self.textViewPopover = TextView(
            title: title,
            text: text,
            actionButtonText: actionButtonText,
            behavior: behavior)
        let wrapper = PopoverContentViewWrapper(contentView: textViewPopover)
        
        super.init(contentViewController: wrapper, behavior: textViewPopover.behavior)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CXTopTextViewPopover {
    class TextView: UIView, CXPopoverContentViewRepresentable {
        
        // MARK: - Constants
        
        private static let insets = UIEdgeInsets(top: 8, left: 16, bottom: 16, right: 16)
        private static let containerInsets = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)
        private static let textViewHeight: CGFloat = 300
        
        // MARK: - Internal properties
        
        let behavior: CXPopoverBehavior
        weak var delegate: (any CXTopTextViewPopoverDelegate)?

        // MARK: - Private properties
        
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
        
        private lazy var actionBarButtonItem = UIBarButtonItem()
        private lazy var navigationBar = UINavigationBar()
        
        // MARK: - Initializers
        
        init(title: String?, text: String?, actionButtonText: String?, behavior: CXPopoverBehavior) {
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
            CGSize(width: containerSize.width, height: Self.textViewHeight)
        }
        
        // MARK: - Lifecycle
        
        func viewDidLoad() {
            setupViewsAndLayoutConstraints()
            setupNavigationBar()
            stylize()
            delegate?.textViewPopover(didSetupTextView: textView, behavior: behavior)
            delegate?.textViewPopover(didSetupNavigationBar: navigationBar, behavior: behavior)
            
            subscribeToTextViewPublishers()
        }
        
        func viewWillAppear() {
            textView.becomeFirstResponder()
        }
        
        func viewWillDisappear() {
            textView.resignFirstResponder()
        }
        
        // MARK: - Private methods
        
        private func setupViewsAndLayoutConstraints() {
            [navigationBar, textView].forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                addSubview($0)
            }
            
            NSLayoutConstraint.activate([
                navigationBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                navigationBar.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
                navigationBar.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
                
                textView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: Self.insets.top),
                textView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: Self.insets.left),
                textView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -Self.insets.right),
                textView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -Self.insets.bottom)
            ])
        }
        
        private func setupNavigationBar() {
            let navigationItem = UINavigationItem(title: title ?? "")
            
            let leftBarButtonItem =
            delegate?.textViewPopover(cancelBarButtonItemWith: behavior) ?? UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
            leftBarButtonItem.target = self
            leftBarButtonItem.action = #selector(didTapCancel)
            navigationItem.leftBarButtonItem = leftBarButtonItem
            
            actionBarButtonItem = delegate?.textViewPopover(actionBarButtonItemWith: behavior) ?? Self.makeActionBarButtonItem(actionButtonText)
            actionBarButtonItem.target = self
            actionBarButtonItem.action = #selector(didTapDone)
            navigationItem.rightBarButtonItem = actionBarButtonItem
            
            navigationBar.items = [navigationItem]
            navigationBar.standardAppearance.configureWithTransparentBackground()
        }
        
        private func stylize() {
            backgroundColor = behavior.popoverBackgroundColor
            textView.backgroundColor = .secondarySystemBackground
            textView.layer.cornerRadius = behavior.cornerRadius
        }
        
        private func subscribeToTextViewPublishers() {
            textView.text = textSubject.value
            
            textView.textPublisher()
                .assign(to: \.value, on: textSubject)
                .store(in: &cancellables)
            
            textSubject
                .map { !($0?.isEmpty ?? true) }
                .assign(to: \.isEnabled, on: actionBarButtonItem)
                .store(in: &cancellables)
        }
        
        @objc private func didTapCancel() {
            parentPopover?.dismiss(animated: true)
        }
        
        @objc private func didTapDone() {
            delegate?.textViewPopover(didFinishEditing: textSubject.value)
            parentPopover?.dismiss(animated: true)
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
