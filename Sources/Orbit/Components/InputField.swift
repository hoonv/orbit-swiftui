import SwiftUI
import UIKit

/// Style variant for Orbit InputField component.
public enum InputFieldStyle {

    /// Style with label positioned above the InputField.
    case `default`
    /// Style with compact label positioned inside the InputField.
    case compact
}

/// Also known as textbox. Offers users a simple input for a form.
///
/// When you have additional information or helpful examples, include placeholder text to help users along.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/inputfield/)
/// - Important: Component expands horizontally unless prevented by `fixedSize` modifier.
public struct InputField<Value>: View where Value: LosslessStringConvertible {

    enum Mode {
        case actionsHandler(onEditingChanged: (Bool) -> Void, onCommit: () -> Void, isSecure: Bool)
        case formatter(formatter: Formatter)
    }

    @Environment(\.sizeCategory) private var sizeCategory
    @Environment(\.isEnabled) private var isEnabled
    @State private var isEditing: Bool = false
    @State private var isSecureTextRedacted: Bool = true

    var label: String = ""
    @Binding var value: Value
    var prefix: Icon.Content = .none
    var suffix: Icon.Content = .none
    var placeholder: String = ""
    var state: InputState = .default
    var textContent: UITextContentType? = nil
    var keyboard: UIKeyboardType = .default
    var autocapitalization: UITextAutocapitalizationType = .none
    var isAutocompleteEnabled: Bool = false
    var passwordStrength: PasswordStrengthIndicator.PasswordStrength = .empty
    var message: Message? = nil
    @Binding var messageHeight: CGFloat
    var style: InputFieldStyle = .default
    let mode: Mode
    var suffixAction: (() -> Void)? = nil

    public var body: some View {
        FieldWrapper(
            fieldLabel,
            message: message,
            messageHeight: $messageHeight
        ) {
            InputContent(
                prefix: prefix,
                suffix: suffix,
                prefixAccessibilityID: .inputFieldPrefix,
                suffixAccessibilityID: .inputFieldSuffix,
                state: state,
                message: message,
                isEditing: isEditing,
                suffixAction: suffixAction
            ) {
                HStack(alignment: .firstTextBaseline, spacing: .small) {
                    compactLabel

                    input
                        .lineLimit(1)
                        .padding(.leading, leadingPadding)
                        .textFieldStyle(TextFieldStyle(leadingPadding: 0))
                        .autocapitalization(autocapitalization)
                        .disableAutocorrection(isAutocompleteEnabled == false)
                        .textContentType(textContent)
                        .keyboardType(keyboard)
                        .orbitFont(size: Text.Size.normal.value)
                        .accentColor(.blueNormal)
                        .background(textFieldPlaceholder, alignment: .leading)
                        .accessibility(.inputFieldValue)
                }
            }
        } footer: {
            PasswordStrengthIndicator(passwordStrength: passwordStrength)
                .padding(.top, .xxSmall)
        }
        .accessibilityElement(children: .ignore)
        .accessibility(label: .init(label))
        .accessibility(value: .init(value.description))
        .accessibility(hint: .init(messageDescription.isEmpty ? placeholder : messageDescription))
        .accessibility(addTraits: .isButton)
    }

    @ViewBuilder var input: some View {
        switch mode {
            case .actionsHandler(let onEditingChanged, let onCommit, let isSecure):
                if isSecure {
                    HStack(spacing: 0) {
                        secureField(onEditingChanged: onEditingChanged, onCommit: onCommit)
                        secureTextRedactedToggle
                    }
                } else {
                    textField(onEditingChanged: onEditingChanged, onCommit: onCommit)
                }
            case .formatter(let formatter):
                TextField("", value: $value, formatter: formatter)
        }
    }

    @ViewBuilder var textFieldPlaceholder: some View {
        if showPlaceholder {
            Text(placeholder)
                .foregroundColor(nil)
                .padding(.leading, leadingPadding)
                .foregroundColor(isEnabled ? state.placeholderColor : .cloudDarkActive)
        }
    }

    @ViewBuilder var compactLabel: some View {
        if style == .compact {
            Text(label)
                .foregroundColor(compactLabelColor)
                .fontWeight(.medium)
                .padding(.leading, prefix.isEmpty ? .small : 0)
        }
    }

    @ViewBuilder var secureTextRedactedToggle: some View {
        if value.description.isEmpty == false, isEnabled {
            Icon(isSecureTextRedacted ? .visibility : .visibilityOff, color: .inkNormal)
                .padding(.vertical, .xSmall)
                .padding(.horizontal, .small)
                .contentShape(Rectangle())
                .onTapGesture {
                    isSecureTextRedacted.toggle()
                }
                .accessibility(addTraits: .isButton)
                .accessibility(.inputFieldPasswordToggle)
                .padding(.vertical, 3) // = 44 height @ normal size
        }
    }

