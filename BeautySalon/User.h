//
//  User.h
//  
//
//  Created by Katushka Mazalova on 05.10.15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Service;

NS_ASSUME_NONNULL_BEGIN

@interface User : NSManagedObject

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *surname;
@property (nullable, nonatomic, retain) NSSet<Service *> *userID;

- (void)addUserIDObject:(Service *)value;
- (void)removeUserIDObject:(Service *)value;
- (void)addUserID:(NSSet<Service *> *)values;
- (void)removeUserID:(NSSet<Service *> *)values;

@end

NS_ASSUME_NONNULL_END

