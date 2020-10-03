//
//  List+RemoveBackground.swift
//  Daybar
//
//  Created by Jay Stakelon on 8/22/20.
//  Copyright © 2020 Jay Stakelon. All rights reserved.
//

import SwiftUI
import Introspect

extension List {
  /// List on macOS uses an opaque background with no option for
  /// removing/changing it. listRowBackground() doesn't work either.
  /// This workaround works because List is backed by NSTableView.
  func removeBackground() -> some View {
    return introspectTableView { tableView in
      tableView.backgroundColor = .clear
      tableView.enclosingScrollView!.drawsBackground = false
    }
  }
}
