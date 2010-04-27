//
//  ANTLRCommonTreeNodeStream.m
//  ANTLR
//
//  Created by Ian Michell on 26/04/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import "ANTLRCommonTreeNodeStream.h"


@implementation ANTLRCommonTreeNodeStream

-(id) initWithTree:(id<ANTLRTree>) tree
{
	return [self initWithTreeAdaptor:[ANTLRCommonTreeAdaptor new] andTree:tree];
}

-(id) initWithTreeAdaptor:(id<ANTLRTreeAdaptor>) adaptor andTree:(id<ANTLRTree>) t
{
	self = [super initWithEOF:[adaptor createTreeWithTokenType:ANTLRTokenTypeEOF withText:@"EOF"]];
	if (self)
	{
		hasNilRoot = NO;
		level = 0;
		treeSource = t;
		treeAdaptor = adaptor;
		iterator = [[ANTLRTreeIterator alloc] initWithTree:self.treeSource];
		iterator.eof = self.eof;
	}
	return self;
}

-(void) reset
{
	[super reset];
	[iterator reset];
	hasNilRoot = NO;
	level = 0;
	if (calls != nil)
	{
		[calls clear];
	}
}

-(id) nextElement
{
	id t = [iterator nextObject];
	if (t == iterator.up)
	{
		level--;
		if (level == 0 && hasNilRoot)
		{
			return [iterator nextObject];
		}
	}
	else if (t == iterator.down)
	{
		level++;
	}
	if (level == 0 && [self.treeAdaptor isEmptyTree:(id<ANTLRTree>)t])
	{
		hasNilRoot = YES;
		t = [iterator nextObject]; // t is now down, so get real node next
		level++;
		t = [iterator nextObject];
	}
	return t;
}

-(NSInteger) LA:(NSInteger) i
{
	return [self.treeAdaptor tokenTypeForNode:(id<ANTLRTree>)[self LT:i]];
}

-(void) push:(NSInteger) i
{
	if (calls == nil)
	{
		calls = [ANTLRIntArray new];
	}
	[calls push:i];
	[self seek:i];
}

-(NSInteger) pop
{
	NSInteger ret = [calls pop];
	[self seek:ret];
	return ret;
}

-(void) replaceChildren:(id<ANTLRTree>) parent start:(NSInteger) startIdx end:(NSInteger) stopIdx object:(id<ANTLRTree>) t;
{
	if (parent != nil)
	{
		[self.treeAdaptor replaceChildrenForTree:parent from:startIdx to:stopIdx with:t];
	}
}

-(NSString *) description
{
	return @"n/a";
}

-(NSString *) toTokenTypeString
{
	[self reset];
	NSMutableString *buf = [NSMutableString new];
	id<ANTLRTree> o = [self LT:1];
	NSInteger type = [self.treeAdaptor tokenTypeForNode:o];
	while (type != ANTLRTokenTypeEOF)
	{
		[buf appendString:@" "];
		[buf appendFormat:@"%d", type];
		[self consume];
		o = [self LT:1];
		type = [self.treeAdaptor tokenTypeForNode:o];
	}
	return buf;
}

@synthesize uniqueNavigationNodes; // may be dynamic
@synthesize treeAdaptor;
@synthesize treeSource;
@synthesize tokenStream;

@dynamic sourceName;
-(NSString *) sourceName
{
	return self.tokenStream.sourceName;
}

@end
