//
//  ViewController.swift
//  SampleApp5
//
//  Created by 川満 翔 on 2017/12/13.
//  Copyright © 2017年 川満 翔. All rights reserved.
//

import UIKit
import TwitterKit
import SafariServices

class ViewController: UIViewController {

    /// Twitterにログインするボタン
    @IBOutlet weak var loginButton: TWTRLogInButton!
    
    /// タイムラインを表示するボタン
    @IBOutlet weak var showTimeLineButton: UIButton!
    
    /// 投稿画面を表示するボタン
    @IBOutlet weak var showComposerButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // ログインが終わった後やキャンセルされた時の処理
        loginButton.logInCompletion = { session, error in
            
            // ログインが失敗したかどうか確認する
            guard let session = session else {
                print("error: \(String(describing: error?.localizedDescription))");
                return
            }
            
            // ログイン成功したらここに来る
            print("signed in as \(session.userName)");
            
            // タイムラインボタンなんかを有効にします。
            self.loginState(isLogin: true)
        };
    
        // 一旦タイムラインボタンなんかを無効にします。
        loginState(isLogin: false);
    }
    
    /// ログイン状態によってボタンの有効無効を切り替える
    func loginState(isLogin:Bool) {
        showTimeLineButton.isEnabled = isLogin
        
        showComposerButton.isEnabled = isLogin
    }
    
    /// Twitterにログインしているか否か
    func isTwitterLogin() -> Bool {
        return false;
    }
    
    /// safariを開くボタン
    @IBAction func openSafari(_ sender: Any) {
        
        if let url = URL(string: "https://www.yahoo.co.jp/") {
            // 上記のURLでViewControllerを作成
            let safariVC = SFSafariViewController(url: url)
            // 画面遷移させる
            self.navigationController?.present(safariVC, animated: true, completion: nil)
        }
    }
    
    /// 投稿画面を開くボタン
    @IBAction func showComposer(_ sender: Any) {
        // 投稿画面
        let composer = TWTRComposer()
        
        // 投稿画面に表示するテキスト（送信テキスト）
        composer.setText("just setting up my Twitter Kit")
        
        // 投稿画面を表示
        composer.show(from: self.navigationController!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// 遷移先の画面に何かを渡したいときはこの関数を使用
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Story
        if segue.identifier == "PushTimeLine" {
            
            // 変数:遷移先ViewController型 = segue.destinationViewController as 遷移先ViewController型
            // segue.destinationViewController は遷移先のViewController
            if let secondViewController = segue.destination as? TWTRTimelineViewController {
                
                // 現在ログインしているユーザーIDを取得
                if let userId = TWTRTwitter.sharedInstance().sessionStore.session()?.userID {
                    
                    // userIDを元にAPIClientを作成
                    let client = TWTRAPIClient(userID: userId)
                    
                    // ユーザーのタイムライン表示用にスクリーンネームを指定する
                    secondViewController.dataSource = TWTRUserTimelineDataSource(screenName: "stevenhepting", apiClient: client)
                } else {
                    // 現在ログインしているユーザーIDが取得できない場合
                }
                
            } else {
                // 遷移先がTWTRTimelineViewControllerじゃなかった場合。
            }
        }
        
    }
}

