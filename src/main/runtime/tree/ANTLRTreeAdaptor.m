//
//  ANTLRTreeAdaptor.m
//  ANTLR
//
//  Created by Ian Michell on 23/04/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import "ANTLRError.h"
#import "ANTLRTreeAdaptor.h"
#import "ANTLRCommonErrorNode.h"


@implementation ANTLRTreeAdaptor

-(id) init
{
	self = [super init];
	if (self)
	{
		uniqueNodeID = 1;
	}
	return self;
}

-(id<ANTLRTree>) createTreeWithToken:(id<ANTLRToken>) payload
{
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

-(id<ANTLRTree>) createEmptyTree
{
	return [self createTreeWithToken:nil];
}

-(id<ANTLRTree>) createErrorNodeWithStream:(id<ANTLRTokenStream>) inStream fromToken:(id<ANTLRToken>) start toToken:(id<ANTLRToken>) stop caughtException:(ANTLRRecognitionException *) exception
{
	ANTLRCommonErrorNode *errNode = [[ANTLRCommonErrorNode alloc] initWithStream:inStream fromToken:start toToken:stop caughtException:exception];
	return errNode;
}

-(id<ANTLRTree>) copyNode:(id<ANTLRTree>) t;
{
	if (t == nil)
	{
		return nil;
	}
	return [t copyWithZone:nil];
}

-(id<ANTLRTree>) copyTree:(id<ANTLRTree>) t
{
	return [self copyTree:t withParent:nil];
}

-(id<ANTLRTree>) copyTree:(id<ANTLRTree>) t withParent:(id<ANTLRTree>) parent
{
	if (t == nil)
	{
		return nil;
	}
	id<ANTLRTree> newTree = [self copyNode:t];
	[self setIndexForNode:newTree toIndex:[self indexForNode:t]];
	[self setParentForNode:newTree toParent:parent];
	NSInteger n = [self childCountForTree:t];
	for (NSInteger i = 0; i < n; i++)
	{
		id<ANTLRTree> child = [self childForNode:t atIndex:i];
		id<ANTLRTree> newSubTree = [self copyTree:child withParent:t];
		[self addChild:newSubTree toTree:newTree];
	}
	return newTree;
}

-(void) addChild:(id<ANTLRTree>) child toTree:(id<ANTLRTree>)parent
{
	if (parent != nil && child != nil)
	{
		[parent addChild:child];
	}
}

-(id<ANTLRTree>) postProcessTree:(id<ANTLRTree>) rootTree
{
	id<ANTLRTree> r = rootTree;
	if (r != nil && r.isEmpty)
	{
		if (r.childCount == 0)
		{
			r = nil;
		}
		else if (rootTree.childCount == 1)
		{
			r = [rootTree childAtIndex:0];
			r.parent = nil;
			r.childIndex = -1;
		}
	}
	return r;
}

-(NSInteger) getUniqueIdForTree:(id<ANTLRTree>) node
{
	if (treeToUniqueIDMap == nil)
	{
		treeToUniqueIDMap = [NSMutableDictionary new];
	}
	NSNumber *prevID = [treeToUniqueIDMap objectForKey:node];
	if ([prevID integerValue] > 0)
	{
		return [prevID integerValue];
	}
	NSNumber *ID = [NSNumber numberWithInteger:uniqueNodeID];
	[treeToUniqueIDMap setObject:ID forKey:node];
	uniqueNodeID++;
	return [ID integerValue];
}

-(BOOL) isEmptyTree:(id<ANTLRTree>) tree
{
	return tree.isEmpty;
}

-(id<ANTLRTree>) createTreeWithToken:(id<ANTLRToken>) token withType:(NSInteger) type
{
	id<ANTLRToken> newToken = [self createTokenFromToken:token];
	newToken.type = type;
	return [self createTreeWithToken:newToken];
}

-(id<ANTLRTree>) createTreeWithToken:(id<ANTLRToken>) token withType:(NSInteger) type andText:(NSString *) text
{
	id<ANTLRToken> newToken = [self createTokenFromToken:token];
	newToken.type = type;
	newToken.text = text;
	return [self createTreeWithToken:newToken];
}

-(id<ANTLRTree>) createTreeWithTokenType:(NSInteger) tokenType withText:(NSString *) text
{
	id<ANTLRToken> newToken = [self createTokenFromType:tokenType withText:text];
	return [self createTreeWithToken:newToken];
}

-(id<ANTLRTree>) becomeRootNode:(id<ANTLRTree>) newRoot ofNode:(id<ANTLRTree>) oldRoot
{
	if (oldRoot == nil)
	{
		return newRoot;
	}
	if (newRoot.isEmpty)
	{
		NSInteger nc = newRoot.childCount;
		if (nc == 1)
		{
			newRoot = [newRoot childAtIndex:0];
		}
		else if (nc > 1)
		{
			@throw [NSException exceptionWithName:ANTLRRuntimeException reason:@"More than one node as root" userInfo:nil];
		}
	}
	[newRoot addChild:oldRoot];
	return newRoot;
}

-(id<ANTLRTree>) becomeRootNodeFromToken:(id<ANTLRToken>) token ofNode:(id<ANTLRTree>) oldRoot
{
	return [self becomeRootNode:[self createTreeWithToken:token] ofNode:oldRoot];
}

-(NSInteger) tokenTypeForNode:(id<ANTLRTree>) t
{
	if (t == nil)
	{
		return ANTLRTokenTypeInvalid;
	}
	return t.type;
}

-(void) setTokenType:(NSInteger) type forNode:(id<ANTLRTree>) t
{
	@throw [NSException exceptionWithName:ANTLRNoSuchMethodException reason:@"Don't know enough about tree" userInfo:nil];
}

-(NSString *) textForNode:(id<ANTLRTree>) t
{
	if (t == nil)
	{
		return nil;
	}
	return t.text;
}

-(void) setText:(NSString *) text forNode:(id<ANTLRTree>) t
{
	@throw [NSException exceptionWithName:ANTLRNoSuchMethodException reason:@"Don't know enough about tree" userInfo:nil];
}

-(id<ANTLRToken>) tokenForNode:(id<ANTLRTree>) t
{
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

-(void) setTokenBoundriesForTree:(id<ANTLRTree>) t fromToken:(id<ANTLRToken>) start toToken:(id<ANTLRToken>) stop
{
	if (t == nil)
	{
		return;
	}
	t.tokenStartIndex = start != nil ? start.tokenIndex : 0;
	t.tokenStopIndex = stop != nil ? stop.tokenIndex : 0;
}

-(NSInteger) tokenStartIndexForTree:(id<ANTLRTree>) t
{
	if (t == nil)
	{
		return -1;
	}
	return t.tokenStartIndex;
}

-(NSInteger) tokenStopIndexForTree:(id<ANTLRTree>) t
{
	if (t == nil)
	{
		return -1;
	}
	return t.tokenStopIndex;
}

-(id<ANTLRTree>) childForNode:(id<ANTLRTree>) parent atIndex:(NSInteger) idx
{
	if (parent == nil)
	{
		return nil;
	}
	return [parent.children objectAtIndex:idx];
}

-(void) setChildForNode:(id<ANTLRTree>) parent atIndex:(NSInteger) idx withChild:(id<ANTLRTree>) child
{
	[parent setChildAtIndex:idx child:child];
}

-(id<ANTLRTree>) removeChildFromNode:(id<ANTLRTree>) parent atIndex:(NSInteger) idx
{
	return [parent deleteChild:idx];
}

-(NSInteger) childCountForTree:(id<ANTLRTree>) t
{
	return t.childCount;
}

-(id<ANTLRTree>) parentForNode:(id<ANTLRTree>) child
{
	if (child == nil)
	{
		return nil;
	}
	return child.parent;
}

-(void) setParentForNode:(id<ANTLRTree>) child toParent:(id<ANTLRTree>) parent
{
	if (child != nil)
	{
		child.parent = parent;
	}
}

-(NSInteger) indexForNode:(id<ANTLRTree>) t
{
	if (t == nil)
	{
		return 0;
	}
	return t.childIndex;
}

-(void) setIndexForNode:(id<ANTLRTree>) t toIndex:(NSInteger) idx
{
	if (t != nil)
	{
		t.childIndex = idx;
	}
}

-(void) replaceChildrenForTree:(id<ANTLRTree>) parent from:(NSInteger) start to:(NSInteger) stop with:(id<ANTLRTree>) t
{
	if (parent != nil)
	{
		[parent replaceChildrenFromIndex:start toIndex:stop tree:t];
	}
}

-(id<ANTLRToken>) createTokenFromType:(NSInteger) tokenType withText:(NSString *) txt
{
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

-(id<ANTLRToken>) createTokenFromToken:(id<ANTLRToken>) fromToken
{
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

@end
