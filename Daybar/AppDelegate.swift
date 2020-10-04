//
//  AppDelegate.swift
//  Daybar
//
//  Created by Jay Stakelon on 8/16/20.
//  Copyright © 2020 Jay Stakelon. All rights reserved.
//

import Cocoa
import SwiftUI
import OAuth2
import Combine

let OAuth2AppDidReceiveCallbackNotification = NSNotification.Name(rawValue: "OAuth2AppDidReceiveCallback")
var keys: Keys?
var userDefaultsStore = UserDefaultsStore()

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!
    var popover: NSPopover!
    var statusBarItem: NSStatusItem!

    // register our app to get notified when launched via URL
    func applicationWillFinishLaunching(_ notification: Notification) {
        NSAppleEventManager.shared().setEventHandler(
            self,
            andSelector: #selector(AppDelegate.handleURLEvent(_:withReply:)),
            forEventClass: AEEventClass(kInternetEventClass),
            andEventID: AEEventID(kAEGetURL)
        )
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Get keys from plist
        readKeys()
        // Get the googleLoader
        let googleLoader = GoogleLoader.shared
        // Add environment objects
        let contentView = ContentView()
            .environmentObject(googleLoader)
            .environmentObject(userDefaultsStore)
        
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 400, height: 400)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: contentView)
        self.popover = popover

        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        if let button = self.statusBarItem.button {
             button.image = NSImage(named: "menubar-icon")
             button.action = #selector(togglePopover(_:))
        }
        
        // Set calendar mode to false if it's never been set
        if (!UserDefaults.exists(key: "isCalendarMode")) {
            UserDefaults.standard.set(false, forKey: "isCalendarMode")
        }
//        UserDefaults.standard.set(true, forKey: "isCalendarMode")

//        // Create the window and set the content view.
//        window = NSWindow(
//            contentRect: NSRect(x: 0, y: 0, width: 320, height: 480),
//            styleMask: [.titled, .closable, .miniaturizable, .fullSizeContentView],
//            backing: .buffered, defer: false)
//        window.center()
//        window.setFrameAutosaveName("Main Window")
//        window.contentView = NSHostingView(rootView: contentView)
//        window.makeKeyAndOrderFront(nil)
    }
    
    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = self.statusBarItem.button {
            if self.popover.isShown {
                self.popover.performClose(sender)
            } else {
                self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
                self.popover.contentViewController?.view.window?.becomeKey()
            }
        }
    }
    
    func readKeys() {
        // turn keys.plist into a globally-accessible var
        let keysURL = Bundle.main.url(forResource: "Keys", withExtension: "plist")!
        if let data = try? Data(contentsOf: keysURL) {
          let decoder = PropertyListDecoder()
            keys = try? decoder.decode(Keys.self, from: data)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    /** Gets called when the App launches/opens via URL. */
    @objc func handleURLEvent(_ event: NSAppleEventDescriptor, withReply reply: NSAppleEventDescriptor) {
        if let urlString = event.paramDescriptor(forKeyword: AEKeyword(keyDirectObject))?.stringValue {
            if let url = URL(string: urlString), "ppoauthapp" == url.scheme && "oauth" == url.host {
                NotificationCenter.default.post(name: OAuth2AppDidReceiveCallbackNotification, object: url)
            }
        }
        else {
            NSLog("No valid URL to handle")
        }
    }


}

//class UserDefaultsStore: ObservableObject {
//    let objectWillChange = PassthroughSubject<UserDefaultsStore, Never>()
//    @Published var isCalendarMode = UserDefaults.standard.bool(forKey: "isCalendarMode") {
//        didSet {
//            UserDefaults.standard.set(self.isCalendarMode, forKey: "isCalendarMode")
//        }
//        willSet {
//            print(self.isCalendarMode)
//            objectWillChange.send(self)
//        }
//    }
//}


class PopoverContentView:NSView {
    var backgroundView:PopoverBackgroundView?
    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        if let frameView = self.window?.contentView?.superview {
            if backgroundView == nil {
                backgroundView = PopoverBackgroundView(frame: frameView.bounds)
                backgroundView!.autoresizingMask = NSView.AutoresizingMask([.width, .height]);
                frameView.addSubview(backgroundView!, positioned: NSWindow.OrderingMode.below, relativeTo: frameView)
            }
        }
    }
}

class PopoverBackgroundView:NSView {
    override func draw(_ dirtyRect: NSRect) {
        NSColor.green.set()
        self.bounds.fill()
    }
}
