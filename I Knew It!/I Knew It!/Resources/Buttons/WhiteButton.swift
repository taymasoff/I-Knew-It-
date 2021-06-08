//
//  WhiteButton.swift
//  I Knew It!
//
//  Created by Тимур Таймасов on 08.06.2021.
//

import UIKit

@IBDesignable
class WhiteButton: UIButton {
    
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
    
    @IBInspectable public var bgColor: UIColor = Colors.white {
        didSet {
            updateButton()
        }
    }
    
    @IBInspectable public var textColor: UIColor = Colors.black {
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
    
    func shake() {
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let fromPoint = CGPoint(x: center.x - 8, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x + 8, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        
        layer.add(shake, forKey: "position")
    }
}
