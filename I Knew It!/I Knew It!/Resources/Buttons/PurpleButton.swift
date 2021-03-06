//
//  PurpleButton.swift
//  I Knew It!
//
//  Created by Тимур Таймасов on 06.06.2021.
//

import UIKit

@IBDesignable
class PurpleButton: UIButton {
    
    // MARK: - Init Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        updateButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        updateButton()
    }
    
    override func prepareForInterfaceBuilder() {
        updateButton()
    }
    
    // MARK: - IBInspectable Properties
    
    @IBInspectable public var bgColor: UIColor = Colors.purple {
        didSet {
            updateButton()
        }
    }
    
    @IBInspectable public var textColor: UIColor = Colors.white {
        didSet {
            updateButton()
        }
    }
    
    // MARK: - Update UI
    
    private func updateButton() {
        
        setShadow()
        setCorner()
        
        setTitleColor(textColor, for: .normal)
        backgroundColor = bgColor
        titleLabel?.font = Fonts.SFProTextSemiBold
        
    }
    
    // MARK: - Button Methods
    
    private func setCorner() {
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = Colors.purple.cgColor
    }
    
    private func setShadow() {
        layer.shadowColor = Colors.purpleShadow.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        layer.shadowRadius = 8
        layer.shadowOpacity = 1
        clipsToBounds = true
        layer.masksToBounds = false
    }
}
