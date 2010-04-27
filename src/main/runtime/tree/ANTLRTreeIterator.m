//
//  ANTLRTreeIterator.m
//  ANTLR
//
//  Created by Ian Michell on 26/04/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import "ANTLRTreeIterator.h"


@implementation ANTLRTreeIterator

-(id) init
{
	self = [super init];
	if (self)
	{
		firstTime = YES;
		nodes = [ANTLRFastQueue new];
	}
	return self;
}

-(id) initWithTree:(id<ANTLRTree>) t
{
	return [self initWithTreeAdaptor:[ANTLRCommonTreeAdaptor new] andTree:t];
}

-(id) initWithTreeAdaptor:(id<ANTLRTreeAdaptor>) a andTree:(id<ANTLRTree>) t
{
	self = [self init];
	if (self)
	{
		adaptor = a;
		tree = t;
		root = t;
		down = [adaptor createTreeWithTokenType:ANTLRTokenTypeDOWN withText:@"DOWN"];
		up = [adaptor createTreeWithTokenType:ANTLRTokenTypeUP withText:@"UP"];
		eof = [adaptor createTreeWithTokenType:ANTLRTokenTypeEOF withText:@"EOF"];
	}
	return self;
}

-(void) reset
{
	firstTime = YES;
	tree = root;
	[nodes clear];
}

-(BOOL) hasNext
{
	if (firstTime)
	{
		return root != nil;
	}
	if ([nodes size] > 0)
	{
		return YES;
	}
	if (tree == nil)
	{
		return NO;
	}
	if ([adaptor childCountForTree:tree] > 0)
	{
		return YES;
	}
	return [adaptor parentForNode:tree] != nil;
}

-(id) nextObject
{
	// is this the first time we are using this method?
	if (firstTime)
	{
		firstTime = NO;
		if ([adaptor childCountForTree:tree] == 0)
		{
			[nodes add:eof];
			return tree;
		}
		return tree;
	}
	// do we have any objects queued up?
	if ([nodes size] > 0)
	{
		return [nodes remove];
	}
	// no nodes left?
	if (tree == nil)
	{
		return self.eof;
	}
	if ([adaptor childCountForTree:tree] > 0)
	{
		tree = [adaptor childForNode:tree atIndex:0];
		[nodes add:tree]; // real node is next after down
		return self.down;
	}
	// if no children, look for next sibling of ancestor
	id<ANTLRTree> parent = [adaptor parentForNode:tree];
	while (parent != nil && ([adaptor indexForNode:tree] + 1) >= [adaptor childCountForTree:parent])
	{
		[nodes add:up];
		tree = parent;
		parent = [adaptor parentForNode:tree];
	}
	if (parent == nil)
	{
		tree = nil;
		[nodes add:self.eof];
		return [nodes remove];
	}
	// must have found a node with an unvisited sibling
	// move to it and return it
	NSInteger nextSiblingIndex = [adaptor indexForNode:tree] + 1;
	tree = [adaptor childForNode:parent atIndex:nextSiblingIndex];
	[nodes add:tree];
	return [nodes remove];
}

-(NSArray *) allObjects
{
	NSMutableArray *array = [NSMutableArray new];
	while ([self hasNext])
	{
		[array addObject:[self nextObject]];
	}
	return array;
}

@synthesize up;
@synthesize down;
@synthesize eof;

@end
