import UIKit

class ViewController: UIViewController {
    
    //MARK: - Properties
    
    var bruteForce = BruteForce()
    
    var isBlack: Bool = false {
        didSet { self.view.backgroundColor = isBlack ? .black : .white }
    }
    
    let queue = DispatchQueue(label: "brutePassword", qos: .userInitiated)
    
    var labelText: UILabel = {
        let label = UILabel()
        label.text = "Password"
        label.textAlignment = .center
        label.backgroundColor = .white
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var passwordTextField: UITextField = {
        let text = UITextField()
        text.isSecureTextEntry = true
        text.layer.cornerRadius = 15.0
        text.layer.borderWidth = 2.0
        text.layer.borderColor = UIColor.systemBlue.cgColor
        text.backgroundColor = .white
        text.textColor = .black
        text.textAlignment = .center
        text.placeholder = "Password"
        text.font = UIFont.systemFont(ofSize: 15)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .systemRed
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    lazy var changeColorButton: UIButton = {
        let button = UIButton()
        button.setTitle("Change Color", for: .normal)
        button.titleLabel?.numberOfLines = 2
        button.backgroundColor = .systemGray3
        button.layer.cornerRadius = 15
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(buttonChangeColor), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var generatePasswordButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.numberOfLines = 2
        button.setTitle("Generate Password", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.backgroundColor = .systemGray3
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(buttonPassword), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Actions
    
    @objc func buttonChangeColor() {
        isBlack.toggle()
    }
    
    @objc func buttonPassword() {
        let password = passwordTextField.text ?? ""
        let unlockPassword: String
        bruteForcePrepare()
        
        if password.isEmpty {
            unlockPassword = self.bruteForce.generatePassword()
            self.passwordTextField.text = unlockPassword
        } else {
            unlockPassword = password
        }
        
        let bruteForcing = DispatchWorkItem {
            self.bruteForce.bruteForce(passwordToUnlock: unlockPassword)
        }
        queue.async(execute: bruteForcing)
    }
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupHierarchy()
        setupLayout()
        
        bruteForce.delegate = self
    }
    
    //MARK: - Methods
    
    func bruteForcePrepare() {
        bruteForce.password = ""
        self.passwordTextField.isSecureTextEntry = true
        self.generatePasswordButton.isEnabled = false
        self.activityIndicator.startAnimating()
    }
    
    //MARK: - Constraints
    
    func setupHierarchy() {
        view.addSubview(generatePasswordButton)
        view.addSubview(changeColorButton)
        view.addSubview(labelText)
        view.addSubview(passwordTextField)
        view.addSubview(activityIndicator)
    }
    
    func setupLayout() {
        
        NSLayoutConstraint.activate([
            changeColorButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            changeColorButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -80),
            changeColorButton.widthAnchor.constraint(equalToConstant: 100),
            
            generatePasswordButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            generatePasswordButton.centerXAnchor.constraint(equalTo: changeColorButton.centerXAnchor, constant: 180),
            generatePasswordButton.widthAnchor.constraint(equalToConstant: 100),
            
            labelText.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200),
            labelText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            passwordTextField.centerYAnchor.constraint(equalTo: labelText.centerYAnchor, constant: 80),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.widthAnchor.constraint(equalToConstant: 100),
            
            activityIndicator.centerYAnchor.constraint(equalTo: labelText.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: labelText.centerXAnchor, constant: -50)
        ])
    }
}

//MARK: - Extension

extension ViewController: UpdateInterface {
    
    func updateInterface() {
        DispatchQueue.main.async {
            self.passwordTextField.isSecureTextEntry = false
            self.labelText.text = self.bruteForce.password
            self.activityIndicator.stopAnimating()
            self.generatePasswordButton.isEnabled = true
            
            print(self.bruteForce.password)
        }
    }
}
