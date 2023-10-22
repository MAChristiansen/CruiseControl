import Foundation
import SwiftUI




public struct CCNavigationView<Destination: CCDestination, RootView: View>: View {
    
    @ObservedObject private var navigationStack: CCNavigationStack<Destination>
    private var rootView: () -> RootView
    
    public init(navigationStack: CCNavigationStack<Destination>, rootView: @escaping () -> RootView) {
        self.navigationStack = navigationStack
        self.rootView = rootView
    }
    
    public var body: some View {
        NavigationStack(path: $navigationStack.stack) {
            rootView()
                .navigationDestination(for: Destination.self) { view in
                    view.buildView()
                }
        }
        .onAppear {
            navigationService?.register(navigationStack)
        }
        .onDisappear {
            navigationService?.unregister(navigationStack)
        }
        .sheet(isPresented: .constant(navigationStack.sheet != nil), onDismiss: {
            navigationStack.sheet = nil
        }) {
            navigationStack.sheet!.buildView()
                .alert(navigationStack.alert?.title ?? "", isPresented: $navigationStack.presentSheetAlert) {
                    ForEach(navigationStack.alert?.buttons ?? []) { button in
                        Button(button.title, role: button.role) {
                            button.action()
                        }
                    }
                }
        }
        .alert(navigationStack.alert?.title ?? "", isPresented: $navigationStack.presentAlert) {
            ForEach(navigationStack.alert?.buttons ?? []) { button in
                Button(button.title, role: button.role) {
                    button.action()
                }
            }
        }
    }
}
