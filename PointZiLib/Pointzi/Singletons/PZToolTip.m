//
//  PZToolTip.m
//  Pointzi
//
//  Created by Mahipal Kummari on 23/05/19.
//  Copyright © 2019 Mahipal Kummari. All rights reserved.
//

#import "PZToolTip.h"
#import "ServerModel.h"

@implementation PZToolTip
@synthesize tooltipObj;
static PZToolTip *_sharedPZToolTip = nil;

//+(PZToolTip *)sharedPZToolTip {
//    @synchronized([PZToolTip class]) {
//        if (self.sharedPZToolTip)
//            _sharedPZToolTip = [[self alloc] init];
//        return _sharedPZToolTip;
//    }
//    return nil;
//}
+(PZToolTip *)sharedPZToolTip {
    static dispatch_once_t pred = 0;
    static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (void)initToolTipWithCompletionHandler:(void(^)(bool))comp  {
    ServerModel *api = [[ServerModel alloc] init];
    [api getJSONData:@"https://dummyapi.io/api/post?limit=1" andCompletionHandler:^(PZTooltipObj * obj) {
        NSLog(@"firstname: %@", obj.firstName);
        self.tooltipObj = obj;
        comp(true);
    }];
}
@end
