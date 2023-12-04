import SwiftUI

/// Orbit component that displays vertical separator between content.
///
/// A ``Separator`` consists of an optional label.
///
/// ```swift
/// Separator("OR", thickness: .hairline)
/// ```
/// 
/// ### Customizing appearance
///
/// The label color can be modified by ``textColor(_:)`` modifier.
///
/// ```swift
/// Separator("OR")
///     .textColor(.blueLight)
/// ```
///
/// ### Layout
///
/// Component expands horizontally.
///
/// - Note: [Orbit.kiwi documentation](https://orbit.kiwi/components/structure/separator/)
public struct Separator: View {

    @Environment(\.textColor) private var textColor

    private let label: String
    private let color: Color
    private let thickness: CGFloat

    public var body: some View {
        if label.isEmpty {
            line
        } else {
            HStack(spacing: .xxxSmall) {
                leadingLine

                Text(label)
                    .textSize(.small)
                    .textColor(textColor ?? .inkNormal)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .layoutPriority(1)

                trailingLine
            }
        }
    }

    @ViewBuilder private var line: some View {
        color
            .frame(height: thickness)
    }

    @ViewBuilder private var leadingLine: some View {
        HStack(spacing: 0) {
            line
            LinearGradient(colors: [color, color.opacity(0)], startPoint: .leading, endPoint: .trailing)
                .frame(width: .large)
                .frame(height: thickness)
        }
    }

    @ViewBuilder private var trailingLine: some View {
        HStack(spacing: 0) {
            LinearGradient(colors: [color, color.opacity(0)], startPoint: .trailing, endPoint: .leading)
                .frame(width: .large)
                .frame(height: thickness)
            line
        }
    }
}

// MARK: - Inits
public extension Separator {
    
    /// Creates Orbit ``Separator`` component.
    init(
        _ label: String = "",
        color: Color = .cloudNormal,
        thickness: Thickness = .default
    ) {
        self.label = label
        self.color = color
        self.thickness = thickness.value
    }
}

// MARK: - Types
public extension Separator {

    /// Orbit ``Separator`` thickness.
    enum Thickness {
        case `default`
        case hairline
        case custom(CGFloat)

        /// Value of Orbit `Separator` ``Separator/Thickness``.
        public var value: CGFloat {
            switch self {
                case .`default`:            return 1
                case .hairline:             return .hairline
                case .custom(let value):    return value
            }
        }
    }
}

// MARK: - Previews
struct SeparatorPreviews: PreviewProvider {

    public static var previews: some View {
        PreviewWrapper {
            standalone
            labels
            mix
        }
        .padding(.vertical, .medium)
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        Separator()
            .previewDisplayName()
    }

    static var labels: some View {
        VStack(spacing: .xLarge) {
            Separator()
            Separator("Separator with label")
        }
        .previewDisplayName()
    }

    static var mix: some View {
        VStack(spacing: .xLarge) {
            Separator("Custom colors", color: .blueNormal)
                .textColor(.productDark)
            Separator("Separator with very very very very very long and multiline label")
            Separator("Hairline thickness", thickness: .hairline)
            Separator("Custom thickness", thickness: .custom(.xSmall))
        }
        .previewDisplayName()
    }

    static var snapshot: some View {
        labels
            .padding(.vertical, .medium)
    }
}
