import UIKit

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
