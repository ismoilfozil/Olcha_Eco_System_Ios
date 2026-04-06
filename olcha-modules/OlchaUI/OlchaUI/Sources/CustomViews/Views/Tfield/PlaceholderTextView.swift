//
//  PlaceholderTextView.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 05/08/22.
//

import UIKit

public class PlaceholderTextView: UITextView, UITextViewDelegate {
    
    public var placeholder = "" {
        didSet {
            self.text = placeholder
        }
    }
    
    private var textEditing: ((String) -> Void)?
    
    public var currentText = ""
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.delegate = self
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.delegate = self
        self.textColor = (self.text == placeholder) ? .olchaLightTextColornnnnnn : .olchaTextBlack
    }
    
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == "" {
            textView.text = placeholder
            textView.textColor = .olchaLightTextColornnnnnn
        } else {
            textView.textColor = .olchaTextBlack
        }
        
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text == placeholder {
            textView.text = ""
            textView.textColor = .olchaTextBlack
        }
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
    
    public func getText() -> String {
        self.text == placeholder ? "" : self.text
    }
    
    public func setText(_ text: String?) {
        self.text = text
        textViewDidEndEditing(self)
    }
}
