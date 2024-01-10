import SwiftUI
import Orbit

struct TutorialScreen: View {

    var primaryAction = {}
    var alertAction = {}
    var secondaryAction = {}
    
    var body: some View {
        VStack(spacing: .large) {
            Card("Card Title") {
                List {
                    ListItem("List Item 1", icon: .check)
                        .iconColor(.greenNormal)
                    ListItem("List Item 2 with a <a href=\"...\">TextLink</a>", icon: .check)
                    ListItem("List Item 3")
                }
                
                Alert("Alert", description: "Alert Desctiption with a <a href=\"...\">TextLink</a>") {
                    Button("Action") {
                        alertAction()
                    }
                }
                
                HStack(spacing: .medium) {
                    Button("Secondary Button", type: .secondary, action: secondaryAction)
                    Button(icon: .creditCard, type: .status(.warning), action: {})
                }
            } action: {
                ButtonLink("Edit", action: {})
            }
            
            VStack(alignment: .leading, spacing: .medium) {
                Text("""
                    Multi-line very long text containing <a href="...">TextLink</a> \
                    and <a href="...">Some other TextLink</a>"
                    """
                )
                
                Badge("Badge", type: .status(.info, inverted: true))
                
                Button("Primary Button", action: primaryAction)
            }
            .padding(.horizontal, .medium)
        }
        .padding(.vertical, .medium)
        .background(Color.screen)
    }
}

struct TutorialScreenPreviews: PreviewProvider {
    static var previews: some View {
        OrbitPreviewWrapper {
            TutorialScreen()
        }
        .previewLayout(.sizeThatFits)
    }
}
