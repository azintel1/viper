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

#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

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
    BOOL isClockwise_;

    CGFloat releaseAngleDiff_;
    CGFloat deltaAngle_;

    CGAffineTransform startTransform_;
    CGFloat angleDifference_;

    BOOL panCanceled_;
    CGPoint lastTouchPoint_;
    CGFloat previousAngle_;

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

- (CGFloat)calculateDistanceFromCenter:(CGPoint)point
{
    CGPoint center = circleView_.center;
    CGFloat dx = point.x - center.x;
    CGFloat dy = point.y - center.y;
    return sqrt(dx*dx + dy*dy);
}

#pragma mark - gesture methods

- (void)onPan:(UIPanGestureRecognizer *)pan
{
    // 1 - Get touch position
    CGPoint touchPoint = [pan locationInView:self.view];

    if (pan.state == UIGestureRecognizerStateBegan)
    {
        panCanceled_ = NO;
        [NSRunLoop cancelPreviousPerformRequestsWithTarget:self selector:@selector(onLoop) object:nil];

        // 1.1 - Get the distance from the center
        CGFloat dist = [self calculateDistanceFromCenter:touchPoint];

        // 1.2 - Filter out touches too close to the center
        if (dist < 40 || dist > circleView_.width/2.0)
        {
            panCanceled_ = YES;
            // forcing a tap to be on the ferrule
            NSLog(@"ignoring tap (%f,%f)", touchPoint.x, touchPoint.y);
            return;
        }

        // 2 - Calculate distance from center
        CGFloat dx = touchPoint.x - circleView_.center.x;
        CGFloat dy = touchPoint.y - circleView_.center.y;
        // 3 - Calculate arctangent value
        deltaAngle_ = atan2(dy,dx);
        // 4 - Save current transform
        startTransform_ = circleView_.transform;
        return;
    }
    else if (pan.state == UIGestureRecognizerStateEnded)
    {
        if (panCanceled_)
        {
            return;
        }

        decay_ = 0.0005;

        [self performSelector:@selector(onLoop) withObject:nil afterDelay:0.01];
    }
    else if (pan.state == UIGestureRecognizerStateChanged)
    {
        if (panCanceled_)
        {
            return;
        }

        previousAngle_ = angleDifference_;

        CGFloat dx = touchPoint.x - circleView_.center.x;
        CGFloat dy = touchPoint.y - circleView_.center.y;
        CGFloat ang = atan2(dy, dx);
        angleDifference_ = DEGREES_TO_RADIANS(RADIANS_TO_DEGREES(deltaAngle_ - ang));

        circleView_.transform = CGAffineTransformRotate(startTransform_, -angleDifference_);

        isClockwise_ = previousAngle_ < angleDifference_;

        CGFloat newAngleDiff = fabsf(angleDifference_);
        CGFloat prevAngleDiff = fabsf(previousAngle_);

        CGFloat diff = fabsf(newAngleDiff - prevAngleDiff);
        NSLog(@"diff: %f", diff);

        rate_ = diff > 0.2 ? 0.2 : diff;
    }

    lastTouchPoint_ = touchPoint;
}

- (void)onLoop
{
    if (isClockwise_)
    {
        angleDifference_ += rate_;
    }
    else
    {
        angleDifference_ -= rate_;
    }

    circleView_.transform = CGAffineTransformRotate(startTransform_, -angleDifference_);

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
