//
//  GirlModel.h
//  DBTest
//
//  Created by 10.12 on 2020/6/1.
//  Copyright © 2020 10.12. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface GirlModel : NSObject<NSSecureCoding>
@property (nonatomic,strong)NSString *name;
@property (nonatomic,assign)CGFloat height;
@property (nonatomic,assign)CGFloat weight;
@property (nonatomic,assign)NSUInteger age;
@property (nonatomic,strong)NSString *hobits;
@property (nonatomic,strong)NSString *birthPlace;
@property (nonatomic,strong)UIImage *photo;

@end

NS_ASSUME_NONNULL_END