    @ViewBuilder func secureField(
        onEditingChanged: @escaping (Bool) -> Void,
        onCommit: @escaping () -> Void
    ) -> some View {
        SecureTextField(
            text: Binding(
                get: { self.value.description },
                set: { self.value = Value.init($0) ?? self.value }
            ),
            isSecured: $isSecureTextRedacted,
            isEditing: $isEditing,
            style: .init(
                textContentType: textContent,
                keyboardType: keyboard,
                font: .orbit(size: Text.Size.normal.value * sizeCategory.ratio, weight: .regular),
                state: state
            ),
            onEditingChanged: onEditingChanged,
            onCommit: onCommit
        )
    }

    @ViewBuilder func textField(
        onEditingChanged: @escaping (Bool) -> Void,
        onCommit: @escaping () -> Void
    ) -> some View {
        TextField(
            "",
            text: Binding(
                get: { self.value.description },
                set: { self.value = Value.init($0) ?? self.value }
            ),
            onEditingChanged: { isEditing in
                self.isEditing = isEditing
                onEditingChanged(isEditing)
            },
            onCommit: onCommit
        )
        .padding(.trailing, suffix == .none ? .small : 0)
    }

    var isSecure: Bool {
        switch mode {
            case .actionsHandler(_, _, let isSecure):
                return isSecure
            case .formatter(_):
                return false
        }
    }

    var fieldLabel: String {
        switch style {
            case .default:          return label
            case .compact:          return ""
        }
    }

    var messageDescription: String {
        message?.description ?? ""
    }

    var compactLabelColor: Color {
        showPlaceholder ? .inkDark : .inkLight
    }

    var showPlaceholder: Bool {
        value.description.isEmpty
    }

    var leadingPadding: CGFloat {
        prefix.isEmpty && style == .default ? .small : 0
    }
}

public extension InputField {

    /// Creates Orbit InputField component.
    ///
    /// - Parameters:
    ///     - message: Message below InputField.
    ///     - messageHeight: Binding to the current height of message.
    ///     - suffixAction: Optional separate action on suffix icon tap.
    init(
        _ label: String = "",
        value: Binding<Value>,
        prefix: Icon.Content = .none,
        suffix: Icon.Content = .none,
        placeholder: String = "",
        state: InputState = .default,
        textContent: UITextContentType? = nil,
        keyboard: UIKeyboardType = .default,
        autocapitalization: UITextAutocapitalizationType = .none,
        isAutocompleteEnabled: Bool = false,
        isSecure: Bool = false,
        passwordStrength: PasswordStrengthIndicator.PasswordStrength = .empty,
        message: Message? = nil,
        messageHeight: Binding<CGFloat> = .constant(0),
        style: InputFieldStyle = .default,
        onEditingChanged: @escaping (Bool) -> Void = { _ in },
        onCommit: @escaping () -> Void = {},
        suffixAction: (() -> Void)? = nil
    ) where Value == String {
        self.init(
            label: label,
            value: value,
            prefix: prefix,
            suffix: suffix,
            placeholder: placeholder,
            state: state,
            textContent: textContent,
            keyboard: keyboard,
            autocapitalization: autocapitalization,
            isAutocompleteEnabled: isAutocompleteEnabled,
            passwordStrength: passwordStrength,
            message: message,
            messageHeight: messageHeight,
            style: style,
            mode: .actionsHandler(onEditingChanged: onEditingChanged, onCommit: onCommit, isSecure: isSecure),
            suffixAction: suffixAction
        )
    }

    /// Creates Orbit InputField component using a provided Formatter
    /// that will format an input without changing underlying value when it's committed
    ///
    /// - Parameters:
    ///     - message: Message below InputField.
    ///     - messageHeight: Binding to the current height of message.
    ///     - formatter: A formatter to use when converting between the
    ///     string the user edits and the underlying value.
    ///     If `formatter` can't perform the conversion, the text field doesn't
    ///     modify `binding.value`.
    ///     - suffixAction: Optional separate action on suffix icon tap.
    init(
        _ label: String = "",
        value: Binding<Value>,
        prefix: Icon.Content = .none,
        suffix: Icon.Content = .none,
        placeholder: String = "",
        state: InputState = .default,
        textContent: UITextContentType? = nil,
        keyboard: UIKeyboardType = .default,
        autocapitalization: UITextAutocapitalizationType = .none,
        isAutocompleteEnabled: Bool = false,
        message: Message? = nil,
        messageHeight: Binding<CGFloat> = .constant(0),
        style: InputFieldStyle = .default,
        formatter: Formatter,
        suffixAction: (() -> Void)? = nil
    ) {
        self.init(
            label: label,
            value: value,
            prefix: prefix,
            suffix: suffix,
            placeholder: placeholder,
            state: state,
            textContent: textContent,
            keyboard: keyboard,
            autocapitalization: autocapitalization,
            isAutocompleteEnabled: isAutocompleteEnabled,
            passwordStrength: .empty,
            message: message,
            messageHeight: messageHeight,
            style: style,
            mode: .formatter(formatter: formatter),
            suffixAction: suffixAction
        )
    }
}

