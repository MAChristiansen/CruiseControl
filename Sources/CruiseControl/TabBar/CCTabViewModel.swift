import Foundation

public class CCTabViewModel<TabItem: CCTabDestination>: CCLifeCycleViewModel, ObservableObject {
    
    private let navigationService: CCNavigationService
    @Published var selectedItem: TabItem
    @Published var bagdes: [TabItem: String?]
    var items: [TabItem]
    
    public init(navigationService: CCNavigationService, selectedItem: TabItem, items: [TabItem]) {
        self.navigationService = navigationService
        self.selectedItem = selectedItem
        self.items = items
        
        self.bagdes = Dictionary(uniqueKeysWithValues: items.map { ($0, nil) })
    }
    
    func getBagde(for item: TabItem) -> String? {
        bagdes[item] ?? nil
    }
    
    func changeBagde(for item: TabItem, to bagde: String?) {
        bagdes.updateValue(bagde, forKey: item)
    }
    
    override func onAppear() {
        navigationService.register(self)
    }
    
    override func onDisappear() {
        navigationService.unregister(self)
    }
}
