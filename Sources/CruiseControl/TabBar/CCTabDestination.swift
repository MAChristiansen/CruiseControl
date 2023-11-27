import Foundation
import SwiftUI

public protocol CCTabDestination: Hashable, Identifiable {
    associatedtype Root: View
    associatedtype Item: View
    
    @ViewBuilder
    func buildRootView() -> Root
    
    @ViewBuilder
    func buildItemView() -> Item
}
