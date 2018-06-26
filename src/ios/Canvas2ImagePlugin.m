//
//  Canvas2ImagePlugin.m
//  Canvas2ImagePlugin PhoneGap/Cordova plugin
//
//  Created by Tommy-Carlos Williams on 29/03/12.
//  Copyright (c) 2012 Tommy-Carlos Williams. All rights reserved.
//  MIT Licensed
//

#import "Canvas2ImagePlugin.h"
#import <Cordova/CDV.h>
#ifndef __CORDOVA_4_0_0
    #import <Cordova/NSData+Base64.h>
#endif

@implementation Canvas2ImagePlugin
@synthesize callbackId;

//-(CDVPlugin*) initWithWebView:(UIWebView*)theWebView
//{
//    self = (Canvas2ImagePlugin*)[super initWithWebView:theWebView];
//    return self;
//}

- (void)saveImageDataToLibrary:(CDVInvokedUrlCommand*)command
{
    self.callbackId = command.callbackId;
    //NSData* imageData = [NSData dataFromBase64String:[command.arguments objectAtIndex:0]];
    
    //NSData* imageData = [[NSData alloc] initWithBase64EncodedString:[command.arguments objectAtIndex:0]];
    
#ifndef __CORDOVA_3_8_0
    NSData* imageData = [NSData dataFromBase64String:[command.arguments objectAtIndex:0]];
#else
    //NSData* data = [[NSData alloc] initWithBase64EncodedString:dataString options:0];
    NSData* imageData = [[NSData alloc] initWithBase64EncodedString:[command.arguments objectAtIndex:0] options:0];
#endif
    
    
    UIImage* image = [[[UIImage alloc] initWithData:imageData] autorelease];    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    CDVPluginResult* pluginResult = nil;
    
    // Was there an error?
    if (error != NULL)
    {
        // Show error message...
        NSLog(@"ERROR: %@",error);
        pluginResult= [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR messageAsString:error.description];
        //[self.webView stringByEvaluatingJavaScriptFromString:[result toErrorCallbackString: self.callbackId]];
    }
    else  // No errors
    {
        // Show message image successfully saved
        NSLog(@"IMAGE SAVED!");
        pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsString:@"Image saved"];
        //[self.webView stringByEvaluatingJavaScriptFromString:[result toSuccessCallbackString: self.callbackId]];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
}

- (void)dealloc
{   
    [callbackId release];
    [super dealloc];
}


@end
