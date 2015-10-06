//
//  ModalTableViewController.m
//  BeautySalon
//
//  Created by Katushka Mazalova on 05.10.15.
//  Copyright © 2015 Katushka Mazalova. All rights reserved.
//

#import "ModalTableViewController.h"
#import "Service.h"
#import "User.h"
#import "MagicalRecord.h"


@interface ModalTableViewController () <UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property (strong, nonatomic) NSArray *durationNames;
@property (strong, nonatomic) NSArray *durationMinutes;
@property (strong,nonatomic) Service *oneService;
@property (strong,nonatomic) User *oneUser;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;



@end

@implementation ModalTableViewController

- (IBAction)clickButDuration:(id)sender {
    [sender setHidden:YES];
    _pickerView.hidden = NO;
    _oneService.duration = [NSNumber numberWithInt:30];
}

- (BOOL)isValidForm {
    return ((self.oneService.title.length != 0) &&
    ([self.oneService.cost integerValue]!=0) &&
    ([self.oneService.duration integerValue]!=0));
}

- (IBAction)saveAction:(id)sender {
    
    if ([self isValidForm]) {
        
         NSManagedObjectContext *localContext = [NSManagedObjectContext MR_defaultContext];

        _oneService.userID = _oneUser;
        [_oneUser addUserIDObject:_oneService];

        __weak typeof(self) weakSelf = self;
        [localContext MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
            [weakSelf dismissViewControllerAnimated:YES completion:nil];

        }];
    }
}
- (IBAction)cancelAction:(id)sender {
   
    [[NSManagedObjectContext MR_defaultContext] deleteObject:_oneService];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
 
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_defaultContext];
    
    Service *someService = [Service MR_createEntityInContext:localContext];
    
    [self initPicckerView:_pickerView];
   
    if(!self.oneService) {
        self.oneService = someService;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPickerViewDataSourse

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [self.durationNames count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
   
    return self.durationNames[row];
    
}
#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    int minute = (int) [self.durationMinutes[row] integerValue];
    self.oneService.duration = [NSNumber numberWithInt:minute];
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];

    return YES;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (![textField.text isEqualToString:@""]) {
       
        if (textField.tag==1) {
            
            self.oneService.title = textField.text;
            
            
        } else if  (textField.tag==3) {
            
            self.oneService.cost = [NSNumber numberWithInt:(int)[textField.text integerValue]];
            
            NSMutableString *mutableText = [textField.text mutableCopy];
            [mutableText insertString:[NSString stringWithFormat:@" .руб"] atIndex:mutableText.length];
            
            textField.text = mutableText;
            
            
        }
    }
   
}

- (void)initPicckerView:(UIPickerView *)picView {
    picView.delegate = self;
    picView.dataSource = self;
    
    self.durationNames = @[@"30 минут", @"1 час", @"1 час 30 минут", @"2 часа", @"2 часа 30 минут", @"3 часа", @"3 часа 30 минут", @"4 часа", @"4 часа 30 минут", @"5 часов", @"5 часов 30 минут", @"6 часов", @"6 часов 30 минут", @"7 часов", @"7 часов 30 минут", @"8 часов", @"8 часов 30 минут", @"9 часов", @"9 часов 30 минут", @"10 часов", @"10 часов 30 минут", @"11 часов", @"11 часов 30 минут", @"12 часов"];
    
    self.durationMinutes = @[ @30, @60, @90, @120, @150, @180, @210, @240, @270, @300, @330, @360, @390, @420, @450, @480, @510, @540, @570, @600, @630, @660, @690, @720];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
        if (textField.tag == 3) {
        
        [textField setKeyboardType:UIKeyboardTypeNumberPad];
        NSMutableString *mutableText = [textField.text mutableCopy];
        if (![mutableText isEqualToString:@""]) {
            [mutableText deleteCharactersInRange:NSMakeRange(mutableText.length-5, 5)];

        }
        textField.text = mutableText;
        
    }
}
#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;
}


@end
