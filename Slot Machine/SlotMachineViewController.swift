//
//  SlotMachineViewController.swift
//  Slot Machine
//
//  Created by Alex Pirog on 08.05.2021.
//

import UIKit

class SlotMachineViewController: UIViewController {
    
    // MARK: - Money
    
    private var currentBet: Int {
        get {
            let last = Storage.shared.lastBet[currency]!
            return last / machine.betStep * machine.betStep
        }
        set {
            Storage.shared.lastBet[currency] = newValue
            betLabel.text = "\(newValue)" + currency.rawValue
        }
    }
    
    private var playerBank: Int {
        get {
            return Storage.shared.userBank[currency] ?? -1
        }
        set {
            Storage.shared.userBank[currency] = newValue
            playerBankLabel.text = "\(newValue)" + currency.rawValue
            checkBankruptcy()
        }
    }
    
    //MARK: - Settings
    
    var machine: SlotMachine!
    
    var currency: Currency = .usd
    var spinDelay: TimeInterval = 0.3
    
    var backColor: UIColor = .white
    var textColor: UIColor = .black
    var elementsBackColor: UIColor = .black
    var elementsTextColor: UIColor = .white
    var controlsTintColor: UIColor = .red
    
    // MARK: - Outlets
    
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var playerBankLabel: UILabel!
    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var slotPicker: UIPickerView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var betLabel: UILabel!
    @IBOutlet weak var betUpButton: UIButton!
    @IBOutlet weak var betDownButton: UIButton!
    @IBOutlet weak var actionButton: UIButton!
    
    // MARK: - Controls
    
    @objc
    private func swipe(_ gesture: UISwipeGestureRecognizer) {
        guard gesture.direction == .down else { return }
        startMachine()
    }
    
    @IBAction func actionTapped(_ sender: UIButton) {
        startMachine()
    }
    
    @IBAction func betUpTapped(_ sender: UIButton) {
        if currentBet + machine.betStep < playerBank {
            currentBet += machine.betStep
        }
    }
    
    @IBAction func betDownTapped(_ sender: UIButton) {
        if currentBet > machine.betStep {
            currentBet -= machine.betStep
        }
    }
    
    @IBAction func exitTapped(_ sender: UIButton) {
        if !isSpinning {
            dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegation()
        setupGestureControls()
        setupUI()
        setupColors()
    }
    
    private func setupDelegation() {
        slotPicker.delegate = self
        slotPicker.dataSource = self
        slotPicker.isUserInteractionEnabled = false
    }
    
    private func setupGestureControls() {
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
        downSwipe.direction = .down
        view.addGestureRecognizer(downSwipe)
    }
    
    private func setupUI() {
        slotPicker.layer.cornerRadius = 16.0
        resultLabel.layer.masksToBounds = true
        resultLabel.layer.cornerRadius = 16.0
        betLabel.layer.masksToBounds = true
        betLabel.layer.cornerRadius = 16.0
        resetPicker(to: machine.currentIndexes)
        currentBet = max(Storage.shared.lastBet[currency]!, machine.betStep)
        playerBank = Storage.shared.userBank[currency]!
        resultLabel.text = " "
    }
    
    private func setupColors() {
        view.backgroundColor = backColor
        exitButton.tintColor = controlsTintColor
        playerBankLabel.textColor = textColor
        gameTitleLabel.textColor = textColor
        slotPicker.backgroundColor = elementsBackColor
        resultLabel.backgroundColor = elementsBackColor
        resultLabel.textColor = elementsTextColor
        betLabel.backgroundColor = elementsBackColor
        betLabel.textColor = elementsTextColor
        betUpButton.tintColor = controlsTintColor
        betDownButton.tintColor = controlsTintColor
        actionButton.tintColor = controlsTintColor
    }
    
    // MARK: - Logic
    
    private var isSpinning = false {
        didSet {
            betUpButton.isEnabled = !isSpinning
            betDownButton.isEnabled = !isSpinning
            actionButton.isEnabled = !isSpinning
        }
    }
    
    private func startMachine() {
        guard !isSpinning else { return }
        spinMachine()
    }
    
    private func spinMachine() {
        isSpinning = true
        resultLabel.text = " "
        resetPicker(to: machine.currentIndexes)
        let result = machine.spin()
        spinPicker(to: result.indexes) { [unowned self] in
            if let rate = result.winCase?.rate {
                let profit = currentBet * rate
                playerBank += profit
                resultLabel.text = "WON \(profit)" + currency.rawValue
            } else {
                playerBank -= currentBet
                resultLabel.text = "TRY AGAIN"
            }
            while playerBank < currentBet {
                currentBet -= machine.betStep
            }
            isSpinning = false
        }
    }
    
    private func spinPicker(to indexes: [Int], completionHandler: @escaping () -> Void) {
        for i in 0..<slotPicker.numberOfComponents {
            let index = indexes[i]
            let random = index + Int.random(in: 1...3) * machine.slots.count
            let delay = spinDelay * TimeInterval(i)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [unowned self] in
                slotPicker.selectRow(random, inComponent: i, animated: true)
                if i == slotPicker.numberOfComponents - 1 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + spinDelay) {
                        completionHandler()
                    }
                }
            }
        }
    }
    
    private func resetPicker(to indexes: [Int]) {
        for i in 0..<slotPicker.numberOfComponents {
            let index = indexes[i]
            let reverseIndex = machine.slots.count - index - 1
            let moved = slotPicker.numberOfRows(inComponent: i) - reverseIndex - 1
            slotPicker.selectRow(moved, inComponent: i, animated: false)
        }
    }
    
    // MARK: - Handle bankruptcy
    
    private func checkBankruptcy() {
        guard playerBank < machine.betStep else { return }
        let alert = UIAlertController(title: "Game Over", message: "You don't have enough \(currency.rawValue) to continue. Visit our shop to get more.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Visit Shop", style: .default, handler: { [unowned self] _ in
            // TODO: - Implement visiting shop here
            // Get free money for now
            playerBank = 100
            currentBet = machine.betStep
        }))
        alert.addAction(UIAlertAction(title: "Leave Game", style: .cancel, handler: { [unowned self] _ in
            dismiss(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - PickerView Delegate & DataSource

extension SlotMachineViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let index = row % machine.slots.count
        let size = pickerView.bounds.height / 3
        return machine.slots[index].slotRepresentableView(of: CGSize(width: size, height: size))
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return pickerView.bounds.height / 3
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return machine.columns
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return machine.slots.count * 5
    }
    
}
