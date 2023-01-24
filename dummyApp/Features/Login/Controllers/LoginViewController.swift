import UIKit
import LocalAuthentication

final class LoginViewController: UIViewController {
    
    let mainView: LoginView
    let navigation: UINavigationController
    var biometryType: String = ""
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
        mainView = LoginView(navigation: navigation)
        super.init(nibName: nil, bundle: nil)
        checkForBiometric()
        validedBiometry()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
        title = "Login"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func checkForBiometric() {
        var error: NSError?
        let context = LAContext()
        let permissions = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        switch context.biometryType {
        case .none:
            biometryType = "Biometria não disponível"
        case .touchID:
            biometryType = "TouchID"
        case .faceID:
            biometryType = "FaceID"
        default:
            biometryType = "Deconhecido"
            
        }
        
        print("permission: \(permissions)")
        print("biometry: \(biometryType)")
        
        let message: String = permissions ? ">> \(biometryType) disponível" : ">> \(biometryType) não disponível ou bloqueado"
        setStatus(status: permissions, message: message)
    }
    
    func validedBiometry() {
        
        let loginAction: (() -> Void)? = { [weak self]  in
            
            let query = KeychainHelper.buildFetchQuery(key: self?.mainView.keyTextField.text ?? "")
            if let data = KeychainHelper.fetch(query: query) {
                self?.navigation.pushViewController(SecretViewController(user: data.0, password: data.1, biometryType: self?.biometryType ?? ""), animated: true)
            } else {
                self?.setStatus(status: false, message: ">>biometria falhou ou foi cancelada")
            }
        }
     
        mainView.loginAction = loginAction
    }
        
    func setStatus(status: Bool, message: String) {
        mainView.statusLabel.text = message
        mainView.statusLabel.textColor = status ? .green : .red
    }
    
}

