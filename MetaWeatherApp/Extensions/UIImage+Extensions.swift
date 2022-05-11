//  MetaWeatherApp
//  Created by Maciej Banasiewicz on 2022-05-10.

import UIKit

extension UIImageView {
    
    private enum AssociatedKeys {
        static var currentTask = "currentTask"
    }
    
    private enum Error: Swift.Error {
        case unableToDecode
    }

    private var currentTask: Task<Void, Swift.Error>? {
        get {
            objc_getAssociatedObject(self, &AssociatedKeys.currentTask) as? Task<Void, Swift.Error>
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.currentTask, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func loadImage(url: URL, imageLoader: ImageLoaderType) {
        currentTask?.cancel()
        
        currentTask = Task {
            let image = try await imageLoader.loadImage(urlRequest: URLRequest(url: url))
            guard let decodedImage = await image.byPreparingForDisplay() else { throw Error.unableToDecode }
            self.replaceImage(decodedImage)
        }
    }
    
    func cancelImageLoading() {
        currentTask?.cancel()
        currentTask = nil
        image = nil
    }
    
    @MainActor
    private func replaceImage(_ newImage: UIImage) {
        image = newImage
    }
}
