import SwiftUI

public struct CCCustomTabView<TabItem: CCTabDestination, TabView: View>: View {
    
    @StateObject public var viewModel: CCTabViewModel<TabItem>
    public var tabView: () -> TabView
    
    public var body: some View {
        CCLifeCycleView(viewModel: viewModel) {
            tabView()
        }
    }
}
