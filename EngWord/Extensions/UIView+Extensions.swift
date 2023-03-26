//
//  UIView+Extensions.swift
//  Quizzie
//
//  Created by hieu nguyen on 04/11/2022.
//

import UIKit

extension UIView {

    class func fromNib<T: UIView>() -> T? {
       return Bundle(for: T.self)
            .loadNibNamed(
                String(describing: T.self),
                owner: nil,
                options: nil)![0] as? T
    }

    func addCornerRadius() {
        layer.masksToBounds = true
        layer.cornerRadius = Constants.borderRadius
    }

    func addDashline(color: UIColor? = nil, cornerRadius: CGFloat = 0) {
        let viewBorder = CAShapeLayer()
        viewBorder.strokeColor = Colors.active.cgColor
        viewBorder.frame = bounds
        viewBorder.lineDashPattern = [8, 4]
        viewBorder.lineWidth = 5
        viewBorder.fillColor = nil
        viewBorder.path = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: cornerRadius
        ).cgPath
        viewBorder.masksToBounds = true
        layer.masksToBounds = true
        layer.cornerRadius = cornerRadius
        layer.addSublayer(viewBorder)
    }

    func addLineBorder(
        _ color: UIColor? = nil,
        cornerRadius: CGFloat = 0
    ) {
        let nameOfBorder = "SolidLineBorder"
        if let lineLayers = layer.sublayers?.filter({ $0.name == nameOfBorder }),
           !lineLayers.isEmpty {
            return
        }
        let viewBorder = CAShapeLayer()
        viewBorder.name = nameOfBorder
        viewBorder.strokeColor = color?.cgColor ?? Colors.active.cgColor
        viewBorder.frame = bounds
        viewBorder.lineWidth = 4
        viewBorder.fillColor = nil
        viewBorder.path = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: cornerRadius
        ).cgPath
        viewBorder.masksToBounds = true
        viewBorder.cornerRadius = cornerRadius
        layer.addSublayer(viewBorder)
    }
}




typealias Constraint = (_ layoutView: UIView) -> NSLayoutConstraint

//
// Solution based on http://chris.eidhof.nl/post/micro-autolayout-dsl/
//
extension UIView {

    /// Adds constraints using NSLayoutAnchors, based on description provided in params.
    /// Please refer to helper equal funtions for info how to generate constraints easily.
    ///
    /// - Parameter constraintDescriptions: constrains array
    /// - Returns: created constraints
    @discardableResult func addConstraints(_ constraintDescriptions: [Constraint]) -> [NSLayoutConstraint] {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraints = constraintDescriptions.map { $0(self) }
        NSLayoutConstraint.activate(constraints)
        return constraints
    }

    /// Remove all constraints from view and it subviews
    func removeAllConstraints() {
        removeConstraints(constraints)
        subviews.forEach { $0.removeAllConstraints() }
    }
}

/// Describes constraint that is equal to constraint from different view.
/// Example: `equal(superView, \.centerXAnchor) will align view centerXAnchor to superview centerXAnchor`
///
/// - Parameters:
///   - view: that constrain should relate to
///   - to: constraints key path
/// - Returns: created constraint
func equal<Anchor, Axis>(_ view: UIView, _ to: KeyPath<UIView, Anchor>) -> Constraint where Anchor: NSLayoutAnchor<Axis> {
    return { layoutView in
        layoutView[keyPath: to].constraint(equalTo: view[keyPath: to])
    }
}

/// Describes constraint that will be equal to constant
/// Example: `equal(\.heightAnchor, to: 36) will create height constraint with value 36`
///
/// - Parameters:
///   - keyPath: constraint key path
///   - constant: value
/// - Returns: created constraint
func equal<LayoutDimension>(_ keyPath: KeyPath<UIView, LayoutDimension>, to constant: CGFloat) -> Constraint where LayoutDimension: NSLayoutDimension {
    return { layoutView in
        layoutView[keyPath: keyPath].constraint(equalToConstant: constant)
    }
}

/// Describes constraint that will be greater or equal to constant
/// Example: `equal(\.heightAnchor, greaterOrEqual: 36) will create height constraint with value greater or equal 36`
///
/// - Parameters:
///   - keyPath: constraint key path
///   - constant: value
/// - Returns: created constraint
func equal<LayoutDimension>(_ keyPath: KeyPath<UIView, LayoutDimension>, greaterOrEqual constant: CGFloat) -> Constraint where LayoutDimension: NSLayoutDimension {
    return { layoutView in
        layoutView[keyPath: keyPath].constraint(greaterThanOrEqualToConstant: constant)
    }
}

/// Describes constraint that will be less or equal to constant
/// Example: `equal(\.heightAnchor, lessOrEqual: 36) will create height constraint with value less or equal 36`
///
/// - Parameters:
///   - keyPath: constraint key path
///   - constant: value
/// - Returns: created constraint
func equal<LayoutDimension>(_ keyPath: KeyPath<UIView, LayoutDimension>, lessOrEqual constant: CGFloat) -> Constraint where LayoutDimension: NSLayoutDimension {
    return { layoutView in
        layoutView[keyPath: keyPath].constraint(lessThanOrEqualToConstant: constant)
    }
}

