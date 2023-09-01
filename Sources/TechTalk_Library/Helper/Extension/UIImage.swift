
import UIKit

extension UIImage {
    
    convenience init(withBackground color: UIColor) {
        let rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        
        let context:CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.init(ciImage: CIImage(image: image)!)
    }
    
    func cropAlpha() -> UIImage {
        
        let cgImage = self.cgImage!;
        
        let width = cgImage.width
        let height = cgImage.height
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel:Int = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        let bitmapInfo: UInt32 = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
        
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo),
            let ptr = context.data?.assumingMemoryBound(to: UInt8.self) else {
                return self
        }
        
        context.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        var minX = width
        var minY = height
        var maxX: Int = 0
        var maxY: Int = 0
        
        for x in 1 ..< width {
            for y in 1 ..< height {
                
                let i = bytesPerRow * Int(y) + bytesPerPixel * Int(x)
                let a = CGFloat(ptr[i + 3]) / 255.0
                
                if(a>0) {
                    if (x < minX) { minX = x };
                    if (x > maxX) { maxX = x };
                    if (y < minY) { minY = y};
                    if (y > maxY) { maxY = y};
                }
            }
        }
        
        let rect = CGRect(x: CGFloat(minX),y: CGFloat(minY), width: CGFloat(maxX-minX), height: CGFloat(maxY-minY))
        let imageScale:CGFloat = self.scale
        let croppedImage =  self.cgImage!.cropping(to: rect)!
        let ret = UIImage(cgImage: croppedImage, scale: imageScale, orientation: self.imageOrientation)
        
        return ret;
    }
}

extension UIImage {
    
    enum SendType : Int { // sending type
        case Full = 1 // full size image
        case HD = 2 // HD size image
        case SD = 3 // SD size image
    }
    
    enum ImageType : Int { // image type
        case Portrait = 1
        case Landscape = 2
        case Square = 3
    }
    
    struct CheckImage { // check image type
        
        /// check image if it is landscape, portrait, or square
        ///
        /// - Parameter image: any image you want to check
        /// - Returns: return image type
        static func checkImageType(image : UIImage) -> ImageType {
            let size : CGSize = image.size
            let width : CGFloat = size.width
            let height : CGFloat = size.height
            
            if width > height {
                return ImageType.Landscape
            } else if width < height {
                return ImageType.Portrait
            } else {
                return ImageType.Square
            }
        }
        
    }
    /// resize image width and height
    ///
    /// - Parameters:
    ///   - image: any image you want to resize
    ///   - targetSize: any size you want to resize to
    /// - Returns: return new image with new width and height
    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    /// Resize image to any type
    ///
    /// - Parameters:
    ///   - image: image to resize
    ///   - type: Full,HD or SD
    /// - Returns: new image after resize and compress
    func resizingImage(toType type : SendType) -> UIImage{
        
        let originalWidth : Float = Float(self.size.width)
        let originalHeight : Float = Float(self.size.height)
        
        let imageType : ImageType = CheckImage.checkImageType(image: self)
        
        var resizedImage : UIImage = UIImage()
        
        switch imageType {
        case .Landscape: // landscape image
            switch type {
            case .Full: // full size
                resizedImage = self
                break
            case .HD: // HD size
                let widthAndHeight = UIImage().getNewWidthAndHeight(fixW: 1440.0, fixH: 1080.0, originalH: originalHeight, originalW: originalWidth)
                resizedImage = UIImage().resizeImage(image: self, targetSize: widthAndHeight)
                break
            default: // SD size
                let widthAndHeight = UIImage().getNewWidthAndHeight(fixW: 960.0, fixH: 720.0, originalH: originalHeight, originalW: originalWidth)
                resizedImage = UIImage().resizeImage(image: self, targetSize: widthAndHeight)
                break
            }
            
        case .Portrait: // Portrait image
            switch type {
            case .Full: // full size
                resizedImage = self
                break
            case .HD: // HD size
                let widthAndHeight = UIImage().getNewWidthAndHeight(fixW: 1080.0, fixH: 1440.0, originalH: originalHeight, originalW: originalWidth)
                resizedImage = UIImage().resizeImage(image: self, targetSize: widthAndHeight)
                break
            default: // SD size
                let widthAndHeight = UIImage().getNewWidthAndHeight(fixW: 720.0, fixH: 960.0, originalH: originalHeight, originalW: originalWidth)
                resizedImage = UIImage().resizeImage(image: self, targetSize: widthAndHeight)
                break
            }
            
        default: // Square image
            switch type {
            case .Full: // full size
                resizedImage = self
                break
            case .HD: // HD size
                let widthAndHeight = UIImage().getNewWidthAndHeight(fixW: 1440.0, fixH: 1440.0, originalH: originalHeight, originalW: originalWidth)
                resizedImage = UIImage().resizeImage(image: self, targetSize: widthAndHeight)
                break
            default: // SD size
                let widthAndHeight = UIImage().getNewWidthAndHeight(fixW: 960.0, fixH: 960.0, originalH: originalHeight, originalW: originalWidth)
                resizedImage = UIImage().resizeImage(image: self, targetSize: widthAndHeight)
                break
            }
        }
        
        return resizedImage
    }
    /// Resize image to any type
    ///
    /// - Parameters:
    ///   - image: image to resize
    ///   - type: Full,HD or SD
    /// - Returns: new image after resize and compress
    class func resizingImage(image: UIImage,toType type : SendType) -> UIImage{
        
