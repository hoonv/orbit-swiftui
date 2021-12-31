import UIKit
import SwiftUI

/// Duplicate and stripped down version of AttributedTextView from SharedUI.
@available(iOS, deprecated: 15.0, message: "Will be replaced with a native markdown-enabled Text component")
public final class TextLinkView: UITextView, UITextViewDelegate {

    let action: TextLink.Action
    private var size: CGSize

    override public var canBecomeFirstResponder: Bool {
        // disable text selection while allowing link interaction
        false
    }

    public init(layoutManager: NSLayoutManager = .init(), size: CGSize, action: @escaping TextLink.Action) {
        let textContainer = NSTextContainer()
        let textStorage = NSTextStorage()
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        layoutManager.allowsNonContiguousLayout = true
        layoutManager.limitsLayoutForSuspiciousContents = false

        self.size = size
        self.action = action

        super.init(frame: .zero, textContainer: textContainer)

        delegate = self

        backgroundColor = .clear
        isEditable = false
        isSelectable = true
        textDragInteraction?.isEnabled = false
        textContainer.lineBreakMode = .byTruncatingTail
        isScrollEnabled = false
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func textView(
        _ textView: UITextView,
        shouldInteractWith URL: URL,
        in characterRange: NSRange,
        interaction _: UITextItemInteraction
    ) -> Bool {
        let linkText = (textView.text as NSString).substring(with: characterRange)
        action(URL, linkText)
        return false
    }

    func update(
        content: NSAttributedString,
        size: CGSize,
        lineLimit: Int,
        color: UIColor?
    ) {
        tintColor = color
        textContainer.maximumNumberOfLines = lineLimit
        self.attributedText = content
        self.size = size
    }

    private func removeInsets() {
        textContainerInset = .zero
        textContainer.lineFragmentPadding = 0
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        removeInsets()
    }

    override public var intrinsicContentSize: CGSize {
        size
    }
}
