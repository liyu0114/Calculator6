//
//  ViewController.swift
//  Calculator3
//
//  Created by liyu on 2022/1/31.
//

import UIKit

class ViewController: UIViewController {
/*
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
*/
    
  
    

    
    
    @IBOutlet weak var displayFormular: UILabel!
    
    
    
    @IBOutlet weak var display: UILabel!
    
    
    
    
    
    
    var theLastButtonEffectivePressed = ""
    
    var isInTheMiddleOfTyping = false

    private var brain = CalculatorBrain()

        
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
    
    
    
    @IBAction func writeOperandToFile(_ sender: UIButton) {
        
        brain.writeOperationDictionary()
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
        brain.queueMemory.append( formular: brain.queue.getFormularAtIndex(), resultString: brain.queue.getResultAtIndex() )
        
        memoryButton.setTitle(brain.queue.getFormularAtIndex(), for: UIControl.State.normal)
        let i = brain.queueMemory.getIndex()
        changeMemory.setTitle( "\(i)↓", for: UIControl.State.normal)
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
















