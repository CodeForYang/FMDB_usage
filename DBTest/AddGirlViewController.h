//
//  AddGirlViewController.h
//  DBTest
//
//  Created by 10.12 on 2020/6/1.
//  Copyright © 2020 10.12. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddGirlViewController : UITableViewController
@property (nonatomic,strong)NSString *name;
@property (nonatomic,assign)NSUInteger age;
@property (nonatomic,strong)NSString *birthPlace;
@end

NS_ASSUME_NONNULL_END
