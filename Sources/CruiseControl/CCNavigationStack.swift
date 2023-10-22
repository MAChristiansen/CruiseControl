import Foundation
import SwiftUI

public class CCNavigationStack<Destination: CCDestination>: ObservableObject {
    @Published var stack = [Destination]()
    @Published var sheet: Destination?
    @Published var presentSheetAlert: Bool = false
    @Published var presentAlert: Bool = false
    var alert: AlertModel?
    
    public init() { }
    
    func dismissAlert() {
        presentAlert = false
        presentSheetAlert = false
        alert = nil
    }
}
