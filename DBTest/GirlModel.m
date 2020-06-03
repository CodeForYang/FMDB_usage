//
//  GirlModel.m
//  DBTest
//
//  Created by 10.12 on 2020/6/1.
//  Copyright © 2020 10.12. All rights reserved.
//

#import "GirlModel.h"

@implementation GirlModel
+ (BOOL)supportsSecureCoding{
    return YES;
}

//归档的时候调用
//告诉编码器该如何归档
//将这个对象哪些属性编码起来
- (void)encodeWithCoder:(NSCoder *)encoder{//归档
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeFloat:self.weight forKey:@"weight"];
    [encoder encodeFloat:self.height forKey:@"height"];
    [encoder encodeObject:self.hobits forKey:@"hobits"];
    [encoder encodeObject:self.birthPlace forKey:@"birthPlace"];
    [encoder encodeObject:self.photo forKey:@"photo"];


}


//解归档
- (instancetype)initWithCoder:(NSCoder *)decoder{//解档

    if ([super init]) {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.weight = [decoder decodeFloatForKey:@"weight"];
        self.height = [decoder decodeFloatForKey:@"height"];
        self.hobits = [decoder decodeObjectOfClass:[NSArray class] forKey:@"hobits"];
        self.birthPlace = [decoder decodeObjectForKey:@"birthPlace"];
        self.photo = [decoder decodeObjectOfClass:[UIImage class] forKey:@"photo"];
        
    }
    return self;
}

@end
