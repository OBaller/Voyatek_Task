//
//  UIToolBar+Util.swift
//  Voyatek_Food_App
//
//  Created by Naseem Oyebola on 15/02/2025.
//

import UIKit

extension UIToolbar {
  static func addDoneToolbar() -> UIToolbar {
    let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
    toolBar.sizeToFit()
    let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePressed))
    toolBar.setItems([button], animated: true)
    return toolBar
  }
  
  @objc
  func donePressed() {
    endEditing(true)
  }
}
