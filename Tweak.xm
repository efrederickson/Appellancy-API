#import "AFaceDetector.h"
#import <dlfcn.h>
#import <objc/runtime.h>
#import <libactivator/libactivator.h>

@interface Sample : NSObject <AFaceDetectorProtocol, LAListener>
-(void)faceRecognized:(NSString*)recognized confidence:(int)confidence;
-(void)faceRejected;
@end

static Sample *wat;
static AFaceDetector *detector;

@implementation Sample
-(void)faceRecognized:(NSString*)recognized confidence:(int)confidence
{
    // The face was accepted, you don't need to do anything with the confidence.
    // Plus, confidence will vary greatly depending upon the number of pictures they have scanned, the lighting, etc.
    
    // Recognized is the profile name.
    
    NSLog(@"Appellancy sample: accepted '%@'", recognized);
    
    // Allow the user in:
    
    // [self.passcodeController allowAccess];
    //[self stop]; // we don't want to keep running in the background! :O
    [detector stop];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Appellancy Test" message:@"Face accepted" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

-(void)faceRejected
{
    NSLog(@"Appellancy sample: face rejected");
    UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Appellancy Test" message:@"Face rejected" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [error show];
    [error release];
}

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // start the listener
        // seems to cause a little lag when starting...
    	[detector start];
    });

    [event setHandled:YES];
}
@end

%ctor
{
    dlopen("/Library/MobileSubstrate/DynamicLibraries/Appelancy.dylib", RTLD_NOW);
    // initialization of the face recognizer will take a while. It is recommended to do it in the initializer.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // start a new face recognition object
    	detector = [[objc_getClass("AFaceDetector") alloc] init];
        
        // set it up to a listener
        wat = [[Sample alloc] init];
        //wat.passwordController = self;

        detector.delegate = wat;

        if([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.springboard"])
            [[%c(LAActivator) sharedInstance] registerListener:wat forName:@"com.efrederickson.appellancy-api-test-listener"];
    });
}