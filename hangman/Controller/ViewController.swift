//
//  ViewController.swift
//  Milestone Projects 7-9
//
//  Created by Dimas on 31/08/21.
//

import UIKit

class ViewController: UIViewController {
	
	var letterButtons = [UIButton]()
	var activityView: UIActivityIndicatorView!
	var words = [String]()
	var currentAnswerStack: UIStackView!
	var hangman: HangmanView!
	var targetWord = [String.Element]()
	var usedLetters = [String.Element]()
	var playButton: UIButton!
	
	override func loadView() {
		view = UIView()
		view.backgroundColor = UIColor(red: 0.149, green: 0.149, blue: 0.149, alpha: 1)
		
		let heading = UILabel()
		heading.translatesAutoresizingMaskIntoConstraints = false
		heading.text = "Hangman"
		heading.font = UIFont(name: "PressStart2P-Regular", size: 40)
		heading.textColor = .white
		view.addSubview(heading)
		
		hangman = HangmanView()
		hangman.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(hangman)
		
		currentAnswerStack = UIStackView()
		currentAnswerStack.translatesAutoresizingMaskIntoConstraints = false
		currentAnswerStack.spacing = 4
		view.addSubview(currentAnswerStack)
		
		let buttonsView = UIView()
		buttonsView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(buttonsView)
		
		playButton = UIButton(type: .system)
		playButton.translatesAutoresizingMaskIntoConstraints = false
		playButton.setTitle("Play", for: .normal)
		playButton.addTarget(self, action: #selector(playAgainTapped), for: .touchUpInside)
		playButton.setTitleColor(.white, for: .normal)
		playButton.titleLabel?.font = .init(name: "PressStart2P-Regular", size: 16)
		playButton.isHidden = true
		view.addSubview(playButton)
		
		let restartButton = UIButton(type: .system)
		restartButton.translatesAutoresizingMaskIntoConstraints = false
		restartButton.setTitle("Restart", for: .normal)
		restartButton.addTarget(self, action: #selector(restartButtonTapped), for: .touchUpInside)
		restartButton.setTitleColor(.white, for: .normal)
		restartButton.titleLabel?.font = .init(name: "PressStart2P-Regular", size: 16)
		view.addSubview(playButton)
		
		let bottomButtons = UIStackView(arrangedSubviews: [playButton, restartButton])
		bottomButtons.translatesAutoresizingMaskIntoConstraints = false
		bottomButtons.axis = .horizontal
		bottomButtons.spacing = 32
		view.addSubview(bottomButtons)
		
		activityView = UIActivityIndicatorView()
		activityView.translatesAutoresizingMaskIntoConstraints = false
		activityView.style = .large
		view.addSubview(activityView)
		
		NSLayoutConstraint.activate([
			heading.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
			heading.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			
			hangman.topAnchor.constraint(equalTo: heading.bottomAnchor, constant: 45),
			hangman.heightAnchor.constraint(equalToConstant: 200),
			hangman.widthAnchor.constraint(equalToConstant: 200),
			hangman.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			
			currentAnswerStack.topAnchor.constraint(equalTo: hangman.bottomAnchor, constant: 65),
			currentAnswerStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			currentAnswerStack.heightAnchor.constraint(equalToConstant: 35),
			
			buttonsView.topAnchor.constraint(equalTo: currentAnswerStack.bottomAnchor, constant: 65),
			buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			buttonsView.widthAnchor.constraint(equalToConstant: 344),
			buttonsView.heightAnchor.constraint(equalToConstant: 192),
			
			playButton.heightAnchor.constraint(equalToConstant: 17),
			playButton.widthAnchor.constraint(equalToConstant: 70),
			
			restartButton.heightAnchor.constraint(equalToConstant: 17),
			restartButton.widthAnchor.constraint(equalToConstant: 120),
			
			bottomButtons.topAnchor.constraint(equalTo: buttonsView.bottomAnchor, constant: 50),
			bottomButtons.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			
			activityView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			activityView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		])
		
		let buttonHeight = 33
		let buttonWidth = 32
		
		let characters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O",
						  "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
		
		var index = 0
		for row in 0 ..< 4 {
			let columnLimit: Int
			(row % 2 == 0) ? (columnLimit = 7) : (columnLimit = 6)
			
			for column in 0 ..< columnLimit {
				let button = UIButton(type: .system)
				button.setTitle(characters[index], for: .normal)
				button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
				
				button.titleLabel?.font = UIFont(name: "PressStart2P-Regular", size: 32)
				button.setTitleColor(UIColor(red: 0.9137, green: 0.9098, blue: 0.9059, alpha: 1), for: .normal)
				
				if row % 2 == 0 {
					button.frame = .init(x: column * (buttonWidth + 20), y: row * (buttonHeight + 20),
										 width: buttonWidth, height: buttonHeight)
				} else {
					button.frame = .init(x: (column * (buttonWidth + 20)) + 26, y: row * (buttonHeight + 20),
										 width: buttonWidth, height: buttonHeight)
				}
				
				buttonsView.addSubview(button)
				letterButtons.append(button)
				index += 1
			}
		}
		
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		downloadFile(from: "https://hangman.crowdai.com/wordlist.txt")
	}
	
	@objc func buttonTapped(_ sender: UIButton) {
		guard let char = sender.titleLabel?.text?.first else { return }
		
		if targetWord.contains(char) {
			usedLetters.append(char)
			updateAnswerStack()
			sender.isHidden = true
		} else {
			let isGameOver = hangman.continueStage()
			if isGameOver {
				gameOver()
				return
			}

			UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: .allowUserInteraction, animations: { [weak self] in
				UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1 / 3) {
					self?.currentAnswerStack.transform = .init(translationX: -24, y: 0)
					self?.currentAnswerStack.backgroundColor = .red
				}
				UIView.addKeyframe(withRelativeStartTime: 1 / 3, relativeDuration: 1 / 3) {
					self?.currentAnswerStack.transform = .init(translationX: 24, y: 0)
				}
				UIView.addKeyframe(withRelativeStartTime: 2 / 3, relativeDuration: 1 / 3) {
					self?.currentAnswerStack.transform = .identity
				}
			}) { [weak self] _ in
				self?.currentAnswerStack.backgroundColor = nil
			}
		}
	}
	
