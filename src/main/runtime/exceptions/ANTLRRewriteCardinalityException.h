//
//  ANTLRRewriteCardinalityException.h
//  ANTLR
//
//  Created by Ian Michell on 29/04/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <objc/objc-runtime.h>

@interface ANTLRRewriteCardinalityException : NSException 
{

}

+(ANTLRRewriteCardinalityException *) exceptionWithElementDescription:(NSString *) description;

@end
