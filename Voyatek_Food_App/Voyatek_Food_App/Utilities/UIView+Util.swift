//
//  UIView+Util.swift
//  Voyatek_Food_App
//
//  Created by Naseem Oyebola on 15/02/2025.
//

import UIKit

public extension UIView {
  func newAnchor( top: NSLayoutYAxisAnchor? = nil,
                  left: NSLayoutXAxisAnchor? = nil,
                  bottom: NSLayoutYAxisAnchor? = nil,
                  right: NSLayoutXAxisAnchor? = nil,
                  paddingTop: CGFloat = 0,
                  paddingLeft: CGFloat = 0,
                  paddingBottom: CGFloat = 0,
                  paddingRight: CGFloat = 0,
                  width: CGFloat? = nil,
                  height: CGFloat? = nil ) {
    
    translatesAutoresizingMaskIntoConstraints = false
    
    if let top = top {
      topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
    }
    
    if let left = left {
      leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
    }
    
    if let bottom = bottom {
      bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
    }
    
    if let right = right {
      rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
    }
    
    if let width = width {
      widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    if let height = height {
      heightAnchor.constraint(equalToConstant: height).isActive = true
    }
  }
  
  @discardableResult func centerX(inView view: UIView) -> Self {
    translatesAutoresizingMaskIntoConstraints = false
    centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    return self
  }
  
  func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil, paddingLeft: CGFloat = 0, constant: CGFloat = 0 ){
    translatesAutoresizingMaskIntoConstraints = false
    centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    
    if let left = leftAnchor {
      newAnchor(left: left, paddingLeft: paddingLeft)
    }
  }
  
  func setDimensions(height: CGFloat, width: CGFloat) {
    translatesAutoresizingMaskIntoConstraints = false
    heightAnchor.constraint(equalToConstant: height).isActive = true
    widthAnchor.constraint(equalToConstant: width).isActive = true
  }
  
  func setHeight(height: CGFloat) {
    translatesAutoresizingMaskIntoConstraints = false
    heightAnchor.constraint(equalToConstant: height).isActive = true
  }
  
  func setWidth(width: CGFloat) {
    translatesAutoresizingMaskIntoConstraints = false
    widthAnchor.constraint(equalToConstant: width).isActive = true
  }
  
  func centerYInSuperview() {
    translatesAutoresizingMaskIntoConstraints = false
    if let centerY = superview?.centerYAnchor {
      centerYAnchor.constraint(equalTo: centerY).isActive = true
    }
  }
  func centerInSuperview(size: CGSize = .zero) {
    translatesAutoresizingMaskIntoConstraints = false
    if let superviewCenterXAnchor = superview?.centerXAnchor {
      centerXAnchor.constraint(equalTo: superviewCenterXAnchor).isActive = true
    }
    
    if let superviewCenterYAnchor = superview?.centerYAnchor {
      centerYAnchor.constraint(equalTo: superviewCenterYAnchor).isActive = true
    }
    
    if size.width != 0 {
      widthAnchor.constraint(equalToConstant: size.width).isActive = true
    }
    
    if size.height != 0 {
      heightAnchor.constraint(equalToConstant: size.height).isActive = true
    }
  }
  
  func addDoneToolbar() -> UIToolbar {
    let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
    toolBar.sizeToFit()
    let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneToolBarPressed))
    toolBar.setItems([button], animated: true)
    return toolBar
  }
  
  @objc
  func doneToolBarPressed() {
    endEditing(true)
  }
}

class CategoryScrollView: UIScrollView {
    override func touchesShouldCancel(in view: UIView) -> Bool {
        return true
    }
}
