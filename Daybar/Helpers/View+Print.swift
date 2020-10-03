//
//  View+Print.swift
//  Daybar
//
//  Created by Jay Stakelon on 8/20/20.
//  Copyright © 2020 Jay Stakelon. All rights reserved.
//

import Foundation
import SwiftUI

extension View {
    func Print(_ vars: Any...) -> some View {
        for v in vars { print(v) }
        return EmptyView()
    }
}
