import SwiftUI

public struct CCCustomTabView<TabItem: CCTabDestination, TabView: View>: View {
    
    @StateObject public var viewModel: CCTabViewModel<TabItem>
    public var tabView: () -> TabView
    
    public init(viewModel: CCTabViewModel<TabItem>, tabView: @escaping () -> TabView) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.tabView = tabView
    }
    
    public var body: some View {
        CCLifeCycleView(viewModel: viewModel) {
            tabView()
        }
    }
}
