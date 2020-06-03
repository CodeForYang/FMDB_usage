//
//  MJPerson.h
//  DBTest
//
//  Created by 10.12 on 2020/5/29.
//  Copyright © 2020 10.12. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface MJPerson : NSObject  <NSCoding,NSSecureCoding>
@property (nonatomic,strong)NSString *name;
@property (nonatomic,assign)CGFloat weight;
@property (nonatomic,assign)CGFloat height;
@property (nonatomic,strong)NSArray *hobits;
@property (nonatomic,strong)NSDictionary *loverStranger;
@property (nonatomic,strong)NSString *md5;
@end

NS_ASSUME_NONNULL_END
