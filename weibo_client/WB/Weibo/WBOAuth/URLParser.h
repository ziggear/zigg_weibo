//
//  URLParser.h
//  WB
//
//  Created by ziggear on 15-1-19.
//  Copyright (c) 2015年 ziggear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLParser : NSObject {
    NSArray *variables;
}

@property (nonatomic, retain) NSArray *variables;

- (id)initWithURLString:(NSString *)url;
- (NSString *)valueForVariable:(NSString *)varName;

@end

