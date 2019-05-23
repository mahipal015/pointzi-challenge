//
//  PZTooltipView.m
//  Pointzi
//
//  Created by Mahipal Kummari on 23/05/19.
//  Copyright © 2019 Mahipal Kummari. All rights reserved.
//

#import "PZTooltipView.h"

#define GRAY_187 [UIColor colorWithRed:187.0f/255.0f green:187.0f/255.0f blue:187.0f/255.0f alpha:1.0f]
#define DRAPE_GRAY [UIColor colorWithWhite:0/255.0f alpha:0.5]

static const CGFloat kTriangleDimensions = 15.0f;
static const CGFloat kBoundingOffset = 10.0f;

@interface PZTooltipView ()
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIWindow *parentWindow;
@property (assign, nonatomic) CGRect sourceRect;
@property (strong, nonatomic) UIButton *drapeButton;
@property (assign, nonatomic) BOOL expandsToTop;

@property (assign, nonatomic) CGFloat leftInsetLimit;
@property (assign, nonatomic) CGFloat rightInsetLimit;

@property (strong, nonatomic) UIView *rootVC;

@end

@implementation PZTooltipView

- (id)initWithContentView:(UIView *)contentView sourceRect:(CGRect)sourceRect parentWindow:(UIWindow *)parentWindow
{
    self = [super init];
    if (self) {
        _contentView = contentView;
        _sourceRect = sourceRect;
        _parentWindow = parentWindow;
        
        [self toolTip_init];
    }
    return self;
}

