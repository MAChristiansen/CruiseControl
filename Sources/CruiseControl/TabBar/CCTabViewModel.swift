import Foundation

public class CCTabViewModel<TabItem: CCTabDestination>: CCLifeCycleViewModel, ObservableObject {
    
    private let navigationService: CCNavigationService
    @Published var selectedItem: TabItem
    var items: [TabItem]
    
    init(navigationService: CCNavigationService, selectedItem: TabItem, items: [TabItem]) {
        self.navigationService = navigationService
        self.selectedItem = selectedItem
        self.items = items
    }
    
    override func onAppear() {
        navigationService.register(self)
    }
    
    override func onDisappear() {
        navigationService.unregister(self)
    }
}
