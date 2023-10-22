import Foundation

public struct AlertModel {
    public var title: String
    public var message: String
    public var buttons: [AlertButton]
    
    public init(title: String, message: String, buttons: [AlertButton]) {
        self.title = title
        self.message = message
        self.buttons = buttons
    }
}
