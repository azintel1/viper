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
    SKView *arrow_;
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
    circleView_.frame = CGRectMake(circleCenterX, circleCenterY, circleDiameter, circleDiameter);

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

    arrow_ = [[SKView alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 50.0)];
    arrow_.alpha = 0.3;
    arrow_.drawBlock = ^(CGRect rect, UIView *view) {

        Triangle triangle = {CGPointMake(0.0, 0.0),
            CGPointMake(view.width, view.height/2.0),
            CGPointMake(0.0, view.height)};

        [UIView drawTriangle:triangle andFillColor:[UIColor blackColor]];

    };
    [self.view addSubview:arrow_];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *savedData = [defaults objectForKey:@"SavedData"];

    NSString *dataString = @"drink,smoke,chug,waterfall,NHIE,Me,You,Heaven,Questions,KingCup";
    NSArray *dataArray = [dataString componentsSeparatedByString:@","];

    if (savedData == nil)
    {
        savedData = @[@{@"name" : @"Default", @"data" : dataArray}];
        [defaults setObject:savedData forKey:@"SavedData"];
        [defaults synchronize];
    }

    NSArray *lastDataSet = [defaults objectForKey:@"LastDataSet"];
    if (lastDataSet == nil)
    {
        lastDataSet = dataArray;
        [defaults setObject:dataArray forKey:@"LastDataSet"];
        [defaults synchronize];
    }

    circleView_.dataArray = lastDataSet;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    arrow_.centerY = self.view.centerY;
}

@end
