import UIKit

class ViewController: UIViewController {
    
    var isBlack: Bool = false {
        didSet {
            if isBlack {
                self.view.backgroundColor = .black
            } else {
                self.view.backgroundColor = .white
            }
        }
    }
    
    lazy var buttonFirst: UIButton = {
        let button = UIButton()
        button.setTitle("Button", for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var buttonSecond: UIButton = {
        let button = UIButton()
        button.setTitle("Button", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var labelText: UILabel = {
        let label = UILabel()
        label.text = "Password"
        label.textAlignment = .center
        label.backgroundColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var textField: UITextField = {
        let text = UITextField()
        text.textAlignment = .center
        text.backgroundColor = .systemGray2
        text.placeholder = "Enter Text Here"
        text.font = UIFont.systemFont(ofSize: 15)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    @objc func buttonAction() {
        isBlack.toggle()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(buttonFirst)
        view.addSubview(buttonSecond)
        view.addSubview(labelText)
        view.addSubview(textField)
        view.backgroundColor = .white
        
        configure()
        
        //self.bruteForce(passwordToUnlock: "1!gr")
        // Do any additional setup after loading the view.
    }
    
    func bruteForce(passwordToUnlock: String) {
        let ALLOWED_CHARACTERS: [String] = String().printable.map { String($0) }

        var password: String = ""

        // Will strangely ends at 0000 instead of ~~~
        while password != passwordToUnlock { // Increase MAXIMUM_PASSWORD_SIZE value for more
            password = generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)
//             Your stuff here
            print(password)
            // Your stuff here
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
            textField.widthAnchor.constraint(equalToConstant: 100)

        ])
        
    }
}

extension String {
    var digits:      String { return "0123456789" }
    var lowercase:   String { return "abcdefghijklmnopqrstuvwxyz" }
    var uppercase:   String { return "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
    var punctuation: String { return "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~" }
    var letters:     String { return lowercase + uppercase }
    var printable:   String { return digits + letters + punctuation }



    mutating func replace(at index: Int, with character: Character) {
        var stringArray = Array(self)
        stringArray[index] = character
        self = String(stringArray)
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


