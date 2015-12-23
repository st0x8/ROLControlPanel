//
//  ROLControlPanel.m
//  ROLControlPanel
//
//  Created by Roy Lin on 15/12/3.
//  Copyright © 2015年 Roy Lin. All rights reserved.
//
//  https://github.com/st0x8/ROLControlPanel
//

#import "ROLControlPanel.h"

@interface ROLControlPanel () {
    
}
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic) UIButton *showButton;
@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, assign) CGPoint holdedPoint;
@property (nonatomic, assign) CGFloat slideToBottomOffest;
@property (nonatomic, assign) CGFloat showingY;
@property (nonatomic, assign) CGFloat closingY;
@end

@implementation ROLControlPanel

- (instancetype)initWithParentView:(UIView *)parentView {
    CGRect panelFrame = [self getFrameFromOrientation];
    if (self = [super initWithFrame:panelFrame]) {
        CGRect containerRect = panelFrame;
        containerRect.size.height = panelFrame.size.height * 0.65;
        _containerView = [[UIView alloc] initWithFrame:containerRect];
        _containerView.backgroundColor = [UIColor greenColor];
        [self addSubview:_containerView];
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
        _topView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        [_containerView addSubview:_topView];
        _showButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - 30, 5, 60, 30)];
        [_showButton setImage:[UIImage imageNamed:@"Button_Collapse"] forState:UIControlStateNormal];
        [_showButton addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:_showButton];
        [self initWithDefaultValue];
        [parentView addSubview:self];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    [NSException raise:@"ROLControlPanelInitialization" format:@"Please use initWithParentView: initialization."];
    return nil;
}

- (instancetype)init {
    return [self initWithFrame:CGRectNull];
}

- (void)initWithDefaultValue {
    self.closingY = self.frame.size.height - _topView.frame.size.height;
    self.showingY = self.frame.size.height - self.containerView.frame.size.height;
    self.velocityForSwipeFollowDerection = 650;
    self.slideAnimationDuration = 0.33;
    self.panelRevealAnimationOption = UIViewAnimationOptionCurveEaseOut;
    self.viewHeight = self.frame.size.height;
    CGRect rect = self.frame;
    rect.origin.y = self.closingY;//Close panel
    self.frame = rect;
    self.panelState = PanelStateClose;
    self.isReveal = NO;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDetected:)];
    [self setEnableSwipeGesture:YES];
}

#pragma mark Public Methods
- (void)closePanel {
    [UIView animateWithDuration:self.slideAnimationDuration delay:0 options:self.panelRevealAnimationOption animations:^{
        [self moveVerticallyToPosition:self.closingY];
        
    } completion:^(BOOL finished) {
        if (_isReveal) {
            if ([self.delegate respondsToSelector:@selector(panelClose)]) {
                [self.delegate panelClose];
            }
            if (self.PanelCloseBlock) {
                self.PanelCloseBlock();
            }
            _isReveal = NO;
            [_showButton setImage:[UIImage imageNamed:@"Button_Collapse"] forState:UIControlStateNormal];
        }
        if (self.panelState != PanelStateClose) {
            self.panelState = PanelStateClose;
        }
        
    }];
}

- (void)revealPanel {
    [UIView animateWithDuration:self.slideAnimationDuration delay:0 options:self.panelRevealAnimationOption animations:^{
        [self moveVerticallyToPosition:self.showingY];
    } completion:^(BOOL finished) {
        if (!_isReveal) {
            if ([self.delegate respondsToSelector:@selector(panelReveal)]) {
                [self.delegate panelReveal];
            }
            if (self.PanelRevealBlock) {
                self.PanelRevealBlock();
            }
            _isReveal = YES;
            [_showButton setImage:[UIImage imageNamed:@"Button_Expand"] forState:UIControlStateNormal];
        }
        if (self.panelState != PanelStateReveal) {
            self.panelState = PanelStateReveal;
        }
    }];
}

