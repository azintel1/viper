//
//  ViewController.m
//  test2
//
//  Created by Zach Brown on 10/23/14.
//  Copyright (c) 2014 Zack Brown. All rights reserved.
//

#import "ViewController.h"
#import "circleview.h"
#import "MenuViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    circleview *circleView_;
    UIPanGestureRecognizer *pan_;
    CGFloat angle_;
    CGFloat startAngle_;
    CGFloat lastAngle_;
    CGFloat endAngle_;
    CGFloat decay_;
    CGFloat rate_;
    CGPoint lastTouch_;
    BOOL isClockwise_;

}
- (void) dealloc
{
    [circleView_ removeGestureRecognizer:pan_];
}
-(void) ONMenu
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
    self.view=[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor greenColor];
    circleView_ =[[circleview alloc]init];
    [self.view addSubview:circleView_];
    circleView_.autoresizingMask = UIViewAutoresizingNone;
    pan_ = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(onPan:)];
    [circleView_ addGestureRecognizer:pan_];
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    CGFloat screenCenterX = screenRect.size.width/2;
    CGFloat circleCenterX = screenCenterX-(300.0/2);
    CGFloat screenCenterY = screenRect.size.height/2;
    CGFloat circleCenterY = screenCenterY-(300.0/2);
    circleView_.frame =CGRectMake(circleCenterX, circleCenterY, 300.0, 300.0);

// buttonload
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(10.0, 10.0, 200.0, 75.0)];
    [button setBackgroundColor:[UIColor clearColor]];
    [button setTitle:@"Menu" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(ONMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

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
#pragma mark - gesture methods

- (void)onPan:(UIPanGestureRecognizer *)pan
{
    
    CGPoint touchPoint = [pan locationInView:self.view];
    CGPoint circleCp = self.view.center;
    CGFloat angleOffset = 180*(M_PI/180);
    angle_ = atan2f(circleCp.y-touchPoint.y, circleCp.x-touchPoint.x);
    angle_ = angle_+ angleOffset;
    
       angle_ = fabsf(angle_);

    
    if (pan.state == UIGestureRecognizerStateBegan)
    {
        [NSRunLoop cancelPreviousPerformRequestsWithTarget:self selector:@selector(onLoop) object:nil];
        startAngle_ = angle_;
        NSLog(@"startangle: %f", startAngle_);
        return;

    } else if (pan.state == UIGestureRecognizerStateEnded)
    {
        rate_ = 0.1;
        decay_ = 0.0006;
        [self performSelector:@selector(onLoop) withObject:nil afterDelay:0.01];
        lastTouch_ = CGPointZero;
        return;
    }
    // -- calculate directction of movement
    if (!CGPointEqualToPoint(lastTouch_, CGPointZero))
    {
        CGPoint circleCp = self.view.center;
        CGFloat angleOffset = 180*(M_PI/180);
        lastAngle_ = atan2f(circleCp.y-lastTouch_.y, circleCp.x-lastTouch_.x);
        lastAngle_ = lastAngle_+ angleOffset;
        NSLog(@"angle: %f lastAngle: %f", angle_, lastAngle_);
        isClockwise_ = angle_>lastAngle_;
        lastAngle_ = fabsf(lastAngle_);
        
        
    }

    endAngle_ = angle_+startAngle_;
    
    NSLog(@"end: %f", endAngle_);
    NSLog(@"clockwise: %d", isClockwise_);
    NSLog(@"==============================================================");
    circleView_.transform = CGAffineTransformRotate(CGAffineTransformIdentity, endAngle_);
    lastTouch_ = touchPoint;
}
- (void)onLoop
{
//    NSLog(@"loop");
    CGFloat newangle = 0.0;
    if (isClockwise_)
    {
        newangle = endAngle_+=rate_;
    }
    else
    {
        newangle = endAngle_-=rate_;
    }
    circleView_.transform = CGAffineTransformRotate(CGAffineTransformIdentity, newangle);
    rate_ -= decay_;
    if (rate_ <= 0)
    {
        [NSRunLoop cancelPreviousPerformRequestsWithTarget:self selector:@selector(onLoop) object:nil];
    }
    else
    {
        [self performSelector:@selector(onLoop) withObject:nil afterDelay:0.01];
    }
}



@end
