//
//  ANTLRRewriteRuleElementStream.h
//  ANTLR
//
//  Created by Ian Michell on 10/05/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ANTLR/ANTLRTree.h>
#import <ANTLR/ANTLRTreeAdaptor.h>

@interface ANTLRRewriteRuleElementStream : NSObject 
{
	NSInteger cursor;
	id singleElement;
	NSMutableArray *elements;
	BOOL dirty;
	NSString *elementDescription;
	id<ANTLRTreeAdaptor> treeAdaptor;
}

-(id) initWithTreeAdaptor:(id<ANTLRTreeAdaptor>) adaptor elementDescription:(NSString *) description;
-(id) initWithTreeAdaptor:(id<ANTLRTreeAdaptor>) adaptor elementDescription:(NSString *) description singleElement:(id) element;
-(id) initWithTreeAdaptor:(id<ANTLRTreeAdaptor>) adaptor elementDescription:(NSString *) description listOfElements:(NSArray *) list;

-(void) reset;
-(void) add:(id) el;
-(id) nextTree;
-(id) copy:(id) el;
-(id) toTree:(id) el;
-(BOOL) hasNext;
-(NSInteger) size;

@property(readwrite, retain) NSString *elementDescription;

// protected
-(id) _next;

@end
