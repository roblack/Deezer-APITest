//
//  UIImage+Extension.swift
//  DeezerAPITest
//
//  Created by Emin Roblack on 04/02/2020.
//  Copyright © 2020 Emin Roblack. All rights reserved.
//

import UIKit

fileprivate let cache = ApiService().cache

extension UIImageView {

    // MARK: Class variables ---------------------------------------
    class var clear:    UIImage { return UIImage(named: "clear")! }
    class var search:   UIImage { return UIImage(named: "search")! }
    
    // MARK: Methods ----------------------------------------------------
    func fromUrl(_ url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            // Caching the image
            let imageCacheKey = NSString(string: url.relativeString)
            cache.setObject(image, forKey: imageCacheKey)
            DispatchQueue.main.async() {
                self.image = image
                self.hideLoader()
            }
        }.resume()
    }
    
    func fromUrl(_ link: String, contentMode mode: UIView.ContentMode = .scaleAspectFill) {
        let imageCacheKey = NSString(string: link)
        if let image = cache.object(forKey: imageCacheKey) {
            self.image = image
            self.hideLoader()
            return
        }
        self.showLoader()
        guard let url = URL(string: link) else { return }
        fromUrl(url, contentMode: mode)
    }
}
