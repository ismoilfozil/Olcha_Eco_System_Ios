//
//  UIImageView+Extension.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 30/06/22.
//

import UIKit
import Kingfisher
import SVGKit
import OlchaUtils
public extension UIImageView {
    func enableZoom() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
        isUserInteractionEnabled = true
        addGestureRecognizer(pinchGesture)
    }
    
    @objc private func startZooming(_ sender: UIPinchGestureRecognizer) {
        let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
        guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
        sender.view?.transform = scale
        sender.scale = 1
    }
    
    
}

fileprivate let quadraticSize = 300

public extension UIImageView {
    enum ImageType {
        case quadratic
        case equalSize(CGFloat)
        case size(CGFloat, CGFloat)
        case width(CGFloat)
        case height(CGFloat)
        case flexible
        case ignoreResize
    }
    
    func load(from urlString: String?,
              withIndicator: Bool = true,
              quality: Int = 4,
              transition: Bool = true,
              imageType: ImageType = .flexible,
              contentMode: UIView.ContentMode? = nil,
              withPlaceholder: Bool = true,
              completion: (() -> Void)? = nil) {
        
        guard let urlString = urlString else {
            setupPlaceholder(withPlaceholder: withPlaceholder)
            return
        }
        
        var options: KingfisherOptionsInfo = []
        if withIndicator {
            self.kf.indicatorType = .activity
        }
        
        if self.image == nil {
//            options.append(.transition(.fade(0.6)))
            if transition {
                options.append(.forceTransition)
            }
        }
        
        switch imageType {
        case .equalSize(let size):
            loadForcedImage(url: urlString,
                            width: size.int,
                            height: size.int,
                            quality: quality,
                            options: options,
                            contentMode: contentMode,
                            withPlaceholder: withPlaceholder)
            break
        case .quadratic:
            loadForcedImage(url: urlString,
                            width: quadraticSize,
                            height: quadraticSize,
                            quality: quality,
                            options: options,
                            contentMode: contentMode,
                            withPlaceholder: withPlaceholder)
            break
        case .size(let width, let height):
            loadForcedImage(url: urlString,
                            width: width.int,
                            height: height.int,
                            quality: quality,
                            options: options,
                            contentMode: contentMode,
                            withPlaceholder: withPlaceholder)
            break
        case .width(let width):
            loadFlexibleImage(url: urlString,
                              optionalWidth: width.int,
                              quality: quality,
                              options: options,
                              contentMode: contentMode,
                              withPlaceholder: withPlaceholder)
            break
        case .height(let height):
            loadFlexibleImage(url: urlString,
                              optionalHeight: height.int,
                              quality: quality,
                              options: options,
                              contentMode: contentMode,
                              withPlaceholder: withPlaceholder)
            break
        case .flexible:
            loadFlexibleImage(url: urlString,
                              quality: quality,
                              options: options,
                              contentMode: contentMode,
                              withPlaceholder: withPlaceholder)
            break
        case .ignoreResize:
            imageLoadRouter(url: urlString,
                            options: options,
                            contentMode: contentMode,
                            withPlaceholder: withPlaceholder,
                            completion: completion
            )
            break
        }
        
    }
    
    private func loadForcedImage(url: String,
                                 width: Int,
                                 height: Int,
                                 quality: Int,
                                 options: KingfisherOptionsInfo,
                                 contentMode: UIView.ContentMode? = nil,
                                 withPlaceholder: Bool) {
        
        let newUrlString = url.replacingOccurrences(
            of: "/original/",
            with: "/\(width * quality)x\(height * quality)/"
        )
        
        imageLoadRouter(url: newUrlString,
                        options: options,
                        contentMode: contentMode,
                        withPlaceholder: withPlaceholder
        )
        
    }
    
    private func loadFlexibleImage(url: String,
                                   optionalWidth: Int? = nil,
                                   optionalHeight: Int? = nil,
                                   quality: Int,
                                   options: KingfisherOptionsInfo,
                                   contentMode: UIView.ContentMode? = nil,
                                   withPlaceholder: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let width: Int = optionalWidth ?? (self.bounds.width * CGFloat.onePixelInPoints()).int
            let height: Int = optionalHeight ?? (self.bounds.height * CGFloat.onePixelInPoints()).int
            
            let newUrlString = url.replacingOccurrences(
                of: "/original/",
                with: "/\(width * quality)x\(height * quality)/"
            )
            
            self.imageLoadRouter(url: newUrlString,
                                 options: options,
                                 contentMode: contentMode,
                                 withPlaceholder: withPlaceholder)
            
        }
    }
    
    private func setupPlaceholder(withPlaceholder: Bool) {
        guard withPlaceholder else { return }
        self.backgroundColor = .olchaLightNeutralDarkGray
        self.contentMode = .scaleAspectFit
        self.image = .placeholder
    }
    
}

public extension UIImageView {
    
    func imageLoadRouter(url: String,
                         options: KingfisherOptionsInfo,
                         contentMode: UIView.ContentMode? = nil,
                         withPlaceholder: Bool,
                         completion: (() -> Void)? = nil) {
        
        if url.contains(".svg") {
            self.loadImagesSVGType(from: url,
                                   contentMode: contentMode)
        } else {
            self.loadImagesOtherType(url: url,
                                     options: options,
                                     contentMode: contentMode,
                                     withPlaceholder: withPlaceholder,
                                     completion: completion)
        }
    }
    
    func loadImagesOtherType(url: String,
                             options: KingfisherOptionsInfo,
                             contentMode: UIView.ContentMode? = nil,
                             withPlaceholder: Bool,
                             completion: (() -> Void)? = nil) {
        self.backgroundColor = .clear
        var resultOptions = options
        do {
            let cache = try ImageCache(name: "Olcha Cache", cacheDirectoryURL: URL(string: url))
            resultOptions.append(.originalCache(cache))
        } catch {}
        self.kf.setImage(with: URL(string: url), options: resultOptions) { [weak self] result in
            guard let self = self else { return }
            
            guard
                ((try? result.get().source.url?.absoluteString == url) ?? false)
            else {
                completion?()
                return
            }
            
            switch result {
            case .success(let image):
                self.backgroundColor = .clear
                if let contentMode = contentMode {
                    self.contentMode = contentMode
                }
            case .failure:
                self.setupPlaceholder(withPlaceholder: withPlaceholder)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                completion?()
            }
        }
    }
    
    func loadImagesSVGType(from urlString: String,
                           contentMode mode: UIView.ContentMode? = nil) {
        guard let url = URL(string: urlString) else { return }
        defer {
            if let contentMode = mode {
                self.contentMode = contentMode
            }
        }
        
        if ImageCache.default.imageCachedType(forKey: urlString) != .none {
            
            ImageCache.default.retrieveImage(forKey: urlString) { [weak self] result in
                guard let self = self else { return }
                
//                DispatchQueue.main.async {
                    switch result {
                    case .success(let image):
                        self.image = image.image
                    case .failure: break
                    }
//                }

                                                                   
            }
            
        } else {
            
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard
                    let self = self,
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let receivedicon: SVGKImage = SVGKImage(data: data),
                    let image = receivedicon.uiImage
                else { return }
                if let cacheKey = httpURLResponse.url?.absoluteString {
                    ImageCache.default.store(image, forKey: cacheKey)
                }
                DispatchQueue.main.async {
                    self.image = image
                }
            }.resume()
        }
    }
}
