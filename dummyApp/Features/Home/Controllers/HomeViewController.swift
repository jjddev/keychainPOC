import UIKit
import Security

final class HomeViewController: UIViewController {
    
    var homeView: HomeView?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        homeView = HomeView(navigation: navigationController ?? UINavigationController())
        view = homeView
        title = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

