import SwiftUI

/// 
@available(iOS 13, *)
@available(macCatalyst 13, *)
@available(macOS, unavailable)
@available(tvOS 13, *)
@available(watchOS 6, *)
public enum ActionSheetState<Action> {
  case dismissed
  case show(ActionSheet)

  public struct ActionSheet {
    public var buttons: [Button]
    public var message: String?
    public var title: String

    public init(
      buttons: [Button],
      message: String? = nil,
      title: String
    ) {
      self.buttons = buttons
      self.message = message
      self.title = title
    }

    public struct Button {
      public var action: Action
      public var label: String
      public var type: `Type`

      public init(
        action: Action,
        label: String,
        type: `Type` = .default
      ) {
        self.action = action
        self.label = label
        self.type = type
      }

      public enum `Type` {
        case cancel
        case `default`
        case destructive
      }
    }
  }
}

@available(iOS 13, *)
@available(macCatalyst 13, *)
@available(macOS, unavailable)
@available(tvOS 13, *)
@available(watchOS 6, *)
extension ActionSheetState: Equatable where Action: Equatable {}

@available(iOS 13, *)
@available(macCatalyst 13, *)
@available(macOS, unavailable)
@available(tvOS 13, *)
@available(watchOS 6, *)
extension ActionSheetState: Hashable where Action: Hashable {}

@available(iOS 13, *)
@available(macCatalyst 13, *)
@available(macOS, unavailable)
@available(tvOS 13, *)
@available(watchOS 6, *)
extension ActionSheetState.ActionSheet: Equatable where Action: Equatable {}

@available(iOS 13, *)
@available(macCatalyst 13, *)
@available(macOS, unavailable)
@available(tvOS 13, *)
@available(watchOS 6, *)
extension ActionSheetState.ActionSheet: Hashable where Action: Hashable {}

@available(iOS 13, *)
@available(macCatalyst 13, *)
@available(macOS, unavailable)
@available(tvOS 13, *)
@available(watchOS 6, *)
extension ActionSheetState.ActionSheet.Button: Equatable where Action: Equatable {}

@available(iOS 13, *)
@available(macCatalyst 13, *)
@available(macOS, unavailable)
@available(tvOS 13, *)
@available(watchOS 6, *)
extension ActionSheetState.ActionSheet.Button: Hashable where Action: Hashable {}

@available(iOS 13, *)
@available(macCatalyst 13, *)
@available(macOS, unavailable)
@available(tvOS 13, *)
@available(watchOS 6, *)
extension ActionSheetState.ActionSheet: Identifiable where Action: Hashable {
  public var id: Self { self }
}

extension View {
  /// Displays an alert when `state` is in the `.show` state.
  ///
  /// - Parameters:
  ///   - state: A value that describes if the alert is shown or dismissed.
  ///   - send: A reference to the view store's `send` method for which actions from this alert
  ///   should be sent to.
  ///   - dismissal: An action to send when the alert is dismissed through non-user actions, such
  ///   as when an alert is automatically dismissed by the system.
  @available(iOS 13, *)
  @available(macCatalyst 13, *)
  @available(macOS, unavailable)
  @available(tvOS 13, *)
  @available(watchOS 6, *)
  public func actionSheet<Action>(
    _ state: ActionSheetState<Action>,
    send: @escaping (Action) -> Void,
    dismissal: Action
  ) -> some View where Action: Hashable {

    self.actionSheet(
      item: Binding<ActionSheetState<Action>.ActionSheet?>(
        get: {
          switch state {
          case .dismissed:
            return nil
          case let .show(alert):
            return alert
          }
        },
        set: {
          guard $0 == nil else { return }
          send(dismissal)
        }),
      content: { $0.toSwiftUI(send: send) }
    )
  }
}

@available(iOS 13, *)
@available(macCatalyst 13, *)
@available(macOS, unavailable)
@available(tvOS 13, *)
@available(watchOS 6, *)
extension ActionSheetState.ActionSheet.Button {
  fileprivate func toSwiftUI(send: @escaping (Action) -> Void) -> SwiftUI.Alert.Button {
    switch self.type {
    case .cancel:
      return SwiftUI.Alert.Button.cancel(Text(self.label)) { send(self.action) }
    case .default:
      return SwiftUI.Alert.Button.default(Text(self.label)) { send(self.action) }
    case .destructive:
      return SwiftUI.Alert.Button.destructive(Text(self.label)) { send(self.action) }
    }
  }
}

@available(iOS 13, *)
@available(macCatalyst 13, *)
@available(macOS, unavailable)
@available(tvOS 13, *)
@available(watchOS 6, *)
extension ActionSheetState.ActionSheet {
  fileprivate func toSwiftUI(send: @escaping (Action) -> Void) -> SwiftUI.ActionSheet {

    SwiftUI.ActionSheet(
      title: Text(self.title),
      message: self.message.map { Text($0) },
      buttons: self.buttons.map {
        $0.toSwiftUI(send: send)
      }
    )
  }
}
