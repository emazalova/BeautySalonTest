//
//  ViewController.m
//  BeautySalon
//
//  Created by Katushka Mazalova on 5.10.15.
//  Copyright © 2015 Katushka Mazalova. All rights reserved.
//

#import "ViewController.h"
#import "User.h"
#import "MagicalRecord.h"


@interface ViewController () <UITextFieldDelegate>

@property (weak,nonatomic) IBOutlet UITextField *nameText;
@property (weak,nonatomic) IBOutlet UITextField *surnameText;

@end

@implementation ViewController

#pragma actions

- (IBAction)cancelAction:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (IBAction)addAction:(id)sender {
    
    
    if ((self.nameText.text.length!=0)&&(self.surnameText.text.length!=0)) {
        
         User *someUser = [User MR_createEntity];
        someUser.name = self.nameText.text;
        someUser.surname = self.surnameText.text;
        [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
        
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma UITextFieldDelegate


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:self.nameText]) {
        
        [self.surnameText becomeFirstResponder];
        
    } else {
            [textField resignFirstResponder];
        }
    
    return YES;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
        
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
