import SwiftUI

/// Lets users sign in using a social service.
///
/// Social buttons are designed to ease the flow for users signing in.
/// Don’t use them in any other case or in any complex scenarios.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/socialbutton/)
/// - Important: Component expands horizontally unless prevented by `fixedSize` or `idealSize` modifier.
public struct SocialButton: View {

    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.idealSize) private var idealSize
    @Environment(\.sizeCategory) private var sizeCategory
    @Environment(\.textColor) private var textColor
    @Environment(\.isHapticsEnabled) private var isHapticsEnabled

    private let label: String
    private let service: Service
    private let action: () -> Void

    public var body: some View {
        SwiftUI.Button(
            action: {
                if isHapticsEnabled {
                    HapticsProvider.sendHapticFeedback(.light(0.5))
                }
                
                action()
            },
            label: {
                HStack(spacing: .xSmall) {
                    logo
                        .scaledToFit()
                        .frame(width: .large * sizeCategory.ratio)

                    Text(label, size: .normal)
                        .fontWeight(.medium)
                        .padding(.vertical, Button.Size.default.verticalPadding)

                    if idealSize.horizontal == nil {
                        Spacer(minLength: 0)
                    }

                    Icon(.chevronForward, size: .large)
                        .iconColor(labelColor)
                }
                .textColor(textColor ?? labelColor)
            }
        )
        .buttonStyle(OrbitStyle(backgroundColor: backgroundColor, idealSize: idealSize))
    }

    @ViewBuilder var logo: some View {
        switch service {
            case .apple:        Self.appleLogo.foregroundColor(.whiteNormal).padding(1)
            case .google:       Self.googleLogo
            case .facebook:     Self.facebookLogo
            case .email:        Icon(.email, size: .large)
        }
    }

    var labelColor: Color {
        switch service {
            case .apple:        return .whiteNormal
            case .google:       return .inkDark
            case .facebook:     return .inkDark
            case .email:        return .inkDark
        }
    }

    var backgroundColor: OrbitStyle.BackgroundColor {
        switch service {
            case .apple:        return (
                colorScheme == .light ? .black : .white,
                colorScheme == .light ? .inkNormalActive : .inkNormalActive
            )
            case .google:       return (.cloudNormal, .cloudNormalActive)
            case .facebook:     return (.cloudNormal, .cloudNormalActive)
            case .email:        return (.cloudNormal, .cloudNormalActive)
        }
    }
}

// MARK: - Inits
public extension SocialButton {
    
    /// Creates Orbit SocialButton component.
    init(_ label: String, service: Service, action: @escaping () -> Void) {
        self.label = label
        self.service = service
        self.action = action
    }
}

// MARK: - Types
extension SocialButton {

    private static let appleLogo = Image.orbit(.apple).renderingMode(.template).resizable()
    private static let googleLogo = Image.orbit(.google).resizable()
    private static let facebookLogo = Image.orbit(.facebook).resizable()

    public enum Service {
        case apple
        case google
        case facebook
        case email
    }

    struct OrbitStyle: ButtonStyle {

        typealias BackgroundColor = (normal: Color, active: Color)

        let backgroundColor: BackgroundColor
        let idealSize: IdealSizeValue

        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .frame(maxWidth: idealSize.horizontal == true ? nil : .infinity)
                .padding(.horizontal, .small)
                .background(
                    configuration.isPressed ? backgroundColor.active : backgroundColor.normal
                )
                .cornerRadius(BorderRadius.default)
        }
    }
}

// MARK: - Previews
struct SocialButtonPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            idealSize
            all
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        SocialButton("Sign in with Facebook", service: .facebook, action: {})
            .previewDisplayName()
    }

    static var idealSize: some View {
        content
            .idealSize()
            .previewDisplayName()
    }

    static var all: some View {
        content
            .previewDisplayName()
    }

    static var content: some View {
        VStack(spacing: .medium) {
            SocialButton("Sign in with E-mail", service: .email, action: {})
            SocialButton("Sign in with Facebook", service: .facebook, action: {})
            SocialButton("Sign in with Google", service: .google, action: {})
            SocialButton("Sign in with Apple", service: .apple, action: {})
        }
    }

    static var snapshot: some View {
        VStack(spacing: .medium) {
            all
            idealSize
        }
        .padding(.medium)
    }
}
