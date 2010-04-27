//
//  ANTLRIntArray.m
//  ANTLR
//
//  Created by Ian Michell on 27/04/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import "ANTLRIntArray.h"


@implementation ANTLRIntArray

-(id) init
{
	self = [super init];
	if (self)
	{
		p = -1;
		buffer = [NSMutableData dataWithLength:ANTLR_INT_ARRAY_INITIAL_SIZE];
		data = [buffer mutableBytes];
	}
	return self;
}

-(void) add:(NSInteger) v
{
	[self ensureCapacity:p + 1];
	data[++p] = v;
}

-(void) push:(NSInteger) v
{
	[self add:v];
}

-(NSInteger) pop
{
	NSInteger v = data[p];
	p--;
	return v;
}

-(NSInteger) get:(NSInteger) i
{
	return data[i];
}

-(NSInteger) size
{
	return p;
}

-(void) clear
{
	p = -1;
}

-(void) ensureCapacity:(NSInteger) index
{
	if ((index + 1) >= [buffer length])
	{
		NSInteger newSize = [buffer length] * 2;
		if (index > newSize)
		{
			newSize = index + 1;
		}
		[buffer setLength:newSize];
	}
}

-(void) dealloc
{
	[buffer release];
	[super dealloc];
}

@synthesize data;

@end
