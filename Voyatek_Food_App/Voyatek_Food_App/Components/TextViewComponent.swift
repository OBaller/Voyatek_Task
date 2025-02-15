//
//  TextViewComponent.swift
//  Voyatek_Food_App
//
//  Created by Naseem Oyebola on 15/02/2025.
//

import UIKit

class DescriptionInputView: UIView, UITextViewDelegate {
    
    private let label = UILabel()
    let textView = UITextView()
    
    private let defaultBorderColor = UIColor.lightGray.cgColor
    private let activeBorderColor = UIColor.systemBlue.cgColor

    init(labelText: String, placeholder: String) {
        super.init(frame: .zero)
        setupUI(labelText: labelText, placeholder: placeholder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI(labelText: String, placeholder: String) {
        label.text = labelText
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray

        textView.text = placeholder
        textView.textColor = .lightGray
        textView.font = .systemFont(ofSize: 16)
      textView.layer.borderWidth = 0.5
        textView.layer.borderColor = defaultBorderColor
        textView.layer.cornerRadius = 6
        textView.backgroundColor = .white
        textView.delegate = self

        addSubview(label)
        addSubview(textView)

        label.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),

            textView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 4),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor),
            textView.heightAnchor.constraint(equalToConstant: 104)
        ])
    }

    // MARK: - UITextViewDelegate Methods
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.layer.borderColor = activeBorderColor
        
        // Remove placeholder text when user starts typing
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        textView.layer.borderColor = defaultBorderColor
        
        if textView.text.isEmpty {
            textView.text = "Enter food description"
            textView.textColor = .lightGray
        }
    }
}
