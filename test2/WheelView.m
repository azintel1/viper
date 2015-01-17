//
//  WheelView.m
//  test2
//
//  Created by Zach Brown on 10/23/14.
//  Copyright (c) 2014 Zack Brown. All rights reserved.
//

#import "WheelView.h"
#import <QuartzCore/QuartzCore.h>

#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@implementation WheelView
{
    CGFloat currentDrawAngle_;
    NSInteger numPieces_;

    UIPanGestureRecognizer *pan_;
    CGFloat angle_;
    CGFloat decay_;
    CGFloat rate_;
    BOOL isClockwise_;

    CGFloat deltaAngle_;

    CGAffineTransform startTransform_;
    CGFloat angleDifference_;

    BOOL panCanceled_;
    CGFloat previousAngle_;

    BOOL isSpinning_;
}

@synthesize dataArray = dataArray_;

- (instancetype)init
{
    self = [super init];
    if (self != nil)
    {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = NO;
        self.layer.masksToBounds = NO;

        pan_ = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(onPan:)];
        [self addGestureRecognizer:pan_];
    }

    return self;
}

- (void)dealloc
{
    [self removeGestureRecognizer:pan_];
}

- (CGFloat)radius
{
    return self.width/2.0;
}

- (void)setDataArray:(NSArray *)dataArray
{
    dataArray_ = dataArray;
    numPieces_= dataArray.count;
    [self setNeedsDisplay];
    [self rebuildLabels];

}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSInteger numPieces = numPieces_;
    CGFloat currentRadius = [self radius];

    for (NSInteger i = 0; i < numPieces; i++)
    {
        CGFloat pieceAngle = 360/numPieces;
        pieceAngle = pieceAngle*(M_PI/180);
        CGContextMoveToPoint(context, self.width/2.0, self.width/2.0);
        CGPoint drawPoint = [self GetPointWithAngle: currentDrawAngle_];
        CGContextAddLineToPoint(context, drawPoint.x, drawPoint.y);
        CGFloat lastAngle = currentDrawAngle_;
        currentDrawAngle_ += pieceAngle;
        drawPoint = [self GetPointWithAngle:currentDrawAngle_];
        CGContextAddArc(context, self.width/2.0, self.width/2.0, currentRadius, lastAngle, currentDrawAngle_, 0);
        CGContextAddLineToPoint(context, self.width/2.0, self.width/2.0);
        CGContextSetFillColorWithColor(context, [UIColor randomColor].CGColor);
        CGContextFillPath(context);
    }
}

- (CGPoint)GetPointWithAngle:(CGFloat)angle;
{
    CGFloat currentRadius = [self radius];
    CGPoint centerPoint = CGPointMake(self.width/2.0, self.width/2.0);

    CGFloat xpos = centerPoint.x + currentRadius * cos(angle);
    CGFloat ypos = centerPoint.y + currentRadius * sin(angle);

    return CGPointMake(xpos, ypos);
}

-(void)rebuildLabels
{   [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (NSInteger i = 0; i < numPieces_; i++)
    {
        NSString *labelText = dataArray_[i];
        UILabel *optionLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.width/2.0, self.height/2.0, 140, 30)];
        [optionLabel setTextColor:[UIColor blackColor]];
        [optionLabel setBackgroundColor:[UIColor clearColor]];
        [optionLabel setText: labelText];
        CGFloat angleSize = 2*M_PI/numPieces_;
        optionLabel.layer.anchorPoint = CGPointMake(1.0f, 0.5f);
        optionLabel.layer.position = CGPointMake(self.width/2.0, self.height/2.0);
        optionLabel.transform= CGAffineTransformIdentity;
        optionLabel.transform = CGAffineTransformMakeRotation((angleSize * i)+(angleSize/2));
        optionLabel.tag = i;
        [self addSubview:optionLabel];
    }
}

- (CGFloat)calculateDistanceFromCenter:(CGPoint)point
{
    CGPoint center = CGPointMake(self.width/2.0, self.height/2.0);
    CGFloat dx = point.x - center.x;
    CGFloat dy = point.y - center.y;
    return sqrt(dx*dx + dy*dy);
}

#pragma mark - gesture methods

- (void)onPan:(UIPanGestureRecognizer *)pan
{
    // 1 - Get touch position
    CGPoint touchPoint = [pan locationInView:self.superview];
    CGPoint center = [self centerPoint];

    if (pan.state == UIGestureRecognizerStateBegan)
    {
        panCanceled_ = NO;
        [NSRunLoop cancelPreviousPerformRequestsWithTarget:self selector:@selector(onLoop) object:nil];

        // 1.1 - Get the distance from the center
        CGFloat dist = [self calculateDistanceFromCenter:touchPoint];

        // 1.2 - Filter out touches too close to the center
        if (dist < 40 || dist > self.width/2.0)
        {
            panCanceled_ = YES;
            // forcing a tap to be on the ferrule
            NSLog(@"ignoring tap (%f,%f)", touchPoint.x, touchPoint.y);
            return;
        }

        // 2 - Calculate distance from center
        CGFloat dx = touchPoint.x - center.x;
        CGFloat dy = touchPoint.y - center.y;
        // 3 - Calculate arctangent value
        deltaAngle_ = atan2(dy,dx);
        // 4 - Save current transform
        startTransform_ = self.transform;
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

        CGFloat dx = touchPoint.x - center.x;
        CGFloat dy = touchPoint.y - center.y;
        CGFloat ang = atan2(dy, dx);
        angleDifference_ = DEGREES_TO_RADIANS(RADIANS_TO_DEGREES(deltaAngle_ - ang));

        self.transform = CGAffineTransformRotate(startTransform_, -angleDifference_);

        isClockwise_ = previousAngle_ < angleDifference_;

        CGFloat newAngleDiff = fabsf(angleDifference_);
        CGFloat prevAngleDiff = fabsf(previousAngle_);

        CGFloat diff = fabsf(newAngleDiff - prevAngleDiff);

        rate_ = diff > 0.2 ? 0.2 : diff;
    }
}

- (CGPoint)centerPoint
{
    return CGPointMake(self.centerX, self.centerY);
}

- (void)onLoop
{
    pan_.enabled = NO;

    isSpinning_ = YES;
    if (isClockwise_)
    {
        angleDifference_ += rate_;
    }
    else
    {
        angleDifference_ -= rate_;
    }

    self.transform = CGAffineTransformRotate(startTransform_, -angleDifference_);

    rate_ -= decay_;
    if (rate_ <= 0)
    {
        pan_.enabled = YES;
        [NSRunLoop cancelPreviousPerformRequestsWithTarget:self selector:@selector(onLoop) object:nil];
    }
    else
    {
        [self performSelector:@selector(onLoop) withObject:nil afterDelay:0.01];
    }
}

@end
