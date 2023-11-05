import Foundation
import SwiftUI

public class CCNavigationStack<Destination: CCDestination>: ObservableObject {
    @Published var stack = [Destination]()
    @Published var sheet: Destination?
    @Published var presentSheetAlert: Bool = false
    @Published var presentAlert: Bool = false
    var alert: AlertModel?
    
    private let navigationService: CCNavigationService
    
    public init(navigationService: CCNavigationService) {
        self.navigationService = navigationService
    }
    
    func dismissAlert() {
        presentAlert = false
        presentSheetAlert = false
        alert = nil
    }
    
    func onAppear() {
        navigationService.register(self)
    }
    
    func onDisappear() {
        navigationService.unregister(self)
    }
}
