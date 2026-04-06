//
//  InvestTextView.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 06/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import UIKit

public class InvestTextView: UITextView, UITextViewDelegate {
    
    @Published public var isInsertedText: Bool = false
    
    public var placeholder = "" {
        didSet {
            self.text = placeholder
            self.textColor = .olchaLightTextColornnnnnn
        }
    }
    
    private var textEditing: ((String) -> Void)?
    
    public var currentText: String = "" {
        didSet {
            isInsertedText = !currentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.delegate = self
    }
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.delegate = self
    }
    
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        textView.border(with: .olchaLightNeutralDarkGray, width: 2.0)
        guard textView.text == "" else { return }
        textView.text = placeholder
        textView.textColor = .olchaLightTextColornnnnnn
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        textView.border(with: .olchaPrimaryColor, width: 1.5)
        guard textView.text == placeholder else { return }
        textView.text = ""
        textView.textColor = .olchaTextBlack
    }
    
    public func textViewDidChangeSelection(_ textView: UITextView) {
        if textView.text != placeholder {
            currentText = textView.text
        }

        textEditing?(textView.text)
    }
 
    public func observeText(editing: ((String) -> Void)?) {
        self.textEditing = editing
    }
    
}
