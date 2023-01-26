import UIKit

final class CreateAccountViewController: UIViewController {
    
    let mainView: CreateAccountView
    let navigation: UINavigationController
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
        mainView = CreateAccountView(navigation: navigation)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
        title = "Criar Chave"
        mainView.createAccountAction = setupCreateAccountAction()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setupCreateAccountAction() -> (() -> Void)? {
        
        let createAccountAction: (() -> Void)? = { [weak self]  in
            let query = KeychainHelper.buildFetchQuery(key: self?.mainView.keyTextField.text ?? "")
            
            if KeychainHelper.fetch(query: query) == nil {
                
                let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
                if let error = KeychainHelper.save(key: self?.mainView.keyTextField.text ?? "", value: self?.mainView.passwordTextField.text ?? "") {
                    print(">>error when trying save \(error)")
                    
                    alertController.title = "Erro ao salvar a chave"
                    alertController.message = error.localizedDescription
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self?.navigation.topViewController?.present(alertController, animated: true)
                }
                
                alertController.title = "Sucesso"
                alertController.message = "Chave criada com sucesso"
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self?.navigation.popViewController(animated: true)
                }))
                
                self?.navigation.topViewController?.present(alertController, animated: true)
            } else {
                let alertController = UIAlertController(title: "Erro", message: "Não foi possível criar essa chave pois ela já existe.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.navigation.topViewController?.present(alertController, animated: true)
            }
        }
        
        return createAccountAction
    }
}