/// Describes relation between constraints of two views.
/// Example: `equal(logoImageView, \.heightAnchor, \.heightAnchor, ratio: 0.5)
/// will create constraint where height of current view is expected to be half of the logoImageView height
///
/// - Parameters:
///   - view: view that constraint is related from
///   - keyPath: constraint key path of current view
///   - to: constraint key path of related view
///   - value: the multiplier constant for the constraint.
/// - Returns: created constraint
func equal<LayoutDimension>(_ view: UIView, _ keyPath: KeyPath<UIView, LayoutDimension>, _ to: KeyPath<UIView, LayoutDimension>, ratio value: CGFloat) -> Constraint where LayoutDimension: NSLayoutDimension {
    return { layoutView in
        layoutView[keyPath: keyPath].constraint(equalTo: view[keyPath: to], multiplier: value)
    }
}

/// Describes relation between constraints of two views
/// Example: `equal(logoImageView, \.topAnchor, \.bottomAnchor, constant: 80)`
/// will create constraint where topAnchor of current view is linked to bottomAnchor of passed view with offset 80
///
/// - Parameters:
///   - view: view that constraint is related from
///   - from: constraint key path of current view
///   - to: constraint key path of related view
///   - constant: value
/// - Returns: created constraint
func equal<Anchor, Axis>(_ view: UIView, _ from: KeyPath<UIView, Anchor>, _ to: KeyPath<UIView, Anchor>, constant: CGFloat = 0) -> Constraint where Anchor: NSLayoutAnchor<Axis> {
    return { layoutView in
        layoutView[keyPath: from].constraint(equalTo: view[keyPath: to], constant: constant)
    }
}

/// Describes relation between constraints of two views
/// Example: `equal(logoImageView, \.topAnchor, \.bottomAnchor, constant: 80)`
/// will create constraint where topAnchor of current view is linked to bottomAnchor of passed view with offset less or equal 80
///
/// - Parameters:
///   - view: view that constraint is related from
///   - from: constraint key path of current view
///   - to: constraint key path of related view
///   - lessOrEqual: value
/// - Returns: created constraint
func equal<Anchor, Axis>(_ view: UIView, _ from: KeyPath<UIView, Anchor>, _ to: KeyPath<UIView, Anchor>, lessOrEqual: CGFloat = 0) -> Constraint where Anchor: NSLayoutAnchor<Axis> {
    return { layoutView in
        layoutView[keyPath: from].constraint(lessThanOrEqualTo: view[keyPath: to], constant: lessOrEqual)
    }
}

/// Describes relation between constraints of two views
/// Example: `equal(logoImageView, \.topAnchor, \.bottomAnchor, constant: 80)`
/// will create constraint where topAnchor of current view is linked to bottomAnchor of passed view with offest greater or equal to 80
///
/// - Parameters:
///   - view: view that constraint is related from
///   - from: constraint key path of current view
///   - to: constraint key path of related view
///   - greaterOrEqual: value
/// - Returns: created constraint
func equal<Anchor, Axis>(_ view: UIView, _ from: KeyPath<UIView, Anchor>, _ to: KeyPath<UIView, Anchor>, greaterOrEqual: CGFloat = 0) -> Constraint where Anchor: NSLayoutAnchor<Axis> {
    return { layoutView in
        layoutView[keyPath: from].constraint(greaterThanOrEqualTo: view[keyPath: to], constant: greaterOrEqual)
    }
}

/// Describes constraints from diffrent views where anchors should match with passed offset
/// Example: `equal(self, \.bottomAnchor, constant: -37)` will align bottomAnchors of current and passed view with offset -37
///
/// - Parameters:
///   - view: view that constraint is related from
///   - keyPath: constraint key path
///   - constant: value
/// - Returns: created constraint
func equal<Axis, Anchor>(_ view: UIView, _ keyPath: KeyPath<UIView, Anchor>, constant: CGFloat = 0) -> Constraint where Anchor: NSLayoutAnchor<Axis> {
    return equal(view, keyPath, keyPath, constant: constant)
}

/// Describes array of constraints that will pin view to its superview.
/// If invoked on iOS 11, this method will pin top and bottom view edges to `safeAreaLayoutGuide`!
/// Example `view.addConstraints(equalToSuperview())`
///
/// - Parameter insets: Optional insets parameter. By default it's set to .zero.
/// - Returns: Array of `Constraint`.
/// - Warning: This method uses force-unwrap on view's superview!
/// - Warning: Pins top and bottom edges to `safeAreaLayoutGuide`!
func equalToSuperview(with insets: UIEdgeInsets = .zero, pinBottomToSafeArea: Bool = true, pinTopToSafeArea: Bool = true) -> [Constraint] {

    let top: Constraint
    let bottom: Constraint
    if pinTopToSafeArea {
        top = { layoutView in
            layoutView.topAnchor.constraint(equalTo: layoutView.superview!.safeAreaLayoutGuide.topAnchor, constant: insets.top)
        }
    } else {
        top = { layoutView in
            layoutView.topAnchor.constraint(equalTo: layoutView.superview!.topAnchor, constant: insets.top)
        }
    }

    if pinBottomToSafeArea {
        bottom = { layoutView in
            layoutView.bottomAnchor.constraint(equalTo: layoutView.superview!.safeAreaLayoutGuide.bottomAnchor, constant: insets.bottom)
        }
    } else {
        bottom = { layoutView in
            layoutView.bottomAnchor.constraint(equalTo: layoutView.superview!.bottomAnchor, constant: insets.bottom)
        }
    }

    let leading: Constraint = { layoutView in
        layoutView.leadingAnchor.constraint(equalTo: layoutView.superview!.leadingAnchor, constant: insets.left)
    }

    let trailing: Constraint = { layoutView in
        layoutView.trailingAnchor.constraint(equalTo: layoutView.superview!.trailingAnchor, constant: insets.right)
    }

    return [leading, top, trailing, bottom]
}
