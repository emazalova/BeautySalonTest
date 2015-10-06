//
//  TableViewController.m
//  BeautySalon
//
//  Created by Katushka Mazalova on 5.10.15.
//  Copyright © 2015 Katushka Mazalova. All rights reserved.
//

#import "TableViewController.h"
#import "User.h"
#import "MagicalRecord.h"
#import "ContactTableViewCell.h"
#import "ServiceTableViewController.h"


@interface TableViewController ()
@property (strong,nonatomic) NSMutableArray *users;

@end

@implementation TableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.users = [[User MR_findAll] mutableCopy];

    [self.tableView reloadData];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.users count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ident = @"UserCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident forIndexPath:indexPath];
    if (cell)
    {
        User *userEntity = [self.users objectAtIndex:indexPath.row];
        
        [cell.textLabel setText:[NSString stringWithFormat:@"%@ %@",userEntity.name,userEntity.surname]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
                User *userEntity = [self.users objectAtIndex:indexPath.row];
        
        [userEntity MR_deleteEntity];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        
        [self.users removeObject:userEntity];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"didSelectRowAtIndexPath");
    
    UIViewController *uiv=[[self storyboard] instantiateViewControllerWithIdentifier:@"ServiceTableController"];
    ServiceTableViewController *serviceViewController = (ServiceTableViewController *)uiv;
    
    User *oneUser = [self.users objectAtIndex:indexPath.row];
    
    [serviceViewController setValue:oneUser forKey:@"oneUser"];
    
    [self.navigationController pushViewController:serviceViewController animated:YES];
   
}


@end
