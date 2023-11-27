import Foundation
import SwiftUI

struct CCTabView<TabItem: CCTabDestination>: View {
    
    @StateObject var viewModel: CCTabViewModel<TabItem>
    var hideNativeTabBar = false
    
    var body: some View {
        CCLifeCycleView(viewModel: viewModel) {
            TabView(selection: $viewModel.selectedItem) {
                Group {
                    ForEach(viewModel.items) { item in
                        item.buildRootView()
                            .tag(item)
                            .tabItem {
                                item.buildItemView()
                            }
                    }
                }
                .toolbarBackground(hideNativeTabBar ? Visibility.hidden : .automatic, for: .tabBar)
            }
        }
    }
}
