//
//  MenuViewController.swift
//  Slot Machine
//
//  Created by Alex Pirog on 08.05.2021.
//

import UIKit

class MenuViewController: UIViewController {
    
    struct Segues {
        static let toSkyGame = "toSkyMachine"
        static let toFruitGame = "toFruitMachine"
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var shopButton: UIButton!
    @IBOutlet weak var bankButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var skyGameButton: UIButton!
    @IBOutlet weak var fruitGameButton: UIButton!
    @IBOutlet weak var bottomHintLabel: UILabel!
    
    // MARK: - Actions
    
    @IBAction func shopTapped(_ sender: UIButton) {
        // Show shop to player
    }
    
    @IBAction func bankTapped(_ sender: UIButton) {
        // Show player bank storage
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        skyGameButton.layer.cornerRadius = 8.0
        fruitGameButton.layer.cornerRadius = 8.0
    }
    
    // MARK: - Navigation

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch identifier {
        case Segues.toSkyGame:
            let currency = SlotsManager.skyCurrency
            let game = SlotsManager.skyMachine
            if Storage.shared.userBank[currency]! < game.betStep {
                showInsufficient(currency: currency, for: game.machineName)
                return false
            }
        case Segues.toFruitGame:
            let currency = SlotsManager.fruitCurrency
            let game = SlotsManager.fruitMachine
            if Storage.shared.userBank[currency]! < game.betStep {
                showInsufficient(currency: currency, for: game.machineName)
                return false
            }
        default:
            break
        }
        return true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SlotMachineViewController {
            switch segue.identifier {
            case Segues.toSkyGame:
                vc.machine = SlotsManager.skyMachine
                vc.backColor = .systemTeal
                vc.textColor = .white
                vc.elementsBackColor = .white
                vc.elementsTextColor = .systemTeal
                vc.controlsTintColor = .white
                vc.currency = SlotsManager.skyCurrency
            case Segues.toFruitGame:
                vc.machine = SlotsManager.fruitMachine
                vc.backColor = .systemGreen
                vc.textColor = .white
                vc.elementsBackColor = .white
                vc.elementsTextColor = .systemGreen
                vc.controlsTintColor = .white
                vc.currency = SlotsManager.fruitCurrency
            default:
                break
            }
        }
    }
    
    // MARK: - Handle Alerts
    
    private func showInsufficient(currency: Currency, for gameName: String) {
        let alert = UIAlertController(title: "Insufficient Funds", message: "You don't have enough \(currency.rawValue) to play \(gameName). Visit our shop to get more.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Visit Shop", style: .default, handler: { _ in
            // Visit shop here
        }))
        alert.addAction(UIAlertAction(title: "Close", style: .cancel))
        present(alert, animated: true, completion: nil)
    }

}
