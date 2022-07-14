import UIKit

class ViewController: UIViewController {
    
    //MARK: - Properties
    
    var isBlack: Bool = false {
        didSet { self.view.backgroundColor = isBlack ? .black : .white }
    }
    
    var password = ""
    
    let queue = DispatchQueue(label: "brutePassword", qos: .userInitiated)
    
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
        createBrute()
        if password.isEmpty {
            unlockPassword = generatePassword()
            passwordTextField.text = unlockPassword
        } else {
            unlockPassword = password
        }
        let bruteForcing = DispatchWorkItem {
            self.bruteForce(passwordToUnlock: unlockPassword)
        }
        queue.async(execute: bruteForcing)
    }
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(changeColorButton)
        view.addSubview(generatePasswordButton)
        view.addSubview(labelText)
        view.addSubview(passwordTextField)
        view.addSubview(activityIndicator)
        view.backgroundColor = .white
        
        configure()
    }
    
//MARK: - Methods
    
    func createBrute() {
        password = ""
        passwordTextField.isSecureTextEntry = true
        self.generatePasswordButton.isEnabled = false
        activityIndicator.startAnimating()
    }
    
    func generatePassword() -> String {
        let characters = String().printable.map { String($0)}
        
        for _ in 0..<3 {
            password += characters.randomElement() ?? ""
        }
        return password
    }
    
    func bruteForce(passwordToUnlock: String) {
        
        let ALLOWED_CHARACTERS: [String] = String().printable.map { String($0) }
        
        var password: String = ""
        
        while password != passwordToUnlock {
            password = generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)
        }
        
        DispatchQueue.main.async {
            passwordTextField.isSecureTextEntry = false
            labelText.text = password
            activityIndicator.stopAnimating()
            self.generatePasswordButton.isEnabled = true
            
            print(password)
        }
        print(password)
    }
    
//MARK: - Constraints
    
    func configure() {
        
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
