//
//  ANTLRMismatchedSetException.m
//  ANTLR
//
//  Created by Ian Michell on 04/07/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import "ANTLRMismatchedSetException.h"


@implementation ANTLRMismatchedSetException

-(id) initWithBitSet:(ANTLRBitSet *) set withInputStream:(id<ANTLRIntStream>) input
{
	self = [super initWithStream:input];
	if (self)
	{
		self.expecting = set;
	}
	return self;
}

@synthesize expecting;

@end
