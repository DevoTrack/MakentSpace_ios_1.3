/**
 * MKMapView+ZoomLevel.h
 *
 * @package Makent
 * @subpackage Controller
 * @category Calendar
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */


#import <MapKit/MapKit.h>

@interface MKMapView (ZoomLevel)

- (void)setCenter : (CLLocationCoordinate2D)centerCoordinate zoomLevel:(NSUInteger)zoomLevel animated:(BOOL)animated;

@end
