//
//  PZTooltipView.h
//  Pointzi
//
//  Created by Mahipal Kummari on 23/05/19.
//  Copyright © 2019 Mahipal Kummari. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PZTooltipView : UIView
@property (assign, nonatomic, getter=isShadowHidden) BOOL hideShadow;
@property (strong, nonatomic) UIColor *arrowColor;
@property (strong, nonatomic) UIColor *borderColor;

- (id)initWithContentView:(UIView *)contentView sourceRect:(CGRect)sourceRect parentWindow:(UIWindow *)parentWindow;

- (void)show;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
