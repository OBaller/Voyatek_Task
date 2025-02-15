//
//  VerticalStackView.swift
//  Voyatek_Food_App
//
//  Created by Naseem Oyebola on 15/02/2025.
//

import UIKit

public class VerticalStackView: UIStackView {
    
  override init(frame: CGRect) {
      super.init(frame: frame)
  }
    
  public init(arrangedSubviews: [UIView], spacing: CGFloat) {
      super.init(frame: .zero)

      arrangedSubviews.forEach { addArrangedSubview($0) }
      self.axis = .vertical
      self.spacing = spacing
      isLayoutMarginsRelativeArrangement = true
  }
    
  required init(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
}


public class VerticalStackView2: UIStackView {
    
  override init(frame: CGRect) {
      super.init(frame: frame)
  }
    
  public init(arrangedSubviews: [UIView], spacing: CGFloat) {
      super.init(frame: .zero)

      arrangedSubviews.forEach { addArrangedSubview($0) }
      self.axis = .vertical
    self.distribution = .fillProportionally
      self.spacing = spacing
  }
    
  required init(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
}

public class HorizontalStackView: UIStackView {
   public init(arrangedSubviews: [UIView], spacing: CGFloat = 0) {
        super.init(frame: .zero)
        arrangedSubviews.forEach({addArrangedSubview($0)})
        self.spacing = spacing
        self.axis = .horizontal
    }
   
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
