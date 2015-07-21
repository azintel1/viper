//
//  EditVC.m
//  test2
//
//  Created by Zack Brown on 12/17/14.
//  Copyright (c) 2014 Zack Brown. All rights reserved.
//

#import "EditVC.h"

#define kPadding 10.0


@implementation EditVC
{
    UITextView *textView_;

}

- (instancetype)init
{
    self = [super init];
    if (self != nil)
    {

    }
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor colorWithHex:0xffeeeeee];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    textView_ = [[UITextView alloc]init];
    textView_.font = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:24.0];
    [self.view addSubview:textView_];
    textView_.translatesAutoresizingMaskIntoConstraints = NO;
    self.navigationItem.title = @"Edit";
    [self beginConstraintsWithMetrics:@{@"kPadding" : @(kPadding), @"TextViewHeight": @(200.0)} forViews:NSDictionaryOfVariableBindings(textView_)];
    [self addVFL:@"H:|-kPadding-[textView_]-kPadding-|"];
    [self addVFL:@"V:|-kPadding-[textView_(==TextViewHeight)]"];
    [self.view addConstraints:[self endConstraints]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSArray *data = _loadedData[@"data"];
    if (data != nil)
    {
        textView_.text = [data componentsJoinedByString:@","];
    }
}



@end
