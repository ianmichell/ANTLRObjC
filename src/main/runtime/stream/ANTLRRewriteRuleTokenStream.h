//
//  ANTLRRewriteRuleTokenStream.h
//  ANTLR
//
//  Created by Ian Michell on 10/05/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ANTLR/ANTLRToken.h>
#import <ANTLR/ANTLRRewriteRuleElementStream.h>

@interface ANTLRRewriteRuleTokenStream : ANTLRRewriteRuleElementStream {

}

-(id) nextNode;
-(id<ANTLRToken>) nextToken;

@end
