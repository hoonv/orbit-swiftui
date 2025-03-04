import SwiftUI
import Orbit

struct StorybookListChoice {

    static let title = "ListChoice tile"
    static let description = "Further description"
    static let value = "Value"
    static let badge = Badge("3", type: .status(.info, inverted: false))
    static let addButton = ListChoiceDisclosure.button(type: .add)
    static let removeButton = ListChoiceDisclosure.button(type: .remove)
    static let uncheckedCheckbox = ListChoiceDisclosure.checkbox(isChecked: false)
    static let checkedCheckbox = ListChoiceDisclosure.checkbox(isChecked: true)

    static var basic: some View {
        Card(contentPadding: 0) {
            ListChoice(title, action: {})
            ListChoice(title, value: "10", action: {})
            ListChoice(title, description: description, action: {})
            ListChoice(title, description: "Multiline\ndescription", value: "USD", action: {})
            ListChoice(title, icon: .airplane, action: {})
            ListChoice(title, icon: .airplane, value: value, action: {})
            ListChoice(title, description: description, icon: .airplane, action: {})
            ListChoice(title, description: description, icon: .airplane, value: value, action: {})
            ListChoice(title, description: description, action: {}) {
                EmptyView()
            } header: {
                badge
            }
            ListChoice(title, description: description, icon: .grid, action: {}) {
                EmptyView()
            } header: {
                badge
            }
        }
        .previewDisplayName()
    }

    static var button: some View {
        Card(contentPadding: 0) {
            ListChoice(title, disclosure: addButton, action: {})
            ListChoice(title, disclosure: removeButton, action: {})
            ListChoice(title, description: description, disclosure: addButton, action: {})
            ListChoice(title, description: description, disclosure: removeButton, action: {})
            ListChoice(title, icon: .airplane, disclosure: addButton, action: {})
            ListChoice(title, icon: .airplane, disclosure: removeButton, action: {})
            ListChoice(title, description: description, icon: .airplane, disclosure: addButton, action: {})
            ListChoice(title, description: description, icon: .airplane, disclosure: removeButton, action: {})
            ListChoice(title, description: description, icon: .airplane, value: value, disclosure: addButton, action: {})
            ListChoice(title, description: description, icon: .airplane, disclosure: removeButton, action: {}) {
                contentPlaceholder
            } header: {
                headerContent
            }
        }
        .previewDisplayName()
    }

    static var checkbox: some View {
        Card(contentPadding: 0) {
            ListChoice(title, disclosure: uncheckedCheckbox, action: {})
            ListChoice(title, disclosure: checkedCheckbox, action: {})
            ListChoice(title, description: description, disclosure: .checkbox(state: .error), action: {})
            ListChoice(title, description: description, disclosure: .checkbox(), action: {})
                .disabled(true)
            ListChoice(title, icon: .airplane, disclosure: .checkbox(isChecked: false, state: .error), action: {})
            ListChoice(title, icon: .airplane, disclosure: .checkbox(isChecked: false), action: {})
                .disabled(true)
            ListChoice(title, description: description, icon: .airplane, disclosure: uncheckedCheckbox, action: {})
            ListChoice(title, description: description, icon: .airplane, disclosure: checkedCheckbox, action: {})
            ListChoice(title, description: description, icon: .airplane, value: value, disclosure: uncheckedCheckbox, action: {})
            ListChoice(title, description: description, icon: .airplane, disclosure: checkedCheckbox, action: {}) {
                contentPlaceholder
            } header: {
                headerContent
            }
        }
        .previewDisplayName()
    }

    static var mix: some View {
        VStack(alignment: .leading, spacing: .large) {
            plain
            radio
        }
    }

    static var plain: some View {
        Card(contentPadding: 0) {
            ListChoice(title, disclosure: .none, action: {})
            ListChoice(title, description: description, disclosure: .none, action: {})
            ListChoice(title, description: "No Separator", disclosure: .none, showSeparator: false, action: {})
            ListChoice(title, icon: .airplane, disclosure: .none, action: {})
            ListChoice(title, icon: .airplane, disclosure: .none, action: {})
                .iconColor(.blueNormal)
            ListChoice(title, description: description, disclosure: .none) {
                // No action
            } icon: {
                CountryFlag("us")
            }
            ListChoice(title, description: description, icon: .grid, value: value, disclosure: .none, action: {})
            ListChoice(title, description: description, disclosure: .none, action: {}) {
                EmptyView()
            } header: {
                badge
            }
            ListChoice(disclosure: .none, action: {}) {
                contentPlaceholder
            } header: {
                headerContent
            }
        }
    }

    static var radio: some View {
        Card(contentPadding: 0) {
            ListChoice(title, description: description, disclosure: .radio(isChecked: false), action: {})
            ListChoice(title, description: description, disclosure: .radio(isChecked: true), action: {})
            ListChoice(title, description: description, disclosure: .radio(state: .error), action: {})
            ListChoice(title, description: description, disclosure: .radio(), action: {})
                .disabled(true)
            ListChoice(title, icon: .airplane, disclosure: .radio(isChecked: false, state: .error), action: {})
            ListChoice(title, icon: .airplane, disclosure: .radio(isChecked: false), action: {})
                .disabled(true)
            ListChoice(
                title,
                description: description,
                icon: .airplane,
                disclosure: .radio(isChecked: false),
                action: {}
            ) {
                contentPlaceholder
            } header: {
                headerContent
            }
        }
        .previewDisplayName("Radio")
    }

    static var headerContent: some View {
        Text("Custom\nheader content")
            .padding(.vertical, .medium)
            .frame(maxWidth: .infinity)
            .background(Color.blueLightActive)
    }
}

struct StorybookListChoicePreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookListChoice.basic
            StorybookListChoice.button
            StorybookListChoice.checkbox
            StorybookListChoice.mix
        }
    }
}
