//
//  ANTLRMismatchedTokenException.m
//  ANTLR
//
//  Created by Ian Michell on 24/04/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import "ANTLRMismatchedTokenException.h"


@implementation ANTLRMismatchedTokenException

-(id) init
{
	self = [super init];
	if (self)
	{
		self.expecting = ANTLRTokenTypeInvalid;
	}
	return self;
}

-(id) initWithExpectedType:(NSInteger) exp forStream:(id<ANTLRIntStream>) input
{
	self = [super initWithStream:input];
	if (self)
	{
		self.expecting = exp;
	}
	return self;
}

-(NSString *) description
{
	return [NSString stringWithFormat:@"ANTLRMismatchedTokenException(%d!=%d)", self.unexpectedType, self.expecting];
}

@synthesize expecting;

@end
