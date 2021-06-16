//
//  Extensions.swift
//  I Knew It!
//
//  Created by Тимур Таймасов on 10.06.2021.
//

import UIKit

var vSpinner : UIView?

// MARK: - Loading Spinner Extension

extension UIViewController {
    
    // MARK: - Add Loading Spinner
    
    /// Fuction that renders "loading" spinner on passed view
    /// - Parameter view: View, that you want spinner rendered in
    func showSpinner(on view: UIView) {
        let spinnerView = UIView.init(frame: view.bounds)
        spinnerView.backgroundColor = view.backgroundColor
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            view.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    // MARK: - Remove Loading Spinner
    
    /// Removes rendered spinner from superview
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}
