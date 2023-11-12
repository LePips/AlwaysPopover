import SwiftUI

class ContentViewController<Content: View>: UIHostingController<Content>, UIPopoverPresentationControllerDelegate {
    
    private var isPresented: Binding<Bool>
    
    init(rootView: Content, isPresented: Binding<Bool>) {
        self.isPresented = isPresented
        super.init(rootView: rootView)
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preferredContentSize = sizeThatFits(in: UIView.layoutFittingExpandedSize)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        .none
    }

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        isPresented.wrappedValue = false
    }
    
    // `presentationControllerDidDismiss` will not be called when using SwiftUI's `dismiss`
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if isPresented.wrappedValue {
            isPresented.wrappedValue = false
        }
    }
}
