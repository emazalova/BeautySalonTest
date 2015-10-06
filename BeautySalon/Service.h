//
//  Service.h
//  
//
//  Created by Katushka Mazalova on 05.10.15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

NS_ASSUME_NONNULL_BEGIN

@interface Service : NSManagedObject

@property (nullable, nonatomic, retain) NSNumber *cost;
@property (nullable, nonatomic, retain) NSNumber *duration;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) User *userID;

@end

NS_ASSUME_NONNULL_END

