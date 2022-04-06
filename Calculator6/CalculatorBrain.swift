//
//  CalculatorBrain.swift
//  Calculator3
//
//  Created by liyu on 2022/2/9.
//

import Foundation
import CoreData
/*
func changeSign(operand: Double ) -> Double
{
    return -operand
}

func multiply(operand1:Double, operand2:Double) -> Double
{
    return operand1 * operand2
}

func divid(operand1:Double, operand2:Double) -> Double
{
    return operand1 / operand2
}



func add(operand1:Double, operand2:Double) -> Double
{
    return operand1 + operand2
}

func subtraction(operand1:Double, operand2:Double) -> Double
{
    return operand1 - operand2
}

*/


struct CalculatorBrain {
    
   // var isComputingEnd = false
    var temperaryFormular = ""
    struct Queue {
        private var long = 0
        private var index = 2
        private var formulars = ["","",""]
        private var resultStrings = ["","",""]
        
      
        mutating func nextIndex() -> Int {
            if index == 0 {
                index = 2
            } else {
                index = index - 1
            }
            return index
        }
        
        func getIndex() -> Int {
            return index
        }
        
        func getLastFormular() -> String {
            return formulars.last!
        }
        
        func getResult(at indexNO:Int) -> String {
           
            return resultStrings[indexNO]
            
        }
        
        func getResultAtIndex() -> String {
            return resultStrings[index]
            
        }
        
        
        func getFormular( at indexNO:Int) -> String {
           
            return formulars[indexNO]
            
        }
        
        
        func getFormularAtIndex() -> String {
            return formulars[index]
        }
            
        mutating func append( formular : String, resultString : String) {
            //formulars.append(formular)
            //formulars.remove(at: 0)
            formulars[0] = formulars[1]
            formulars[1] = formulars[2]
            formulars[2] = formular
            resultStrings[0] = resultStrings[1]
            resultStrings[1] = resultStrings[2]
            resultStrings[2] = resultString
            //resultStrings.append(resultString)
            //resultStrings.remove(at: 0)
            index = 2
        }
        
        mutating func clear() {
            long = 0
            index = 2
            formulars = ["","",""]
            resultStrings = ["","",""]
        }
        
    }
    
    var queue = Queue()
    
 
    struct QueueMemory {
        private var long = 0
        private var index = 9
        private var formulars = ["","","","","","","","","",""]
        private var resultStrings = ["","","","","","","","","",""]
        
      
        mutating func nextIndex() -> Int {
            if index == 0 {
                index = 9
            } else {
                index = index - 1
            }
            return index
        }
        
        func count() -> Int {
            return formulars.count
        }
        
        func getIndex() -> Int {
            return index
        }
        
        func getLastFormular() -> String {
            return formulars.last!
        }
        
        func getResult(at indexNO:Int) -> String {
           
            return resultStrings[indexNO]
            
        }
        
        func getResultAtIndex() -> String {
            return resultStrings[index]
            
        }
        
        
        func getFormular( at indexNO:Int) -> String {
           
            return formulars[indexNO]
            
        }
        
        
        func getFormularAtIndex() -> String {
            return formulars[index]
        }
            
        mutating func append( formular : String, resultString : String) {
            //formulars.append(formular)
            //formulars.remove(at: 0)
            formulars[0] = formulars[1]
            formulars[1] = formulars[2]
            formulars[2] = formulars[3]
            formulars[3] = formulars[4]
            formulars[4] = formulars[5]
            formulars[5] = formulars[6]
            formulars[6] = formulars[7]
            formulars[7] = formulars[8]
            formulars[8] = formulars[9]
            formulars[9] = formular
            
            
            
            resultStrings[0] = resultStrings[1]
            resultStrings[1] = resultStrings[2]
            resultStrings[2] = resultStrings[3]
            resultStrings[3] = resultStrings[4]
            resultStrings[4] = resultStrings[5]
            resultStrings[5] = resultStrings[6]
            resultStrings[6] = resultStrings[7]
            resultStrings[7] = resultStrings[8]
            resultStrings[8] = resultStrings[9]
            resultStrings[9] = resultString
            //resultStrings.append(resultString)
            //resultStrings.remove(at: 0)
            index = 9
        }
        
        mutating func clear() {
            long = 0
            index = 9
            formulars = ["","","","","","","","","",""]
            resultStrings = ["","","","","","","","","",""]
        }
        
    }
    
    
    var queueMemory = QueueMemory()
    
    

    
    
    
    private var operandNO =  0
    
    private var history:String = ""
    
    
        
    private var canNotPressBinaryOperation = false
    
    private var accumulatorString:String = ""

