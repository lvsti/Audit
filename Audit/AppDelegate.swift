//
//  AppDelegate.swift
//  Audit
//
//  Created by Tamás Lustyik on 2019. 02. 15..
//  Copyright © 2019. Tamas Lustyik. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    private let browserWindowController = BrowserWindowController()
    private var lookupWindowController: LookupWindowController!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        window = browserWindowController.window
        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    @IBAction private func showLookupWindow(_ sender: Any?) {
        if lookupWindowController == nil {
            lookupWindowController = LookupWindowController(window: nil)
        }
        lookupWindowController.showWindow(nil)
    }
    
    func showLookupWindow(for fourCC: UInt32) {
        showLookupWindow(nil)
        lookupWindowController.show(for: fourCC)
    }
    

}

