import SwiftUI

struct PopoverAnchorView<PopoverContent: View>: UIViewRepresentable {
    
    private let popoverContent: () -> PopoverContent
    private let isPresented: Binding<Bool>
    private var lastPresentationValue: Bool
    
    init(
        popoverContent: @escaping () -> PopoverContent,
        isPresented: Binding<Bool>
    ) {
        self.popoverContent = popoverContent
        self.isPresented = isPresented
        self.lastPresentationValue = isPresented.wrappedValue
    }
    
    func makeUIView(context: Context) -> some UIView {
        context.coordinator.anchorView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(isPresented: isPresented, popoverContent: popoverContent)
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        context.coordinator.update(with: isPresented.wrappedValue)
    }
    
    // MARK: Coordinator
    
    class Coordinator {
        
        let anchorView: UIView
        let isPresented: Binding<Bool>
        let popoverContent: () -> PopoverContent
        private var lastPresentationValue: Bool
        
        init(isPresented: Binding<Bool>, popoverContent: @escaping () -> PopoverContent) {
            self.anchorView = UIView()
            self.isPresented = isPresented
            self.popoverContent = popoverContent
            self.lastPresentationValue = isPresented.wrappedValue
        }
        
        func update(with newValue: Bool) {
            guard lastPresentationValue != newValue else { return }
            lastPresentationValue = newValue
            
            if newValue {
                presentPopover()
            } else {
                dismissPopover()
            }
        }
        
        // MARK: dismissPopover
        
        private func dismissPopover() {
            guard let sourceVC = anchorView.closestVC() else {
                return
            }

            if let presentedVC = sourceVC.presentedViewController {
                presentedVC.dismiss(animated: true)
            }
        }
        
        // MARK: presentPopover
        
        private func presentPopover() {
            let contentController = ContentViewController(rootView: popoverContent(), isPresented: isPresented)
            contentController.modalPresentationStyle = .popover

            guard let popover = contentController.popoverPresentationController else { return }
            popover.sourceView = anchorView
            popover.sourceRect = anchorView.bounds
            popover.delegate = contentController

            guard let sourceViewController = anchorView.closestVC() else { return }

            if let presentedVC = sourceViewController.presentedViewController {
                presentedVC.dismiss(animated: true) {
                    sourceViewController.present(contentController, animated: true)
                }
            } else {
                sourceViewController.present(contentController, animated: true)
            }
        }
    }
}
