//
//  AutoLayout DSL.swift
//  GitHubSearch
//
//  Created by Maxim Kovalko on 6/18/18.
//  Copyright © 2018 Maxim Kovalko. All rights reserved.
//

import UIKit

public extension UIView {
    var alLeft: LayoutItem { return LayoutItem(view: self, attribute: .left) }
    var alRight: LayoutItem { return LayoutItem(view: self, attribute: .right) }
    
    var alTop: LayoutItem { return LayoutItem(view: self, attribute: .top) }
    var alBottom: LayoutItem { return LayoutItem(view: self, attribute: .bottom) }
    
    var alLeading: LayoutItem { return LayoutItem(view: self, attribute: .leading) }
    var alTrailing: LayoutItem { return LayoutItem(view: self, attribute: .trailing) }
    
    var alWidth: LayoutItem { return LayoutItem(view: self, attribute: .width) }
    var alHeight: LayoutItem { return LayoutItem(view: self, attribute: .height) }
    
    var alCenterX: LayoutItem { return LayoutItem(view: self, attribute: .centerX) }
    var alCenterY: LayoutItem { return LayoutItem(view: self, attribute: .centerY) }
    
    var alLastBaseline: LayoutItem { return LayoutItem(view: self, attribute: .lastBaseline) }
    var alFirstBaseline: LayoutItem { return LayoutItem(view: self, attribute: .firstBaseline) }
}

public struct LayoutItem {
    fileprivate let view: UIView
    fileprivate let attribute: NSLayoutAttribute
    fileprivate let multiplier: CGFloat
    fileprivate let constant: CGFloat
    
    init(view: UIView, attribute: NSLayoutAttribute, multiplier: CGFloat = 1, constant: CGFloat = 0) {
        self.view = view
        self.attribute = attribute
        self.multiplier = multiplier
        self.constant = constant
    }
    
    public func relateTo(_ right: LayoutItem?, relation: NSLayoutRelation) -> NSLayoutConstraint {
        let rightAttribute = right?.attribute ?? .notAnAttribute
        let rightMultiplier = right?.multiplier ?? 1
        let rightConstant = right?.constant ?? 0
        
        return NSLayoutConstraint(
            item: view,
            attribute: attribute,
            relatedBy: relation,
            toItem: right?.view,
            attribute: rightAttribute,
            multiplier: rightMultiplier  / multiplier,
            constant: (rightConstant - constant) / multiplier * .scale5)
    }
    
    public func relateTo(_ right: CGFloat, relation: NSLayoutRelation) -> NSLayoutConstraint {
        return NSLayoutConstraint(
            item: view,
            attribute: attribute,
            relatedBy: relation,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: (right - constant) * .scale5)
    }
}

public func * (left: LayoutItem, right: CGFloat) -> LayoutItem {
    return LayoutItem(
        view: left.view,
        attribute: left.attribute,
        multiplier: left.multiplier * right,
        constant: left.constant)
}

public func / (left: LayoutItem, right: CGFloat) -> LayoutItem {
    return LayoutItem(
        view: left.view,
        attribute: left.attribute,
        multiplier: left.multiplier / right,
        constant: left.constant)
}

public func + (left: LayoutItem, right: CGFloat) -> LayoutItem {
    return LayoutItem(
        view: left.view,
        attribute: left.attribute,
        multiplier: left.multiplier,
        constant: left.constant + right)
}

public func - (left: LayoutItem, right: CGFloat) -> LayoutItem {
    return LayoutItem(
        view: left.view,
        attribute: left.attribute,
        multiplier: left.multiplier,
        constant: left.constant - right)
}

public func == (left: LayoutItem, right: LayoutItem?) -> NSLayoutConstraint {
    return left.relateTo(right, relation: .equal)
}

public func == (left: LayoutItem, right: CGFloat) -> NSLayoutConstraint {
    return left.relateTo(right, relation: .equal)
}

public func == (left: (UIView, UIView), right: [NSLayoutAttribute]) -> [NSLayoutConstraint] {
    return right.map{ NSLayoutConstraint(
        item: left.0, attribute: $0, relatedBy: .equal,
        toItem: left.1, attribute: $0, multiplier: 1, constant: 0) }
}

public func >= (left: LayoutItem, right: LayoutItem) -> NSLayoutConstraint {
    return left.relateTo(right, relation: .greaterThanOrEqual)
}

public func >= (left: LayoutItem, right: CGFloat) -> NSLayoutConstraint {
    return left.relateTo(right, relation: .greaterThanOrEqual)
}

public func <= (left: LayoutItem, right: LayoutItem) -> NSLayoutConstraint {
    return left.relateTo(right, relation: .lessThanOrEqual)
}

public func <= (left: LayoutItem, right: CGFloat) -> NSLayoutConstraint {
    return left.relateTo(right, relation: .lessThanOrEqual)
}

precedencegroup LayoutPriorityPrecedence {
    associativity: left
    higherThan: LogicalConjunctionPrecedence
    lowerThan: ComparisonPrecedence
}

infix operator ~ : LayoutPriorityPrecedence

public func ~(lhs: NSLayoutConstraint, rhs: UILayoutPriority) -> NSLayoutConstraint {
    let newConstraint = NSLayoutConstraint(
        item: lhs.firstItem as Any, attribute: lhs.firstAttribute, relatedBy: lhs.relation,
        toItem: lhs.secondItem, attribute: lhs.secondAttribute,
        multiplier: lhs.multiplier, constant: lhs.constant)
    newConstraint.priority = rhs
    return newConstraint
}

extension CGFloat {
    static let scale5 = UIScreen.main.bounds.width / 320
    
    static let onePixel = 1 / UIScreen.main.scale
    
    static let gap: CGFloat = 8
    static let pad: CGFloat = 16
}
