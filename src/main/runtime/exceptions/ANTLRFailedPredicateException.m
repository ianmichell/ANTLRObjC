//
//  ANTLRFailedPredicateException.m
//  ANTLR
//
//  Created by Ian Michell on 04/07/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import "ANTLRFailedPredicateException.h"


@implementation ANTLRFailedPredicateException

@synthesize predicateText;
@synthesize ruleName;

-(id) initWithStream:(id<ANTLRIntStream>) input withRuleName:(NSString *) rule withPredicateText:(NSString *) pt
{
	self = [super initWithStream:input];
	if (self)
	{
		self.ruleName = rule;
		self.predicateText = pt;
	}
	return self;
}

@end
