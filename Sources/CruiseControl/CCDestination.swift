import Foundation
import SwiftUI

public protocol CCDestination: Hashable {
    associatedtype Content: View
    
    @ViewBuilder
    func buildView() -> Content
}
