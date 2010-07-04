//
//  ANTLRFailedPredicateException.h
//  ANTLR
//
//  Created by Ian Michell on 04/07/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ANTLR/ANTLRRecognitionException.h>
#import <ANTLR/ANTLRIntStream.h>

@interface ANTLRFailedPredicateException : ANTLRRecognitionException
{
	NSString *ruleName;
	NSString *predicateText;
}

-(id) initWithStream:(id<ANTLRIntStream>) input withRuleName:(NSString *) rule withPredicateText:(NSString *) pt;

@property(readwrite, retain) NSString *ruleName;
@property(readwrite, retain) NSString *predicateText;

@end
