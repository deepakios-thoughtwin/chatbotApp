import UIKit
import YMSupport
import Combine

class LoginViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    var storage = Set<AnyCancellable>()

    var viewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        userNameTextField.textPublisher.assign(to: \.email, on: viewModel).store(in: &storage)
        passwordTextField.textPublisher.assign(to: \.password, on: viewModel).store(in: &storage)

        viewModel.loginResponse
            .receive(on: RunLoop.main)
            .sink { responseType in
                switch responseType {
                case .error(let error): self.showErrorAlert(error.localizedDescription)
                case .success:
                    self.showBotList()
                case .twoFA(let token):
                    self.show2FAView(token: token, email:  self.viewModel.email)
                }
            }
            .store(in: &storage)


        // Show Home when bot selection is complete
        defaults
            .publisher(for: \.selectedBotId, options: .new)
            .sink { _ in
                SceneDelegate.shared?.showMainView()
            }
            .store(in: &storage)

        navigationItem.title = "Login"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController!.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        userNameTextField.becomeFirstResponder()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) // keyboard dismiss when touched anywhere outside
    }

    @IBAction func actionSignIn(_ sender: UIButton) {
        guard !userNameTextField.text!.isEmpty || !passwordTextField.text!.isEmpty else {
            return
        }
        login()
    }

    private func login() {
        view.endEditing(true)
        showSpinner()
        viewModel.login()
    }

    private func showBotList() {
        let botVC = BotListViewController.makeFromStoryboard()
        self.navigationController?.pushViewController(botVC, animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    private func show2FAView(token: String, email: String) {
        let botVC = TwoFAViewController.makeFromStoryboard()
        botVC.viewModel = TwoFAViewModel(email: email, twoFAToken: token)

        self.navigationController?.pushViewController(botVC, animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === userNameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            login()
        }
        return true
    }
}
