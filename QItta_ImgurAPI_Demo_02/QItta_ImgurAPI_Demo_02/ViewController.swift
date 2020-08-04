//
//  ViewController.swift
//  QItta_ImgurAPI_Demo_02
//
//  Created by HIROKI IKEUCHI on 2020/08/03.
//  Copyright © 2020 hikeuchi. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    @IBOutlet weak var uploadingImageButton: NSButton!
    @IBOutlet weak var deletingImageButton: NSButton!
    @IBOutlet weak var resettingOAuthInfoButton: NSButton!
    @IBOutlet weak var accessTokenLabel: NSTextField!
    @IBOutlet weak var refreshTokenLabel: NSTextField!
    @IBOutlet weak var imageURLLabel: NSTextField!
    
    var imgurClient: ImgurClient?  // CallBackURLを受け取るためにプロパティとして保持している
    var image: Image?  // アップロードしたメディア情報
    var isProgressing: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        ImgurAPI.OAuthInfo.resetUserDefault()
        updateUI()
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    // MARK: - Helper Methods
    func updateUI() {
        accessTokenLabel.stringValue = ImgurAPI.OAuthInfo.accessToken
        refreshTokenLabel.stringValue = ImgurAPI.OAuthInfo.refreshToken
        
        if isProgressing {
            progressIndicator.isHidden = false
            progressIndicator.startAnimation(nil)
            uploadingImageButton.isEnabled = false
        } else {
            progressIndicator.isHidden = true
            progressIndicator.stopAnimation(true)
            uploadingImageButton.isEnabled = true
        }
        
        if let image = image,
            let url = URL(string: image.link) {
            
            if let data = try? Data(contentsOf: url) {
                imageView.image = NSImage(data: data)
            }
            
            deletingImageButton.isEnabled = true
            imageURLLabel.stringValue = url.absoluteString
        } else {
            imageView.image = nil
            deletingImageButton.isEnabled = false
            imageURLLabel.stringValue = ""
        }
        
        if ImgurAPI.OAuthInfo.accessToken.count > 0 {
            resettingOAuthInfoButton.isEnabled = true
        } else {
            resettingOAuthInfoButton.isEnabled = false
        }
    }
    
    // MARK:- Imgur Methods
    
    
    // MARK: - Actions
    @IBAction func authorizeButtonClicked(_ sender: Any) {
       
    }
    
    @IBAction func updateAccessTokenButtonClicked(_ sender: Any) {
       
    }
    
    @IBAction func uploadImageButtonClicked(_ sender: Any) {
        
    }
    
    @IBAction func deleteImageButtonClicked(_ sender: Any) {
        
    }
}
