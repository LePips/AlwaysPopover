import AlwaysPopover
import SwiftUI

struct ContentView: View {
    
    @State
    private var isFirstPopoverPresented: Bool = false
    @State
    private var isSecondPopoverPresented: Bool = false
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            Button {
                isFirstPopoverPresented = true
            } label: {
                Text("Present Popover!")
            }
            .alwaysPopover(isPresented: $isFirstPopoverPresented) {
                VStack {
                    
                    Text("1")
                        .fontWeight(.bold)
                    
                    Text("I should always be in a popover")
                    
                    Button("Dismiss") {
                        isFirstPopoverPresented = false
                    }
                }
                .padding()
            }
            
            Button {
                isSecondPopoverPresented = true
            } label: {
                Text("Present Another Popover!")
            }
            .alwaysPopover(isPresented: $isSecondPopoverPresented) {
                CustomPopoverContent()
            }
        }
        .padding()
    }
}

struct CustomPopoverContent: View {
    
    @Environment(\.dismiss)
    private var dismiss
    
    var body: some View {
        VStack {
            
            Text("2")
                .fontWeight(.bold)
            
            Text("I should always be in a popover")
            
            Button("Dismiss") {
                dismiss()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
