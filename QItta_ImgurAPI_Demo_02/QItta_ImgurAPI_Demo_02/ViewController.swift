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
    
    // TODO: もうちょっと整合性を加味してEnableの制御はできそう
    func updateUI() {
        accessTokenLabel.stringValue  = ImgurAPI.OAuthInfo.accessToken
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
    
    // ユーザ認証
    func authorizeInBrowser() {
        imgurClient = ImgurClient(httpClient: URLSession.shared)
        imgurClient?.callbackURLCompletion = updateUI  // UIに反映させるために実装しているだけで本来は必要なしです。
        let userAuthenticationRequest = ImgurAPI.UserAuthenticationRequest()
        imgurClient?.openAuthorizePageInBrowser(request: userAuthenticationRequest)
    }
    
    // アクセストークンの更新
    func updateAccessToken() {
        // APIクライアントの作成
        let client = ImgurClient(httpClient: URLSession.shared)
        
        // Requestの発行
        let request = ImgurAPI.GeneratingAccessTokenRequest()
        
        // リクエストの送信
        client.send(request: request) { result in
            switch result {
            case .success(let response):
                ImgurAPI.OAuthInfo.update(for: response)
                print("アクセストークンの更新に成功")
            case .failure(let error):
                print("アクセストークンの更新に失敗")
                print(error)
            }
            
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }
    
    // 画像のアップロード
    func uploadImage() {
        // APIクライアントの作成
        let client = ImgurClient(httpClient: URLSession.shared)
        
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false // 複数ファイルの選択を許すか
        openPanel.canChooseDirectories    = false // ディレクトリを選択できるか
        openPanel.canCreateDirectories    = false // ディレクトリを作成できるか
        openPanel.canChooseFiles          = true // ファイルを選択できるか
        openPanel.allowedFileTypes        = NSImage.imageTypes // 選択できるファイル種別
        
        openPanel.begin { (response) in
            if response == NSApplication.ModalResponse.OK {
                
                guard let url = openPanel.url else {
                    return
                }
                
                guard let imageData  = NSData(contentsOf: url) else {
                    return
                }
                
                let base64 = imageData.base64EncodedString()
                let request = ImgurAPI.UploadingImageRequest(imageInBase64String: base64, needAuthentication: true)  // Requestの発行
                
                // リクエストの送信
                self.isProgressing = true
                self.updateUI()
                
                client.send(request: request) { result in
                    self.isProgressing = false
                    switch result {
                    case .success(let response):
                        self.image = response.data
                        print("画像のアップロードに成功")
                        print(response)
                    case .failure(let error):
                        print("画像のアップロードに失敗")
                        print(error.localizedDescription)
                    }
                    
                    DispatchQueue.main.async {
                        self.updateUI()
                    }
                }
            }
        }
    }
    
    func deleteImage() {
        // APIクライアントの作成
        let client = ImgurClient(httpClient: URLSession.shared)
        
        guard let imageHash = image?.deletehash else {
            return
        }
        let request = ImgurAPI.DeletingImageRequest.init(imageHash: imageHash , needAuthentication: true)
        
        // リクエストの送信
        isProgressing = true
        updateUI()
        client.send(request: request) { result in
            self.isProgressing = false
            switch result {
            case .success(let response):
                if response.data {
                    print("画像の削除に成功")
                    self.image = nil
                } else {
                    print("画像の削除に失敗")
                }
            case .failure(let error):
                print("画像の削除に失敗")
                print(error.localizedDescription)
            }
            
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction func authorizeButtonClicked(_ sender: Any) {
        authorizeInBrowser()
    }
    
    @IBAction func updateAccessTokenButtonClicked(_ sender: Any) {
        updateAccessToken()
    }
    
    @IBAction func uploadImageButtonClicked(_ sender: Any) {
        uploadImage()
    }
    
    @IBAction func deleteImageButtonClicked(_ sender: Any) {
        deleteImage()
    }
    
    @IBAction func resetOAuthInfoButtonClicked(_ sender: Any) {
        ImgurAPI.OAuthInfo.resetUserDefault()
        updateUI()
    }
}
