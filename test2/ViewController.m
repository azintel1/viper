//
//  ViewController.m
//  test2
//
//  Created by Zach Brown on 10/23/14.
//  Copyright (c) 2014 Zack Brown. All rights reserved.
//

#import "ViewController.h"
#import "WheelView.h"
#import "MenuViewController.h"

#define kCirclePadding 20.0

@interface ViewController ()

@end

@implementation ViewController
{
    WheelView *circleView_;
    SKView *dropShadow_;
}

- (void)onMenu
{
    MenuViewController *menuViewController = [[MenuViewController alloc]init];
    __weak typeof(self)weakSelf = self;
    menuViewController.onOptionUpdate = ^(NSArray *dataArray)
    {
        typeof(self)strongSelf = weakSelf;
        if (strongSelf != nil)
        {
            strongSelf->circleView_.dataArray = dataArray;
        }
    };
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:menuViewController];
    [self presentViewController:navController animated: YES completion: nil];
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor colorWithHex:0xffeeeeee];

    circleView_ = [[WheelView alloc]init];
    circleView_.autoresizingMask = UIViewAutoresizingNone;

    CGRect screenRect = [UIScreen mainScreen].bounds;
    CGFloat circleDiameter = screenRect.size.height - (kCirclePadding*2.0);

    CGFloat circleCenterX = screenRect.size.width-(circleDiameter/2);
    CGFloat screenCenterY = screenRect.size.height/2;
    CGFloat circleCenterY = screenCenterY-(circleDiameter/2);
    circleView_.frame =CGRectMake(circleCenterX, circleCenterY, circleDiameter, circleDiameter);

    dropShadow_ = [[SKView alloc] init];
    dropShadow_.autoresizingMask = UIViewAutoresizingNone;
    dropShadow_.layer.shadowColor = [UIColor blackColor].CGColor;
    dropShadow_.layer.shadowOffset = CGSizeMake(-5.0, -5.0);
    dropShadow_.layer.shadowRadius = 5.0;
    dropShadow_.layer.shadowOpacity = 0.45;
    dropShadow_.drawBlock = ^(CGRect rect, UIView *view) {

        [UIView drawOvalInRect:rect andFillColor:[UIColor whiteColor]];

    };

    dropShadow_.frame = circleView_.frame;

    [self.view addSubview:dropShadow_];
    [self.view addSubview:circleView_];

    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.cornerRadius = 5.0;
    button.layer.masksToBounds = YES;
    [button setBackgroundColor:[UIColor clearColor]];
    button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor blackColor]] forState:UIControlStateNormal];
    [button setTitle:@"Menu" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

    [button sizeToFit];

    button.width = button.width + 10.0;
    button.height = button.height + 10.0;
    button.top = 30.0;
    button.left = 10.0;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

}
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