- (void)setIsReveal:(BOOL)isReveal {
    if (isReveal) {
        [self revealPanel];
    } else {
        [self closePanel];
    }
}

- (CGRect)getFrameFromOrientation {
    CGRect frame = [UIScreen mainScreen].bounds;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        return frame;
    } else {
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            CGRect landscpeeFrame = frame;
            landscpeeFrame.size.height = frame.size.width;
            landscpeeFrame.size.width = frame.size.height;
            return landscpeeFrame;
        }
        return frame;
    }
}

#pragma mark Setter & Getter
- (void)setEnableSwipeGesture:(BOOL)enableSwipeGesture {
    _enableSwipeGesture = enableSwipeGesture;
    if (_enableSwipeGesture) {
        [self addGestureRecognizer:self.panGestureRecognizer];
    } else {
        [self removeGestureRecognizer:self.panGestureRecognizer];
    }
}

#pragma mark Gesture Recognizing
- (void)panGestureDetected:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self];
    CGPoint velocity = [recognizer velocityInView:self];
    CGFloat movement = translation.y - self.holdedPoint.y;
   
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.holdedPoint = translation;
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat newVerticalLocation = [self verticalLocation];
        newVerticalLocation += movement;
        
        if (newVerticalLocation  >= [self minYUpDragging] && newVerticalLocation <= [self maxYDownDragging]) {
            [self moveVerticallyToPosition:newVerticalLocation];
            
        }
        
         self.holdedPoint = translation;
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        self.panelState = PanelStateMoving;
        CGFloat positiveVelocity = (velocity.y > 0) ? velocity.y : velocity.y * -1;
        if (positiveVelocity >= self.velocityForSwipeFollowDerection) {//If the speed high enough to reveal or close panel
            if (velocity.y > 0) {//Move Down
                [self closePanel];
            } else {//Move up
                [self revealPanel];
            }
        } else {
            CGFloat currentY = [self verticalLocation];
            if (currentY > self.showingY + 60) {
                
                if (velocity.y < 0 && currentY <= self.closingY - 35) {//Move up
                    [self revealPanel];
                } else {
                    [self closePanel];
                }
                
            } else {
                [self revealPanel];
            }
        }
    }
}

#pragma mark Private Methods
- (void)buttonTap:(UIButton *)button {
    if (self.isReveal) {
        [self closePanel];
    } else {
        [self revealPanel];
    }
}

- (void)moveVerticallyToPosition:(CGFloat)location {
    CGRect rect = self.frame;
    rect.origin.y = location;
    //rect.origin.x = 0;
    self.frame = rect;
}

//- (CGFloat)horizontalLocation {
//    CGRect rect = self.frame;
//    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
//    if (floor(NSFoundationVersionNumber) >= NSFoundationVersionNumber_iOS_8_0) {
//        return rect.origin.x;
//    } else {
//        if (UIInterfaceOrientationIsLandscape(orientation)) {
//            return (orientation == UIInterfaceOrientationLandscapeRight) ? rect.origin.y : rect.origin.y*-1;
//        } else {
//            return (orientation == UIInterfaceOrientationMaskPortrait) ? rect.origin.x : rect.origin.x*-1;
//        }
//    }
//}

- (CGFloat)verticalLocation {
    CGRect rect = self.frame;
    return rect.origin.y;
}

//- (CGFloat)horizontalSize {
//    
//    CGRect rect = self.frame;
//    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
//    
//    if ((floor(NSFoundationVersionNumber) >= NSFoundationVersionNumber_iOS_8_0))
//    {
//        return rect.size.width;
//    }
//    else
//    {
//        if (UIInterfaceOrientationIsLandscape(orientation))
//        {
//            return rect.size.height;
//        }
//        else
//        {
//            return rect.size.width;
//        }
//    }
//}

- (CGFloat)verticalSize {
    CGRect rect = self.frame;
    return rect.size.height;
}

- (CGFloat)minYUpDragging {
    return 38.0f;
    
}

- (CGFloat)maxYDownDragging {
    return [self verticalSize] - 18;
}


@end
