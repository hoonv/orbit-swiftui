import SwiftUI

public enum AlertButtons {
    case none
    case primary(Button.Content)
    case secondary(Button.Content)
    case primaryAndSecondary(Button.Content, Button.Content)

    var isVisible: Bool {
        switch self {
            case .primary, .secondary, .primaryAndSecondary:    return true
            case .none:                                         return false
        }
    }
}

/// Breaks the main user flow to present information.
///
/// There are times when just simple information isn’t enough and the user needs
/// to take additional steps to resolve the problem or get additional details.
///
/// In such cases, provide additional actions for your message.
/// Alerts use special status buttons to match the button color with the alert color.
///
/// Use at most two actions in each Alert: one primary and one subtle.
///
/// - Related components:
///   - ``Heading`` + ``Text``
///   - ``Toast``
///   - ``EmptyState``
///   - ``Modal``
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/alert/)
/// - Important: Component expands horizontally to infinity.
public struct Alert<Content: View>: View {

    let title: String
    let description: String
    let icon: Icon.Symbol
    let buttons: AlertButtons
    let status: Status
    let isSuppressed: Bool
    let descriptionLinkAction: TextLink.Action
    let content: () -> Content

    public var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: .xSmall) {
            
            Icon(icon, size: .normal, color: status.color)
            
            VStack(alignment: .leading, spacing: .medium) {

                if isHeaderEmpty == false {
                    VStack(alignment: .leading, spacing: .xxSmall) {
                        Text(title, weight: .bold)
                        Text(description, linkColor: .secondary, linkAction: descriptionLinkAction)
                    }
                }
                
                content()
                
                switch buttons {
                    case .primary, .secondary, .primaryAndSecondary:
                        // Keeping the identity of buttons for correct animations
                        buttonsView
                    case .none:
                        EmptyView()
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding([.vertical, .trailing], .medium)
        .padding(.leading, icon == .none ? .medium : .small)
        .background(background)
        .cornerRadius(BorderRadius.default)
    }

    @ViewBuilder var buttonsView: some View {
        HStack(alignment: .top, spacing: .small) {
            switch buttons {
                case .primary(let primaryButton),
                     .primaryAndSecondary(let primaryButton, _):
                    Button(primaryButton.label, style: primaryButtonStyle, size: .small, action: primaryButton.action)
                case .none, .secondary:
                    EmptyView()
            }

            switch buttons {
                case .secondary(let secondaryButton),
                     .primaryAndSecondary(_, let secondaryButton):
                    Button(secondaryButton.label, style: secondaryButtonStyle, size: .small, action: secondaryButton.action)
                case .none, .primary:
                    EmptyView()
            }
        }
    }

    @ViewBuilder var background: some View {
        backgroundColor
            .overlay(
                RoundedRectangle(cornerRadius: BorderRadius.default)
                    .strokeBorder(strokeColor, lineWidth: 1)
            )
            .overlay(
                status.color
                    .frame(height: 3),
                alignment: .top
            )
    }
    
    var backgroundColor: Color {
        switch (status, isSuppressed) {
            case (_, true):             return .cloudLight
            case (.info, _):            return .blueLight
            case (.success, _):         return .greenLight
            case (.warning, _):         return .orangeLight
            case (.critical, _):        return .redLight
        }
    }

    var strokeColor: Color {
        switch (status, isSuppressed) {
            case (_, true):             return .cloudLightHover
            case (.info, _):            return .blueLightHover
            case (.success, _):         return .greenLightHover
            case (.warning, _):         return .orangeLightHover
            case (.critical, _):        return .redLightHover
        }
    }

    var textColor: UIColor {
        switch status {
            case .info:     return .blueDark
            case .success:  return .greenDark
            case .warning:  return .orangeDark
            case .critical: return .redDark
        }
    }

    var primaryButtonStyle: Orbit.Button.Style {
        .status(status, subtle: false)
    }

    var secondaryButtonStyle: Orbit.Button.Style {
        isSuppressed
            ? .secondary
            : .status(status, subtle: true)
    }

    var isHeaderEmpty: Bool {
        title.isEmpty && description.isEmpty
    }
}

// MARK: - Inits
public extension Alert {
    
    /// Creates Orbit Alert component including custom content.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Symbol = .none,
        buttons: AlertButtons = .none,
        status: Status = .info,
        isSuppressed: Bool = false,
        descriptionLinkAction: @escaping TextLink.Action = { _, _ in },
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.description = description
        self.icon = icon
        self.buttons = buttons
        self.status = status
        self.isSuppressed = isSuppressed
        self.descriptionLinkAction = descriptionLinkAction
        self.content = content
    }
    
    /// Creates Orbit Alert component.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Symbol = .none,
        buttons: AlertButtons = .none,
        status: Status = .info,
        isSuppressed: Bool = false,
        descriptionLinkAction: @escaping TextLink.Action = { _, _ in }
    ) where Content == EmptyView {
        self.init(
            title,
            description: description,
            icon: icon,
            buttons: buttons,
            status: status,
            isSuppressed: isSuppressed,
            descriptionLinkAction: descriptionLinkAction,
            content: { EmptyView() }
        )
    }
}

// MARK: - Previews
struct AlertPreviews: PreviewProvider {

