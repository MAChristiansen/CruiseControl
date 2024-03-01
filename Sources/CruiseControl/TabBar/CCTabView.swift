import Foundation
import SwiftUI

public struct CCTabView<TabItem: CCTabDestination>: View {
    
    @StateObject var viewModel: CCTabViewModel<TabItem>
    
    public init(viewModel: CCTabViewModel<TabItem>) {
        self._viewModel = StateObject(wrappedValue: viewModel)
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
            }
        }
    }
}
