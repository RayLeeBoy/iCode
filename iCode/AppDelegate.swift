//
//  AppDelegate.swift
//  MacDemo
//
//  Created by 云淡风轻 on 2019/9/17.
//  Copyright © 2019 云淡风轻. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSComboBoxDelegate, NSComboBoxDataSource {
    
    @IBOutlet weak var window: NSWindow!
    
    
    /// 主视图
    var mainView: MainView!
    
    var hLine: NSView!
    
    var vLine: NSView!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        // 添加通知
        NotificationCenter.default.addObserver(self, selector: #selector(windowDidResize), name: NSWindow.didResizeNotification, object: nil)
        
        self.window.backgroundColor = NSColor.white
        self.window.title = "iCode"
        self.window.setContentSize(CGSize(width: 700, height: 400))
        
        let mainView = MainView()
        mainView.wantsLayer = true
        mainView.needsDisplay = true
        mainView.layer?.backgroundColor = NSColor.white.cgColor
        self.window.contentView?.addSubview(mainView)
        self.mainView = mainView
        
        let hLine = NSView()
        hLine.wantsLayer = true
        hLine.layer?.backgroundColor = NSColor.lightGray.cgColor
        mainView.addSubview(hLine)
        self.hLine = hLine
        
        let vLine = NSView()
        vLine.wantsLayer = true
        vLine.layer?.backgroundColor = NSColor.lightGray.cgColor
        mainView.addSubview(vLine)
        self.vLine = vLine
        
        self.windowDidResize()
    }
    
    // MARK: - 调整视图位置和大小
    @objc func windowDidResize() {
        
        // 主视图布局
        if self.mainView != nil {
            self.mainView.frame = NSRect(x: 10, y: 10, width: self.window.frame.width - 20, height: self.window.frame.height - 20)
            
            let width = self.mainView.frame.width
            let height = self.mainView.frame.height
            self.hLine.frame = NSRect(x: 0, y: 160, width: width, height: 1)
            self.vLine.frame = NSRect(x: width / 2, y: 160, width: 1, height: height - 160)
            self.mainView.windowDidResize()
        }
    }
    
    // MARK: - Unused
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

