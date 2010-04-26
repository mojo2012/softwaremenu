//
//  SMWeatherControl.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 3/14/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import "SMWeatherControl.h"
#import "SMYahooWeather.h"
#import "SMWeatherController.h"
#define bundleImag(name,ext)    [BRImage imageWithPath:[[NSBundle bundleForClass:[self class]]pathForResource:(name) ofType:(ext)]]
#define bundleResc(name,ext)    [[NSBundle bundleForClass:[self class]]pathForResource:(name) ofType:(ext)]
#define OPACITY     0.6
@implementation SMWeatherControl
-(id)init
{
    self=[super init];
    _city=[[BRTextControl alloc]init];
    _centerImage=[[BRImageControl alloc]init];
    _infoDict=[[NSMutableArray alloc]init];
    _firstLoad=YES;
//    [self drawControls];
    
    return self;
}
//-(void)controlWasActivated
//{
//    [self drawControls];
//}
-(void)drawControls;
{
    [_city removeFromParent];
    [_city release];
    [_region_country removeFromParent];
    [_region_country release];
    
    _city=[[BRTextControl alloc]init];
    _region_country=[[BRTextControl alloc]init];
    
    
    /*
     *      Adding City Name
     */
    [_city setText:@"(Cannot Load)            " withAttributes:[[BRThemeInfo sharedTheme] menuTitleTextAttributes]];
    CGRect nframe;
    CGRect masterFrame;
    masterFrame.size = [BRWindow maxBounds];
    nframe.size = [_city preferredFrameSize];
    nframe.origin.x=masterFrame.origin.x+masterFrame.size.width*0.05f;
    nframe.origin.y=masterFrame.origin.y+masterFrame.size.height-nframe.size.height*1.3;
    [_city setFrame:nframe];
    [_city setOpacity:OPACITY];
    [self addControl:_city];
    CGPoint topLeft=nframe.origin;
    topLeft.y=topLeft.y+nframe.size.height;
    
    
    /*
     *      Adding Region and Country Subtitle
     */
//    NSString *text;
//    if ([[_infoDict objectForKey:@"region"]length]>0) {
//        text=[NSString stringWithFormat:@"%@, %@",[_infoDict objectForKey:@"region"],[_infoDict objectForKey:@"country"]];
//    }
//    else {
//        text=[_infoDict objectForKey:@"country"];
//    }

    [_region_country setText:@"(null)                           " withAttributes:[[BRThemeInfo sharedTheme] labelTextAttributes]];
    nframe.origin.y=nframe.origin.y-[_region_country preferredFrameSize].height*1.1;
    nframe.size=[_region_country preferredFrameSize];
    [_region_country setFrame:nframe];
    [_region_country setOpacity:OPACITY];
    [self addControl:_region_country];
    
    
    
    BRDividerControl *ctrl3 = [[BRDividerControl alloc] init];
    [ctrl3 setLineThickness:2];
    [ctrl3 setBrightness:1.0f];
    [ctrl3 setOpacity:OPACITY];
    nframe.origin.y = nframe.origin.y-[ctrl3 recommendedHeight];//+[ctrl3 recommendedHeight];//[ctrl2 recommendedHeight]*2.f-nframe.size.height*0.1f-masterFrame.size.height*0.25f;
    nframe.origin.x = masterFrame.origin.x+masterFrame.size.width*0.05;
    nframe.size.width=masterFrame.size.width*0.9f;
	nframe.size.height = [ctrl3 recommendedHeight];
    //frame.size.width = masterFrame.size.width-frame.origin.x-masterFrame.size.width*0.05f;
    [ctrl3 setFrame:nframe];
    [self addControl: ctrl3];
    CGPoint pt_two = nframe.origin;
    
    
    
    BRImage *image=[self imageForCode:[_infoDict objectForKey:@"code"]];
    [_centerImage setImage:image];
    CGRect imgFrame;
    imgFrame.size.height=topLeft.y-pt_two.y;
    imgFrame.size.width=imgFrame.size.height*[image aspectRatio];
    imgFrame.origin.x=([BRWindow maxBounds].width-imgFrame.size.width)/2.;
    imgFrame.origin.y=pt_two.y;
    [_centerImage setFrame:imgFrame];
    [_centerImage setOpacity:OPACITY];
    [self addControl:_centerImage];
    CGRect tframe=imgFrame;
    
    
    /*
     *  Adding Temperature
     */
    
    [_temperature removeFromParent];
    [_temperature release];
    _temperature=[[BRTextControl alloc]init];
    [_temperature setText:@"???°?"//[NSString stringWithFormat:@"???°?",[_infoDict objectForKey:@"temp"],[_infoDict objectForKey:@"temperature"],nil]
           withAttributes:[[BRThemeInfo sharedTheme] menuTitleTextAttributes]];
    tframe.origin.x=imgFrame.origin.x-[_temperature preferredFrameSize].width*1.3;
//    NSLog(@"temp pref frame: %lf %lf",[_temperature preferredFrameSize].width,[_temperature preferredFrameSize].height)
    tframe.origin.y=tframe.origin.y+(tframe.size.height-[_temperature preferredFrameSize].height)/2.f;
    tframe.size=[_temperature preferredFrameSize];
    [_temperature setOpacity:OPACITY];
    [_temperature setFrame:tframe];
    [self addControl:_temperature];
    
    /*
     *  Adding Date
     */
    tframe=imgFrame;
    [_date removeFromParent];
    [_date release];
    _date=[[BRTextControl alloc]init];
    [_date setText:@"???                                    "
    withAttributes:[[BRThemeInfo sharedTheme] menuTitleTextAttributes]];
    tframe.origin.x=tframe.origin.x+tframe.size.width*1.3;
    tframe.origin.y=tframe.origin.y+(tframe.size.height-[_date preferredFrameSize].height)/2.f;
    tframe.size=[_date preferredFrameSize];
    [_date setOpacity:OPACITY];
    [_date setFrame:tframe];
    [self addControl:_date];

    
    BRTextControl *sunriseText = [[BRTextControl alloc]init];
    [sunriseText setText:@"Sunrise:" withAttributes:[[BRThemeInfo sharedTheme]metadataTitleAttributes]];
    nframe.origin.y=nframe.origin.y-[sunriseText preferredFrameSize].height*1.f;
    nframe.size=[sunriseText preferredFrameSize];
    [sunriseText setOpacity:OPACITY];
    [sunriseText setFrame:nframe];
    [self addControl:sunriseText];
    CGPoint pt_three=nframe.origin;
    
    [_sunrise removeFromParent];
    [_sunrise release];
    _sunrise=[[BRTextControl alloc] init];
    [_sunrise setText:@"???                    " withAttributes:[[BRThemeInfo sharedTheme]metadataTitleAttributes]];
    nframe.origin.x=nframe.origin.x+nframe.size.width*1.2f;
    nframe.size=[_sunrise preferredFrameSize];
    [_sunrise setOpacity:OPACITY];
    [_sunrise setFrame:nframe];
    [self addControl:_sunrise];
    
    sunriseText = [[BRTextControl alloc]init];
    [sunriseText setText:@"Sunset:" withAttributes:[[BRThemeInfo sharedTheme]metadataTitleAttributes]];
    nframe.origin=pt_three;
    nframe.origin.y=nframe.origin.y-[sunriseText preferredFrameSize].height*1.f;
    nframe.size=[sunriseText preferredFrameSize];
    [sunriseText setOpacity:OPACITY];
    [sunriseText setFrame:nframe];
    [self addControl:sunriseText];
    
    [_sunset removeFromParent];
    [_sunset release];
    _sunset=[[BRTextControl alloc] init];
    [_sunset setText:@"???                    " withAttributes:[[BRThemeInfo sharedTheme]metadataTitleAttributes]];
    nframe.origin=[_sunrise frame].origin;
    nframe.origin.y=nframe.origin.y-[_sunset preferredFrameSize].height*1.1f;
    nframe.size=[_sunset preferredFrameSize];
    [_sunset setOpacity:OPACITY];
    [_sunset setFrame:nframe];
    [self addControl:_sunset];
    
    
    nframe.origin.y=pt_three.y;
    nframe.origin.x+=[BRWindow maxBounds].width*0.26;
    BRTextControl *windControl = [[BRTextControl alloc]init];
    windControl = [[BRTextControl alloc]init];
    [windControl setText:@"Wind Direction:" withAttributes:[[BRThemeInfo sharedTheme]metadataTitleAttributes]];
    [windControl setOpacity:OPACITY];
    nframe.size=[windControl preferredFrameSize];
    [windControl setFrame:nframe];
    [self addControl:windControl];
    
    float width = [windControl preferredFrameSize].width*1.1;
    [_windDirection removeFromParent];
    [_windDirection release];
    _windDirection=[[BRTextControl alloc]init];
    [_windDirection setText:@"???                    " 
             withAttributes:[[BRThemeInfo sharedTheme]metadataTitleAttributes]];
    CGRect wframe=nframe;
    wframe.origin.x=wframe.origin.x+width;
    wframe.size=[_windDirection preferredFrameSize];
    [_windDirection setFrame:wframe];
    [_windDirection setOpacity:OPACITY];
    [self addControl:_windDirection];
    
    
    nframe.origin.y=nframe.origin.y-[windControl preferredFrameSize].height*1.f;
    windControl = [[BRTextControl alloc]init];
    [windControl setText:@"Wind Speed:" withAttributes:[[BRThemeInfo sharedTheme]metadataTitleAttributes]];
    [windControl setOpacity:OPACITY];
    nframe.size=[windControl preferredFrameSize];
    [windControl setFrame:nframe];
    [self addControl:windControl];
    
    wframe.origin.y-=[_windDirection preferredFrameSize].height*1.f;
    [_windSpeed removeFromParent];
    [_windSpeed release];
    _windSpeed=[[BRTextControl alloc]init];
    [_windSpeed setText:@"???                    "
         withAttributes:[[BRThemeInfo sharedTheme]metadataTitleAttributes]];
    wframe.size=[_windSpeed preferredFrameSize];
    [_windSpeed setFrame:wframe];
    [_windSpeed setOpacity:OPACITY];
    [self addControl:_windSpeed];
    
    
    nframe.origin.y=nframe.origin.y-[windControl preferredFrameSize].height*1.f;
    windControl = [[BRTextControl alloc]init];
    [windControl setText:@"Wind Chill:" withAttributes:[[BRThemeInfo sharedTheme]metadataTitleAttributes]];
    [windControl setOpacity:OPACITY];
    nframe.size=[windControl preferredFrameSize];
    [windControl setFrame:nframe];
    [self addControl:windControl];
    
    wframe.origin.y-=[_windDirection preferredFrameSize].height*1.f;
    [_windChill removeFromParent];
    [_windChill release];
    _windChill=[[BRTextControl alloc]init];
    [_windChill setText:@"???                    "
         withAttributes:[[BRThemeInfo sharedTheme]metadataTitleAttributes]];
    wframe.size=[_windChill preferredFrameSize];
    [_windChill setFrame:wframe];
    [_windChill setOpacity:OPACITY];
    [self addControl:_windChill];
    float lowestHeight = wframe.origin.y;
    
    
    nframe.origin.y=pt_three.y;
    nframe.origin.x+=[BRWindow maxBounds].width*0.36;
    BRTextControl *humidityControl = [[BRTextControl alloc]init];
    humidityControl = [[BRTextControl alloc]init];
    [humidityControl setText:@"Humidity:" withAttributes:[[BRThemeInfo sharedTheme]metadataTitleAttributes]];
    [humidityControl setOpacity:OPACITY];
    nframe.size=[humidityControl preferredFrameSize];
    [humidityControl setFrame:nframe];
    [self addControl:humidityControl];
    
    
    width = [humidityControl preferredFrameSize].width*1.1;
    [_humidity removeFromParent];
    [_humidity release];
    _humidity=[[BRTextControl alloc]init];
    [_humidity setText:@"???                    "
             withAttributes:[[BRThemeInfo sharedTheme]metadataTitleAttributes]];
    wframe=nframe;
    wframe.origin.x=wframe.origin.x+width;
    wframe.size=[_humidity preferredFrameSize];
    [_humidity setFrame:wframe];
    [_humidity setOpacity:OPACITY];
    [self addControl:_humidity];    
    
    nframe.origin.y=nframe.origin.y-[windControl preferredFrameSize].height*1.f;
    windControl = [[BRTextControl alloc]init];
    [windControl setText:@"Pressure:" withAttributes:[[BRThemeInfo sharedTheme]metadataTitleAttributes]];
    [windControl setOpacity:OPACITY];
    nframe.size=[windControl preferredFrameSize];
    [windControl setFrame:nframe];
    [self addControl:windControl];
    
    wframe.origin.y-=[_windDirection preferredFrameSize].height*1.f;
    [_pressure removeFromParent];
    [_pressure release];
    _pressure=[[BRTextControl alloc]init];
    [_pressure setText:@"???                    "
         withAttributes:[[BRThemeInfo sharedTheme]metadataTitleAttributes]];
    wframe.size=[_pressure preferredFrameSize];
    [_pressure setFrame:wframe];
    [_pressure setOpacity:OPACITY];
    [self addControl:_pressure];
    
    ctrl3 = [[BRDividerControl alloc] init];
    [ctrl3 setLineThickness:2];
    [ctrl3 setBrightness:1.0f];
    [ctrl3 setOpacity:OPACITY];
    [ctrl3 setLabel:@"Forecast"];
    nframe.origin.y = lowestHeight-[ctrl3 recommendedHeight];//+[ctrl3 recommendedHeight];//[ctrl2 recommendedHeight]*2.f-nframe.size.height*0.1f-masterFrame.size.height*0.25f;
    nframe.origin.x = masterFrame.origin.x+masterFrame.size.width*0.05;
    nframe.size.width=masterFrame.size.width*0.9f;
	nframe.size.height = [ctrl3 recommendedHeight];
    //frame.size.width = masterFrame.size.width-frame.origin.x-masterFrame.size.width*0.05f;
    [ctrl3 setFrame:nframe];
    [self addControl: ctrl3];
    CGPoint underForcast= nframe.origin;
    NSDictionary *forecast1=[[_infoDict objectForKey:@"forecast"] objectAtIndex:0];
   // NSDictionary *forecast2=[[_infoDict objectForKey:@"forecast"] objectAtIndex:1];
    
    _forecastDate1 = [[BRTextControl alloc]init];
    [_forecastDate1 setText:@"???                            " 
             withAttributes:[[BRThemeInfo sharedTheme]metadataTitleAttributes]];
    nframe.origin.y=nframe.origin.y-[_forecastDate1 preferredFrameSize].height*1.f;
    nframe.size=[_forecastDate1 preferredFrameSize];
    [_forecastDate1 setOpacity:OPACITY];
    [_forecastDate1 setFrame:nframe];
    [self addControl:_forecastDate1];
    CGPoint pt_five=nframe.origin;
    
    BRTextControl *high=[[BRTextControl alloc]init];
    [high setText:@"High:" withAttributes:[[BRThemeInfo sharedTheme]metadataTitleAttributes]];
    CGRect highFrame;
    highFrame.origin=nframe.origin;
    highFrame.size=[high preferredFrameSize];
    highFrame.origin.x+=masterFrame.size.width*0.16;
    [high setOpacity:OPACITY];
    [high setFrame:highFrame];
    [self addControl:high];
    [high release];
    
    tframe= highFrame;
    tframe.origin.x+=[high preferredFrameSize].width*1.1f;
    _forecastHigh1=[[BRTextControl alloc]init];
    [_forecastHigh1 setText:@"???                     "
             withAttributes:[[BRThemeInfo sharedTheme]metadataTitleAttributes]];
    tframe.size=[_forecastHigh1 preferredFrameSize];
    [_forecastHigh1 setFrame:tframe];
    [_forecastHigh1 setOpacity:OPACITY];
    [self addControl:_forecastHigh1];
    

    
    
    
    BRTextControl *low=[[BRTextControl alloc]init];
    [low setText:@"Low:" withAttributes:[[BRThemeInfo sharedTheme]metadataTitleAttributes]];
    CGRect lowFrame;
    lowFrame.origin=nframe.origin;
    lowFrame.size=[low preferredFrameSize];
    lowFrame.origin.x+=masterFrame.size.width*0.16;
    lowFrame.origin.y-=[low preferredFrameSize].height;
    [low setOpacity:OPACITY];
    [low setFrame:lowFrame];
    [self addControl:low];
    [low release];
    
    _weatherImage1=[[BRImageControl alloc]init];
    image=[self imageForCode:@"3200"];
    [_weatherImage1 setImage:image];
    imgFrame.size.height=(underForcast.y-masterFrame.size.height*0.5)*0.95;
    imgFrame.size.width=imgFrame.size.height*[image aspectRatio];
    imgFrame.origin.x=lowFrame.origin.x+masterFrame.size.width*0.1;
    imgFrame.origin.y=masterFrame.size.height*0.54;//lowFrame.origin.y-lowFrame.size.height;
    [_weatherImage1 setFrame:imgFrame];
    [_weatherImage1 setOpacity:OPACITY];
    [self addControl:_weatherImage1];
    //NSLog(@"weather image1: %lf, %lf, %lf, %lf",imgFrame.size.height,imgFrame.size.width,imgFrame.origin.x,imgFrame.origin.y);

    
//    tframe= highFrame;
    tframe.origin.y-=[high preferredFrameSize].height;
    _forecastLow1=[[BRTextControl alloc]init];
    [_forecastLow1 setText:@"???                     "
             withAttributes:[[BRThemeInfo sharedTheme]metadataTitleAttributes]];
    tframe.size=[_forecastLow1 preferredFrameSize];
    [_forecastLow1 setFrame:tframe];
    [_forecastLow1 setOpacity:OPACITY];
    [self addControl:_forecastLow1];
    
    ctrl3 = [[BRDividerControl alloc]init];
    [ctrl3 setLineThickness:1];
    [ctrl3 setBrightness:1.0f];
    [ctrl3 setOpacity:OPACITY];
    CGRect dframe=nframe;
    dframe.origin.x=masterFrame.size.height*0.2;
    dframe.origin.y=masterFrame.size.width*0.24;
    dframe.size.width=masterFrame.size.width*0.2;
    dframe.size.height=masterFrame.size.height*0.5;
    [ctrl3 setDividerOrientation:3];
    [ctrl3 setDividerHeightStyle:3];
    [ctrl3 setFrame:dframe];
    [self addControl:ctrl3];
    
    _forecastDate2 = [[BRTextControl alloc]init];
    [_forecastDate2 setText:@"???                            " withAttributes:[[BRThemeInfo sharedTheme]metadataTitleAttributes]];
    //nframe.origin.y=//nframe.origin.y-[_forecastDate2 preferredFrameSize].height*1.1f;
    nframe.origin.x=pt_five.x+masterFrame.size.width*0.45;
    nframe.origin.y=pt_five.y;
    nframe.size=[_forecastDate2 preferredFrameSize];
    [_forecastDate2 setOpacity:OPACITY];
    [_forecastDate2 setFrame:nframe];
    [self addControl:_forecastDate2];
    
    

    
    

    high=[[BRTextControl alloc]init];
    [high setText:@"High:" withAttributes:[[BRThemeInfo sharedTheme]metadataTitleAttributes]];
//    CGRect highFrame;
    highFrame.origin=nframe.origin;
    highFrame.size=[high preferredFrameSize];
    highFrame.origin.x+=masterFrame.size.width*0.16;
    [high setOpacity:OPACITY];
    [high setFrame:highFrame];
    [self addControl:high];
    [high release];
    
    tframe= highFrame;
    tframe.origin.x+=[high preferredFrameSize].width*1.1f;
    _forecastHigh2=[[BRTextControl alloc]init];
    [_forecastHigh2 setText:@"???                     "//[NSString stringWithFormat:@"%@°%@",[forecast2 objectForKey:@"high"],[_infoDict objectForKey:@"temperature"],nil]
             withAttributes:[[BRThemeInfo sharedTheme]metadataTitleAttributes]];
    tframe.size=[_forecastHigh2 preferredFrameSize];
    [_forecastHigh2 setFrame:tframe];
    [_forecastHigh2 setOpacity:OPACITY];
    [self addControl:_forecastHigh2];
    
    
    low=[[BRTextControl alloc]init];
    [low setText:@"Low:" withAttributes:[[BRThemeInfo sharedTheme]metadataTitleAttributes]];
//    CGRect lowFrame;
    lowFrame.origin=nframe.origin;
    lowFrame.size=[low preferredFrameSize];
    lowFrame.origin.x+=masterFrame.size.width*0.16;
    lowFrame.origin.y-=[low preferredFrameSize].height;
    [low setOpacity:OPACITY];
    [low setFrame:lowFrame];
    [self addControl:low];
    [low release];
    
    _weatherImage2=[[BRImageControl alloc]init];

    image=[self imageForCode:[forecast1 objectForKey:@"code"]];
    [_weatherImage2 setImage:image];
    imgFrame.size.height=(underForcast.y-masterFrame.size.height*0.5)*0.95;
    imgFrame.size.width=imgFrame.size.height*[image aspectRatio];
    imgFrame.origin.x=lowFrame.origin.x+masterFrame.size.width*0.1;
    imgFrame.origin.y=masterFrame.size.height*0.54;
    [_weatherImage2 setFrame:imgFrame];
    [_weatherImage2 setOpacity:OPACITY];
    [self addControl:_weatherImage2];
    
//    tframe= highFrame;
    tframe.origin.y-=[high preferredFrameSize].height;
    _forecastLow2=[[BRTextControl alloc]init];
    [_forecastLow2 setText:@"???                     "//[NSString stringWithFormat:@"%@°%@",[forecast2 objectForKey:@"low"],[_infoDict objectForKey:@"temperature"],nil]
            withAttributes:[[BRThemeInfo sharedTheme]metadataTitleAttributes]];
    tframe.size=[_forecastLow2 preferredFrameSize];
    [_forecastLow2 setFrame:tframe];
    [_forecastLow2 setOpacity:OPACITY];
    [self addControl:_forecastLow2];
    

    
    
    
    
}
-(void)drawControlsN;
{

    
    /*
     *      Adding City Name
     */
    CGRect oldFrame=[_city frame];
    [_city removeFromParent];
    [_city setText:[_infoDict objectForKey:@"city"] withAttributes:[[BRThemeInfo sharedTheme] menuTitleTextAttributes]];
//    oldFrame.size = [_city preferredFrameSize];
    [_city setFrame:oldFrame];
    [self addControl:_city];
    
    /*
     *      Adding Region and Country Subtitle
     */
    NSString *text;
    if ([[_infoDict objectForKey:@"region"]length]>0) {
        text=[NSString stringWithFormat:@"%@, %@",[_infoDict objectForKey:@"region"],[_infoDict objectForKey:@"country"]];
    }
    else {
        text=[_infoDict objectForKey:@"country"];
    }
    oldFrame=[_region_country frame];
    [_region_country removeFromParent];
    [_region_country setText:text withAttributes:[[BRThemeInfo sharedTheme] labelTextAttributes]];
//    oldFrame.size=[_region_country preferredFrameSize];
    [_region_country setFrame:oldFrame];
    [self addControl:_region_country];
    
    
    
    oldFrame=[_centerImage frame];
    [_centerImage removeFromParent];
    BRImage *image=[self imageForCode:[_infoDict objectForKey:@"code"]forForecast:NO];
    [_centerImage setImage:image];
    [_centerImage setFrame:oldFrame];
    [self addControl:_centerImage];
    
    
    /*
     *  Adding Temperature
     */
    
    [_temperature removeFromParent];
    oldFrame=[_temperature frame];
    [_temperature setText:[NSString stringWithFormat:@"%@°%@",[_infoDict objectForKey:@"temp"],[_infoDict objectForKey:@"temperature"],nil]
           withAttributes:[[BRThemeInfo sharedTheme] menuTitleTextAttributes]];
//    oldFrame.origin.x=imgFrame.origin.x-[_temperature preferredFrameSize].width*1.3;
//    oldFrame.size=[_temperature preferredFrameSize];
    [_temperature setOpacity:OPACITY];
    [_temperature setFrame:oldFrame];
    [self addControl:_temperature];
    
    /*
     *  Adding Date
     */
    oldFrame=[_date frame];
    [_date removeFromParent];
    //[_date release];
    
    //_date=[[BRTextControl alloc]init];
//    NSArray *timeZoneNames = [NSTimeZone knownTimeZoneNames];
//    NSLog(@"timezones: %@",timeZoneNames);
    NSDate *rdate = [self parseDate:[_infoDict objectForKey:@"date"]];
    [_date setText:[rdate descriptionWithCalendarFormat:@"%I:%M %p, %d-%m-%Y" timeZone:_timezone locale:nil]
    withAttributes:[[BRThemeInfo sharedTheme] menuTitleTextAttributes]];
    //oldFrame.size=[_date preferredFrameSize];
    [_date setFrame:oldFrame];
    [self addControl:_date];
    
    
    oldFrame=[_sunrise frame];
    [_sunrise removeFromParent];
    [_sunrise setText:[_infoDict objectForKey:@"sunrise"] withAttributes:[[BRThemeInfo sharedTheme]metadataTitleAttributes]];
    //oldFrame.size=[_sunrise preferredFrameSize];
    [_sunrise setFrame:oldFrame];
    [self addControl:_sunrise];
    
    oldFrame=[_sunset frame];
    [_sunset removeFromParent];
    [_sunset setText:[_infoDict objectForKey:@"sunset"] withAttributes:[[BRThemeInfo sharedTheme]metadataTitleAttributes]];
    //oldFrame.size=[_sunset preferredFrameSize];
    [_sunset setFrame:oldFrame];
    [self addControl:_sunset];
    
    
    oldFrame=[_windDirection frame];
    [_windDirection removeFromParent];
    [_windDirection setText:[NSString stringWithFormat:@"%@°",[_infoDict objectForKey:@"direction"],nil] 
             withAttributes:[[BRThemeInfo sharedTheme]metadataTitleAttributes]];
    //oldFrame.size=[_windDirection preferredFrameSize];
    [_windDirection setFrame:oldFrame];
    [self addControl:_windDirection];
    
    
    oldFrame=[_windSpeed frame];
    [_windSpeed removeFromParent];
    [_windSpeed setText:[NSString stringWithFormat:@"%@%@",[_infoDict objectForKey:@"speed"],[_infoDict objectForKey:@"speedU"],nil]
         withAttributes:[[BRThemeInfo sharedTheme]metadataTitleAttributes]];
    //oldFrame.size=[_windSpeed preferredFrameSize];
    [_windSpeed setFrame:oldFrame];
    [self addControl:_windSpeed];
    
    

    oldFrame=[_windChill frame];
    [_windChill removeFromParent];
    [_windChill setText:[NSString stringWithFormat:@"%@°%@",[_infoDict objectForKey:@"chill"],[_infoDict objectForKey:@"temperature"],nil]
         withAttributes:[[BRThemeInfo sharedTheme]metadataTitleAttributes]];
    //oldFrame.size=[_windChill preferredFrameSize];
    [_windChill setFrame:oldFrame];
    [self addControl:_windChill];
    
    

    
    oldFrame=[_humidity frame];
    [_humidity removeFromParent];
    [_humidity setText:[NSString stringWithFormat:@"%@%",[_infoDict objectForKey:@"humidity"],nil] 
        withAttributes:[[BRThemeInfo sharedTheme]metadataTitleAttributes]];
    //oldFrame.size=[_humidity preferredFrameSize];
    [_humidity setFrame:oldFrame];
    [self addControl:_humidity];    
    

    oldFrame=[_pressure frame];
    [_pressure removeFromParent];
    [_pressure setText:[NSString stringWithFormat:@"%@%@",[_infoDict objectForKey:@"pressure"],[_infoDict objectForKey:@"pressureU"],nil]
        withAttributes:[[BRThemeInfo sharedTheme]metadataTitleAttributes]];
    //oldFrame.size=[_pressure preferredFrameSize];
    [_pressure setFrame:oldFrame];
    [self addControl:_pressure];
    

    
    NSDictionary *forecast1=[[_infoDict objectForKey:@"forecast"] objectAtIndex:0];
    NSDictionary *forecast2=[[_infoDict objectForKey:@"forecast"] objectAtIndex:1];
    oldFrame=[_forecastDate1 frame];
    [_forecastDate1 removeFromParent];
    [_forecastDate1 setText:[NSString stringWithFormat:@"%@, %@",[forecast1 objectForKey:@"day"],[forecast1 objectForKey:@"date"],nil] 
             withAttributes:[[BRThemeInfo sharedTheme]metadataTitleAttributes]];
    //oldFrame.size=[_forecastDate1 preferredFrameSize];
    [_forecastDate1 setFrame:oldFrame];
    [self addControl:_forecastDate1];
    

    oldFrame=[_forecastHigh1 frame];
    [_forecastHigh1 removeFromParent];
    [_forecastHigh1 setText:[NSString stringWithFormat:@"%@°%@",[forecast1 objectForKey:@"high"],[_infoDict objectForKey:@"temperature"],nil]
             withAttributes:[[BRThemeInfo sharedTheme]metadataTitleAttributes]];
    //oldFrame.size=[_forecastHigh1 preferredFrameSize];
    [_forecastHigh1 setFrame:oldFrame];
    [self addControl:_forecastHigh1];
    
    

    oldFrame=[_forecastLow1 frame];
    [_forecastLow1 setText:[NSString stringWithFormat:@"%@°%@",[forecast1 objectForKey:@"low"],[_infoDict objectForKey:@"temperature"],nil]
            withAttributes:[[BRThemeInfo sharedTheme]metadataTitleAttributes]];
    //oldFrame.size=[_forecastLow1 preferredFrameSize];
    [_forecastLow1 setFrame:oldFrame];
    [self addControl:_forecastLow1];
    

    
    oldFrame=[_forecastDate2 frame];
    [_forecastDate2 removeFromParent];
    [_forecastDate2 setText:[NSString stringWithFormat:@"%@, %@",[forecast2 objectForKey:@"day"],[forecast2 objectForKey:@"date"],nil] withAttributes:[[BRThemeInfo sharedTheme]metadataTitleAttributes]];
    //oldFrame.size=[_forecastDate2 preferredFrameSize];
    [_forecastDate2 setFrame:oldFrame];
    [self addControl:_forecastDate2];
    
    
    
    

    oldFrame=[_forecastHigh2 frame];
    [_forecastHigh2 removeFromParent];
    [_forecastHigh2 setText:[NSString stringWithFormat:@"%@°%@",[forecast2 objectForKey:@"high"],[_infoDict objectForKey:@"temperature"],nil]
             withAttributes:[[BRThemeInfo sharedTheme]metadataTitleAttributes]];
    //oldFrame.size=[_forecastHigh2 preferredFrameSize];
    [_forecastHigh2 setFrame:oldFrame];
    [self addControl:_forecastHigh2];
    
    

    oldFrame=[_forecastLow2 frame];
    [_forecastLow2 removeFromParent];
    [_forecastLow2 setText:[NSString stringWithFormat:@"%@°%@",[forecast2 objectForKey:@"low"],[_infoDict objectForKey:@"temperature"],nil]
            withAttributes:[[BRThemeInfo sharedTheme]metadataTitleAttributes]];
    //oldFrame.size=[_forecastLow2 preferredFrameSize];
    [_forecastLow2 setFrame:oldFrame];
    [self addControl:_forecastLow2];
    
    [_weatherImage1 removeFromParent];
    image=[self imageForCode:[forecast1 objectForKey:@"code"]forForecast:YES];
    [_weatherImage1 setImage:image];
//    imgFrame.size.height=underForcast.y-masterFrame.size.height*0.5;
//    imgFrame.size.width=imgFrame.size.height*[image aspectRatio];
//    imgFrame.origin.x=lowFrame.origin.x+masterFrame.size.width*0.1;
//    imgFrame.origin.y=masterFrame.size.height*0.54;//lowFrame.origin.y-lowFrame.size.height;
//    [_weatherImage1 setFrame:imgFrame];
//    [_weatherImage1 setOpacity:OPACITY];
    [self addControl:_weatherImage1];
    
    [_weatherImage2 removeFromParent];
    image=[self imageForCode:[forecast2 objectForKey:@"code"]forForecast:YES];
    [_weatherImage2 setImage:image];
//    imgFrame.size.height=underForcast.y-masterFrame.size.height*0.5;
//    imgFrame.size.width=imgFrame.size.height*[image aspectRatio];
//    imgFrame.origin.x=lowFrame.origin.x+masterFrame.size.width*0.1;
//    imgFrame.origin.y=masterFrame.size.height*0.54;
//    [_weatherImage2 setFrame:imgFrame];
//    [_weatherImage2 setOpacity:OPACITY];
    [self addControl:_weatherImage2];
    
    
    
    
    
    
}
-(void)setTimeZones:(NSString *)tz
{
    if (_timezone!=nil) {
        [_timezone release];
        _timezone=nil;
    }
    if (tz==nil) {
        return;
    }
    //NSLog(@"tz in control: %@",[NSTimeZone timeZoneWithName:tz]);
    NSLog(@"time zone: %@",tz);
    _timezone=[NSTimeZone timeZoneWithName:tz];
    [_timezone retain];
}
-(void)loadUsDictionaryForCode:(NSNumber *)code
{
    NSAutoreleasePool *newpool = [[NSAutoreleasePool alloc] init];
    NSDictionary *dict=[self loadDictionaryForCode:[code intValue] usUnits:YES];
    [self performSelectorOnMainThread:@selector(setInfoDictionary:) withObject:dict waitUntilDone:NO];
    [newpool drain];
}
-(void)loadEuDictionaryForCode:(NSNumber *)code
{
    NSAutoreleasePool *newpool = [[NSAutoreleasePool alloc] init];
    
    NSDictionary *dict=[self loadDictionaryForCode:[code intValue] usUnits:NO];
    [self performSelectorOnMainThread:@selector(setInfoDictionary:) withObject:dict waitUntilDone:NO];
    [newpool drain];
}
-(NSDictionary *)loadDictionaryForCode:(int)code usUnits:(BOOL)us
{
    NSURL *url;
    if (us) {
        url=[NSURL URLWithString:[NSString stringWithFormat:@"http://weather.yahooapis.com/forecastrss?w=%i",code,nil]];
        
    }
    else
        url=[NSURL URLWithString:[NSString stringWithFormat:@"http://weather.yahooapis.com/forecastrss?w=%i&u=c",code,nil]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
	NSURLResponse *response = nil;
    NSError *error;
	NSData *documentData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSXMLDocument *doc;
    if (error!=nil) {
        NSLog(@"error: %@",error);
        return [NSDictionary dictionary];
    }
    else {
        NSStringEncoding responseEncoding = CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding((CFStringRef)[response textEncodingName]));
        NSString *documentString = [[NSString alloc] initWithData:documentData encoding:responseEncoding];
        doc=[[NSXMLDocument alloc]initWithXMLString:documentString options:NSXMLDocumentTidyXML error:nil];
        
    }
    NSDictionary *dict = [SMYahooWeather parseYahooRSS:doc];
    [doc release];
    return dict;
    
}

