//
//  SMApplianceInstallerController.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 11/19/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//

@class SMButtonControl,SMApplianceDictionary;
@interface SMApplianceInstallerController : BRController {
	//BRCoverArtPreviewControl *			_sourceImagel;
    int padding[32];
    BRImageControl *            _sourceImages;
    BRImageControl *            _trustedImage;
    BRImageControl *            _testedImage;
    BRTextControl *             _names;
    SMButtonControl *           _installButton;
    SMButtonControl *           _removeButton;
    SMButtonControl *           _backupButton;
    SMButtonControl *           _restoreButton;
    SMButtonControl *           _removeBackupButton;
    SMButtonControl *           _hideButton;
    BRGridControl   *           _trustedGrid;
    BRMediaShelfControl *       _shelfControl;
    id                          _licenseButton;
    id                          _infoButton;
    BRTextControl *             _author;
    SMApplianceDictionary *       _information;
    BOOL                        _forceDestination;
    BOOL                        _isHidden;
    NSURLDownload *             _downloader;
    NSString *                  _outputPath;
    NSString *                  _downloadURL;
    SMFProgressBarControl *      _progressBar;
    BRTextControl *             _statusText;
    long long               _totalLength;
    long long               _gotLength;
    int m_screen_saver_timeout;
    NSMutableArray *                   _gridNames;
	//BRImage		*				_theImage;
}
-(void)setupButtons;
//-(BOOL)frapUpToDate;
//-(BOOL)frapExists;
//-(BOOL)bakExists;
//-(NSString *)bakVersion;
//-(NSString *)installedVersion;
-(id)initWithDictionary:(SMApplianceDictionary *)dict;
-(void)addImage;
-(void)_handleSelectionWithCode:(NSString *)code;
-(void)_handleSelectionForShelf;
-(void)_install;
-(id)getProviderForGrid;
@end
