#import <ImageIO/ImageIO.h>
#import <Accelerate/Accelerate.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImage+EEUtils.h"

@implementation UIImage (EEUtils)

CGAffineTransform CreateTransformForOrientation(UIImageOrientation orientation, CGSize imageSize, BOOL *swapWidthHeight);

+ (BOOL)isHorizontal:(UIImageOrientation)orientation
{
  return orientation == UIImageOrientationLeft || orientation == UIImageOrientationRight ||
    orientation == UIImageOrientationLeftMirrored || orientation == UIImageOrientationRightMirrored;
}

- (BOOL)isHorizontal
{
  UIImageOrientation orientation = self.imageOrientation;
  return orientation == UIImageOrientationLeft || orientation == UIImageOrientationRight ||
    orientation == UIImageOrientationLeftMirrored || orientation == UIImageOrientationRightMirrored;
}

#pragma mark - Render

- (void)prerender
{
  UIGraphicsBeginImageContextWithOptions(CGSizeMake(1, 1), YES, 0);
  [self drawAtPoint:CGPointZero];
  UIGraphicsEndImageContext();
}

- (UIImage *)prerenderedImage
{
  UIGraphicsBeginImageContextWithOptions(self.size, YES, 0);
  [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}

#pragma mark - Resizing

- (UIImage *)correctImageToSize:(CGSize)size
{
  UIImage *resultImage = self;
  if(size.width >= 1.0 && size.height >= 1.0) {
    CGSize imageSize = CGSizeMake(CGImageGetWidth(self.CGImage), CGImageGetHeight(self.CGImage));
    if(imageSize.width > size.width || imageSize.height > size.height || self.imageOrientation != UIImageOrientationUp) {
      UIImage *image = [self imageByScaleAndRotatePhotoToMaxSize:size cropToSquare:NO cornerRadius:0];
      if(image)
        resultImage = image;
    }
  }
  return resultImage;
}

- (UIImage *)imageResize:(CGSize)size
{
  UIGraphicsBeginImageContext(size);
  [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}

- (UIImage *)imageByScaleAndRotatePhotoToMaxSize:(CGSize)maxSize cropToSquare:(BOOL)square cornerRadius:(CGFloat)cornerRadius
{
  CGImageRef imgRef = self.CGImage;
  CGFloat width = CGImageGetWidth(imgRef);
  CGFloat height = CGImageGetHeight(imgRef);
  if(width == 0.0 || height == 0.0)
    return nil;

  CGSize newSize = CGSizeMake(width, height);
  if(width > maxSize.width || height > maxSize.height) {
    if(square) {
      CGFloat ratio = height / width;
      if(ratio > 1) {
        newSize.width = maxSize.width;
        newSize.height = roundf(newSize.width * ratio);
      } else {
        newSize.height = maxSize.height;
        newSize.width = roundf(newSize.height / ratio);
      }
    } else {
      CGFloat ratio = width / height;
      if(ratio > 1) {
        newSize.width = maxSize.width;
        newSize.height = roundf(newSize.width / ratio);
      } else {
        newSize.height = maxSize.height;
        newSize.width = roundf(newSize.height * ratio);
      }
    }
  }
  CGFloat r = MIN(width, height) / 2;
  if(cornerRadius > r)
    cornerRadius = r;

  CGFloat scaleRatio = newSize.width / width;
  UIImageOrientation orientation = self.imageOrientation;

  BOOL swapWidthHeight = NO;
  CGAffineTransform transform = CreateTransformForOrientation(orientation, CGSizeMake(width, height), &swapWidthHeight);
  if(swapWidthHeight)
    newSize = CGSizeMake(newSize.height, newSize.width);

  CGFloat minWH = MIN(width, height);
  CGFloat minWHM = MIN(minWH, MIN(maxSize.width, maxSize.height));
  CGSize drawSize = square ? CGSizeMake(minWHM, minWHM) : newSize;
  CGFloat dx = square ? (minWH - width) * 0.5f : 0.0f;
  CGFloat dy = square ? (height - minWH) * 0.5f : 0.0f;

  UIGraphicsBeginImageContext(drawSize);
  CGContextRef context = UIGraphicsGetCurrentContext();
  if([UIImage isHorizontal:orientation]) {
    CGContextScaleCTM(context, -scaleRatio, scaleRatio);
    CGContextTranslateCTM(context, -height, 0);
  } else {
    CGContextScaleCTM(context, scaleRatio, -scaleRatio);
    CGContextTranslateCTM(context, 0, -height);
  }
  CGContextConcatCTM(context, transform);
  if(cornerRadius >= 1.0) {
    CGRect frame = CGRectMake(0.0, dy * 2.0f, square ? minWH : width, square ? minWH : height);
    CGPathRef clipPath = [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:cornerRadius / scaleRatio].CGPath;
    CGContextAddPath(context, clipPath);
    CGContextClip(context);
  }
  CGContextDrawImage(context, CGRectMake(dx, dy, width, height), imgRef);
  UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  return resultImage;
}

- (UIImage *)imageByScaleAndRotatePhotoToMaxSize:(CGSize)maxSize fill:(BOOL)fill crop:(BOOL)crop
{
  CGImageRef imgRef = self.CGImage;
  CGFloat width = CGImageGetWidth(imgRef);
  CGFloat height = CGImageGetHeight(imgRef);
  if(width == 0.0 || height == 0.0)
    return self;
  if(width <= maxSize.width && height <= maxSize.height && self.imageOrientation == UIImageOrientationUp) {
    if((width == maxSize.width && height == maxSize.height) || (!fill && !crop))
      return self;
  }

  CGSize newSize = CGSizeMake(width, height);
  if(width > maxSize.width || height > maxSize.height) {
    if(fill) {
      CGFloat ratio = height / width;
      if(ratio > 1) {
        newSize.width = maxSize.width;
        newSize.height = roundf(newSize.width * ratio);
      } else {
        newSize.height = maxSize.height;
        newSize.width = roundf(newSize.height / ratio);
      }
    } else {
      CGFloat ratio = width / height;
      if(ratio > 1) {
        newSize.width = maxSize.width;
        newSize.height = roundf(newSize.width / ratio);
      } else {
        newSize.height = maxSize.height;
        newSize.width = roundf(newSize.height * ratio);
      }
    }
  }

  CGFloat scaleRatio = newSize.width / width;
  UIImageOrientation orientation = self.imageOrientation;

  BOOL swapWidthHeight = NO;
  CGAffineTransform transform = CreateTransformForOrientation(orientation, CGSizeMake(width, height), &swapWidthHeight);
  if(swapWidthHeight)
    newSize = CGSizeMake(newSize.height, newSize.width);

  CGSize cropSize = CGSizeMake(MIN(newSize.width, maxSize.width), MIN(newSize.height, maxSize.height));
  CGSize drawSize = (fill && crop) ? cropSize : newSize;
  CGFloat dx = (fill && crop) ? (cropSize.width / scaleRatio - width) * 0.5f : 0.0f;
  CGFloat dy = (fill && crop) ? (height - cropSize.height / scaleRatio) * 0.5f : 0.0f;

  UIGraphicsBeginImageContext(drawSize);
  CGContextRef context = UIGraphicsGetCurrentContext();
  if([UIImage isHorizontal:orientation]) {
    CGContextScaleCTM(context, -scaleRatio, scaleRatio);
    CGContextTranslateCTM(context, -height, 0);
  } else {
    CGContextScaleCTM(context, scaleRatio, -scaleRatio);
    CGContextTranslateCTM(context, 0, -height);
  }
  CGContextConcatCTM(context, transform);
  CGContextDrawImage(context, CGRectMake(dx, dy, width, height), imgRef);
  UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  return resultImage;
}

- (UIImage *)rotatedAndScaledImageToSize:(CGSize)size crop:(BOOL)crop
{
  CGImageRef imageRef = self.CGImage;
  CGFloat width = CGImageGetWidth(imageRef);
  CGFloat height = CGImageGetHeight(imageRef);
  if(width == 0.0 || height == 0.0)
    return nil;

  CGSize originalSize = CGSizeMake(width, height);
  UIImageOrientation orientation = self.imageOrientation;
  if(orientation == UIImageOrientationUp && CGSizeEqualToSize(originalSize, size))
    return self;

  BOOL swapWidthHeight = NO;
  CGAffineTransform transform = CreateTransformForOrientation(orientation, originalSize, &swapWidthHeight);
  if(swapWidthHeight)
    originalSize = CGSizeMake(height, width);

  CGFloat originalRatio = originalSize.width / originalSize.height;
  CGFloat croppedRatio = size.width / size.height;
  CGSize croppedSize = originalSize;
  CGSize scaledSize = originalSize;
  if(originalSize.width > size.width && originalSize.height > size.height) {
    if(originalRatio < croppedRatio) {
      scaledSize.width = size.width;
      scaledSize.height = roundf(scaledSize.width / originalRatio);
    } else {
      scaledSize.height = size.height;
      scaledSize.width = roundf(scaledSize.height * originalRatio);
    }
    croppedSize = size;
  } else {
    if(originalRatio > croppedRatio)
      croppedSize.height = roundf(croppedSize.width / croppedRatio);
    else
      croppedSize.width = roundf(croppedSize.height * croppedRatio);
    if(orientation == UIImageOrientationUp)
      return crop ? [self croppedImageToSize:croppedSize] : self;
  }

  CGFloat scaleRatio = scaledSize.width / originalSize.width;

  CGSize unscaledCroppedSize = CGSizeMake(croppedSize.width / scaleRatio, croppedSize.height / scaleRatio);
  if(!crop) {
    croppedSize = scaledSize;
    unscaledCroppedSize = originalSize;
  }

  CGPoint offset = CGPointMake(
    crop ? (unscaledCroppedSize.width - originalSize.width) / 2.0f : 0.0f,
    crop ? (unscaledCroppedSize.height - originalSize.height) / 2.0f : 0.0f);

  UIGraphicsBeginImageContext(croppedSize);
  CGContextRef context = UIGraphicsGetCurrentContext();
  if([UIImage isHorizontal:orientation]) {
    CGContextScaleCTM(context, -scaleRatio, scaleRatio);
    CGContextTranslateCTM(context, -height, 0);
  } else {
    CGContextScaleCTM(context, scaleRatio, -scaleRatio);
    CGContextTranslateCTM(context, 0, -height);
    offset.y = -offset.y;
  }
  CGContextConcatCTM(context, transform);
  CGRect drawFrame = CGRectMake(swapWidthHeight ? offset.y : offset.x, swapWidthHeight ? offset.x : offset.y, width, height);
  CGContextDrawImage(context, drawFrame, imageRef);
  UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  return resultImage;
}

- (UIImage *)croppedImageToSize:(CGSize)size
{
  if(self.isHorizontal)
    size = CGSizeMake(size.height, size.width);

  CGSize imageSize = CGSizeMake(CGImageGetWidth(self.CGImage), CGImageGetHeight(self.CGImage));
  size.width = MIN(size.width, imageSize.width);
  size.height = MIN(size.height, imageSize.height);

  if(CGSizeEqualToSize(imageSize, size))
    return self;

  CGRect frame = CGRectMake((imageSize.width - size.width) / 2.0f, (imageSize.height - size.height) / 2.0f, size.width, size.height);
  CGImageRef croppedImageRef = CGImageCreateWithImageInRect(self.CGImage, frame);
  UIImage *croppedImage = [UIImage imageWithCGImage:croppedImageRef scale:self.scale orientation:self.imageOrientation];
  CGImageRelease(croppedImageRef);
  return croppedImage;
}

- (UIImage *)rotatedImageWithExifOrientation
{
  UIImageOrientation orientation = self.imageOrientation;
  if(orientation == UIImageOrientationUp)
    return self;

  CGImageRef imgRef = self.CGImage;
  CGFloat width = CGImageGetWidth(imgRef);
  CGFloat height = CGImageGetHeight(imgRef);
  if(width == 0.0 || height == 0.0)
    return nil;

  CGRect bounds = CGRectMake(0, 0, width, height);
  CGFloat scaleRatio = 1.0;

  BOOL swapWidthHeight = NO;
  CGAffineTransform transform = CreateTransformForOrientation(orientation, CGSizeMake(width, height), &swapWidthHeight);
  if(swapWidthHeight)
    bounds.size = CGSizeMake(bounds.size.height, bounds.size.width);

  UIGraphicsBeginImageContext(bounds.size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  if([UIImage isHorizontal:orientation]) {
    CGContextScaleCTM(context, -scaleRatio, scaleRatio);
    CGContextTranslateCTM(context, -height, 0);
  } else {
    CGContextScaleCTM(context, scaleRatio, -scaleRatio);
    CGContextTranslateCTM(context, 0, -height);
  }
  CGContextConcatCTM(context, transform);

  CGContextDrawImage(context, CGRectMake(0, 0, width, height), imgRef);
  UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  return resultImage;
}

CGAffineTransform CreateTransformForOrientation(UIImageOrientation orientation, CGSize imageSize, BOOL *swapWidthHeight)
{
  *swapWidthHeight = NO;
  CGAffineTransform transform;
  switch(orientation) {
    case UIImageOrientationUp: // EXIF = 1
      transform = CGAffineTransformIdentity;
      break;
    case UIImageOrientationUpMirrored: // EXIF = 2
      transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
      transform = CGAffineTransformScale(transform, -1.0f, 1.0);
      break;
    case UIImageOrientationDown: // EXIF = 3
      transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
      transform = CGAffineTransformRotate(transform, (CGFloat)M_PI);
      break;
    case UIImageOrientationDownMirrored: // EXIF = 4
      transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
      transform = CGAffineTransformScale(transform, 1.0, -1.0f);
      break;
    case UIImageOrientationLeftMirrored: // EXIF = 5
      *swapWidthHeight = YES;
      transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
      transform = CGAffineTransformScale(transform, -1.0f, 1.0);
      transform = CGAffineTransformRotate(transform, (CGFloat)(3.0 * M_PI / 2.0));
      break;
    case UIImageOrientationLeft: // EXIF = 6
      *swapWidthHeight = YES;
      transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
      transform = CGAffineTransformRotate(transform, (CGFloat)(3.0 * M_PI / 2.0));
      break;
    case UIImageOrientationRightMirrored: // EXIF = 7
      *swapWidthHeight = YES;
      transform = CGAffineTransformMakeScale(-1.0f, 1.0);
      transform = CGAffineTransformRotate(transform, (CGFloat)(M_PI / 2.0));
      break;
    case UIImageOrientationRight: // EXIF = 8
      *swapWidthHeight = YES;
      transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
      transform = CGAffineTransformRotate(transform, (CGFloat)(M_PI / 2.0));
      break;
    default:
      transform = CGAffineTransformIdentity;
  }
  return transform;
}

- (UIImage *)imageWithRoundedCornersRadius:(CGFloat)radius;
{
  CGRect frame = CGRectMake(0.0, 0.0, self.size.width, self.size.height);
  UIGraphicsBeginImageContext(self.size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGPathRef clipPath = [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:radius].CGPath;
  CGContextAddPath(context, clipPath);
  CGContextClip(context);
  [self drawInRect:frame];
  UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return roundedImage;
}

+ (UIImage *)imageMaskWithRoundedCornersRadius:(CGFloat)radius
{
  CGFloat size = (radius * 2) + 1; // 1 pixel for stretching
  UIGraphicsBeginImageContext(CGSizeMake(size, size));
  CGContextRef context = UIGraphicsGetCurrentContext();

  CGContextSetAlpha(context, 0.5f);
  CGContextSetLineWidth(context, 0);
  CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);

  CGFloat minX = 0;
  CGFloat midX = size / 2;
  CGFloat maxX = size;
  CGFloat minY = 0;
  CGFloat midY = size / 2;
  CGFloat maxY = size;

  CGContextMoveToPoint(context, minX, midY);
  CGContextAddArcToPoint(context, minX, minY, midX, minY, radius);
  CGContextAddArcToPoint(context, maxX, minY, maxX, midY, radius);
  CGContextAddArcToPoint(context, maxX, maxY, midX, maxY, radius);
  CGContextAddArcToPoint(context, minX, maxY, minX, midY, radius);
  CGContextClosePath(context);
  CGContextDrawPath(context, kCGPathFillStroke);

  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  return image;
}

- (UIImage *)imageWithMask:(UIImage *)mask
{
  CGImageRef imageRef = self.CGImage;
  CGRect imageRect = CGRectMake(0, 0, CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));

  // mask with transparency
  //CGImageRef maskRef = mask.CGImage;
  //CGImageRef maskImageRef = CGImageMaskCreate(CGImageGetWidth(maskRef), CGImageGetHeight(maskRef), CGImageGetBitsPerComponent(maskRef),
  //  CGImageGetBitsPerPixel(maskRef), CGImageGetBytesPerRow(maskRef), CGImageGetDataProvider(maskRef), NULL, false);
  //CGImageRef maskedImageRef = CGImageCreateWithMask(self.CGImage, maskImageRef);

  // mask with grayscale
  CGImageRef maskedImageRef = CGImageCreateWithMask(imageRef, mask.CGImage);

  UIGraphicsBeginImageContext(imageRect.size);
  CGContextDrawImage(UIGraphicsGetCurrentContext(), imageRect, maskedImageRef);
  UIImage *maskedImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  CGImageRelease(maskedImageRef);

  return maskedImage;
}

#pragma mark - Grayscale

- (UIImage *)grayscaleImage
{
  CGSize size = self.size;
  CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);

  UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
  CGContextRef ctx = UIGraphicsGetCurrentContext();

  CGContextSetRGBFillColor(ctx, 1.0f, 1.0f, 1.0f, 1.0f);
  CGContextFillRect(ctx, rect);

  [self drawInRect:rect blendMode:kCGBlendModeLuminosity alpha:1.0f];
  //[image drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];

  UIImage *grayscaleImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  return grayscaleImage;
}

- (UIImage *)grayscaleImage2
{
  CGSize size = self.size;
  CGFloat scale = self.scale;
  CGRect rect = CGRectMake(0, 0, size.width * scale, size.height * scale);

  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
  CGContextRef context = CGBitmapContextCreate(nil, (size_t)rect.size.width, (size_t)rect.size.height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaNone);
  CGContextDrawImage(context, rect, self.CGImage);
  CGImageRef grayImage = CGBitmapContextCreateImage(context);
  CGColorSpaceRelease(colorSpace);
  CGContextRelease(context);

  context = CGBitmapContextCreate(nil, (size_t)rect.size.width, (size_t)rect.size.height, 8, 0, nil, (CGBitmapInfo)kCGImageAlphaOnly);
  CGContextDrawImage(context, rect, self.CGImage);
  CGImageRef mask = CGBitmapContextCreateImage(context);
  CGContextRelease(context);

  CGImageRef cgImage = CGImageCreateWithMask(grayImage, mask);
  UIImage *grayScaleImage = [UIImage imageWithCGImage:cgImage scale:scale orientation:self.imageOrientation];

  CGImageRelease(cgImage);
  CGImageRelease(grayImage);
  CGImageRelease(mask);

  return grayScaleImage;
}

#pragma mark - Blur

- (UIImage *)blurredImageWithBlurLevel:(uint32_t)blur
{
  // blur (0;64]
  if(blur == 0)
    return self;

  CGImageRef img = self.CGImage;

  vImage_Buffer inBuffer, outBuffer;

  CGDataProviderRef inProvider = CGImageGetDataProvider(img);
  CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);

  inBuffer.width = CGImageGetWidth(img);
  inBuffer.height = CGImageGetHeight(img);
  inBuffer.rowBytes = CGImageGetBytesPerRow(img);
  inBuffer.data = (void *)CFDataGetBytePtr(inBitmapData);

  void *pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));

  outBuffer.data = pixelBuffer;
  outBuffer.width = CGImageGetWidth(img);
  outBuffer.height = CGImageGetHeight(img);
  outBuffer.rowBytes = CGImageGetBytesPerRow(img);

  //vImage_Error error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, blur, blur, NULL, kvImageEdgeExtend);
  vImage_Error error = vImageTentConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, blur, blur, NULL, kvImageEdgeExtend);
  if(error)
    NSLog(@"Image processing error %ld", error);

  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  CGContextRef ctx = CGBitmapContextCreate(outBuffer.data, outBuffer.width, outBuffer.height, 8, outBuffer.rowBytes, colorSpace, CGImageGetBitmapInfo(img));

  CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
  UIImage *resultImage = [UIImage imageWithCGImage:imageRef scale:[UIScreen mainScreen].scale orientation:self.imageOrientation];

  // clean up
  CGContextRelease(ctx);
  CGColorSpaceRelease(colorSpace);
  free(pixelBuffer);
  CFRelease(inBitmapData);
  CGImageRelease(imageRef);

  return resultImage;
}