        let originalWidth : Float = Float(image.size.width)
        let originalHeight : Float = Float(image.size.height)
        
        let imageType : ImageType = CheckImage.checkImageType(image: image)
        
        var resizedImage : UIImage = UIImage()
        
        switch imageType {
        case .Landscape: // landscape image
            switch type {
            case .Full: // full size
                resizedImage = image
                break
            case .HD: // HD size
                let widthAndHeight = UIImage().getNewWidthAndHeight(fixW: 1440.0, fixH: 1080.0, originalH: originalHeight, originalW: originalWidth)
                resizedImage = UIImage().resizeImage(image: image, targetSize: widthAndHeight)
                break
            default: // SD size
                let widthAndHeight = UIImage().getNewWidthAndHeight(fixW: 960.0, fixH: 720.0, originalH: originalHeight, originalW: originalWidth)
                resizedImage = UIImage().resizeImage(image: image, targetSize: widthAndHeight)
                break
            }
            
        case .Portrait: // Portrait image
            switch type {
            case .Full: // full size
                resizedImage = image
                break
            case .HD: // HD size
                let widthAndHeight = UIImage().getNewWidthAndHeight(fixW: 1080.0, fixH: 1440.0, originalH: originalHeight, originalW: originalWidth)
                resizedImage = UIImage().resizeImage(image: image, targetSize: widthAndHeight)
                break
            default: // SD size
                let widthAndHeight = UIImage().getNewWidthAndHeight(fixW: 720.0, fixH: 960.0, originalH: originalHeight, originalW: originalWidth)
                resizedImage = UIImage().resizeImage(image: image, targetSize: widthAndHeight)
                break
            }
            
        default: // Square image
            switch type {
            case .Full: // full size
                resizedImage = image
                break
            case .HD: // HD size
                let widthAndHeight = UIImage().getNewWidthAndHeight(fixW: 1440.0, fixH: 1440.0, originalH: originalHeight, originalW: originalWidth)
                resizedImage = UIImage().resizeImage(image: image, targetSize: widthAndHeight)
                break
            default: // SD size
                let widthAndHeight = UIImage().getNewWidthAndHeight(fixW: 960.0, fixH: 960.0, originalH: originalHeight, originalW: originalWidth)
                resizedImage = UIImage().resizeImage(image: image, targetSize: widthAndHeight)
                break
            }
        }
        