	@objc func playAgainTapped() {
		restart()
	}
	
	@objc func restartButtonTapped() {
		restart()
	}
	
	private func gameOver() {
		for subview in currentAnswerStack.subviews {
			subview.removeFromSuperview()
		}
		
		for letterButton in letterButtons {
			letterButton.isEnabled = false
			letterButton.layer.opacity = 0.6
		}
		
		for char in "GAME OVER" {
			let label = UILabel()
			label.font = .init(name: "PressStart2P-Regular", size: 34)
			
			label.text = "\(char)"
			
			
			NSLayoutConstraint.activate([
				label.heightAnchor.constraint(equalToConstant: 35),
				label.widthAnchor.constraint(equalToConstant: 34)
			])
			
			currentAnswerStack.addArrangedSubview(label)
		}
		
		playButton.isHidden = false
		currentAnswerStack.setNeedsLayout()
	}
	
	private func restart() {
		if !currentAnswerStack.arrangedSubviews.isEmpty {
			for subview in currentAnswerStack.subviews {
				subview.removeFromSuperview()
			}
			targetWord.removeAll()
			createAnswerStacks()
			hangman.restart()
		}
		
		for letterButton in letterButtons {
			letterButton.isEnabled = true
			letterButton.layer.opacity = 1
		}
		
		playButton.isHidden = true
	}
	
	func downloadFile(from urlString: String) {
		guard let url = URL(string: urlString) else { return }
		
		activityView.startAnimating()
		
		DispatchQueue.global(qos: .userInitiated).async {
			let task = URLSession.shared.downloadTask(with: url) { [weak self] localURL, urlResponse, error in
				if let localURL = localURL {
					if let string = try? String(contentsOf: localURL) {
						self?.parse(string)
					}
				}
			}
			
			task.resume()
		}
	}
	
	private func parse(_ string: String) {
		DispatchQueue.main.async { [weak self] in
			let words = string.components(separatedBy: "\n")
			
			for word in words {
				if word.count <= 9 {
					self?.words.append(word)
				}
			}
			self?.createAnswerStacks()
			self?.activityView.stopAnimating()
		}
	}
	
	private func createAnswerStacks() {
		guard let word = words.randomElement() else { return }
		
		targetWord += Array(word.uppercased())
		
		for _ in 0 ..< targetWord.count {
			let label = UILabel()
			label.font = .init(name: "PressStart2P-Regular", size: 34)
			
				label.text = "_"
			
			
			NSLayoutConstraint.activate([
				label.heightAnchor.constraint(equalToConstant: 35),
				label.widthAnchor.constraint(equalToConstant: 34)
			])
			
			currentAnswerStack.addArrangedSubview(label)
		}
		
		currentAnswerStack.setNeedsLayout()
		print("target: \(targetWord)") // TODO: - Delete after testing
	}
	
	func updateAnswerStack() {
		for i in 0 ..< targetWord.count {
			if usedLetters.contains(String.Element(extendedGraphemeClusterLiteral: targetWord[i])) {
				if let targetLabel = currentAnswerStack.arrangedSubviews[i] as? UILabel{
					targetLabel.text = "\(targetWord[i])"
				}
				
			}
		}
	}
	
}

