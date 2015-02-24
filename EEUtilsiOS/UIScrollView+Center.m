#import "UIScrollView+Center.h"

@implementation UIScrollView (Center)

- (void)centerContentWithSize:(CGSize)size
{
  CGSize contentSize = self.contentSize;
  if(CGSizeEqualToSize(contentSize, CGSizeZero))
    return;
  CGFloat x = (contentSize.width < size.width) ? (size.width - contentSize.width) * 0.5f : 0.0f;
  CGFloat y = (contentSize.height < size.height) ? (size.height - contentSize.height) * 0.5f : 0.0f;
  self.contentInset = UIEdgeInsetsMake(y, x, y, x);
}

- (void)centerContent
{
  CGSize boundsSize = self.bounds.size;
  CGSize contentSize = self.contentSize;
  if(CGSizeEqualToSize(contentSize, CGSizeZero))
    return;
  CGFloat x = (contentSize.width < boundsSize.width) ? (boundsSize.width - contentSize.width) * 0.5f : 0.0f;
  CGFloat y = (contentSize.height < boundsSize.height) ? (boundsSize.height - contentSize.height) * 0.5f : 0.0f;
  self.contentInset = UIEdgeInsetsMake(y, x, y, x);
}

- (void)centerContentHorizontally
{
  CGSize boundsSize = self.bounds.size;
  CGSize contentSize = self.contentSize;
  if(CGSizeEqualToSize(contentSize, CGSizeZero))
    return;
  CGFloat x = (contentSize.width < boundsSize.width) ? (boundsSize.width - contentSize.width) * 0.5f : 0.0f;
  self.contentInset = UIEdgeInsetsMake(0, x, 0, x);
}

- (void)centerContentVertically
{
  CGSize boundsSize = self.bounds.size;
  CGSize contentSize = self.contentSize;
  if(CGSizeEqualToSize(contentSize, CGSizeZero))
    return;
  CGFloat y = (contentSize.height < boundsSize.height) ? (boundsSize.height - contentSize.height) * 0.5f : 0.0f;
  self.contentInset = UIEdgeInsetsMake(y, 0, y, 0);
}

@end