//
//  UpcomingEventsFeedParser.m
//  FSUGuide
//
//  Created by Justin Block on 6/20/16.
//  Copyright © 2016 Justin Block. All rights reserved.
//
// Credits - http://www.appcoda.com/ios-programming-rss-reader-tutorial/ for a guide on making an rss feed. Code from appcoda url above used for UpcomingEventsFeedParser class.

#import "UpcomingEventsFeedParser.h"

@interface UpcomingEventsFeedParser()
@property (strong, nonatomic) NSString* elementName;
@property (strong, nonatomic) NSMutableDictionary* item;
@property (strong, nonatomic) NSMutableString* articleTitle;
@property (strong, nonatomic) NSMutableString* articleLink;
@property (strong, nonatomic) NSMutableString* articleDescription;
@end

@implementation UpcomingEventsFeedParser
- (instancetype)initWithFSUFeed
{
    self = [super init];
    if (self) {
        NSURL *fsuFeedURL = [NSURL URLWithString:@"http://calendar.fsu.edu/_layouts/listfeed.aspx?List=%7BBFDD3427-0440-4285-906E-260832DCE7F7%7D&Source=http%3A%2F%2Fcalendar%2Efsu%2Eedu%2FLists%2FCalendar%2Fcalendar%2Easpx"];
        self.parser = [[NSXMLParser alloc] initWithContentsOfURL:fsuFeedURL];
        [self.parser setShouldResolveExternalEntities:NO];
        [self.parser setDelegate:self];
        [self.parser parse];
        
        // After parsing sort the array based on earliest upcoming event first - credits http://stackoverflow.com/a/8665549
        [self.feedData sortUsingDescriptors:[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"startTimeDateObject" ascending:YES], nil]];
    }
    return self;
}

#pragma Lazy loading
-(NSMutableArray *)feedData {
    if(_feedData == nil) {
        _feedData = [[NSMutableArray alloc] init];
    }
    return _feedData;
}

#pragma NSXMLParserDelegate
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    self.elementName = elementName;
    
    // Clear old data by re-allocing everytime we come across an item xml tag
    if ([self.elementName isEqualToString:@"item"]) {
        self.item = [[NSMutableDictionary alloc] init];
        self.articleTitle = [[NSMutableString alloc] init];
        self.articleLink = [[NSMutableString alloc] init];
        self.articleDescription = [[NSMutableString alloc] init];
    }
}

/*
 Add the values we read between the opening and closing bracket of the xml element
*/
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    // Trims whitespace and newline characters
    NSString* trimmedString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                               
    if ([self.elementName isEqualToString:@"title"]) {
        [self.articleTitle appendString:trimmedString];
    } else if ([self.elementName isEqualToString:@"link"]) {
        [self.articleLink appendString:trimmedString];
    } else if ([self.elementName isEqualToString:@"description"]) {
        [self.articleDescription appendString:trimmedString];
    }
}

/*
    When we reach the closing tag for the element save all the data
*/
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"item"]) {
        NSString* dateAsString = [self getStartTimeFromDescription];
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm a"];
        NSDate *date = [dateFormatter dateFromString:dateAsString];
        
        // If the date is in the past dont store the item
        if([date timeIntervalSinceNow] < 0) {
            return;
        }
        
        [self.item setObject:dateAsString forKey:@"startTime"];
        [self.item setObject:date forKey:@"startTimeDateObject"];
        [self.item setObject:self.articleTitle forKey:@"title"];
        [self.item setObject:self.articleLink forKey:@"link"];
        [self.item setObject:self.articleDescription forKey:@"description"];
        [self.feedData addObject:[self.item copy]];
    }
}

/*
    Parses the start time from the description
*/
-(NSString *)getStartTimeFromDescription {
    // Get the starting position of start time
    NSRange startPos = [self.articleDescription rangeOfString:@"Start Time"];
    // Split the string so we can find the first occurence of </div> thats AFTER Start Time. This is needed since rangeOfString returns the first occurence in the string
    NSString* firstPartOfString = [self.articleDescription substringWithRange: NSMakeRange(startPos.location + 16, startPos.location + 100)];
    return [self.articleDescription substringWithRange: NSMakeRange(startPos.location + 16, [firstPartOfString rangeOfString: @"</div>"].location)];
}

@end
