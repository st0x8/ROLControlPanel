//
//  ViewController.m
//  ROLControlPanel
//
//  Created by Roy Lin on 15/12/3.
//  Copyright © 2015年 Roy Lin. All rights reserved.
//
//  https://github.com/st0x8/ROLControlPanel
//

#import "ViewController.h"
#import "ROLControlPanel.h"

@interface ViewController () <ROLControlPanelDelegagte>
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
    ROLControlPanel *panelView = [[ROLControlPanel alloc] initWithParentView:self.view];
    panelView.delegate = self;
    panelView.slideAnimationDuration = 0.5;//default is 0.33
    panelView.PanelCloseBlock = ^(void) {
        NSLog(@"Block panel close!");
    };
    panelView.PanelRevealBlock = ^(void) {
        NSLog(@"Block panel reveal!");
    };
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)panelReveal {
    NSLog(@"Delegate panel reveal!");
}

- (void)panelClose {
    NSLog(@"Delegate panel close!");
}

@end
