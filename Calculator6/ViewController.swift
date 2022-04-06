//
//  ViewController.swift
//  Calculator3
//
//  Created by liyu on 2022/1/31.
//

import UIKit

//还少个删除键
//还少对表格的操作
//按加号后再按C键有问题

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(UITableViewCell.self,
         forCellReuseIdentifier: "Cell")
        //tableView.transform = CGAffineTransform (scaleX: 1,y: -1)
        
        tableView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
       
        //1
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
        brain.fetchHistory(appDelegate: appDelegate)
       
        
        //Mark change button's title
        fromPersistentHistoryToMemoryQueue()
    }
    
    
    
    @IBOutlet weak var displayFormular: UILabel!
    
    
    
    @IBOutlet weak var display: UILabel!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var theLastButtonEffectivePressed = ""
    
    var isInTheMiddleOfTyping = false

    private var brain = CalculatorBrain()

    
    
    @IBAction func dataFromTable(_ sender: UIButton) {
        fromPersistentHistoryToMemoryQueue()
    }
    
    
    func fromPersistentHistoryToMemoryQueue () {
        brain.persistentHistoryToQueueMemory()
        let i = brain.queueMemory.count()-1
        memoryButton.setTitle(brain.queueMemory.getFormular(at:i ), for: UIControl.State.normal)
        changeMemory.setTitle( "\(i)↓", for: UIControl.State.normal)
    }
        
    @IBAction func digitPressed(_ sender: UIButton) {
        let digit = sender.currentTitle!
 
        if isInTheMiddleOfTyping {
            let textCurrentlyDisplayed = display.text!
            display.text = textCurrentlyDisplayed + digit
        }else {
            display.text = digit
            
            isInTheMiddleOfTyping = true
            if brain.formularFinished {
                displayFormular.text = ""
                
            }

        }
        //isInTheMiddleOfTwoOperandCoputing = false
        theLastButtonEffectivePressed = "digit"
    }
    
    
    var displayValue:Double {
        get{
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    @IBOutlet weak var showOrHideTableButton: UIButton!
    
    
    
    @IBAction func showOrHideTable(_ sender: UIButton) {
        if tableView.isHidden == true {
            tableView.isHidden = false
            showOrHideTableButton.setTitle("Hide Table", for: .normal)
        } else {
            tableView.isHidden = true
            showOrHideTableButton.setTitle("Show Table", for: .normal)
        }
    }
    
    
    
    
    
    
    
    private var isInTheMiddleOfTwoOperandCoputing = false
    
    @IBAction func performOneOperandOperation(_ sender: UIButton) {
       print("isinthemiddle of twoperandcomputing","\(isInTheMiddleOfTwoOperandCoputing)")
        if !isInTheMiddleOfTwoOperandCoputing {
            if let mathmaticalSymbol = sender.currentTitle {
                
                print("in one operand")
                
                brain.setOperand(displayValue,operandString: display.text!)
                
                isInTheMiddleOfTwoOperandCoputing = false
                
                
                
                isInTheMiddleOfTyping = false
                brain.performOperation(mathmaticalSymbol)
                
                displayFormular.text = brain.hisoryString
                
                historyButton.setTitle( brain.queue.getFormularAtIndex(), for: UIControl.State.normal )
                
                
                
                
                let i = brain.queue.getIndex()
                changeHistory.setTitle( "\(i)↓", for: UIControl.State.normal)
                
                if let result = brain.result {
                    displayValue = result
                    
                }
                
                
                theLastButtonEffectivePressed = "oneOperand"
            }
        }
    
    }
    
  

    @IBOutlet weak var canBeChangedOneOperandButton: UIButton!
    
    
    
    @IBOutlet weak var oneOperandSymbolTest: UITextField!
    
    
    
    
    
    @IBAction func changedOneOperandSymbolButtonPressed(_ sender: UIButton) {
        canBeChangedOneOperandButton.setTitle(oneOperandSymbolTest.text, for: UIControl.State.normal)
    }
    
    
    
    
    @IBOutlet weak var canBeChangedTwoOperandButton: UIButton!
    
    

    @IBOutlet weak var twoOperandSymbolTest: UITextField!
    
    
    @IBAction func cahngeTwoOperandSymbolButtonPressed(_ sender: UIButton) {
        canBeChangedTwoOperandButton.setTitle(twoOperandSymbolTest.text, for: UIControl.State.normal)
    }
    
    
    @IBOutlet weak var historyButton: UIButton!
    

    @IBAction func historyButtonPressed(_ sender: UIButton) {
 
        if (sender.currentTitle != nil  && sender.currentTitle != "") && (!isInTheMiddleOfTyping) {
            display.text = brain.queue.getResultAtIndex()
            theLastButtonEffectivePressed = "digit"
            isInTheMiddleOfTyping = true
            if brain.formularFinished {
                displayFormular.text = ""
                
            }
        }
        
    }
    
    @IBOutlet weak var changeHistory: UIButton!
    
    @IBAction func changeHistoryButton(_ sender: UIButton) {
        let i = brain.queue.nextIndex()
        historyButton.setTitle(brain.queue.getFormular(at: i), for: UIControl.State.normal)
        changeHistory.setTitle( "\(i)↓", for: UIControl.State.normal)
        
        
    }
    
 
    
    
    @IBOutlet weak var changeMemory: UIButton!
    
    
    @IBAction func changeMemoryPressed(_ sender: UIButton) {
        let i = brain.queueMemory.nextIndex()
        memoryButton.setTitle(brain.queueMemory.getFormular(at: i), for: UIControl.State.normal)
        changeMemory.setTitle( "\(i)↓", for: UIControl.State.normal)
        
    }
    
    
    
    
    @IBAction func storeHistory(_ sender: UIButton) {
        
        let formular =  brain.queue.getFormularAtIndex()
        let result = brain.queue.getResultAtIndex()
        brain.queueMemory.append( formular: formular, resultString: result  )
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
        brain.persistentHistorySave(appDelegate: appDelegate, formular: formular, result: result)
        
       // memoryButton.setTitle(brain.queue.getFormularAtIndex(), for: UIControl.State.normal)
        memoryButton.setTitle(formular, for: UIControl.State.normal)
        let i = brain.queueMemory.getIndex()
        changeMemory.setTitle( "\(i)↓", for: UIControl.State.normal)
        self.tableView.reloadData()
        
        
        
        print("memory result"+brain.queueMemory.getResultAtIndex())
    }
    
    
    
 
    @IBOutlet weak var memoryButton: UIButton!
    
    
    @IBAction func memoryButtonPressed(_ sender: UIButton) {
        if (sender.currentTitle != nil  && sender.currentTitle != "") && (!isInTheMiddleOfTyping) {
            display.text = brain.queueMemory.getResultAtIndex()
            theLastButtonEffectivePressed = "digit"
            isInTheMiddleOfTyping = true
            if brain.formularFinished {
                displayFormular.text = ""
                
            }
        }
    }
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func performEqualOperation(_ sender: UIButton) {
        if (!isInTheMiddleOfTwoOperandCoputing || (isInTheMiddleOfTwoOperandCoputing && theLastButtonEffectivePressed == "digit")){
            if let mathmaticalSymbol = sender.currentTitle {
                
                
                if isInTheMiddleOfTyping {
                    brain.setOperand(displayValue,operandString: display.text!)
                    
                }
                isInTheMiddleOfTwoOperandCoputing = false
                
              
                
                isInTheMiddleOfTyping = false
                brain.performOperation(mathmaticalSymbol)
                
                
                
               
                
                //displayQueueLastElement.text = brain.queue.getLastFormular()
                
                if let result = brain.result {
                    displayFormular.text = brain.hisoryString
                    displayValue = result
                    historyButton.setTitle( brain.queue.getFormularAtIndex(), for: UIControl.State.normal )
                    
                    
                    
                    
                    let i = brain.queue.getIndex()
                    changeHistory.setTitle( "\(i)↓", for: UIControl.State.normal)
                }
                
                theLastButtonEffectivePressed = "equal"
                
            }
        }
    }
    

    @IBAction func performClearOperation(_ sender: UIButton) {
        isInTheMiddleOfTwoOperandCoputing = false
        
        isInTheMiddleOfTyping = false

        theLastButtonEffectivePressed = ""
        brain.clear()
        display.text = "0"
        displayFormular.text = brain.hisoryString
        //historyButton.setTitle("", for: UIControl.State.normal)
        
        
    
    }
    

    
    @IBAction func performOperation(_ sender: UIButton) {

        if let mathmaticalSymbol = sender.currentTitle {
         
                
            //if isInTheMiddleOfTyping {
                brain.setOperand(displayValue,operandString: display.text!)
                
            //}
            isInTheMiddleOfTwoOperandCoputing = true
            
   
            isInTheMiddleOfTyping = false
            brain.performOperation(mathmaticalSymbol)

            displayFormular.text = brain.hisoryString
            
            if let result = brain.result {
                displayValue = result
   
            }
            theLastButtonEffectivePressed = "TwoOperand"
           
            
        }
       
    }
    
    
    
}









// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        //return brain.queueMemory.count()
        //return names.count
        return brain.persistentHistorys.count
    }
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {
        let cell =
        tableView.dequeueReusableCell(withIdentifier: "Cell",
                                      for: indexPath)
        //cell.textLabel?.text = names[indexPath.row]
       // cell.textLabel?.text =
        //brain.queueMemory.getFormular(at: indexPath.row)
        let count = brain.persistentHistorys.count
        
        cell.textLabel?.text =
        brain.persistentHistory(indexAt: count - 1 - indexPath.row)
        //print("\(indexPath.row)")
        //cell.contentView.transform = CGAffineTransform (scaleX: 1,y: -1);
        return cell
    }




}





