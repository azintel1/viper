//
//  MenuViewController.m
//  test2
//
//  Created by Zack Brown on 11/11/14.
//  Copyright (c) 2014 Zack Brown. All rights reserved.
//

#import "MenuViewController.h"
#import "ViewController.h"
#import "circleview.h"


@implementation MenuViewController
{
    UILabel *label;
    UITextView *optionsText;
}

@synthesize onOptionUpdate = onOptionUpdate_;


-(void) ONClose
{
    if (self.onOptionUpdate != nil)
    {
        self.onOptionUpdate([optionsText.text componentsSeparatedByString:@","]);
    }
    [self dismissViewControllerAnimated: YES completion:nil];
}

- (void)loadView
{
    self.view=[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor blueColor];
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(10.0, 10.0, 200.0, 75.0)];
    [button setBackgroundColor:[UIColor clearColor]];
    [button setTitle:@"close" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(ONClose) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    optionsText = [[UITextView alloc]initWithFrame:CGRectMake(20, 75, 350, 200)];
    optionsText.backgroundColor = [UIColor whiteColor];
    optionsText.textColor = [UIColor blackColor];
    optionsText.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:optionsText];
}

-(void) textField
{

}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
