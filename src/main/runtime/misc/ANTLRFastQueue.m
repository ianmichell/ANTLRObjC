//
//  ANTLRFastQueue.m
//  ANTLR
//
//  Created by Ian Michell on 26/04/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import "ANTLRFastQueue.h"
#import "ANTLRError.h"

@implementation ANTLRFastQueue

-(id) init
{
	self = [super init];
	if (self)
	{
		data = [NSMutableArray new];
		p = 0;
	}
	return self;
}

-(void) reset
{
	p = 0;
	[data removeAllObjects];
}

-(id) remove
{
	id o = [self get:0];
	p++;
	// check to see if we have hit the end of the buffer
	if (p == [data count])
	{
		// if we have, then we need to clear it out
		[self clear];
	}
	return o;
}

-(void) add:(id) o
{
	[data addObject:o];
}

-(NSInteger) size
{
	return [data count] - p;
}

-(id) head
{
	return [self get:0];
}

-(id) get:(NSInteger) i
{
	if (p + i >= [data count])
	{
		@throw [NSException exceptionWithName:ANTLRNoSuchElementException reason:[NSString stringWithFormat:@"queue index (%d+%d) > size %d", p, i, [data count]] userInfo:nil];
	}
	return [data objectAtIndex:(p + i)];
}

// FIXME: Java code has this, it doesn't seem like it needs to be there... Then again a lot of the code in the java runtime is not great...
-(void) clear
{
	[self reset];
}

-(NSString *) description
{
	NSMutableString *buf = [NSMutableString new];
	NSInteger n = [self size];
	for (NSInteger i = 0; i < n; i++)
	{
		[buf appendString:[[self get:i] description]];
		if ((i + 1) < n)
		{
			[buf appendString:@" "];
		}
	}
	return buf;
}

@end
