//
//  YourActionsViewController.m
//  OpenIt
//
//  Created by Patrick Balestra on 22/07/14.
//  Copyright (c) 2014 Patrick Balestra. All rights reserved.
//

#import "YourActionsViewController.h"
#import "ActionDetailViewController.h"
#import "SchemeBuilder.h"
#import <Pointzi/Pointzi.h>

@interface YourActionsViewController ()

@property (strong, nonatomic) NSMutableArray *actions;

@property (nonatomic) BOOL presentedDebug;

@end

@implementation YourActionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[PZToolTip sharedPZToolTip] initToolTipWithCompletionHandler:^(bool sucess) {
        
        NSError *error = nil;
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 350)];
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[PZToolTip sharedPZToolTip] tooltipObj].tooltipImgURL] options:NSDataReadingMappedIfSafe error:&error];
        
        //    imageView.image = [UIImage imageWithData:data];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:data]];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        imageView.frame = CGRectMake(10, 25, 280, 280);
        [baseView addSubview:imageView];
        
        UILabel * nameLabel = [[UILabel alloc] init];
        [nameLabel setText:[[PZToolTip sharedPZToolTip] tooltipObj].tooltipMessage];
        [nameLabel setTextAlignment:NSTextAlignmentCenter];
        nameLabel.frame = CGRectMake(10, 300, 280, 50);
        [baseView addSubview:nameLabel];
        
      PZTooltipView * tooltip = [[PZTooltipView alloc] initWithContentView:baseView sourceRect:CGRectMake(10, 35, 50, 50) parentWindow:self.view.window];
        
        [tooltip show];
    }];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.8745 green:0.0784 blue:0.0745 alpha:1.0000];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:20], NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    self.actions = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"actions"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewAction:) name:@"AddNewAction" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editAction:) name:@"EditAction" object:nil];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}

- (void)saveActions {
    // Save locally
    [[NSUserDefaults standardUserDefaults] setObject:[self.actions mutableCopy] forKey:@"actions"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Save to extension
    SchemeBuilder *builder = [SchemeBuilder new];
    NSMutableArray *extensionActions = [NSMutableArray new];
    
    [self.actions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSString *scheme = [builder buildSchemeWithArray:obj];
        [extensionActions addObject:@{@"Title" : obj[0][@"Title"], @"Scheme" : scheme}];
    }];
    
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.actions"];
    [sharedDefaults setObject:[extensionActions mutableCopy] forKey:@"actions"];
    [sharedDefaults synchronize];
}

- (void)addNewAction:(NSNotification *)notification {
    
//    NSError *error = nil;
//    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
//
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[PZToolTip sharedPZToolTip] tooltipObj].tooltipImgURL] options:NSDataReadingMappedIfSafe error:&error];
//
//    //    imageView.image = [UIImage imageWithData:data];
//
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:data]];
//    [imageView setContentMode:UIViewContentModeScaleAspectFit];
//    imageView.frame = CGRectMake(10, 10, 280, 280);
//    [baseView addSubview:imageView];
//
//    PZTooltipView * tooltip = [[PZTooltipView alloc] initWithContentView:baseView sourceRect:CGRectMake(0, 0, 50, 50) parentWindow:self.view.window];
//
//    [tooltip show];
    
    [self.actions addObject:notification.object];
    [self.tableView reloadData];
    [self saveActions];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
    
}

- (void)editAction:(NSNotification *)notification {
    [self.actions replaceObjectAtIndex:[self.tableView indexPathForSelectedRow].row withObject:[notification.object mutableCopy]];
    [self.tableView reloadData];
    [self saveActions];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.actions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.actions[indexPath.row][0][@"Title"];
    cell.detailTextLabel.text = self.actions[indexPath.row][1][@"Type"];
    cell.imageView.image = [UIImage imageNamed:self.actions[indexPath.row][1][@"Type"]];
    
    CGSize itemSize = CGSizeMake(35, 35);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.actions removeObjectAtIndex:indexPath.row];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        [self saveActions];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    id objectToMove = [self.actions objectAtIndex:sourceIndexPath.row];
    [self.actions removeObjectAtIndex:sourceIndexPath.row];
    [self.actions insertObject:objectToMove atIndex:destinationIndexPath.row];
    [self.tableView reloadData];
    [self saveActions];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"DetailAction"]) {
        ActionDetailViewController *actionDetail = (ActionDetailViewController *)segue.destinationViewController;
        actionDetail.shortcutArray = [self.actions[[self.tableView indexPathForSelectedRow].row] mutableCopy];
        actionDetail.newAction = YES;
    }
}

- (IBAction)edit:(id)sender {
    if (self.tableView.isEditing) {
        [self.tableView setEditing:NO animated:YES];
        [self.editButton setTitle:@"Edit"];
    } else {
        [self.tableView setEditing:YES animated:YES];
        [self.editButton setTitle:@"Done"];
    }
}

@end