        return resizedImage
    }
    /// generate new CGSize for image
    ///
    /// - Parameters:
    ///   - fixW: new width
    ///   - fixH: new height
    ///   - originalH: original image height
    ///   - originalW: original image width
    /// - Returns: return new CGSize(width,height) for image
    private func getNewWidthAndHeight(fixW : Float,fixH : Float, originalH : Float,originalW: Float) -> CGSize {
        
        var newWidth : Float = 0.0
        var newHeight : Float = 0.0
        
        if originalW > fixW && originalH > fixH {
            newWidth = fixW
            newHeight = fixH
        } else if originalW > fixW && originalH < fixH {
            newWidth = fixW
            newHeight = originalH
        } else if originalW < fixW && originalH > fixH {
            newWidth = originalW
            newHeight = fixH
        } else if originalW < fixW && originalH < fixH {
            newWidth = originalW
            newHeight = originalH
        } else if originalW == fixW && originalH < fixH {
            newWidth = originalW
            newHeight = originalH
        }
            //fix crash on 28.02.2019, when image is too small
        else {
            newWidth = fixW
            newHeight = fixH
        }
        return CGSize(width: CGFloat(newWidth), height: CGFloat(newHeight))
    }
    func fixedOrientation() -> UIImage {
    // No-op if the orientation is already correct
    if (imageOrientation == UIImage.Orientation.up) {
        return self
    }
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    var transform:CGAffineTransform = CGAffineTransform.identity
    
    if (imageOrientation == UIImage.Orientation.down
        || imageOrientation == UIImage.Orientation.downMirrored) {
        
        transform = transform.translatedBy(x: size.width, y: size.height)
        transform = transform.rotated(by: CGFloat(Double.pi))
    }
    
    if (imageOrientation == UIImage.Orientation.left
        || imageOrientation == UIImage.Orientation.leftMirrored) {
        
        transform = transform.translatedBy(x: size.width, y: 0)
        transform = transform.rotated(by: CGFloat(Double.pi/2))
    }
    
    if (imageOrientation == UIImage.Orientation.right
        || imageOrientation == UIImage.Orientation.rightMirrored) {
        
        transform = transform.translatedBy(x: 0, y: size.height);
        transform = transform.rotated(by: CGFloat(-Double.pi/2));
    }
    
    if (imageOrientation == UIImage.Orientation.upMirrored
        || imageOrientation == UIImage.Orientation.downMirrored) {
        
        transform = transform.translatedBy(x: size.width, y: 0)
        transform = transform.scaledBy(x: -1, y: 1)
    }
    
    if (imageOrientation == UIImage.Orientation.leftMirrored
        || imageOrientation == UIImage.Orientation.rightMirrored) {
        
        transform = transform.translatedBy(x: size.height, y: 0);
        transform = transform.scaledBy(x: -1, y: 1);
    }
    
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    let ctx:CGContext = CGContext(data: nil, width: Int(size.width), height: Int(size.height),
                                  bitsPerComponent: cgImage!.bitsPerComponent, bytesPerRow: 0,
                                  space: cgImage!.colorSpace!,
                                  bitmapInfo: cgImage!.bitmapInfo.rawValue)!
    
    ctx.concatenate(transform)
    
    
    if (imageOrientation == UIImage.Orientation.left
        || imageOrientation == UIImage.Orientation.leftMirrored
        || imageOrientation == UIImage.Orientation.right
        || imageOrientation == UIImage.Orientation.rightMirrored
        ) {
        
        
        ctx.draw(cgImage!, in: CGRect(x:0,y:0,width:size.height,height:size.width))
        
    } else {
        ctx.draw(cgImage!, in: CGRect(x:0,y:0,width:size.width,height:size.height))
    }
    
    
    // And now we just create a new UIImage from the drawing context
    let cgimg:CGImage = ctx.makeImage()!
    let imgEnd:UIImage = UIImage(cgImage: cgimg)
    
    return imgEnd
    }
    
    func cropImageForThumbnail() -> UIImage {
        let size = self.size
        var widthHeight : CGFloat = 0
        var crop = CGRect()
        if size.height > size.width {
            // Dom: comment this code because it make image rotate
//            widthHeight = size.width
//            crop = CGRect(x: 0, y: 0, width: size.width, height: widthHeight * 0.8)
            return self
        }
        else {
            widthHeight = size.height
            let cutEdge = (size.width - widthHeight) / 2
            crop = CGRect(x: cutEdge, y: 0, width: widthHeight, height: widthHeight)
        }
        let cgImage : CGImage = (self.cgImage?.cropping(to: crop))!
        let croppedImage : UIImage = UIImage(cgImage: cgImage)
        
        return croppedImage
    }
    
    func imageWithColor(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContext(self.size)
        guard let context = UIGraphicsGetCurrentContext() else { return self }
        
        // flip the image
        context.scaleBy(x: 1.0, y: -1.0)
        context.translateBy(x: 0.0, y: -self.size.height)
        
        // multiply blend mode
        context.setBlendMode(.multiply)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context.clip(to: rect, mask: self.cgImage!)
        color.setFill()
        context.fill(rect)
        
        // create UIImage
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return self }
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
