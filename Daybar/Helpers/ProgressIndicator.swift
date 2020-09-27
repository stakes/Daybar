//
//  ProgressIndicator.swift
//  MacTodayTest
//
//  Created by Jay Stakelon on 8/20/20.
//  Copyright © 2020 Jay Stakelon. All rights reserved.
//

import Foundation
import SwiftUI

struct ProgressIndicator: NSViewRepresentable {
    
    typealias TheNSView = NSProgressIndicator
    var configuration = { (view: TheNSView) in }
    
    func makeNSView(context: NSViewRepresentableContext<ProgressIndicator>) -> NSProgressIndicator {
        TheNSView()
    }
    
    func updateNSView(_ nsView: NSProgressIndicator, context: NSViewRepresentableContext<ProgressIndicator>) {
        configuration(nsView)
    }
}
