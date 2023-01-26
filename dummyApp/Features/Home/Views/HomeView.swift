import UIKit

final class HomeView: UIView {
    
    let createButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Criar chave", for: .normal)
        button.backgroundColor = .blue
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        button.addTarget(self, action: #selector(showCreateKey), for: .touchUpInside)
        return button
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .blue
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        button.addTarget(self, action: #selector(showLogin), for: .touchUpInside)
        return button
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Apagar todas as chaves", for: .normal)
        button.backgroundColor = .red
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        button.addTarget(self, action: #selector(deleteAllItems), for: .touchUpInside)
        return button
    }()

    
    let stackButton: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    let navigation: UINavigationController
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
        super.init(frame: .zero)
        setupViewConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeView {
    @objc
    func showCreateKey() {
        navigation.pushViewController(CreateAccountViewController(navigation: navigation), animated: true)
    }
    
    @objc
    func showLogin() {
        navigation.pushViewController(LoginViewController(navigation: navigation), animated: true)
    }
    
    @objc
    func deleteAllItems() {
        
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        if let error = KeychainHelper.deleteAll() {
            alertController.title = "Erro"
            alertController.message = error.localizedDescription
        } else {
            alertController.title = "Sucesso"
            alertController.message = "Todas as chaves foram apagadas"
        }
        
        navigation.topViewController?.present(alertController, animated: true)
    }
}

extension HomeView: ViewCodingProtocol {
    func buildViewHierarchy() {
        stackButton.addArrangedSubview(createButton)
        stackButton.addArrangedSubview(loginButton)
        stackButton.addArrangedSubview(deleteButton)
        addSubview(stackButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            stackButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
        
        let buttonHeight = CGFloat(48)
        NSLayoutConstraint.activate([
            createButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            loginButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            deleteButton.heightAnchor.constraint(equalToConstant: buttonHeight),
        ])
    }
    
    func configurationViews() {
        backgroundColor = .systemBackground
    }
}
