import SwiftUI

struct CCCustomTabView<TabItem: CCTabDestination, TabView: View>: View {
    
    @StateObject var viewModel: CCTabViewModel<TabItem>
    var tabView: () -> TabView
    
    var body: some View {
        CCLifeCycleView(viewModel: viewModel) {
            tabView()
        }
    }
}
