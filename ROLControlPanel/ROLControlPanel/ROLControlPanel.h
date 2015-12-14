//
//  ROLControlPanel.h
//  ROLControlPanel
//
//  Created by Roy Lin on 15/12/3.
//  Copyright © 2015年 Roy Lin. All rights reserved.
//
//  https://github.com/st0x8/ROLControlPanel
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(char, PanelState) {
    PanelStateReveal,
    PanelStateClose,
    PanelStateMoving
};

@protocol ROLControlPanelDelegagte <NSObject>
@optional
- (void)panelReveal;
- (void)panelClose;
@end

@interface ROLControlPanel : UIView

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, weak) id<ROLControlPanelDelegagte> delegate;
@property (nonatomic) BOOL enableSwipeGesture;
@property (nonatomic) BOOL isReveal;
@property (nonatomic, assign) CGFloat velocityForSwipeFollowDerection;
/**
 *  @brief  Set the panel reveal and close animation duration.
 */
@property (nonatomic, assign) CGFloat slideAnimationDuration;
@property (nonatomic, assign) UIViewAnimationOptions panelRevealAnimationOption;
@property (nonatomic, copy) void (^PanelRevealBlock)(void);
@property (nonatomic, copy) void (^PanelCloseBlock)(void);
@property (nonatomic, assign) PanelState panelState;

- (instancetype)initWithParentView:(UIView *)parentView;
- (void)revealPanel;
- (void)closePanel;

@end
