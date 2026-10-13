import 
import 
import 
// --- UIDevice Category ---
@interface UIDevice (IOS18Spoof)
- (NSString )spoofed_systemVersion;
@end
@implementation UIDevice (IOS18Spoof)
- (NSString )spoofed_systemVersion {
    return @"18.0";
}
@end
// --- NSProcessInfo Category ---
@interface NSProcessInfo (IOS18Spoof)
- (NSOperatingSystemVersion)spoofed_operatingSystemVersion;
- (NSString )spoofed_operatingSystemVersionString;
- (BOOL)spoofed_isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion)version;
@end
@implementation NSProcessInfo (IOS18Spoof)
- (NSOperatingSystemVersion)spoofed_operatingSystemVersion {
    NSOperatingSystemVersion version;
    version.majorVersion = 18;
    version.minorVersion = 0;
    version.patchVersion = 0;
    return version;
}
- (NSString )spoofed_operatingSystemVersionString {
    return @"Version 18.0 (Build 22A3354)";
}
- (BOOL)spoofed_isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion)version {
    return YES; // App က ဘယ် Version စစ်စစ် အမြဲတမ်း Pass ပေးခြင်း
}
@end
// --- Method Swizzling Helper ---
static void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    if (originalMethod && swizzledMethod) {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
// --- Dylib Load ဖြစ်ချိန်တွင် Run မည့် Constructor ---
__attribute__((constructor))
static void init(void) {
    @autoreleasepool {
        // Swizzle UIDevice
        Class deviceClass = [UIDevice class];
        swizzleMethod(deviceClass, @selector(systemVersion), @selector(spoofed_systemVersion));
        // Swizzle NSProcessInfo
        Class processInfoClass = [NSProcessInfo class];
        swizzleMethod(processInfoClass, @selector(operatingSystemVersion), @selector(spoofed_operatingSystemVersion));
        swizzleMethod(processInfoClass, @selector(operatingSystemVersionString), @selector(spoofed_operatingSystemVersionString));
        swizzleMethod(processInfoClass, @selector(isOperatingSystemAtLeastVersion:), @selector(spoofed_isOperatingSystemAtLeastVersion:));
    }
}
