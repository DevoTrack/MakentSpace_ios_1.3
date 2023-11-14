/**
 * MLImagePickerAssetsManger.swift
 *
 * @package Makent
 * @subpackage Controller
 * @category Calendar
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */



import UIKit
import PhotosUI

class MLImagePickerAssetsManger: PHCachingImageManager {
    
    private var fetchResult:PHFetchResult<PHAsset>!
    
    func result()->PHFetchResult<PHAsset>{
        if self.fetchResult != nil {
            return self.fetchResult
        }
        self.stopCachingImagesForAllAssets()
        
        let options:PHFetchOptions = PHFetchOptions()
        options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)

        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        self.fetchResult = PHAsset.fetchAssets(with: options)
        
        return self.fetchResult
        
    }
}