-(NSTimeZone *)timeZone
{
    return _timezone;
}

-(void)reload
{
    int code = [SMWeatherController yWeatherCode];
    


    DLog(@"time: %@",[NSDate date]);
    if ([SMWeatherController USUnitsForCode:code]) {
        [NSThread detachNewThreadSelector:@selector(loadUsDictionaryForCode:) toTarget:self withObject:[NSNumber numberWithInt:code]];
    }
    else {
        [NSThread detachNewThreadSelector:@selector(loadEuDictionaryForCode:) toTarget:self withObject:[NSNumber numberWithInt:code]];
    }

    

//    NSDictionary *dict=[SMWeatherMext loadDictionaryForCode:code usUnits:[SMWeatherController USUnitsForCode:code]];
    
//    [self setTimeZones:[SMWeatherController tzForCode:code]];
//    //NSLog(@"after setting tz");
//    if (dict==nil) 
//        dict=[NSDictionary dictionary];
//    
//    [self setInfoDictionary:dict];
//    
}
-(void)setInfoDictionary:(NSDictionary *)infoDict
{
    DLog(@"time2: %@",[NSDate date]);
    [self setTimeZones:[SMWeatherController tzForCode:[SMWeatherController yWeatherCode]]];
    if (infoDict==nil) 
        infoDict=[NSDictionary dictionary];
    
    [_infoDict release];
    _infoDict=[infoDict retain];
    [self checkInfoDict];
    if(_firstLoad)
    {
        [self drawControls];
        [self drawControlsN];
        _firstLoad=NO;
    }
    else {
        [self drawControlsN];
    }

}
-(BRImage *)imageForCode:(NSString *)code
{
    return [self imageForCode:code forForecast:YES];
}
-(BRImage *)imageForCode:(NSString *)code forForecast:(BOOL)forecast
{
    if ([code intValue]<0 || [code intValue]>49) {
        return bundleImag(@"3200",@"png");
    }
    if ([code isEqualToString:@"3200"]) {
        return bundleImag(@"3200",@"png");
    }
    if (forecast) {
        code=[code stringByAppendingString:@"d"];
    }
    else {
        int sunrise=[self convertTimeToInt:[_infoDict objectForKey:@"sunrise"]];
        int sunset=[self convertTimeToInt:[_infoDict objectForKey:@"sunset"]];
        //NSLog(@"known time zones: %@",[NSTimeZone knownTimeZoneNames]);
        int current=[[[NSDate date] descriptionWithCalendarFormat:@"%H%M" timeZone:_timezone locale:nil]intValue];
        NSLog(@"date: %@ ,sunrise %i, current %i, sunset %i",[NSDate date], sunrise,current,sunset);
        if (current>=sunrise && current<sunset) {
            code=[code stringByAppendingString:@"d"];
        }
        else {
            code=[code stringByAppendingString:@"n"];
        }

    }
//    NSLog(@"imageCode: %@",code);
    NSString *path = bundleResc(code,@"png");
//    NSLog(@"path: %@",path);
    if (path!=nil) {
        return [BRImage imageWithPath:path];
    }
    else
        return bundleImag(@"3200",@"png");
    
}
-(int)convertTimeToInt:(NSString *)time
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"hh:mm a"]; 
    NSDate *rdate=[formatter dateFromString:time];
    //NSLog(@"date: %@, %@, %@",time, rdate, [rdate descriptionWithCalendarFormat:@"%H%M" timeZone:_timezone locale:nil]);
    return [[rdate descriptionWithCalendarFormat:@"%H%M" timeZone:nil locale:nil]intValue];
}
-(NSDate*)parseDate:(NSString *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"EEE, dd MMM yyyy hh:mm a zzz"];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateStyle:NSDateFormatterFullStyle];
    [fmt setTimeStyle:NSDateFormatterFullStyle];
    //NSDate *rdate2= [fmt dateFromString:date];
    NSDate *rdate = [formatter dateFromString:date];
    return rdate;
}
-(void)checkInfoDict
{
    NSArray *expectedKeys = [NSArray arrayWithObjects:@"chill",@"city",@"code",@"country",@"date",@"direction",
                             @"distance",@"humidity",@"pressure",@"region",@"rising",@"speed",@"speedU",
                             @"sunrise",@"sunset",@"temp",@"temperature",@"text",@"visibility",nil];
    NSMutableDictionary *dict=[_infoDict mutableCopy];
    NSArray *keys =[dict allKeys];
    int i,count=[expectedKeys count];
    for(i=0;i<count;i++)
    {
        if(![keys containsObject:[expectedKeys objectAtIndex:i]])
        {
            [dict setObject:@"N/A                          ." forKey:[expectedKeys objectAtIndex:i]];
        }
    }
    if(![keys containsObject:@"forecast"])
    {
        NSDictionary *forecast = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"3201",@"code",
                                  @"N/A                      .",@"date",
                                  @"N/A.",@"day",
                                  @"N/A     .",@"high",
                                  @"N/A     .",@"low",
                                  @"N/A             .",@"text",nil];
        [dict setObject:[NSArray arrayWithObjects:forecast,forecast,nil] forKey:@"forecast"];
    }
    [_infoDict release];
    _infoDict=[dict retain];
}
@end
