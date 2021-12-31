import SwiftUI

/// Orbit label above form fields.
public struct FormFieldLabel: View {

    let label: String

    public var body: some View {
        Text(label, size: .normal, weight: .medium)
            .padding(.bottom, .xxSmall)
    }

    public init(_ label: String) {
        self.label = label
    }
}
