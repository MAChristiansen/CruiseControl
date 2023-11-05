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
            navigationStack.onAppear()
        }
        .onDisappear {
            navigationStack.onDisappear()
        }
        .sheet(isPresented: .constant(navigationStack.sheet != nil), onDismiss: {
            navigationStack.sheet = nil
        }) {
            navigationStack.sheet!.buildView()
                .presentAlert(navigationStack.alert, isPresented: $navigationStack.presentSheetAlert)
        }
        .presentAlert(navigationStack.alert, isPresented: $navigationStack.presentAlert)
    }
}

extension View {
    @ViewBuilder
    func presentAlert(_ model: AlertModel?, isPresented: Binding<Bool>) -> some View {
        self
            .alert(model?.title ?? "", isPresented: isPresented) {
                ForEach(model?.buttons ?? []) { button in
                    Button(button.title, role: button.role) {
                        button.action()
                    }
                }
            } message: {
                Text(model?.message ?? "")
            }
    }
}
