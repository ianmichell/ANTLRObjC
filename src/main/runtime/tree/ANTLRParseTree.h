//
//  ANTLRParseTree.h
//  ANTLR
//
//  Created by Ian Michell on 28/04/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ANTLR/ANTLRTree.h>
#import <ANTLR/ANTLRToken.h>

@interface ANTLRParseTree : ANTLRTree 
{
	id payload;
	NSMutableArray *hiddenTokens;
}

-(id) initWithLabel:(id) label;
-(NSString *) descriptionWithHiddenTokens;
-(NSString *) inputString;
-(void) stringLeaves:(NSMutableString *) buf;

@property(readwrite, retain) id payload;
@property(readwrite, retain) NSMutableArray *hiddenTokens;

@end
