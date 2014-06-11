//
//  TreeView.swift
//  AVLTree
//
//  Created by Alex Nichol on 6/10/14.
//  Copyright (c) 2014 Alex Nichol. All rights reserved.
//

import Cocoa

class TreeView: NSView {
  
  var rootNode : TreeNode?
  
  init(frame: NSRect) {
    super.init(frame: frame)
  }
  
  func isFlipped() -> Bool {
    return true
  }
  
  func performLayout(animated: Bool) {
    if !rootNode {
      return
    }
    rootNode!.addTo(self)
    let nodeSize = rootNode!.calculateNodeSize(self.bounds.size)
    let padding = rootNode!.padding(self.bounds.size)
    rootNode!.performLayout(self.bounds, size: CGSizeMake(nodeSize, nodeSize),
      padding: padding, animated: animated)
  }
  
  func insertNumber(number: Int) {
    var aNode = TreeNode(value: number)
    if !rootNode {
      rootNode = aNode
    } else {
      rootNode!.insertNode(aNode)
      rootNode = rootNode!.rebalance()
      rootNode!.recalculateDepth()
    }
  }
  
}
