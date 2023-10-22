import Foundation
import SwiftUI

public struct AlertButton: Identifiable {
    public var id = UUID().uuidString
    
    public var title: String
    public var role: ButtonRole?
    public var action: () -> Void
    
    public init(title: String, role: ButtonRole? = nil, action: @escaping () -> Void) {
        self.title = title
        self.role = role
        self.action = action
    }
}