// MARK: - Types
public extension InputField {
    
    struct TextFieldStyle : SwiftUI.TextFieldStyle {
        
        let leadingPadding: CGFloat
        
        public init(leadingPadding: CGFloat = .xSmall) {
            self.leadingPadding = leadingPadding
        }
        
        public func _body(configuration: TextField<Self._Label>) -> some View {
            configuration
                .padding(.leading, leadingPadding)
                .padding(.vertical, .small)
        }
    }
}

// MARK: - Identifiers
public extension AccessibilityID {

    static let inputFieldPrefix             = Self(rawValue: "orbit.inputfield.prefix")
    static let inputFieldSuffix             = Self(rawValue: "orbit.inputfield.suffix")
    static let inputFieldValue              = Self(rawValue: "orbit.inputfield.value")
    static let inputFieldPasswordToggle     = Self(rawValue: "orbit.inputfield.password.toggle")
}

// MARK: - Previews
struct InputFieldPreviews: PreviewProvider {

    static let label = "Field label"
    static let longLabel = "Very \(String(repeating: "very ", count: 8))long multiline label"
    static let passwordLabel = "Password label"
    static let value = "Value"
    static let passwordValue = "someVeryLongPasswordValue"
    static let longValue = "\(String(repeating: "very ", count: 15))long value"
    static let placeholder = "Placeholder"
    static let helpMessage = "Help message"
    static let errorMessage = "Error message"
    static let longErrorMessage = "Very \(String(repeating: "very ", count: 8))long error message"