    private var accumulator: Double?
    
    private enum Operation {
        //case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double,Double) -> Double)
        case equals
    }
   
    
    private var operations:Dictionary<String,Operation> =
    [
        //"π": Operation.constant(Double.pi), //Double.pi,
        //"e": Operation.constant(M_E), //M_E
       
        
        "sin": Operation.unaryOperation(sin),
        "cos": Operation.unaryOperation(cos),
        "tan": Operation.unaryOperation(tan),
        "asin": Operation.unaryOperation(asin),
        "acos": Operation.unaryOperation(acos),
        "atan": Operation.unaryOperation(atan),
        "sinh": Operation.unaryOperation(sinh),
        "cosh": Operation.unaryOperation(cosh),
        "tanh": Operation.unaryOperation(tanh),
        
        "exp": Operation.unaryOperation(exp),
        "sqrt": Operation.unaryOperation(sqrt),
        "log": Operation.unaryOperation(log),
        "log10": Operation.unaryOperation(log10),
        
        "ceil": Operation.unaryOperation(ceil),
        "floor": Operation.unaryOperation(floor),
        
        "fabs": Operation.unaryOperation(fabs),
        
        //负号
        
        "neg": Operation.unaryOperation({ -$0 }),
        
        
        
        
        
        "%": Operation.binaryOperation({ ($0 / $1) * 100 }),
        "*": Operation.binaryOperation({ $0 * $1 }),
        "/": Operation.binaryOperation({ $0 / $1 }),
        "+": Operation.binaryOperation({ $0 + $1 }),
        "-": Operation.binaryOperation({ $0 - $1 }),
        
        "pow": Operation.binaryOperation({pow($0, $1)}),
        "powf": Operation.binaryOperation({Double(powf(Float($0), Float($1)))}),
                       
        "=": Operation.equals
        
    ]

    
    
    
    
    
    /*
    func writeOperationDictionary( ){
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
            let fileName = "OperDictionary"

            if let documentPath = paths.first {
                let filePath = NSMutableString(string: documentPath).appendingPathComponent(fileName)

                let URL = NSURL.fileURL(withPath: filePath)
                
                let dictionary = operations as NSDictionary
/*
                let dictionary = NSMutableDictionary(capacity: 0)

                dictionary.setValue("valu1", forKey: "key1")
                dictionary.setValue("valu2", forKey: "key2")

                let success = dictionary.write(to: URL, atomically: true)
 */
                
