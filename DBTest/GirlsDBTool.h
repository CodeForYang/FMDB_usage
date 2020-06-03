//
//  GirlsDBTool.h
//  DBTest
//
//  Created by 10.12 on 2020/6/1.
//  Copyright © 2020 10.12. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>

NS_ASSUME_NONNULL_BEGIN

@interface GirlsDBTool : NSObject<NSCopying>
@property (nonatomic,strong)FMDatabase *db;

+ (instancetype)shareInstance;
@end

NS_ASSUME_NONNULL_END
