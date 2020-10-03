//
//  DropdownMenuView.swift
//  Daybar
//
//  Created by Jay Stakelon on 9/7/20.
//  Copyright © 2020 Jay Stakelon. All rights reserved.
//

import SwiftUI

struct DropdownMenuView: NSViewRepresentable {
    
    var profile: Profile?
    
    func makeNSView(context: Context) -> NSPopUpButton {
        
        let dropdown = NSPopUpButton(frame: CGRect(x: 0, y: 0, width: 48, height: 24), pullsDown: true)
        dropdown.menu!.autoenablesItems = false
        return dropdown
        
    }
    
    func updateNSView(_ nsView: NSPopUpButton, context: Context) {
        
        nsView.removeAllItems()
        
        var img: NSImage = NSImage(named: "avatar-placeholder")!
        if let p = profile {
            if let url = URL(string: p.picture) {
                if let data = try? Data(contentsOf: url) {
                    if let image = NSImage(data: data) {
                        img = image
                    }
                }
            }
        }
        let avatarItem = NSMenuItem()
        let avatarImage = img
        avatarImage.size = NSSize(width: 24, height: 24)
        avatarItem.image = avatarImage.oval()
        
        let emailItem = NSMenuItem()
        var emailStr = ""
        if let e = profile?.email {
            emailStr = e
        }
        emailItem.attributedTitle = NSAttributedString(string: emailStr, attributes: [NSAttributedString.Key.foregroundColor: NSColor.lightGray])

        let signOutItem = NSMenuItem(title: "Sign out", action: #selector(GoogleLoader.signOutFromMenu(_:)), keyEquivalent: "")
        signOutItem.target = GoogleLoader.shared
        
//        let refreshItem = NSMenuItem(title: "Refresh", action: #selector(Coordinator.fetchAction), keyEquivalent: "r")
//        refreshItem.representedObject = eventListViewModel
//        refreshItem.target = context.coordinator
        
        let quitItem = NSMenuItem(title: "Quit", action: #selector(Coordinator.quitAction), keyEquivalent: "q")
        quitItem.target = context.coordinator

        nsView.menu?.insertItem(avatarItem, at: 0)
        nsView.menu?.insertItem(emailItem, at: 1)
        nsView.menu?.insertItem(signOutItem, at: 2)
        nsView.menu?.insertItem(NSMenuItem.separator(), at: 3)
        nsView.menu?.insertItem(quitItem, at: 4)

        let cell = nsView.cell as? NSButtonCell
        cell?.imagePosition = .imageOnly
        cell?.bezelStyle = .texturedRounded

        nsView.wantsLayer = true
        nsView.layer?.backgroundColor = NSColor.clear.cgColor
        nsView.isBordered = false
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject {
        @objc func fetchAction(_ sender: NSMenuItem) {
            let vm = sender.representedObject as! EventListViewModel
            vm.fetch()
        }
        @objc func quitAction(_ sender: NSMenuItem) {
            NSApplication.shared.terminate(self)
        }
    }
}

//struct DropdownMenuView_Previews: PreviewProvider {
//    static var previews: some View {
//        DropdownMenuView()
//    }
//}
