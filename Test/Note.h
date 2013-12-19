//
//  Note.h
//  Test
//
//  Created by  on 19.12.13.
//  Copyright (c) 2013 Nubaslon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Note : NSObject

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *text;

+(Note *)noteWithData:(NSDictionary *)dict;
-(id)initWithData:(NSDictionary *)dict;
@end
