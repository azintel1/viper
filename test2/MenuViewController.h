//
//  MenuViewController.h
//  test2
//
//  Created by Zack Brown on 11/11/14.
//  Copyright (c) 2014 Zack Brown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>

@property (nonatomic, copy) void (^onOptionUpdate)(NSArray *listArray);

@end
