//
//  TreeNode.swift
//  AVLTree
//
//  Created by Alex Nichol on 6/10/14.
//  Copyright (c) 2014 Alex Nichol. All rights reserved.
//

import Cocoa

class TreeNode : NSView {
  var left: TreeNode?
  var right: TreeNode?
  var depth: Int = 0
  var value: Int!
  var label: NSTextField!
  
  class func nodeDepth(aNode: TreeNode?) -> Int {
    if aNode {
      return aNode!.depth + 1
    } else {
      return 0
    }
  }
  
  init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  init(value aValue: Int) {
    super.init()
    self.autoresizesSubviews = false
    value = aValue
    label = NSTextField(frame: CGRectMake(0, 0, 1, 1))
    label.stringValue = "\(value)"
    label.alignment = .CenterTextAlignment
    label.editable = false
    label.selectable = false
    label.backgroundColor = NSColor.clearColor()
    label.bordered = false
    self.addSubview(label)
  }
  
  func insertNode(node: TreeNode) {
    if node.value < value {
      if !left {
        left = node
      } else {
        left!.insertNode(node)
      }
    } else {
      if !right {
        right = node
      } else {
        right!.insertNode(node)
      }
    }
    recalculateDepth()
    left = left ? left!.rebalance() : nil
    right = right ? right!.rebalance() : nil
  }
  
  func recalculateDepth() -> Int {
    let leftDepth = (left ? left!.recalculateDepth() + 1 : 0)
    let rightDepth = (right ? right!.recalculateDepth() + 1 : 0)
    depth = max(leftDepth, rightDepth)
    return depth
  }
  
  func isRightHeavy() -> Bool {
    if !right {
      return false
    } else if !left {
      return true
    } else {
      return right!.depth > left!.depth
    }
  }
  
  func rebalance() -> TreeNode {
    let leftDepth = (left ? left!.recalculateDepth() + 1 : 0)
    let rightDepth = (right ? right!.recalculateDepth() + 1 : 0)
    if leftDepth + 1 < rightDepth {
      // right is too dominant, do a floopty
      if right!.isRightHeavy() {
        var oldRight = right!
        right = right!.left
        oldRight.left = self
        return oldRight
      } else {
        var newTop = right!.left
        var oldRight = right!
        right = newTop!.left
        oldRight.left = newTop!.right
        newTop!.right = oldRight
        newTop!.left = self
        return newTop!
      }
    } else if rightDepth + 1 < leftDepth {
      if !left!.isRightHeavy() {
        var oldLeft = left!
        left = left!.right
        oldLeft.right = self
        return oldLeft
      } else {
        var newTop = left!.right
        var oldLeft = left!
        left = newTop!.right
        oldLeft.right = newTop!.left
        newTop!.left = oldLeft
        newTop!.right = self
        return newTop!
      }
    } else {
      return self
    }
  }
  
  func padding(size: CGSize) -> CGFloat {
    let nodeCount : CGFloat = CGFloat((1 << (depth + 1)) - 1)
    return (size.width / nodeCount) / 20.0
  }
  
  func calculateNodeSize(size: CGSize) -> CGFloat {
    let heightBound = (size.height - (CGFloat(depth) * padding(size))) / CGFloat(depth + 1)
    let nodeCount : CGFloat = CGFloat((1 << (depth + 1)) - 1)
    let widthBound = (size.width - (nodeCount - 1) * padding(size)) / nodeCount
    return min(heightBound, widthBound)
  }
  
  func performLayout(rect: CGRect, size: CGSize, padding: CGFloat, animated: Bool) {
    if animated {
      self.animator().frame = CGRectMake(rect.origin.x + (rect.size.width - size.width) / 2, rect.origin.y, size.width, size.height)
      self.label.frame = CGRectMake(0, (size.height - 22) / 2, size.width, 22)
    } else {
      self.frame = CGRectMake(rect.origin.x + (rect.size.width - size.width) / 2, rect.origin.y, size.width, size.height)
      self.label.frame = CGRectMake(0, (size.height - 22) / 2, size.width, 22)
    }
    
    
    var leftFrame = CGRectMake(rect.origin.x,
                               rect.origin.y + size.height + padding,
                               (rect.size.width - size.width) / 2.0 - padding,
                               rect.size.height - size.height - padding)
    var rightFrame = CGRectMake(rect.origin.x + (rect.size.width + size.width) / 2 + padding,
                                leftFrame.origin.y,
                                leftFrame.size.width,
                                leftFrame.size.height)
    left?.performLayout(leftFrame, size: size, padding: padding, animated: animated)
    right?.performLayout(rightFrame, size: size, padding: padding, animated: animated)
  }
  
  func addTo(view: NSView) {
    if self.superview != view {
      if self.superview {
        self.removeFromSuperview()
      }
      view.addSubview(self)
    }
    right?.addTo(view)
    left?.addTo(view)
  }
  
  func removeFrom(view: NSView) {
    if self.superview == view {
      self.removeFromSuperview()
    }
    right?.removeFrom(view)
    left?.removeFrom(view)
  }
  
  override func drawRect(dirtyRect: NSRect)  {
    NSColor.clearColor().set()
    NSRectFillUsingOperation(self.bounds, .CompositeSourceOver)
    NSColor.yellowColor().set()
    NSBezierPath(ovalInRect: self.bounds).fill()
  }
}
