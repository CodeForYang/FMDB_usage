//
//  GirlsDBTool.m
//  DBTest
//
//  Created by 10.12 on 2020/6/1.
//  Copyright © 2020 10.12. All rights reserved.
//

#import "GirlsDBTool.h"
@interface GirlsDBTool()
@end
@implementation GirlsDBTool

static FMDatabase *db_;
+ (instancetype)shareInstance{
    static GirlsDBTool *mydb = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mydb = [[GirlsDBTool alloc]init];
        
    });
    
    
    //创建数据库
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"person.db"];
    NSLog(@"path: %@",path);
    
    db_ = [FMDatabase databaseWithPath:path];
    return mydb;
}

- (FMDatabase *)db{
    return db_;
}


@end
