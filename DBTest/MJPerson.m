//
//  MJPerson.m
//  DBTest
//
//  Created by 10.12 on 2020/5/29.
//  Copyright © 2020 10.12. All rights reserved.
//

#import "MJPerson.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation MJPerson
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
    [encoder encodeObject:self.loverStranger forKey:@"loverStranger"];
    
    [self md5WithStringArray:@[_name,[NSString stringWithFormat:@"%.2f",_height],[NSString stringWithFormat:@"%.2f",_weight],_hobits,_loverStranger]];
    
    if(self.md5.length>0) [encoder encodeObject:self.md5 forKey:@"md5"];
    
    NSLog(@"%s  %@",__func__,self.md5);

}

- (void)md5WithStringArray:(NSArray *)array{
    NSMutableString *strM = [NSMutableString string];
    for (id obj in array) {
        [strM appendFormat:@"%@",obj];
    }
    
    NSLog(@"%s  %@",__func__,strM);
    
   const char *cStr = strM.UTF8String;
   unsigned char result[CC_MD5_DIGEST_LENGTH];

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
   CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
#pragma clang diagnostic pop

   NSMutableString *md5Str = [NSMutableString string];
   for (int i = 0; i < CC_MD5_DIGEST_LENGTH; ++i) {
       [md5Str appendFormat:@"%02x", result[i]];
   }
    self.md5 = md5Str;
}


//解归档
- (instancetype)initWithCoder:(NSCoder *)decoder{//解档

    if ([super init]) {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.weight = [decoder decodeFloatForKey:@"weight"];
        self.height = [decoder decodeFloatForKey:@"height"];
        self.hobits = [decoder decodeObjectOfClass:[NSArray class] forKey:@"hobits"];
        self.loverStranger = [decoder decodeObjectOfClass:[NSDictionary class] forKey:@"loverStranger"];
        self.md5 = [decoder decodeObjectForKey:@"md5"];
        
    }
    return self;
}


@end