    static var previews: some View {
        PreviewWrapper {
            standalone
            styles
            sizing
            password
            mix
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        StateWrapper(value) { state in
            InputField(label, value: state, prefix: .grid, suffix: .grid, placeholder: placeholder, state: .default)
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var styles: some View {
        VStack(spacing: .medium) {
            Group {
                inputField(value: "", message: .none)
                inputField(value: "", prefix: .none, message: .help(helpMessage))
                inputField(value: "", suffix: .none, message: .error(errorMessage))
                Separator()
                inputField(value: longValue, prefix: .none, suffix: .none, message: .none)
                inputField(value: value, message: .help(helpMessage))
                inputField(value: value, message: .error(errorMessage))
                Separator()
            }

            Group {
                inputField(value: longValue, prefix: .none, suffix: .none, message: .none, style: .compact)
                inputField(value: "", prefix: .none, suffix: .none, message: .none, style: .compact)
                inputField(value: "", message: .error(errorMessage), style: .compact)
                inputField(value: value, message: .error(errorMessage), style: .compact)
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var sizing: some View {
        VStack(alignment: .leading, spacing: .small) {
            Group {
                inputField("", value: "", message: .none)
                inputField("", value: "", prefix: .none, suffix: .none)
                inputField("", value: "Value", prefix: .none, suffix: .none)
                inputField("", value: "", prefix: .grid, suffix: .none, placeholder: "")
                inputField("", value: "", prefix: .none, suffix: .none, placeholder: "")
                inputField("", value: "Password", prefix: .none, suffix: .none, isSecure: true)
                inputField("", value: "Password", prefix: .none, suffix: .none, isSecure: true)
                    .disabled(true)
            }
            .frame(width: 200)
            .measured()
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var password: some View {
        VStack(spacing: .medium) {
            inputField("Disabled", value: passwordValue, isSecure: true)
                .disabled(true)
            inputField(passwordLabel, value: passwordValue, isSecure: true)
            inputField(passwordLabel, value: "", prefix: .none, placeholder: "Input password", isSecure: true)
            inputField(passwordLabel, value: passwordValue, suffix: .none, isSecure: true, passwordStrength: .weak(title: "Weak"), message: .error("Error message"))
            inputField(passwordLabel, value: passwordValue, prefix: .none, suffix: .none, isSecure: true, passwordStrength: .medium(title: "Medium"), message: .help("Help message"))
            inputField(passwordLabel, value: passwordValue, isSecure: true, passwordStrength: .strong(title: "Strong"))
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var mix: some View {
        VStack(spacing: .medium) {
            inputField("Empty", value: "", prefix: .symbol(.grid, color: .blueDark), suffix: .symbol(.grid, color: .blueDark))
            inputField("Disabled, Empty", value: "", prefix: .countryFlag("cz"), suffix: .countryFlag("us"))
                .disabled(true)
            inputField("Disabled", value: "Disabled Value", prefix: .sfSymbol("info.circle.fill"), suffix: .sfSymbol("info.circle.fill"))
                .disabled(true)
            inputField("Modified from previous state", value: "Modified value", state: .modified)
            inputField("Focused", value: "Focused / Help", message: .help("Help message"))
            inputField(
                FieldLabelPreviews.longLabel,
                value: longValue,
                message: .error(longErrorMessage)
            )
            .textLinkColor(.status(.critical))
            .textAccentColor(.orangeNormal)
            
            inputField("Compact", style: .compact)

            HStack(spacing: .medium) {
                inputField(value: "No label")
                inputField(value: "Flag prefix", prefix: .countryFlag("us"))
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static func inputField(
        _ label: String = label,
        value: String = value,
        prefix: Icon.Content = .grid,
        suffix: Icon.Content = .grid,
        placeholder: String = placeholder,
        state: InputState = .default,
        isSecure: Bool = false,
        passwordStrength: PasswordStrengthIndicator.PasswordStrength = .empty,
        message: Message? = nil,
        style: InputFieldStyle = .default
    ) -> some View {
        StateWrapper(value) { value in
            InputField(
                label,
                value: value,
                prefix: prefix,
                suffix: suffix,
                placeholder: placeholder,
                state: state,
                isSecure: isSecure,
                passwordStrength: passwordStrength,
                message: message,
                style: style
            )
        }
    }
}

struct InputFieldLivePreviews: PreviewProvider {

    class UppercaseAlphabetFormatter: Formatter {

        override func string(for obj: Any?) -> String? {
            guard let string = obj as? String else { return nil }

            return string.uppercased()
        }

        override func getObjectValue(
            _ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
            for string: String,
            errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?
        ) -> Bool {
            obj?.pointee = string.lowercased() as AnyObject
            return true
        }
    }

    static var previews: some View {
        PreviewWrapper()
        securedWrapper
    }
    
    struct PreviewWrapper: View {

        @State var message: Message? = nil
        @State var textValue = "12"
        @State var intValue = 0

        init() {
            Font.registerOrbitFonts()
        }

        var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: .medium) {
                    Heading("Heading", style: .title2)

                    Text("Some text, but also very long and multi-line to test that it works.")

                    InputField(
                        "InputField",
                        value: $textValue,
                        suffix: .email,
                        placeholder: "Placeholder",
                        message: message,
                        suffixAction: {
                            intValue = 1
                        }
                    )
                    .disabled(true)

                    Text("Some text, but also very long and multi-line to test that it works.")

                    VStack(alignment: .leading, spacing: .medium) {
                        Text("InputField uppercasing the input, but not changing projected value:")

                        InputField(
                            value: $textValue,
                            placeholder: "Uppercased",
                            formatter: UppercaseAlphabetFormatter()
                        )

                        Text("Number: \(intValue)")

                        InputField(
                            value: $intValue,
                            placeholder: "Decimal formatter",
                            formatter: formatter
                        )
                    }

                    Spacer(minLength: 0)

                    Button("Change") {
                        switch message {
                            case .none:
                                message = .normal("Secondary label")
                            case .normal:
                                message = .help(
                                    "Help message, but also very long and multi-line to test that it works."
                                )
                            case .help:
                                message = .warning("Warning text")
                            case .warning:
                                message = .error(
                                    "Error message, also very long and multi-line to test that it works."
                                )
                            case .error:
                                message = .none
                        }
                    }
                }
                .animation(.easeOut(duration: 0.25), value: message)
                .padding(.medium)
            }
            .previewDisplayName("Run Live Preview with Input Field")
        }

        let formatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter
        }()
    }

    static var securedWrapper: some View {
        StateWrapper("textfield-should-respect-long-password-and-screen-bounds-1234567890") { state in
            VStack(alignment: .leading, spacing: .medium) {
                Heading("Secured TextField with long init value", style: .title2)

                InputField(
                    value: state,
                    suffix: .none,
                    textContent: .password,
                    isSecure: true,
                    passwordStrength: validate(password: state.wrappedValue)
                )
            }
            .padding()
            .previewDisplayName()

        }
    }

    static func validate(password: String) -> PasswordStrengthIndicator.PasswordStrength {
        switch password.count {
            case 0:         return .empty
            case 1...3:     return .weak(title: "Weak")
            case 4...6:     return .medium(title: "Medium")
            default:        return .strong(title: "Strong")
        }
    }
}
