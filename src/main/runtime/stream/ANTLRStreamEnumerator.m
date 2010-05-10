//
//  ANTLRStreamEnumertor.m
//  ANTLR
//
//  Created by Ian Michell on 29/04/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import "ANTLRStreamEnumerator.h"


@implementation ANTLRStreamEnumerator

-(id) init
{
	self = [super init];
	if (self)
	{
		i = 0;
	}
	return self;
}

-(id) initWithNodes:(NSMutableArray *) n andEOF:(id) o
{
	self = [self init];
	if (self)
	{
		nodes = n;
		eof = o;
	}
	return self;
}

-(BOOL) hasNext
{
	return i < [nodes count];
}

-(id) nextObject
{
	NSInteger current = i;
	i++;
	if (current < [nodes count])
	{
		return [nodes objectAtIndex:current];
	}
	return eof;
}

@end
