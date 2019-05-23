//
//  ServerModel.m
//  Pointzi
//
//  Created by Mahipal Kummari on 23/05/19.
//  Copyright © 2019 Mahipal Kummari. All rights reserved.
//

#import "ServerModel.h"
#import "PZTooltipObj.h"

@implementation ServerModel

-(void)getJSONData:(NSString*)urlString andCompletionHandler:(void(^)(PZTooltipObj *))comp {
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask * data = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse*)response;
        if(httpResponse.statusCode == 200){
            NSLog(@"Got The Data");
            if(data){
                id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                NSArray * toolTipArray = [result valueForKey:@"data"];
                
                NSLog(@"%@ , count = %ld",result,toolTipArray.count);
                if([toolTipArray count])
                {
                    NSDictionary * dict_tooltip = [toolTipArray objectAtIndex:0];
                    PZTooltipObj * tooltipObj = [[PZTooltipObj alloc] init];
                    [tooltipObj initWithJsonDict:dict_tooltip];
                    
                    
                    dispatch_sync(dispatch_get_main_queue(),^{
                        comp(tooltipObj);
                         //[  updateTootipWithContent:tooltipObj];
                        
                    });
                }
                
                
               
                
            }
        }
    }];
    [data resume];
}
@end
