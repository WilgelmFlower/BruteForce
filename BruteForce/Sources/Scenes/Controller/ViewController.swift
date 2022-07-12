import UIKit

class ViewController: UIViewController {
    
    //MARK: - Properties
    
    var isBlack: Bool = false {
        didSet {
            if isBlack {
                self.view.backgroundColor = .black
            } else {
                self.view.backgroundColor = .white
            }
        }
    }
    
    lazy var password = ""
    
    let queue = DispatchQueue(label: "brutePassword", qos: .userInitiated)
    
    lazy var buttonFirst: UIButton = {
        let button = UIButton()
        button.setTitle("Change Color", for: .normal)
        button.titleLabel?.numberOfLines = 2
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var buttonSecond: UIButton = {
        let button = UIButton()
        button.titleLabel?.numberOfLines = 2
        button.setTitle("Generate Password", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(buttonPassword), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var labelText: UILabel = {
        let label = UILabel()
        label.text = "Password"
        label.textAlignment = .center
        label.backgroundColor = .systemMint
        label.layer.cornerRadius = 15
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var textField: UITextField = {
        let text = UITextField()
        text.isSecureTextEntry = true
        text.textAlignment = .center
        text.backgroundColor = .green
        text.layer.cornerRadius = 15
        text.placeholder = "Password"
        text.font = UIFont.systemFont(ofSize: 15)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .systemRed
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    //MARK: - Actions
    
    @objc func buttonAction() {
        isBlack.toggle()
    }
    
    @objc func buttonPassword() {
        let password = textField.text ?? ""
        let unlockPassword: String
        if password.isEmpty {
            createBrute()
            unlockPassword = generatePassword()
            textField.text = unlockPassword
        } else {
            unlockPassword = password
            createBrute()
        }
        let bruteForcing = DispatchWorkItem {
            self.bruteForce(passwordToUnlock: unlockPassword)
        }
        queue.async(execute: bruteForcing)
    }
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(buttonFirst)
        view.addSubview(buttonSecond)
        view.addSubview(labelText)
        view.addSubview(textField)
        view.addSubview(activityIndicator)
        view.backgroundColor = .white
        
        configure()
    }
    
//MARK: - Methods
    
    func createBrute() {
        password = ""
        textField.isSecureTextEntry = true
        buttonSecond.isEnabled = false
        activityIndicator.startAnimating()
    }
    
    func generatePassword() -> String {
        let characters = String().printable.map { String($0)}
        
        for _ in 0..<4 {
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
            self.textField.isSecureTextEntry = false
            self.labelText.text = password
            self.activityIndicator.stopAnimating()
            self.buttonSecond.isEnabled = true
            
            print(password)
        }
        print(password)
    }
    
    func configure() {
        
        NSLayoutConstraint.activate([
            buttonFirst.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            buttonFirst.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -80),
            buttonFirst.widthAnchor.constraint(equalToConstant: 100),
            
            buttonSecond.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            buttonSecond.centerXAnchor.constraint(equalTo: buttonFirst.centerXAnchor, constant: 180),
            buttonSecond.widthAnchor.constraint(equalToConstant: 100),
            
            labelText.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200),
            labelText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            textField.centerYAnchor.constraint(equalTo: labelText.centerYAnchor, constant: 80),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.widthAnchor.constraint(equalToConstant: 100),
            
            activityIndicator.centerYAnchor.constraint(equalTo: labelText.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: labelText.centerXAnchor, constant: -50)
        ])
        
    }
}

func indexOf(character: Character, _ array: [String]) -> Int {
    return array.firstIndex(of: String(character))!
}

func characterAt(index: Int, _ array: [String]) -> Character {
    return index < array.count ? Character(array[index])
    : Character("")
}

func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
    var str: String = string
    
    if str.count <= 0 {
        str.append(characterAt(index: 0, array))
    }
    else {
        str.replace(at: str.count - 1,
                    with: characterAt(index: (indexOf(character: str.last!, array) + 1) % array.count, array))
        
        if indexOf(character: str.last!, array) == 0 {
            str = String(generateBruteForce(String(str.dropLast()), fromArray: array)) + String(str.last!)
        }
    }
    
    return str
}

//MARK: - Extensions

extension String {
    var digits:      String { return "0123456789" }
    var lowercase:   String { return "abcde" }
    var uppercase:   String { return "ABCDE" }
    var punctuation: String { return "!@#$%" }
    var letters:     String { return lowercase + uppercase }
    var printable:   String { return digits + letters + punctuation }
    
    mutating func replace(at index: Int, with character: Character) {
        var stringArray = Array(self)
        stringArray[index] = character
        self = String(stringArray)
    }
}
