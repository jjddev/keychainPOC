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

    
    let stackButton: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
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
}

extension HomeView: ViewCodingProtocol {
    func buildViewHierarchy() {
        stackButton.addArrangedSubview(createButton)
        stackButton.addArrangedSubview(loginButton)
        addSubview(stackButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            stackButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            stackButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            createButton.heightAnchor.constraint(equalToConstant: 44),
            loginButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    func configurationViews() {
        backgroundColor = .systemBackground
    }
}
