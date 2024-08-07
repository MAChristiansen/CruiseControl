import Foundation
import OSLog

public protocol CCNavigationServiceDelegate {
    func onWarning(_ description: String)
    func onError(_ error: Error)
}

public protocol CCSheetDelegate {
    func onSheetDismissed(_ destination: any CCDestination)
}

open class CCNavigationService {
    
    private var navigationObjects = [AnyObject]()
    public var delegate: CCNavigationServiceDelegate?
    public var sheetDelegate: CCSheetDelegate?

    public init(delegate: CCNavigationServiceDelegate? = nil) {
        self.delegate = delegate
    }
    
    /// Registers the navigation stack. You must register your navigation stack before you can perform navigation actions on it. You can't register multiple stack of the same type.
    /// - Parameter stack: The navigation stack you want to register
    func register<T: CCDestination>(_ stack: CCNavigationStack<T>) {
        if navigationObjects.filter({ $0 is CCNavigationStack<T> }).count > 0 {
            delegate?.onError(CCNavigationServiceError.destinationStackAlreadyRegistered)
            return
        }
        
        navigationObjects.append(stack)
    }
    
    /// Unregisters the navigations stack that is provided as parameter.
    /// - Parameter stack: The navigation stack you want to unregister
    func unregister<T: CCDestination>(_ stack: CCNavigationStack<T>) {
        navigationObjects.removeAll { $0 is CCNavigationStack<T> }
    }
    
    /// Registers a tab bar. You must register your tab bar before you can perform navigation actions on it. You can't register multiple stack of the same type.
    func register<T: CCTabDestination>(_ tabView: CCTabViewModel<T>) {
        if navigationObjects.filter({ $0 is CCTabViewModel<T> }).count > 0 {
            delegate?.onError(CCNavigationServiceError.destinationTabBarAlreadyRegistered)
            return
        }
        
        navigationObjects.append(tabView)
    }
    
    /// Unregisters the tab bar
    func unregister<T: CCTabDestination>(_ tabView: CCTabViewModel<T>) {
        navigationObjects.removeAll { $0 is CCTabViewModel<T> }
    }
    
    /// Changes the tab for the requested TabBar.
    public func changeTab<T: CCTabDestination>(_ newTab: T) {
        onMainThread {
            let tabBar = try self.getTabBar(newTab)
            
            if !tabBar.items.contains(newTab) {
                throw CCNavigationServiceError.tabBarDoesNotHaveRequestedTab
            }
            
            tabBar.selectedItem = newTab
        }
    }
    
    /// Changes the bagde for the requested Tab..
    public func changeTabBagde<T: CCTabDestination>(for item: T, to newBagde: String?) {
        onMainThread {
            let tabBar = try self.getTabBar(item)
            
            if !tabBar.items.contains(item) {
                throw CCNavigationServiceError.tabBarDoesNotHaveRequestedTab
            }
            
            tabBar.changeBagde(for: item, to: newBagde)
        }
    }
    
    /// Will present a sheet with the provided destination. Note: You can't display a sheet on a sheet. This action is done on the Main Dispatch queue.
    /// - Parameter destination: The destination of your sheet
    public func display<T: CCDestination>(_ destination: T) {
        onMainThread {
            let navigationStack = try self.getNavigationStack(for: destination)
            if navigationStack.sheet != nil {
                return
            }
            
            navigationStack.sheet = destination
        }
    }
    
    /// Will present a system alert based on the model provided. Note: You can't display an alert on another alert. This action is done on the Main Dispatch queue.
    /// - Parameter type: The type of the navigation stack you want to present the alert
    /// - Parameter alertModel: The system alert will be create by this model
    public func display<T: CCDestination>(_ type: T.Type, alertModel: AlertModel) {
        onMainThread {
            let navigationStack = try self.getNavigationStack(forType: type)
            if navigationStack.alert != nil {
                return
            }
            
            navigationStack.alert = alertModel
            
            if navigationStack.sheet != nil {
                navigationStack.presentSheetAlert = true
            } else {
                navigationStack.presentAlert = true
            }
        }
    }
    
    /// Dismiss the sheet on the given navigation stack
    /// - Parameter type: The navigation stack you want to dismiss your sheet
    public func dismissSheet<T: CCDestination>(_ type: T.Type) {
        onMainThread {
            let navigationStack = try self.getNavigationStack(forType: type)
            navigationStack.sheet = nil
        }
    }
    
