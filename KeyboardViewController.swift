import UIKit

final class KeyboardViewController: UIInputViewController {
    private let board = UIView()
    private let circle = UIView()
    private var keyButtons: [UIButton] = []
    private var circleCenter: CGPoint = .zero
    private var hasPlacedCircle = false
    private let rows = ["QWERTYUIOP", "ASDFGHJKL", "ZXCVBNM"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.035, green: 0.055, blue: 0.10, alpha: 1)
        buildKeyboard()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !hasPlacedCircle {
            circle.center = CGPoint(x: view.bounds.midX, y: view.bounds.height * 0.52)
            circleCenter = circle.center
            hasPlacedCircle = true
        }
    }

    private func buildKeyboard() {
        board.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(board)
        NSLayoutConstraint.activate([
            board.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
            board.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            board.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            board.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8)
        ])

        let main = UIStackView()
        main.axis = .vertical
        main.spacing = 8
        main.distribution = .fillEqually
        main.translatesAutoresizingMaskIntoConstraints = false
        board.addSubview(main)
        NSLayoutConstraint.activate([
            main.leadingAnchor.constraint(equalTo: board.leadingAnchor),
            main.trailingAnchor.constraint(equalTo: board.trailingAnchor),
            main.topAnchor.constraint(equalTo: board.topAnchor),
            main.bottomAnchor.constraint(equalTo: board.bottomAnchor)
        ])

        for (index, row) in rows.enumerated() {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.spacing = 5
            stack.distribution = .fillEqually
            if index == 1 {
                stack.layoutMargins = UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 13)
                stack.isLayoutMarginsRelativeArrangement = true
            } else if index == 2 {
                stack.addArrangedSubview(makeSpecialKey("⇧", action: {}))
            }
            for character in row {
                stack.addArrangedSubview(makeLetterKey(String(character)))
            }
            if index == 2 {
                stack.addArrangedSubview(makeSpecialKey("⌫") { [weak self] in
                    self?.textDocumentProxy.deleteBackward()
                })
            }
            main.addArrangedSubview(stack)
        }

        let bottom = UIStackView()
        bottom.axis = .horizontal
        bottom.spacing = 5
        bottom.distribution = .fillEqually
        bottom.addArrangedSubview(makeSpecialKey("🌐") { [weak self] in
            self?.advanceToNextInputMode()
        })
        bottom.addArrangedSubview(makeSpecialKey("123") {})
        bottom.addArrangedSubview(makeSpecialKey("space") { [weak self] in
            self?.textDocumentProxy.insertText(" ")
        })
        bottom.addArrangedSubview(makeSpecialKey("return") { [weak self] in
            self?.textDocumentProxy.insertText("\n")
        })
        main.addArrangedSubview(bottom)

        circle.backgroundColor = UIColor(red: 0.12, green: 0.42, blue: 1.0, alpha: 0.96)
        circle.layer.cornerRadius = 17
        circle.layer.borderWidth = 2
        circle.layer.borderColor = UIColor.white.withAlphaComponent(0.9).cgColor
        circle.layer.shadowColor = UIColor.systemBlue.cgColor
        circle.layer.shadowOpacity = 0.65
        circle.layer.shadowRadius = 10
        circle.bounds = CGRect(x: 0, y: 0, width: 34, height: 34)
        circle.isUserInteractionEnabled = true
        let pan = UIPanGestureRecognizer(target: self, action: #selector(dragCircle(_:)))
        circle.addGestureRecognizer(pan)
        view.addSubview(circle)
    }

    private func makeLetterKey(_ title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        button.backgroundColor = UIColor(red: 0.13, green: 0.18, blue: 0.28, alpha: 1)
        button.layer.cornerRadius = 6
        button.addAction(UIAction { [weak self, weak button] _ in
            guard let self, let button else { return }
            self.textDocumentProxy.insertText(title.lowercased())
            self.dropCircle(onto: button)
        }, for: .touchUpInside)
        keyButtons.append(button)
        return button
    }

    private func makeSpecialKey(_ title: String, action: @escaping () -> Void) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: title.count > 3 ? 13 : 17, weight: .semibold)
        button.backgroundColor = UIColor(red: 0.20, green: 0.29, blue: 0.43, alpha: 1)
        button.layer.cornerRadius = 6
        button.addAction(UIAction { _ in action() }, for: .touchUpInside)
        return button
    }

    @objc private func dragCircle(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        if gesture.state == .changed {
            circle.center = CGPoint(x: circle.center.x + translation.x,
                                    y: circle.center.y + translation.y)
            gesture.setTranslation(.zero, in: view)
        } else if gesture.state == .ended {
            circleCenter = circle.center
        }
    }

    private func dropCircle(onto button: UIButton) {
        let target = button.convert(CGPoint(x: button.bounds.midX, y: button.bounds.midY), to: view)
        UIView.animate(withDuration: 0.22, delay: 0, options: [.curveEaseIn]) {
            self.circle.center = CGPoint(x: target.x, y: target.y - 10)
            self.circle.transform = CGAffineTransform(scaleX: 0.82, y: 0.82)
        } completion: { _ in
            UIView.animate(withDuration: 0.18, delay: 0, options: [.curveEaseOut]) {
                self.circle.center = target
                self.circle.transform = .identity
            } completion: { _ in
                UIView.animate(withDuration: 0.25) {
                    self.circle.center = self.circleCenter
                }
            }
        }
    }
}
