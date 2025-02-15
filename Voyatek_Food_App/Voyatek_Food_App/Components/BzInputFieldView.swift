//
//  BzInputFieldView.swift
//  Voyatek_Food_App
//
//  Created by Naseem Oyebola on 15/02/2025.
//

import UIKit

public class BzInputFieldView: UIStackView {

    init(_ labelText: String? = nil, _ textField: UITextField) {
        super.init(frame: .zero)
        let label = UILabel(text: labelText?.uppercased() ?? "", size: 14, textColor: UIColor.BBG.primary, isBold: false)
        label.adjustsFontSizeToFitWidth = false
        textField.setHeight(height: 55)
        addArrangedSubviews([label, textField])
        spacing = 8
        axis = .vertical
        alignment = .fill
        setCustomSpacing(5, after: textField)
        layoutIfNeeded()
    }

    init(_ labelText: String? = nil, _ view: UIView) {
        super.init(frame: .zero)
        let label = UILabel(text: labelText?.uppercased() ?? "", size: 14, textColor: UIColor.BBG.primary, isBold: false)
        label.adjustsFontSizeToFitWidth = false
        view.setHeight(height: 55)
        addArrangedSubviews([label, view])
        spacing = 8
        axis = .vertical
        alignment = .fill
        setCustomSpacing(5, after: view)
        layoutIfNeeded()
    }

    init(_ labelText: String? = nil,
         _ textField: UITextField,
         trailingLabelText: String? = nil,
         trailingLabelAttribute: NSAttributedString? = nil,
         trailingLabelSize: CGFloat = 14) {
        super.init(frame: .zero)
        
        let label = UILabel(text: labelText?.uppercased() ?? "", size: 14, textColor: UIColor.BBG.primary, isBold: false)
        label.adjustsFontSizeToFitWidth = false

        let labelStack = UIStackView(arrangedSubviews: [label])
        labelStack.distribution = .equalSpacing

        let trailingLabel = UILabel(text: trailingLabelText ?? "", size: trailingLabelSize, textColor: UIColor.BBG.primary, isBold: false)
        
        if let trailingLabelAttribute = trailingLabelAttribute {
            trailingLabel.attributedText = trailingLabelAttribute
        }
        
        if !labelStack.arrangedSubviews.contains(trailingLabel) {
            labelStack.addArrangedSubview(trailingLabel)
        }

        textField.setHeight(height: 55)
        addArrangedSubviews([labelStack, textField])
        spacing = 8
        axis = .vertical
        alignment = .fill
        setCustomSpacing(5, after: textField)
        layoutIfNeeded()
    }

    init(_ labelText: String, _ textView: UITextView) {
        super.init(frame: .zero)

        setHeight(height: 115)
        let label = UILabel(text: labelText.uppercased(), size: 14, textColor: UIColor.BBG.primary, isBold: false)
        addSubview(label)
        label.newAnchor(top: topAnchor, left: leftAnchor)

        addSubview(textView)
        textView.newAnchor(top: label.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
