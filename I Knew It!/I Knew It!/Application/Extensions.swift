//
//  Extensions.swift
//  I Knew It!
//
//  Created by Тимур Таймасов on 10.06.2021.
//

import UIKit

// MARK: - Image Downloader Extension

extension UIImageView {
    
    /// Downloads image from URL
    /// - Parameters:
    ///   - url: Valid image URL
    ///   - mode: How image will fit in ImageView
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    
    /// Downloads image from link
    /// - Parameters:
    ///   - link: Valid image link
    ///   - mode: How image will fit in ImageView
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

// MARK: - Loading Spinner Extension

var vSpinner : UIView?

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
