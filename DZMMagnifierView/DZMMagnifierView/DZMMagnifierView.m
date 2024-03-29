//
//  DZMMagnifierView.m
//  UIMenuController
//
//  Created by 邓泽淼 on 2017/11/27.
//  Copyright © 2017年 邓泽淼. All rights reserved.
//

#define DZMMV_AnimateDuration 0.08

#define DZMMV_Scale 1.8

#define DZMMV_WH 120

#import "DZMMagnifierView.h"

@interface DZMMagnifierView ()

@property (nonatomic, strong) DZMMagnifierView *strongSelf;

@property (nonatomic, weak) CALayer *contentLayer;

@end

@implementation DZMMagnifierView

+ (instancetype)magnifierView {
    
    DZMMagnifierView *mv = [[DZMMagnifierView alloc] init];
    
    mv.strongSelf = mv;
    
    return mv;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) { }
    
    return self;
}

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        self.offsetPoint = CGPointMake(0, 0);
        self.scale = DZMMV_Scale;
        
        self.frame = CGRectMake(0, 0, DZMMV_WH, DZMMV_WH);
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[[UIColor grayColor] colorWithAlphaComponent:0.9] CGColor];
        self.layer.cornerRadius = DZMMV_WH / 2;
        self.layer.masksToBounds = YES;
        self.windowLevel = UIWindowLevelAlert;
        // iOS13 以后苹果增加了 SceneDelegate 来管理窗口，必须将自定义 Window 注册到 SceneDelegate 中
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene *windowScene in [UIApplication sharedApplication].connectedScenes) {
                if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                    self.windowScene = windowScene;
                    break;
                }
            }
        }
        
        CALayer *contentLayer = [CALayer layer];
        contentLayer.frame = self.bounds;
        contentLayer.delegate = self;
        contentLayer.contentsScale = [[UIScreen mainScreen] scale];
        [self.layer addSublayer:contentLayer];
        self.contentLayer = contentLayer;
        
        self.transform = CGAffineTransformMakeScale(0.5, 0.5);
    }
    
    return self;
}

- (void)setOffsetPoint:(CGPoint)offsetPoint {
    
    _offsetPoint = offsetPoint;

    [self setTargetPoint:self.targetPoint];
}

- (void)setScale:(CGFloat)scale {
    
    _scale = scale;
    
    [self.contentLayer setNeedsDisplay];
}

- (void)setTargetWindow:(UIView *)targetWindow {
    
    _targetWindow = targetWindow;
    
    [self makeKeyAndVisible];
    
    __weak DZMMagnifierView *weakSelf = self;
    
    [UIView animateWithDuration:DZMMV_AnimateDuration animations:^{
        
        weakSelf.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
    
    [self setTargetPoint:self.targetPoint];
}

- (void)setTargetPoint:(CGPoint)targetPoint {
    
    _targetPoint = targetPoint;
    
    if (self.targetWindow) {
        
        CGPoint center = CGPointMake(targetPoint.x, self.center.y);
        
        if (targetPoint.y > CGRectGetHeight(self.bounds) * 0.5) {
            
            center.y = targetPoint.y -  CGRectGetHeight(self.bounds) / 2;
        }
        
        self.center = CGPointMake(center.x + self.offsetPoint.x, center.y + self.offsetPoint.y);
        
        [self.contentLayer setNeedsDisplay];
    }
}

- (void)remove:(void (^)(void))complete {
    
    __weak DZMMagnifierView *weakSelf = self;
    
    [UIView animateWithDuration:DZMMV_AnimateDuration animations:^{
        
        weakSelf.alpha = 0.5;
        
        weakSelf.transform = CGAffineTransformMakeScale(0.2, 0.2);
        
    } completion:^(BOOL finished) {
        
        [weakSelf removeFromSuperview];
        
        weakSelf.strongSelf = nil;
        
        if (complete != nil) { complete(); }
    }];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    CGContextTranslateCTM(ctx, DZMMV_WH / 2, DZMMV_WH / 2);
    
    CGContextScaleCTM(ctx, self.scale, self.scale);
    
    CGContextTranslateCTM(ctx, -1 * self.targetPoint.x, -1 * self.targetPoint.y);
    
    [self.targetWindow.layer renderInContext:ctx];
}

- (void)dealloc
{
    [self.contentLayer removeFromSuperlayer];

    self.contentLayer = nil;
}

@end
