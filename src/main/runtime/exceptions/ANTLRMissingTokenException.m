//
//  ANTLRMissingTokenException.m
//  ANTLR
//
//  Created by Ian Michell on 24/04/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import "ANTLRMissingTokenException.h"


@implementation ANTLRMissingTokenException

-(id) initWithExpectedType:(NSInteger) expected forInputStream:(id<ANTLRIntStream>) input withObject:(id) o
{
	self = [super initWithExpectedType:expected forStream:input];
	if (self)
	{
		inserted = o;
	}
	return self;
}

@synthesize inserted;

@dynamic missingType;
-(NSInteger) missingType
{
	return self.expecting;
}

-(NSString *) description
{
	if (self.inserted != nil && self.token != nil)
	{
		return [NSString stringWithFormat:@"ANTLRMissingTokenException(inserted=%@ at %@)", [self.inserted description], self.token.text];
	}
	if (self.token != nil)
	{
		return [NSString stringWithFormat:@"ANTLRMissingTokenException(at %@)", self.token.text];
	}
	return @"ANTLRMissingTokenException";
}
@end
