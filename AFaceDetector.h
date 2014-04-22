@interface AFaceDetector
-(id) initWithImageView:(UIImageView*)imView;
-(void) start;
-(void) stop;
-(BOOL) running;
@property (nonatomic, strong) id delegate;
@end

@protocol AFaceDetectorProtocol
-(void)faceRecognized:(NSString*)recognized confidence:(int)confidence;
-(void)faceRejected;
@end
