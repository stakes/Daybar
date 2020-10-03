//
//  SpinnerView.swift
//  Daybar
//
//  Created by Jay Stakelon on 8/26/20.
//  Copyright © 2020 Jay Stakelon. All rights reserved.
//

import Foundation
import SwiftUI

struct SpinnerView: NSViewRepresentable {
    
    public func makeNSView(context: Context) -> NSProgressIndicator {
        let nsView = NSProgressIndicator()
        
        nsView.isIndeterminate = true
        nsView.style = .spinning
        
        return nsView
    }
    
    public func updateNSView(_ nsView: NSViewType, context: Context) {
        nsView.startAnimation(self)
    }
    
}
