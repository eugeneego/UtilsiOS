#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface UIImage (EEUtils)

+ (BOOL)isHorizontal:(UIImageOrientation)orientation;
- (BOOL)isHorizontal;

- (void)prerender;
- (UIImage *)prerenderedImage;

- (UIImage *)correctImageToSize:(CGSize)size;
- (UIImage *)imageResize:(CGSize)size;
- (UIImage *)imageByScaleAndRotatePhotoToMaxSize:(CGSize)maxSize cropToSquare:(BOOL)square cornerRadius:(CGFloat)cornerRadius;
- (UIImage *)imageByScaleAndRotatePhotoToMaxSize:(CGSize)maxSize fill:(BOOL)fill crop:(BOOL)crop;
- (UIImage *)rotatedAndScaledImageToSize:(CGSize)size crop:(BOOL)crop;
- (UIImage *)croppedImageToSize:(CGSize)size;
- (UIImage *)rotatedImageWithExifOrientation;
- (UIImage *)imageWithRoundedCornersRadius:(CGFloat)radius;
+ (UIImage *)imageMaskWithRoundedCornersRadius:(CGFloat)radius;

- (UIImage *)imageWithMask:(UIImage *)mask;

- (UIImage *)grayscaleImage;
- (UIImage *)grayscaleImage2;
- (UIImage *)blurredImageWithBlurLevel:(uint32_t)blur;

+ (UIImage *)imageWithColor:(UIColor *)color;

@end

typedef void(^AssetCallback)(NSURL *assetURL, NSError *error);

@interface ImageUtils: NSObject

+ (void)assetInfoFromURL:(NSURL *)assetURL completion:(void (^)(NSDictionary *, NSError *))completion;

+ (void)writeImage:(UIImage *)image toAlbum:(NSString *)albumName completion:(AssetCallback)completion;
+ (void)writeVideo:(NSURL *)url toAlbum:(NSString *)albumName completion:(AssetCallback)completion;

@end

@interface ALAssetsLibrary (Utils)

- (void)addAssetURL:(NSURL *)assetURL toAlbum:(NSString *)albumName completion:(AssetCallback)completion;

@end
