//
//  circleview.m
//  test2
//
//  Created by Zach Brown on 10/23/14.
//  Copyright (c) 2014 Zack Brown. All rights reserved.
//

#import "circleview.h"
#import <QuartzCore/QuartzCore.h>

@implementation circleview
{
    CGFloat currentDrawAngle_;
    NSInteger numPieces_;
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
            }
    
    return self;
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
@end
