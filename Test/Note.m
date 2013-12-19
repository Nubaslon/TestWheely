//
//  Note.m
//  Test
//
//  Created by  on 19.12.13.
//  Copyright (c) 2013 Nubaslon. All rights reserved.
//

#import "Note.h"

@implementation Note

+(Note *)noteWithData:(NSDictionary *)dict
{
    return [[Note alloc] initWithData:dict];
}

-(id)initWithData:(NSDictionary *)data
{
    //NSLog(@"DATA - %@", data);
    if (self = [super init]) {
        self.ID = [data objectForKey:@"id"];
        self.title = [data objectForKey:@"title"];
        self.text = [data objectForKey:@"text"];
    }
    return self;
}

@end
