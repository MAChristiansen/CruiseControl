import Foundation
import SwiftUI

public struct CCTabView<TabItem: CCTabDestination>: View {
    
    @ObservedObject var viewModel: CCTabViewModel<TabItem>
    public var hideNativeTabBar = false
    
    public init(viewModel: CCTabViewModel<TabItem>, hideNativeTabBar: Bool = false) {
        self.viewModel = viewModel
        self.hideNativeTabBar = hideNativeTabBar
    }
    
    public var body: some View {
        CCLifeCycleView(viewModel: viewModel) {
            TabView(selection: $viewModel.selectedItem) {
                Group {
                    ForEach(viewModel.items) { item in
                        item.buildRootView()
                            .tag(item)
                            .tabItem {
                                item.buildItemView()
                            }
                            .badge(viewModel.getBagde(for: item))
                    }
                }
                .toolbarBackground(hideNativeTabBar ? Visibility.hidden : .automatic, for: .tabBar)
            }
        }
    }
}