#pragma mark - Color

+ (UIImage *)imageWithColor:(UIColor *)color
{
  CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
  UIGraphicsBeginImageContext(rect.size);
  CGContextRef context = UIGraphicsGetCurrentContext();

  CGContextSetFillColorWithColor(context, [color CGColor]);
  CGContextFillRect(context, rect);

  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  return image;
}

@end

@implementation ImageUtils

#pragma mark - Asset Library

+ (void)assetInfoFromURL:(NSURL *)assetURL completion:(void (^)(NSDictionary *, NSError *))completion
{
  ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
  [library assetForURL:assetURL
    resultBlock:^(ALAsset *asset) {
      ALAssetRepresentation *imageRepresentation = asset.defaultRepresentation;

      uint8_t *buffer = (Byte *)malloc((size_t)imageRepresentation.size);
      NSUInteger length = [imageRepresentation getBytes:buffer fromOffset:0 length:(NSUInteger)imageRepresentation.size error:nil];

      if(length != 0) {
        NSData *data = [[NSData alloc] initWithBytesNoCopy:buffer length:(NSUInteger)imageRepresentation.size freeWhenDone:YES];

        // identify image type (jpeg, png, RAW file, ...) using UTI hint
        NSDictionary *sourceOptionsDict = @{ (NSString *)kCGImageSourceTypeIdentifierHint : imageRepresentation.UTI };

        CGImageSourceRef sourceRef = CGImageSourceCreateWithData((__bridge CFDataRef)data, (__bridge CFDictionaryRef)sourceOptionsDict);

        CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(sourceRef, 0, NULL);
        NSDictionary *propertiesDict = (__bridge_transfer NSDictionary *)imageProperties;
        NSLog(@"Image properties: %@", propertiesDict);

        //CFDictionaryRef exif = (CFDictionaryRef)CFDictionaryGetValue(imageProperties, kCGImagePropertyExifDictionary);
        //NSDictionary *exif_dict = (__bridge NSDictionary *)exif;
        //NSLog(@"exif_dict: %@", exif_dict);

        /*NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSURL *fileURL = nil;
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(sourceRef, 0, imageProperties);

        if(![[sourceOptionsDict objectForKey:@"kCGImageSourceTypeIdentifierHint"] isEqualToString:@"public.tiff"]) {
          fileURL = [NSURL fileURLWithPath:[NSString
            stringWithFormat:@"%@/%@.%@", documentsDirectory, @"myimage",
              [[sourceOptionsDict[@"kCGImageSourceTypeIdentifierHint"] componentsSeparatedByString:@"."] objectAtIndex:1]]];
          CGImageDestinationRef dr = CGImageDestinationCreateWithURL(
            (__bridge CFURLRef)fileURL, (__bridge CFStringRef)sourceOptionsDict[@"kCGImageSourceTypeIdentifierHint"], 1, NULL);
          CGImageDestinationAddImage(dr, imageRef, imageProperties);
          CGImageDestinationFinalize(dr);
          CFRelease(dr);
        } else {
          NSLog(@"no valid kCGImageSourceTypeIdentifierHint found …");
        }

        CFRelease(imageRef);*/
        //CFRelease(imageProperties);
        CFRelease(sourceRef);

        if(completion)
          completion(propertiesDict, nil);
      } else {
        free(buffer);
        NSLog(@"imageRepresentation buffer length == 0");
        if(completion)
          completion(nil, nil);
      }
    }
    failureBlock:^(NSError *error) {
      NSLog(@"couldn't get asset: %@", error);
      if(completion)
        completion(nil, error);
    }
  ];
}

