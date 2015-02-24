#import "UITableViewCell+Size.h"

@implementation UITableViewCell (Size)

- (CGSize)calculateSizeWithWidth:(CGFloat)width
{
  if([self.contentView respondsToSelector:@selector(systemLayoutSizeFittingSize:withHorizontalFittingPriority:verticalFittingPriority:)])
    return [self.contentView systemLayoutSizeFittingSize:CGSizeMake(width, 0)
      withHorizontalFittingPriority:UILayoutPriorityRequired verticalFittingPriority:UILayoutPriorityFittingSizeLevel];
  else
    return [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
}

@end