                let success = dictionary.write(to: URL, atomically: true)
                print("writeto: ",URL, "!",success)
            }
    }
    
    
  */
    
    mutating func performOperation (_ symbol:String) {
        //if !canNOTPressOperation {
            if operandNO > 0 {
                if let operation = operations[symbol]  {
                    switch operation {
                    /*
                    case .constant(let value):
                        accumulator = value
                        accumulatorString = symbol
                        history = symbol
                        //isComputingEnd = false
                        operandNO = 1
                        canNotPressBinaryOperation = false
                     */
                    case .unaryOperation(let function):
                        if accumulator != nil {
                            history = symbol + accumulatorString
                            accumulator = function(accumulator!)
                            
                            
                            queue.append(formular: history, resultString: "\(accumulator! )")
                        }
                        
                        
                        operandNO = 0
                        formularFinished = true
                        canNotPressBinaryOperation = false
                        //isComputingEnd = true
                    case .binaryOperation(let function):
                        
                        print("\(canNotPressBinaryOperation)")
                        if !canNotPressBinaryOperation {
                            if operandNO == 1 {
                                pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!,firstOperandString:accumulatorString )
                                history =  accumulatorString + symbol
                                
                                temperaryFormular = temperaryFormular + accumulatorString + symbol
                                print("not = pressed && operandNO==1",temperaryFormular)
                                
                                
                                //accumulatorString = ""
                                accumulator = nil
                                canNotPressBinaryOperation = true
                                print("one:\(operandNO)")
                            } else {
                                
                                
                                temperaryFormular = temperaryFormular + accumulatorString + symbol
                                print("not = pressed",temperaryFormular)
                                performPendingBinaryOperation()
                                
                                
                                
                                
                                pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!,firstOperandString:accumulatorString )
                                
                              
                                
                                
                                print("two:\(operandNO)")
                                history = accumulatorString + symbol
                                
                                
                               
                               
                                operandNO = 1
                                canNotPressBinaryOperation = true
                            }
                            formularFinished = false
                        }
                    case .equals:
                        if (operandNO > 1) {
                            history = history + accumulatorString
                            
                            temperaryFormular = temperaryFormular + accumulatorString
                            
                            print("equal pressed :", temperaryFormular)
                            
                           
                            
                            performPendingBinaryOperation()
                            
                            queue.append(formular: temperaryFormular, resultString: accumulatorString)
                            print("temperaoryFormular:",temperaryFormular,"resultString",accumulatorString)
                            temperaryFormular = ""
                            
                            print("queue0",queue.getFormular(at: 0),queue.getResult(at: 0),
                                  "queue1",queue.getFormular(at: 1),queue.getResult(at: 1),"queue2",queue.getFormular(at: 2),queue.getResult(at: 2))
                               
                            operandNO = 0
                            formularFinished = true
                            canNotPressBinaryOperation  = false
                        }
                    
                        
                    }
                }
            //}
        }
        
        
    }
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    
    
    private mutating func performPendingBinaryOperation (){
        if pendingBinaryOperation != nil && accumulator != nil{
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            accumulatorString = "\(accumulator!)"
          
            
            pendingBinaryOperation = nil
            
        }
    }
    
    
    private struct PendingBinaryOperation {
        let function: (Double,Double) ->Double
        let firstOperand: Double
        let firstOperandString:String
        
        func perform(with secondOperand:Double) -> Double {
            let resultInPerform = function(firstOperand,secondOperand)
            
            
            return resultInPerform
            
        }
    }
    
    
    mutating func setOperand(_ operand: Double,operandString:String){
        
        accumulator = operand
        accumulatorString = operandString
        //isComputingEnd = false
        operandNO = operandNO + 1
        //if operandNO == 2 {
        canNotPressBinaryOperation = false
        //}
        print("zero:\(canNotPressBinaryOperation)")
    }
     
    
    mutating func clear() {
        accumulator = 0
        accumulatorString = ""
        history = ""
        //queue.clear()
        operandNO = 0
    }
    
    var hisoryString:String?
    {
        get {
            return history
        }
    }
    
    var result:Double?
    {
        get {
            return accumulator
        }
        
    }
    
    var formularFinished = false
    
    
    
    
    
    
    ///Mark Core Data
    ///
    ///


    var persistentHistorys: [NSManagedObject] = []
    
    func persistentHistory (indexAt index: Int ) -> String {
        let persistentFormularHistory = persistentHistorys[index].value(forKey: "formular") as! String
        let persistentResultHistory = persistentHistorys[index].value(forKey: "result") as! String
        
        //时间
        let persistentTimeStampHistory = persistentHistorys[index].value(forKey: "timeStamp") as? Date
        let timeFormatter = DateFormatter()
        //日期显示格式，可按自己需求显示
        timeFormatter.dateFormat = "yyy-MM-dd' at 'HH:mm:ss.SSS"
        let strTimeStamp = timeFormatter.string(from: persistentTimeStampHistory ?? Date())
        
        
        return "\( persistentFormularHistory)" + " = " + "\(persistentResultHistory)" + "  -> " + "\(strTimeStamp)"
        
    }
    
    mutating func fetchHistory( appDelegate: AppDelegate  ) {
        let managedContext =
        appDelegate.persistentContainer.viewContext
        //2
        let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "History")
        
        //3
        do {
            persistentHistorys = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        
        
    }
    
    
    mutating func persistentHistorySave(appDelegate:AppDelegate, formular: String, result: String) {
     
        let managedContext =
        appDelegate.persistentContainer.viewContext
        // 2
        let entity =
        NSEntityDescription.entity(forEntityName: "History",
                                   in: managedContext)!
        let persisttentHistoryRow = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        
        // 3
        
        let timeStamp = Date()
        persisttentHistoryRow.setValue(formular, forKeyPath: "formular")
   
        persisttentHistoryRow.setValue(result, forKeyPath: "result")
        
        persisttentHistoryRow.setValue(timeStamp, forKey: "timeStamp")
        // 4
        do {
            try managedContext.save()
            persistentHistorys.append(persisttentHistoryRow)
           
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    
    mutating func persistentHistoryToQueueMemory() {
        let persistentHistoryCount = persistentHistorys.count
        let queueMemoryCount = queueMemory.count()
        var i = 0
        if  persistentHistoryCount > queueMemoryCount {
            i = queueMemoryCount
            
        }else {
            i = persistentHistoryCount
        }
        if i > 0 {
          
                
            for j in (0...i-1).reversed() {
                let index = persistentHistoryCount - j - 1
                let persistentFormularHistory = persistentHistorys[index].value(forKey: "formular") as! String
                let persistentResultHistory = persistentHistorys[index].value(forKey: "result") as! String
                queueMemory.append(formular: persistentFormularHistory, resultString: persistentResultHistory)
            }
        }
    }
    
    
}