    static let title = "Title"
    static let description = """
        The main description message of this Alert component should be placed here. If you need to use TextLink \
        in this component, please do it by using <a href="..">Normal Underline text style</a>.

        Description message can be <strong>formatted</strong>, but if more <ref>customizaton</ref> is needed a custom \
        description content can be provided instead.
        """
    static let primaryAndSecondaryConfiguration = AlertButtons.primaryAndSecondary("Primary", "Secondary")
    static let primaryConfiguration = AlertButtons.primary("Primary")
    static let secondaryConfiguration = AlertButtons.secondary("Secondary")

    static var previews: some View {
        PreviewWrapper {
            standalone

            basic
            basicNoIcon
            suppressed
            suppressedNoIcon

            primaryButtonOnly
            noButtons
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        Alert(
            "Alert with very very very very very very very very very very very long and <u>multiline</u> title",
            description: description,
            icon: .grid,
            buttons: primaryAndSecondaryConfiguration
        ) {
            customContentPlaceholder
        }
        .padding(.medium)
    }

    static var basic: some View {
        alerts(showIcons: true, isSuppressed: false)
            .padding(.medium)
    }

    static var basicNoIcon: some View {
        alerts(showIcons: false, isSuppressed: false)
            .padding(.medium)
    }

    static var suppressed: some View {
        alerts(showIcons: true, isSuppressed: true)
            .padding(.medium)
    }

    static var suppressedNoIcon: some View {
        alerts(showIcons: false, isSuppressed: true)
            .padding(.medium)
    }

    static func alert(_ title: String, status: Status, icon: Icon.Symbol, isSuppressed: Bool) -> some View {
        Alert(
            title,
            description: description,
            icon: icon,
            buttons: primaryAndSecondaryConfiguration,
            status: status,
            isSuppressed: isSuppressed
        )
    }

    static func alerts(showIcons: Bool, isSuppressed: Bool) -> some View {
        VStack(spacing: .medium) {
            alert("Informational message", status: .info, icon: showIcons ? .informationCircle : .none, isSuppressed: isSuppressed)
            alert("Success message", status: .success, icon: showIcons ? .checkCircle : .none, isSuppressed: isSuppressed)
            alert("Warning message", status: .warning, icon: showIcons ? .alertCircle : .none, isSuppressed: isSuppressed)
            alert("Critical message", status: .critical, icon: showIcons ? .alertCircle : .none, isSuppressed: isSuppressed)
        }
    }

    static var primaryButtonOnly: some View {
        VStack(spacing: .medium) {
            Alert(title, description: description, icon: .informationCircle, buttons: Self.primaryConfiguration)
            Alert(description: description, icon: .informationCircle, buttons: Self.primaryConfiguration)
            Alert(title, description: description, buttons: Self.primaryConfiguration)
            Alert(description: description, buttons: Self.primaryConfiguration)
            Alert( title, icon: .informationCircle, buttons: Self.primaryConfiguration)
            Alert(title, buttons: Self.primaryConfiguration)
            Alert(icon: .informationCircle, buttons: Self.primaryConfiguration)
            Alert(buttons: Self.primaryConfiguration)
        }
        .padding(.medium)
        .previewDisplayName("Primary buttons")
    }
    
    static var noButtons: some View {
        VStack(spacing: .medium) {
            Alert(title, description: description, icon: .informationCircle)
            Alert(title, description: description)
            Alert(title) {
                customContentPlaceholder
            }
            Alert {
                customContentPlaceholder
            }
            Alert(title, icon: .informationCircle)
            Alert(icon: .informationCircle)
            Alert(title)
            Alert()
        }
        .padding(.medium)
        .previewDisplayName("No buttons")
    }

    static var storybook: some View {
        VStack(alignment: .leading, spacing: .large) {
            basic
            basicNoIcon
            suppressed
            suppressedNoIcon
        }
    }

    static var storybookMix: some View {
        VStack(alignment: .leading, spacing: .large) {
            primaryButtonOnly
            noButtons
        }
    }

    static var storybookLive: some View {
        StateWrapper(initialState: primaryAndSecondaryConfiguration) { buttons in
            VStack(spacing: .large) {
                Alert(
                    title,
                    description: description,
                    icon: .informationCircle,
                    buttons: buttons.wrappedValue
                )

                Button("Toggle buttons") {
                    withAnimation(.spring()) {
                        switch buttons.wrappedValue {
                            case .none:                     buttons.wrappedValue = primaryConfiguration
                            case .primary:                  buttons.wrappedValue = secondaryConfiguration
                            case .secondary:                buttons.wrappedValue = primaryAndSecondaryConfiguration
                            case .primaryAndSecondary:      buttons.wrappedValue = .none
                        }
                    }
                }
            }
            .padding(.medium)
            .animation(.default, value: buttons.wrappedValue.isVisible)
        }
    }
}

struct AlertDynamicTypePreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            content
                .environment(\.sizeCategory, .extraSmall)
                .previewDisplayName("Dynamic Type - XS")

            content
                .environment(\.sizeCategory, .accessibilityExtraLarge)
                .previewDisplayName("Dynamic Type - XL")
        }
        .previewLayout(.sizeThatFits)
    }

    @ViewBuilder static var content: some View {
        AlertPreviews.standalone
    }
}
