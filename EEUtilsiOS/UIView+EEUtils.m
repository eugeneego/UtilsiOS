#import "UIView+EEUtils.h"

@implementation UIView (EEUtils)

#pragma mark - Screenshot

- (UIImage *)screenshot
{
  UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
  [self.layer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}

- (UIImage *)screenshot7
{
  UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
  if(![self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)] || ![self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO])
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}

#pragma mark - Transitions

- (void)addFadeTransition
{
  CATransition *transition = [CATransition animation];
  transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  transition.type = kCATransitionFade;
  [self.layer addAnimation:transition forKey:nil];
}

#pragma mark - Constraints

- (void)addConstraintsToFillSuperView
{
  UIView *superView = self.superview;
  if(!superView)
    return;

  self.translatesAutoresizingMaskIntoConstraints = NO;

  NSLayoutConstraint *top = [NSLayoutConstraint
    constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
    toItem:superView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
  [superView addConstraint:top];

  NSLayoutConstraint *left = [NSLayoutConstraint
    constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual
    toItem:superView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0];
  [superView addConstraint:left];

  NSLayoutConstraint *bottom = [NSLayoutConstraint
    constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual
    toItem:superView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
  [superView addConstraint:bottom];

  NSLayoutConstraint *right = [NSLayoutConstraint
    constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual
    toItem:superView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0];
  [superView addConstraint:right];
}

#pragma mark - Nib loading

+ (UIView *)viewFromNibNamed:(NSString *)name owner:(id)owner
{
  NSArray *views = [[NSBundle mainBundle] loadNibNamed:name owner:owner options:nil];
  return views.lastObject;
}

+ (instancetype)viewFromNibNamed:(NSString *)nibName
{
  UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
  NSArray *objects = [nib instantiateWithOwner:nil options:nil];

  __block id object;
  [objects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    if([obj isKindOfClass:[self class]]) {
      object = obj;
      *stop = YES;
    }
  }];

  return object;
}

@end