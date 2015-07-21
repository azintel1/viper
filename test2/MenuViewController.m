//
//  MenuViewController.m
//  test2
//
//  Created by Zack Brown on 11/11/14.
//  Copyright (c) 2014 Zack Brown. All rights reserved.
//

#import "MenuViewController.h"
#import "ViewController.h"
#import "WheelView.h"
#import "EditVC.h"


@implementation MenuViewController
{
    UITableView *tableView_;
    NSMutableArray *dataArray_;
    NSIndexPath *selectedIndexPath_;
}

@synthesize onOptionUpdate = onOptionUpdate_;

- (instancetype)init
{
    self = [super init];
    if (self != nil)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSArray *savedData = [defaults objectForKey:@"SavedData"];

        dataArray_ = [NSMutableArray arrayWithArray:savedData];
    }
    return self;
}


- (void)onClose
{

    [self dismissViewControllerAnimated: YES completion:nil];
}

- (void)onAdd
{

}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor colorWithHex:0xffeeeeee];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onClose)];
    self.navigationItem.title = @"Create";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAdd)];

    tableView_ = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView_.translatesAutoresizingMaskIntoConstraints = NO;
    tableView_.delegate = self;
    tableView_.dataSource = self;
    [self.view addSubview:tableView_];

    [self beginConstraints];
    [self addLayoutConstraints:[tableView_ fillParent]];
    [self.view addConstraints:[self endConstraints]];

}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndexPath_ = indexPath;
    [tableView_ deselectRowAtIndexPath:indexPath animated:YES];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Options"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Load", @"Edit", nil];

    [actionSheet showInView:self.view];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray_.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView_ dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];

    }
    NSDictionary *data = [dataArray_ objectAtIndex:indexPath.row];
    cell.textLabel.text = data[@"name"];
    return cell;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            NSDictionary *data = [dataArray_ objectAtIndex:selectedIndexPath_.row];
            if (self.onOptionUpdate != nil)
            {
                self.onOptionUpdate(data[@"data"]);
            }
            [self dismissViewControllerAnimated: YES completion:nil];
            //load

            break;
        }
        case 1:
        {
            EditVC *editVC = [[EditVC alloc] init];
            editVC.loadedData = [dataArray_ objectAtIndex:selectedIndexPath_.row];
            [self.navigationController pushViewController:editVC animated:YES];

            break;
        }
        default:
            break;
    }
}

@end
