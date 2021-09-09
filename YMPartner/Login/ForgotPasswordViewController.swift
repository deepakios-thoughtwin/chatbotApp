//
//  ForgotPasswordViewController.swift
//  YMPartner
//
//  Created by Kauntey Suryawanshi on 27/04/21.
//

import UIKit
import WebKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController!.setNavigationBarHidden(false, animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let resetPasswordURL = "https://app.yellowmessenger.com/user/reset-password"
        let request = URLRequest(url: URL(string: resetPasswordURL)!)
        webView.load(request)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
