//
//  ServiceTableViewController.m
//  BeautySalon
//
//  Created by Katushka Mazalova on 05.10.15.
//  Copyright © 2015 Katushka Mazalova. All rights reserved.
//

#import "ServiceTableViewController.h"
#import "MagicalRecord.h"
#import "User.h"
#import "Service.h"
#import "ContactTableViewCell.h"
#import "ServiceTableViewCell.h"
#import "AddServiceCell.h"
#import "ModalTableViewController.h"

@interface ServiceTableViewController () <UIAlertViewDelegate>

@property (strong,nonatomic) User *oneUser;

@property (strong,nonatomic) NSMutableArray *services;
@property (assign,nonatomic) CGPoint touchPoint;

@end

@implementation ServiceTableViewController

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch(buttonIndex) {
        case 0: //"No" pressed
            _touchPoint = CGPointZero;
            break;
        case 1: //"Yes" pressed
            [self deleteServiceWith:_touchPoint];
            break;
    }
}
- (void) deleteServiceWith:(CGPoint )touchPoint {
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:touchPoint];
    
    Service *serviceEntity = [self.services objectAtIndex:indexPath.row];
    
    [serviceEntity MR_deleteEntity];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    [self.services removeObject:serviceEntity];
    
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    [self setPlaceholderInTableView:self.tableView];
    
}
- (IBAction)deleteServiceAction:(UIButton *)sender {
    
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:self.tableView];
    _touchPoint = touchPoint;
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warning!" message:@"Are you sure you want to delete the service?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [alert show];

}


- (void)reloadContent
{
    self.services = [self arrayFromSet:[_oneUser userID]];
    [self.tableView reloadData];
}
- (void)setPlaceholderInTableView:(UITableView *)tableView {
    
    if (self.services.count != 0) {
        [tableView.backgroundView setHidden:YES];
    } else if (self.services.count == 0) {
        [tableView.backgroundView setHidden:NO];
    }
}

- (NSMutableArray *)arrayFromSet:(NSSet *)setOfObjects {
    
    NSMutableArray *array = [@[] mutableCopy];
    for (id object in setOfObjects) {
        [array addObject:object];
    }
    
    return array;
}
- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self reloadContent];
    
    [self setPlaceholderInTableView:self.tableView];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.tableView.backgroundView == nil) {
        UILabel *messageLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,
                                            self.tableView.bounds.size.width,
                                            self.tableView.bounds.size.height)];
        messageLbl.text = @"You do not have any added services";
        messageLbl.textColor = [UIColor grayColor];
        messageLbl.textAlignment = NSTextAlignmentCenter;
        self.tableView.backgroundView = messageLbl;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableViewDataSourse

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 1;
    }
    
    return [self.services count] + 1;
    
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *title = nil;
    if (section==0) {
        title = @"";
    }else title = @"Услуги";
    return title;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 44.f;
    } else if (indexPath.row==self.services.count) {
        return 44.f;
    }
    else {
        return 66.f;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.selectionStyle != UITableViewCellSelectionStyleNone) {
        
        NSLog(@"Selected");
        
        UIViewController *uiv=[[self storyboard] instantiateViewControllerWithIdentifier:@"ModalTableViewController"];
        ModalTableViewController *modalViewController = (ModalTableViewController *)uiv;
//      modalViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        
        [modalViewController setValue:self.oneUser forKey:@"oneUser"];
    
        [self presentViewController:modalViewController animated:YES completion:^{
            
        }];
        
    }
}
- (NSString *)showStringInTableViewCellWithCost:(int)cost andDuration:(int)duration {
    
    NSString *durationStr = @"";
    
    switch (duration) {
        case 30:
            durationStr = [NSString stringWithFormat:@"30 минут"];
            break;
        case 60:
            durationStr = [NSString stringWithFormat:@"1 час"];
            break;
        case 90:
            durationStr = [NSString stringWithFormat:@"1 час 30 минут"];
            break;
            
        default:
            if ((duration/60)!=0) {
                
                (((duration/60)==2)|((duration/60)==3)|(duration/60)==4)?(durationStr = [NSString stringWithFormat:@"%d часа",(duration/60)]):(durationStr = [NSString stringWithFormat:@"%d часов",(duration/60)]);
            }
            if (duration%60) {
                durationStr = [durationStr stringByAppendingString:[NSString stringWithFormat:@" 30 минут"]];
            }
            break;
    }
    NSLog(@"durationStr is %@",durationStr);
    durationStr = [durationStr stringByAppendingString:[NSString stringWithFormat:@", %d руб.",cost]];
    NSLog(@"durationStr and cost is %@",durationStr);
    return durationStr;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *contactIdent = @"Contact";
    static NSString *serviceIdent = @"Service";
    static NSString *addServiceIdent = @"AddService";
    
    
    if (indexPath.section==0) {
        
        ContactTableViewCell *contactCell = [tableView dequeueReusableCellWithIdentifier:contactIdent];
        
        if (!contactCell) {
            contactCell = [[ContactTableViewCell alloc]init];
            
        }
        [contactCell.nameLabel setText:[NSString stringWithFormat:@"%@ %@",self.oneUser.name,self.oneUser.surname]];
        contactCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return contactCell;

    }  else if (!(indexPath.row==self.services.count)) {
        
        Service *someService = [self.services objectAtIndex:indexPath.row];

        ServiceTableViewCell *serviceCell = [tableView dequeueReusableCellWithIdentifier:serviceIdent];
        if (!serviceCell) {
            serviceCell = [[ServiceTableViewCell alloc]init];
        }
        [serviceCell.titleLabel setText:[NSString stringWithFormat:@"%@",someService.title]];
        serviceCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [serviceCell.durationCostLabel setText:[self showStringInTableViewCellWithCost:(int)[someService.cost integerValue] andDuration:(int)[someService.duration integerValue]]];
        
        return serviceCell;
        
    } else  {
        
        AddServiceCell *addCell = [tableView dequeueReusableCellWithIdentifier:addServiceIdent];
        if (!addCell) {
            addCell = [[AddServiceCell alloc]init];
        }
        [addCell.addLabel setText:@"Добавить услугу"];
        return addCell;
        
    }
   
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {

    
    return NO;
}


@end