- (void)toolTip_init
{
    _expandsToTop = YES;
    _rootVC = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    
    [self addSubview:self.contentView];
    
    CGRect drapeButtonRect = [_rootVC convertRect:_rootVC.frame toView:self];
    self.drapeButton = [[UIButton alloc] initWithFrame:drapeButtonRect];
    self.drapeButton.backgroundColor = DRAPE_GRAY;
    [self.drapeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    [_parentWindow insertSubview:self.drapeButton belowSubview:self];
    
    [self checkExpandingDirection];
    [self adjustXPosition];
}

#pragma mark - Setters

- (void)setHideShadow:(BOOL)hideShadow
{
    _hideShadow = hideShadow;
    
    self.drapeButton.backgroundColor = hideShadow ? [UIColor clearColor] : DRAPE_GRAY;
}

- (void)setArrowColor:(UIColor *)arrowColor
{
    _arrowColor = arrowColor;
    
    [self layoutIfNeeded];
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    
    [self layoutIfNeeded];
}

#pragma mark - Position Calculations

- (void)checkExpandingDirection
{
    if ((CGRectGetMaxY(self.sourceRect) + CGRectGetHeight(self.contentView.frame) + kTriangleDimensions + 10 > CGRectGetHeight(self.rootVC.frame)))
    {
        self.expandsToTop = YES;
        self.frame = CGRectMake(CGRectGetMinX(self.sourceRect) - ((CGRectGetWidth(self.contentView.frame) - CGRectGetWidth(self.sourceRect)) / 2),
                                CGRectGetMinY(self.sourceRect) - CGRectGetHeight(self.contentView.frame) - kTriangleDimensions,
                                CGRectGetWidth(self.contentView.frame),
                                CGRectGetHeight(self.contentView.frame));
    }
    
    else
    {
        self.expandsToTop = NO;
        self.frame = CGRectMake(CGRectGetMinX(self.sourceRect) - ((CGRectGetWidth(self.contentView.frame) - CGRectGetWidth(self.sourceRect)) / 2),
                                CGRectGetMaxY(self.sourceRect) + kTriangleDimensions,
                                CGRectGetWidth(self.contentView.frame),
                                CGRectGetHeight(self.contentView.frame));
    }
}

- (void)adjustXPosition
{
    //Arrange x position of the view for best position on screen
    
    self.leftInsetLimit = CGRectGetMinX(self.frame) - CGRectGetMinX(self.rootVC.frame) < kBoundingOffset ? CGRectGetMinX(self.frame) - CGRectGetMinX(self.rootVC.frame) : 0;
    self.rightInsetLimit = CGRectGetMaxX(self.rootVC.frame) - CGRectGetMaxX(self.frame) < -kBoundingOffset ? CGRectGetMaxX(self.rootVC.frame) - CGRectGetMaxX(self.frame) : 0;
    
    self.frame = self.leftInsetLimit < kBoundingOffset && self.leftInsetLimit != 0 ? CGRectMake(CGRectGetMinX(self.frame) - self.leftInsetLimit + kBoundingOffset,
                                                                                                CGRectGetMinY(self.frame),
                                                                                                CGRectGetWidth(self.frame),
                                                                                                CGRectGetHeight(self.frame)) : self.frame;
    
    self.frame = self.rightInsetLimit < -kBoundingOffset && self.rightInsetLimit != 0 ? CGRectMake(CGRectGetMinX(self.frame) + self.rightInsetLimit - kBoundingOffset,
                                                                                                   CGRectGetMinY(self.frame),
                                                                                                   CGRectGetWidth(self.frame),
                                                                                                   CGRectGetHeight(self.frame)) : self.frame;
}

#pragma mark - Draw Borders

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path,NULL,0.0,0.0);
    
    CGRect intentedSourceRect = [self.superview convertRect:self.sourceRect toView:self];
    
    if (self.expandsToTop)
    {
        CGPathAddLineToPoint(path, NULL, CGRectGetWidth(self.frame), 0.0f);
        CGPathAddLineToPoint(path, NULL, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        CGPathAddLineToPoint(path, NULL, CGRectGetMidX(intentedSourceRect) + kTriangleDimensions, CGRectGetHeight(self.frame));
        CGPathAddLineToPoint(path, NULL, CGRectGetMidX(intentedSourceRect), CGRectGetHeight(self.frame) + kTriangleDimensions);
        CGPathAddLineToPoint(path, NULL, CGRectGetMidX(intentedSourceRect) - kTriangleDimensions, CGRectGetHeight(self.frame));
        CGPathAddLineToPoint(path, NULL, 0.0f, CGRectGetHeight(self.frame));
        CGPathAddLineToPoint(path, NULL, 0.0f, 0.0f);
    }
    
    else
    {
        CGPathAddLineToPoint(path, NULL, CGRectGetMidX(intentedSourceRect) - kTriangleDimensions, 0.0f);
        CGPathAddLineToPoint(path, NULL, CGRectGetMidX(intentedSourceRect), - kTriangleDimensions);
        CGPathAddLineToPoint(path, NULL, CGRectGetMidX(intentedSourceRect) + kTriangleDimensions, 0.0f);
        CGPathAddLineToPoint(path, NULL, CGRectGetWidth(self.frame), 0.0f);
        CGPathAddLineToPoint(path, NULL, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        CGPathAddLineToPoint(path, NULL, 0.0f, CGRectGetHeight(self.frame));
        CGPathAddLineToPoint(path, NULL, 0.0f, 0.0f);
    }
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setPath:path];
    [shapeLayer setFillColor:self.arrowColor ? self.arrowColor.CGColor : [[UIColor whiteColor] CGColor]];
    [shapeLayer setStrokeColor:self.borderColor ? self.borderColor.CGColor : [GRAY_187 CGColor]];
    [shapeLayer setAnchorPoint:CGPointMake(0.0f, 0.0f)];
    [shapeLayer setPosition:CGPointMake(0.0f, 0.0f)];
    [self.layer addSublayer:shapeLayer];
    
    CGPathRelease(path);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self addSubview:self.contentView];
}

#pragma mark - Public Methods

- (void)show
{
    [self.parentWindow addSubview:self];
}

- (void)dismiss
{
    [self.drapeButton removeFromSuperview];
    [self removeFromSuperview];
}
@end