    /// Dismiss the alert on the given navigation stack
    /// - Parameter type: The navigation stack you want to dismiss your alert
    public func dismissAlert<T: CCDestination>(_ type: T.Type) {
        onMainThread {
            let navigationStack = try self.getNavigationStack(forType: type)
            navigationStack.dismissAlert()
        }
    }
    
    /// Pushes destination on the according navigation stack. This action is done on the Main Dispatch queue.
    /// - Parameter destination: The destination to be presented
    public func push<T: CCDestination>(_ destination: T) {
        onMainThread {
            try self.getNavigationStack(for: destination)
                .stack
                .append(destination)
        }
    }
    
    /// Pushes a list of destinations on the according navigation stack. This action is done on the Main Dispatch queue.
    /// - Parameter destinations: The destinations to be presented
    public func push<T: CCDestination>(_ destinations: [T]) {
        onMainThread {
            guard let firstDestination = destinations.first else { return }

            try self.getNavigationStack(for: firstDestination)
                .stack
                .append(contentsOf: destinations)
        }
    }
    
    /// Creates a  stack on the according navigation stack. This will override the existing stack.  This action is done on the Main Dispatch queue.
    /// - Parameter destinations: The destinations to be presented
    public func createStack<T: CCDestination>(_ destinations: [T]) {
        onMainThread {
            try self.getNavigationStack(for: destinations.first!)
                .stack = destinations
        }
    }
    
    /// Pops the provided numbers of views from the specified navigation stack. The default will only pop the top view. This action is done on the Main Dispatch queue.
    /// - Parameters:
    ///   - type: Navigation stack type
    ///   - last: The numbers of views that will be popped.
    public func pop<T: CCDestination>(_ type: T.Type, last: Int = 1) {
        onMainThread {
            try self.getNavigationStack(forType: type)
                .stack
                .removeLast(last)
        }
    }
    
    /// Pops to the specified lcoation in the according navigation stack. This action is done on the Main Dispatch queue.
    /// - Parameter destination: The destination that will be popped to
    public func pop<T: CCDestination>(to destination: T) {
        onMainThread {
            let navigationStack = try self.getNavigationStack(for: destination)
            
            guard let destinationIndex = navigationStack.stack.firstIndex(of: destination) else {
                self.delegate?.onWarning("The specified destination is not in the navigation stack.")
                return
            }
            
            let range = destinationIndex+1..<navigationStack.stack.endIndex
            
            navigationStack
                .stack
                .removeSubrange(range)
        }
    }
    
    /// Pops to the root of the specified navigation stack. This action is done on the Main Dispatch queue.
    /// - Parameter type: Navigation stack type
    public func popToRoot<T: CCDestination>(_ type: T.Type) {
        onMainThread {
            try self.getNavigationStack(forType: type)
                .stack
                .removeAll()
        }
    }
    
    private func getNavigationStack<T: CCDestination>(for destination: T) throws -> CCNavigationStack<T> {
        for stack in navigationObjects {
            if let navigationStack = stack as? CCNavigationStack<T> {
                return navigationStack
            }
        }
        
        throw CCNavigationServiceError.navigationStackNotMatchingDestinationType
    }
    
    private func getNavigationStack<T: CCDestination>(forType type: T.Type) throws -> CCNavigationStack<T> {
        for stack in navigationObjects {
            if let navigationStack = stack as? CCNavigationStack<T> {
                return navigationStack
            }
        }
        
        throw CCNavigationServiceError.navigationStackNotMatchingDestinationType
    }
    
    private func getTabBar<T: CCTabDestination>(_ newTab: T) throws -> CCTabViewModel<T> {
        for objects in navigationObjects {
            if let tabBar = objects as? CCTabViewModel<T> {
                return tabBar
            }
        }
        
        throw CCNavigationServiceError.tabBarNotMatchingDestinationType
    }
    
    private func onMainThread(_ action: @escaping () throws -> Void) {
        DispatchQueue.main.async {
            do {
                try action()
            } catch {
                self.delegate?.onError(error)
            }
        }
    }
}

enum CCNavigationServiceError: Error {
    case navigationStackNotMatchingDestinationType
    case tabBarNotMatchingDestinationType
    case destinationStackAlreadyRegistered
    case destinationTabBarAlreadyRegistered
    case tabBarDoesNotHaveRequestedTab
}
