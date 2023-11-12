import SwiftUI

public extension View {
    
    func alwaysPopover<Content: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        background(PopoverAnchorView(popoverContent: content, isPresented: isPresented))
    }
}
