import Foundation

open class CCTabViewModel<TabItem: CCTabDestination>: CCLifeCycleViewModel, ObservableObject {
    
    public let navigationService: CCNavigationService
    @Published public var selectedItem: TabItem
    @Published var bagdes: [TabItem: String?]
    public var items: [TabItem]
    
    public init(
        navigationService: CCNavigationService,
        selectedItem: TabItem,
        items: [TabItem]
    ) {
        self.navigationService = navigationService
        self.selectedItem = selectedItem
        self.items = items
        
        self.bagdes = Dictionary(uniqueKeysWithValues: items.map { ($0, nil) })
    }
    
    public func getBagde(for item: TabItem) -> String? {
        bagdes[item] ?? nil
    }
    
    func changeBagde(for item: TabItem, to bagde: String?) {
        bagdes.updateValue(bagde, forKey: item)
    }
    
    override func onAppear() {
        super.onAppear()
        navigationService.register(self)
    }
    
    override func onDisappear() {
        super.onDisappear()
        navigationService.unregister(self)
    }
}