+ (void)writeImage:(UIImage *)image toAlbum:(NSString *)albumName completion:(AssetCallback)completion
{
  ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
  [library writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)image.imageOrientation
    completionBlock:^(NSURL *assetURL, NSError *error) {
      if(!error) {
        [library addAssetURL:assetURL toAlbum:albumName completion:completion];
      } else {
        if(completion)
          completion(nil, error);
      }
    }];
}

+ (void)writeVideo:(NSURL *)url toAlbum:(NSString *)albumName completion:(AssetCallback)completion
{
  ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
  [library writeVideoAtPathToSavedPhotosAlbum:url completionBlock:^(NSURL *assetURL, NSError *error) {
    if(!error) {
      [library addAssetURL:assetURL toAlbum:albumName completion:completion];
    } else {
      if(completion)
        completion(nil, error);
    }
  }];
}

@end

@implementation ALAssetsLibrary (Utils)

- (void)addAssetURL:(NSURL *)assetURL toAlbum:(NSString *)albumName completion:(AssetCallback)completion
{
  void (^failureBlock)(NSError *) = ^(NSError *error) {
    if(completion)
      completion(assetURL, error);
  };

  [self enumerateGroupsWithTypes:ALAssetsGroupAlbum
    usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
      if([albumName compare:[group valueForProperty:ALAssetsGroupPropertyName]] == NSOrderedSame) {
        [self assetForURL:assetURL
          resultBlock:^(ALAsset *asset) {
            [group addAsset:asset];
            if(completion)
              completion(assetURL, nil);
          }
          failureBlock:failureBlock];
        *stop = YES;
        return;
      }

      if(!group) {
        __typeof(self) __weak weakSelf = self;
        [self addAssetsGroupAlbumWithName:albumName
          resultBlock:^(ALAssetsGroup *assetsGroup) {
            [weakSelf assetForURL:assetURL
              resultBlock:^(ALAsset *asset) {
                [assetsGroup addAsset:asset];
                if(completion)
                  completion(assetURL, nil);
              }
              failureBlock:failureBlock];
          }
          failureBlock:failureBlock];
      }
    }
    failureBlock:failureBlock];
}

@end