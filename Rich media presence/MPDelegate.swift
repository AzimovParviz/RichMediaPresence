////
////  MPDelegate.swift
////  Rich media presence
////
////  Created by rosenberg on 15.6.2025.
////
//
//import SwiftUI
//
//class MPDelegate: NSObject, NSApplicationDelegate{
//    @objc
//    func statusBarButtonClicked(_ sender: NSStatusBarButton) {
//        print("menu bar item clicked")
//        let windowWidth: CGFloat = 400
//        let windowHeight: CGFloat = 300
//        let menubarHeight = getMenuBarHeight()
//        let mouseLocation = NSEvent.mouseLocation
//        var window = getOrCreateWindow(size: NSRect(
//            x: mouseLocation.x - windowWidth / 2,
//            y: mouseLocation.y - windowHeight - menubarHeight,
//            width: windowWidth,
//            height: windowHeight
//        ))
//        toggleWindow(location: NSPoint(x: mouseLocation.x, y: mouseLocation.y - menubarHeight))
//    }
//    
//    func applicationDidFinishLaunching(_ aNotification: Notification) {
//        let statusBarItem = NSStatusBar.system.statusItem(
//            withLength: NSStatusItem.variableLength
//        )
//        if let button = statusBarItem.button {
//            button.image = NSImage(systemSymbolName: "square.and.arrow.up", accessibilityDescription: nil)
//            button.action = #selector(statusBarButtonClicked(_:))
//            button.target = self
//            button.title = "Open Window"
//        }
//    }
//    
//    @objc func getOrCreateWindow(size: NSRect) -> NSWindow {
//        var window: NSWindow?
//        if window != nil {
//            return window!
//        }
//        let contentView = ContentView()
//        window = NSWindow(
//            contentRect: size,
//            styleMask: [.borderless],
//            backing: .buffered,
//            defer: false)
//        window?.contentView = NSHostingView(rootView: contentView)
//        window?.level = .floating
//        return window.unsafelyUnwrapped;
//    }
//    
//    func toggleWindow(location: NSPoint) {
//        var window: NSWindow?
//        if window == nil {
//            return
//        }
//        if window!.isVisible {
//            window?.orderOut(nil)
//        } else {
//            window?.setFrameOrigin(location)
//            window?.makeKeyAndOrderFront(nil)
//            NSApp.activate(ignoringOtherApps: true)
//        }
//    }
//    
//    func getMenuBarHeight() -> CGFloat {
//        return NSStatusBar.system.thickness
//    }
//}
