//
//  AppDelegate.swift
//  AVLTree
//
//  Created by Alex Nichol on 6/10/14.
//  Copyright (c) 2014 Alex Nichol. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
                            
  @IBOutlet var window: NSWindow
  @IBOutlet var textField: NSTextField
  
  var rootView : TreeView!
  
  func applicationDidFinishLaunching(aNotification: NSNotification?) {
    // Insert code here to initialize your application
    var root = TreeNode(value: 1)
    rootView = TreeView(frame: getContentFrame())
    rootView.rootNode = root
    rootView.performLayout(false)
    window.contentView.addSubview(rootView)
    
    window.delegate = self
  }
  
  func getContentFrame() -> CGRect {
    var rect = CGRectInset(window.contentView.bounds, 10, 10)
    rect.size.height -= 40
    return rect
  }

  func applicationWillTerminate(aNotification: NSNotification?) {
    // Insert code here to tear down your application
  }

  func windowDidResize(note: NSNotification!) {
    rootView.frame = getContentFrame()
    rootView.performLayout(false)
  }
  
  @IBAction func addNode(AnyObject!) {
    var number = textField.stringValue.toInt()
    if !number {
      NSBeep()
      return
    }
    rootView.insertNumber(number!)
    NSAnimationContext.currentContext().duration = 0.5
    NSAnimationContext.beginGrouping()
    rootView.performLayout(true)
    NSAnimationContext.endGrouping()
  }
  
}

