//
//  UserDefaultsStore.swift
//  Daybar
//
//  Created by Jay Stakelon on 10/4/20.
//

import Foundation
import Combine

@propertyWrapper
struct UserDefault<T> {
  let key: String
  let defaultValue: T
  
  var wrappedValue: T {
    get {
      return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
    }
    set {
      UserDefaults.standard.set(newValue, forKey: key)
    }
  }
}

final class UserDefaultsStore: ObservableObject {
    let objectWillChange = ObservableObjectPublisher()

    @UserDefault(key: "isCalendarMode", defaultValue: false)
    var isCalendarMode: Bool

    private var notificationSubscription: AnyCancellable?

    init() {
        notificationSubscription = NotificationCenter.default.publisher(for: UserDefaults.didChangeNotification).sink { _ in
            self.objectWillChange.send()
        }
    }
}

extension UserDefaults {
    static func exists(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
}
