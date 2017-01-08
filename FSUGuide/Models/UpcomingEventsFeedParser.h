//
//  UpcomingEventsFeedParser.h
//  FSUGuide
//
//  Created by Justin Block on 6/20/16.
//  Copyright © 2016 Justin Block. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpcomingEventsFeedParser : NSObject <NSXMLParserDelegate>
- (instancetype)initWithFSUFeed;
@property (strong, nonatomic) NSXMLParser* parser;
@property (strong, nonatomic) NSMutableArray* feedData;
@end
