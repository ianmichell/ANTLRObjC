//
//  ANTLRMismatchedTreeNodeException.m
//  ANTLR
//
//  Created by Ian Michell on 03/07/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import "ANTLRMismatchedTreeNodeException.h"


@implementation ANTLRMismatchedTreeNodeException

-(id) init
{
	self = [super init];
	return self;
}

-(id) initWithTreeNodeStream:(id<ANTLRTreeNodeStream>) input withExpecting:(NSInteger) exp
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
	return [NSString stringWithFormat: @"ANTLRMismatchedTreeNodeException(%d != %d)", self.unexpectedType, self.expecting];
}

@synthesize expecting;

@end
