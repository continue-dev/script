//
//  Rabbit.swift
//  script1
//
//  Created by Yoshiki Izumi on 2019/12/05.
//  Copyright © 2019 Yoshiki Izumi. All rights reserved.
//

import Foundation

class Func {
    var function : String
    var argument : [String]
    var argumentValue : [String]
    var script : String
    var returnValue: String
    var ifScript: String
    init() {
        function = ""
        argument = []
        argumentValue = []
        script = ""
        returnValue = ""
        ifScript = ""
    }
}

class Rabbit {
    private var funcArray : [Func] = []

    func run(script: String) {
        guard let path = Bundle.main.path(forResource: script, ofType: "jump") else {return}
        do {
            let script = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            
            searchFunc(script: script)

            for i in 0..<funcArray.count {
                if funcArray[i].function == "main" {
                    funcParse(script: funcArray[i].script)
                }
            }
            
            for i in 0..<funcArray.count {
                if funcArray[i].function != "onTouchDown" && funcArray[i].function == "main" {
                    routine(func0: funcArray[i])
                }
            }
            
        } catch let error as NSError {
            print("エラー: \(error)")
            return
        }
    }

    func onTouchDown(x: Float, y: Float) {
        for i in 0..<funcArray.count {
            if funcArray[i].function == "onTouchDown" {
                let func0: Func = funcArray[i]
                if func0.argumentValue.count > 0 {
                    func0.argumentValue[0] = x.description
                    func0.argumentValue[1] = y.description
                } else {
                    func0.argumentValue.append(x.description)
                    func0.argumentValue.append(y.description)
                }
                routine(func0: func0)
            }
        }
    }
    func falls() {
        for i in 0..<funcArray.count {
            if funcArray[i].function == "jumpToHostLanguage" {
                print(funcArray[i].script)
            }
        }
    }

    
    func parseReturn(script: String) -> String {
        var nextRange2 = script.startIndex..<script.endIndex
        while let end2 = script.range(of: "return", options: .caseInsensitive, range: nextRange2) {
            guard let closeNL = script.range(of: "\n", options: .caseInsensitive, range: end2.upperBound..<script.endIndex) else {break}
            let returnRange = end2.upperBound..<closeNL.lowerBound
            var returnValue = script[returnRange]
            while let range = returnValue.range(of: " ") {
               returnValue.replaceSubrange(range, with: "")
            }
            while let range = returnValue.range(of: "\"") {
               returnValue.replaceSubrange(range, with: "")
            }
            nextRange2 = closeNL.upperBound..<script.endIndex
            if returnValue.description != "" {
                return returnValue.description
            }            //funcArray[i].returnValue = returnValue.description

        }
        return ""
    }
    
    
    func searchFunc(script: String) {
        var nextRange0 = script.startIndex..<script.endIndex
        // scriptの中からfuncを検索
        while let begin0 = script.range(of: "func", options: .caseInsensitive, range: nextRange0) {
            nextRange0 = begin0.upperBound..<script.endIndex
            // funcの後ろに "(" があるか検索
            guard var end0 = script.range(of: "(", options: .caseInsensitive, range: nextRange0) else {break}
            // funcと(の間にある文字列が関数名になる
            let funcRange = begin0.upperBound..<end0.lowerBound
            var function = script[funcRange]

            while let range = function.range(of: " ") {
                function.replaceSubrange(range, with: "")
            }

            let func0: Func = Func()
            func0.function = function.description

            nextRange0 = end0.upperBound..<script.endIndex
            // "(" の後ろに ")" があるか検索
            guard let closeBracket = script.range(of: ")", options: .caseInsensitive, range: nextRange0) else {break}
            // "(" と ")" の間にある文字列が引数になる
            let argumentRange = end0.upperBound..<closeBracket.lowerBound
            let argument = script[argumentRange]
            var argumnetBegin = argument.startIndex
            var flag: Bool = true
            
            if !(argument == "" || argument == " ") {
                // 引数の中で "," があるか検索
                while let argumentEnd = argument.range(of: ",", options: .caseInsensitive, range: argumnetBegin..<argument.endIndex) {
                    // "," があれば引数の１つとしてFuncクラスの引数配列に登録
                    let argument0 = argumnetBegin..<argumentEnd.lowerBound
                    var argument00 = argument[argument0]
                    while let range = argument00.range(of: " ") {
                        argument00.replaceSubrange(range, with: "")
                    }
                    func0.argument.append(argument00.description)
                    argumnetBegin = argumentEnd.upperBound
                    flag = false
                }
                if flag == true {
                    func0.argument.append(argument.description)
                } else {
                    var arg = argument[argumnetBegin..<argument.endIndex]
                    while let range = arg.range(of: " ") {
                       arg.replaceSubrange(range, with: "")
                    }
                    func0.argument.append(arg.description)
                }
            }
            // 関数の中身を取得
            guard let bracket0 = script.range(of: "{", options: .caseInsensitive, range: nextRange0) else {break}
//            guard var bracket1 = script.range(of: "}", options: .caseInsensitive, range: nextRange0) else {break}
//            var bracket00 = bracket0

            var bracket1 = end0
            var count = 0
            while count >= 0 {
//                let bracket2 = script.range(of: "{", options: .caseInsensitive, range: end0.upperBound..<script.endIndex) {
//                end0 = bracket2
//                bracket0 = end0
//                count += 1
                
                guard let bracket31 = script.range(of: "{", options: .caseInsensitive, range: end0.upperBound..<script.endIndex) else {break}
                guard let bracket32 = script.range(of: "}", options: .caseInsensitive, range: end0.upperBound..<script.endIndex) else {break}
                if bracket31.upperBound < bracket32.upperBound {
                    count += 1
                    end0 = bracket31
                    bracket1 = end0
                } else {
                    count -= 1
                    end0 = bracket32
                    bracket1 = end0
                }
//                print("count:" + count.description)

                if count <= 0 {
                    break
                }
            }
            if count >= 1 {
                guard let bracket32 = script.range(of: "}", options: .caseInsensitive, range: end0.upperBound..<script.endIndex) else {break}
                bracket1 = bracket32
            }
            let bracketRange = bracket0.upperBound..<bracket1.lowerBound
            func0.script = script[bracketRange].description
            funcArray.append(func0)
        }
    }

    func funcParse(script:String) {
        for i in 0..<funcArray.count {
            funcArray[i].returnValue = parseReturn(script: funcArray[i].script)
            // 関数のスクリプトの中身に 関数名と"(" があるか検索
            var nextRange1 = script.startIndex..<script.endIndex

            while let end1 = script.range(of: funcArray[i].function + "(", options: .caseInsensitive, range: nextRange1 ) {
                // 関数名と"("があった場合、 ")"を検索
                guard let closeBracket = script.range(of: ")", options: .caseInsensitive, range: end1.upperBound..<script.endIndex) else {break}
                // "("と")"の間にあった文字列が引数になる
                let argumentRange = end1.upperBound..<closeBracket.lowerBound
                var argument = script[argumentRange]
                var argumnetBegin = argument.startIndex
                var flag: Bool = true
//                print(argument)
                if !(argument == "" || argument == " ") {

                    // 引数の文字列の中に","があるか検索
                    while let argumentEnd = argument.range(of: ",", options: .caseInsensitive, range: argumnetBegin..<argument.endIndex) {
                        // ","があれば引数の１つとしてFuncクラスの引数の値の配列に登録
                        let argument0 = argumnetBegin..<argumentEnd.lowerBound
                        var argument00 = argument[argument0]
                        while let range = argument00.range(of: " ") {
                            argument00.replaceSubrange(range, with: "")
                        }
                        funcArray[i].argumentValue.append(argument00.description)
                        argumnetBegin = argumentEnd.upperBound
                        flag = false
                    }
                    while let range = argument.range(of: "\"") {
                        argument.replaceSubrange(range, with: "")
                    }
                    if flag == true {
                        funcArray[i].argumentValue.append(argument.description)
                    } else {
                        var arg = argument[argumnetBegin..<argument.endIndex]
                        while let range = arg.range(of: " ") {
                           arg.replaceSubrange(range, with: "")
                        }
                        funcArray[i].argumentValue.append(arg.description)
                    }
                }
                // 関数を実行
//                routine(func0: funcArray[i])
                nextRange1 = argumentRange.upperBound..<script.endIndex
            }

//            var nextRange2 = script.startIndex..<script.endIndex
//            while let end2 = script.range(of: "return", options: .caseInsensitive, range: nextRange2) {
//                guard let closeNL = script.range(of: "\n", options: .caseInsensitive, range: end2.upperBound..<script.endIndex) else {break}
//                let returnRange = end2.upperBound..<closeNL.lowerBound
//                var returnValue = script[returnRange]
//                while let range = returnValue.range(of: " ") {
//                   returnValue.replaceSubrange(range, with: "")
//                }
//                while let range = returnValue.range(of: "\"") {
//                   returnValue.replaceSubrange(range, with: "")
//                }
//                funcArray[i].returnValue = returnValue.description
//                print(funcArray[i].returnValue)
//                nextRange2 = closeNL.upperBound..<script.endIndex
//            }
        }
    }
    
    func searchElement() {
    }
    
    func elementParse() {
    }
    
    func exec() {
        
    }
    

    func routine(func0: Func) {
        let script = func0.script
//        funcParse(script: script)

        var varArray: [Substring] = []
        var valArray: [String] = []

        for i in 0..<funcArray.count {
            var nextRange0 = script.startIndex..<script.endIndex
            while let end3 = script.range(of: funcArray[i].function, options: .caseInsensitive, range: nextRange0 ) {
                routine(func0: funcArray[i])
                nextRange0 = end3.upperBound..<script.endIndex
            }
        }
        
        var nextRange1 = script.startIndex..<script.endIndex
        while let end3 = script.range(of: "if", options: .caseInsensitive, range: nextRange1 ) {
            guard let openBracket = script.range(of: "(", options: .caseInsensitive, range: end3.upperBound..<script.endIndex) else {break}
            guard let closeBracket = script.range(of: ")", options: .caseInsensitive, range: openBracket.upperBound..<script.endIndex) else {break}
            let evaluationRange = openBracket.upperBound..<closeBracket.lowerBound
//            print(script[evaluationRange])
            
            guard let openBigBracket = script.range(of: "{", options: .caseInsensitive, range: closeBracket.upperBound..<script.endIndex) else {break}
            guard let closeBigBracket = script.range(of: "}", options: .caseInsensitive, range: openBigBracket.upperBound..<script.endIndex) else {break}
            let scriptBigBracket = openBigBracket.upperBound..<closeBigBracket.lowerBound
//            print(script[scriptBigBracket].description)
            
            guard let elseWord = script.range(of: "else", options: .caseInsensitive, range: closeBigBracket.upperBound..<script.endIndex) else {break}
            guard let openBigBracket2 = script.range(of: "{", options: .caseInsensitive, range: elseWord.upperBound..<script.endIndex) else {break}
            guard let closeBigBracket2 = script.range(of: "}", options: .caseInsensitive, range: openBigBracket2.upperBound..<script.endIndex) else {break}
            let elseWordRange = openBigBracket2.upperBound..<closeBigBracket2.lowerBound
//            print(script[elseWordRange].description)
            
            nextRange1 = closeBigBracket2.upperBound..<script.endIndex
            
            let eq = script[evaluationRange].range(of: "==")
            
            let eqRange = script[evaluationRange].startIndex..<eq!.lowerBound
            var eqWord = script[eqRange]
            while let range = eqWord.range(of: " ") {
                eqWord.replaceSubrange(range, with: "")
            }
            
            let eqRange2 = eq!.upperBound..<script[evaluationRange].endIndex
            var eqWord2 = script[eqRange2]
            while let range = eqWord2.range(of: " ") {
                eqWord2.replaceSubrange(range, with: "")
            }

            var evaluationArg = eqWord.description
            for i in 0..<func0.argument.count {
                if func0.argument[i] == eqWord {
                    evaluationArg = func0.argumentValue[i]
                }
            }
            var evaluationArg2 = eqWord2.description
            for i in 0..<func0.argument.count {
                if func0.argument[i] == eqWord2 {
                    evaluationArg2 = func0.argumentValue[i]
                }
            }
            
            if evaluationArg == evaluationArg2 {
                func0.ifScript = script[scriptBigBracket].description
                routineIf(func0: func0)
                return
            } else {
                func0.ifScript = script[elseWordRange].description
                routineIf(func0: func0)
                return
            }
            
        }
        
        var begin010 = script.startIndex
        while let begin01 = script.range(of: "var", options: .caseInsensitive, range: begin010..<script.endIndex) {
            guard let end1 = script.range(of: "=", options: .caseInsensitive, range: begin01.upperBound..<script.endIndex) else {return}
            let varRange = begin01.upperBound..<end1.lowerBound
            var variable = script[varRange]

            while let range = variable.range(of: " ") {
                variable.replaceSubrange(range, with: "")
            }
            varArray.append(variable)

            guard let nl1 = script.range(of: "\n", options: .caseInsensitive, range: end1.upperBound..<script.endIndex) else {return}
            let valRange = end1.upperBound..<nl1.lowerBound
            var value = script[valRange].description
            while let range = value.range(of: " ") {
                value.replaceSubrange(range, with: "")
            }
            while let range = value.range(of: "\"") {
                value.replaceSubrange(range, with: "")
            }
            
            while let arithmetic = value.range(of: "+", options: .caseInsensitive, range: value.startIndex..<value.endIndex) {
                let value1 = value.startIndex..<arithmetic.lowerBound
                let value2 = arithmetic.upperBound..<value.endIndex
                let tmp = Int(value[value1].description)! + Int(value[value2].description)!
                value = tmp.description

            }
            valArray.append(value)
            begin010 = nl1.upperBound
        }

        var nextRange4 = script.startIndex..<script.endIndex
        while let begin4 = script.range(of: "while", options: .caseInsensitive, range: nextRange4 ) {
            guard let openBracket = script.range(of: "(", options: .caseInsensitive, range: begin4.upperBound..<script.endIndex) else {break}
            guard let closeBracket = script.range(of: ")", options: .caseInsensitive, range: openBracket.upperBound..<script.endIndex) else {break}
            let evaluationRange = openBracket.upperBound..<closeBracket.lowerBound

            guard let gr = script[evaluationRange].range(of: "<") else {break}
            
            let grRange = script[evaluationRange].startIndex..<gr.lowerBound
            var grWord = script[grRange]
            while let range = grWord.range(of: " ") {
                grWord.replaceSubrange(range, with: "")
            }
            
            let grRange2 = gr.upperBound..<script[evaluationRange].endIndex
            var grWord2 = script[grRange2]
            while let range = grWord2.range(of: " ") {
                grWord2.replaceSubrange(range, with: "")
            }

            var val1 = 0
            for i in 0..<varArray.count {
                if varArray[i] == grWord {
                    val1 = Int(valArray[i])!
                }
            }
            var val2 = Int(grWord2.description)!
            for i in 0..<varArray.count {
                if varArray[i] == grWord2{
                    val2 = Int(valArray[i])!
                }
            }

            while val1 < val2 {
                guard let openBigBracket = script.range(of: "{", options: .caseInsensitive, range: closeBracket.upperBound..<script.endIndex) else {break}
                guard let closeBigBracket = script.range(of: "}", options: .caseInsensitive, range: openBigBracket.upperBound..<script.endIndex) else {break}
                let scriptBigBracket = openBigBracket.upperBound..<closeBigBracket.lowerBound
                for i in 0..<varArray.count {
                    var begin010 = script[scriptBigBracket].startIndex
                    while let begin01 = script[scriptBigBracket].range(of: varArray[i], options: .caseInsensitive, range: begin010..<script[scriptBigBracket].endIndex) {
                        guard let arithmetic = script[scriptBigBracket].range(of: "+=", options: .caseInsensitive, range: begin01.upperBound..<script[scriptBigBracket].endIndex) else {break}
                        guard let nl = script[scriptBigBracket].range(of: "\n", options: .caseInsensitive, range: arithmetic.upperBound..<script[scriptBigBracket].endIndex) else {return}
                        var value = script[scriptBigBracket][arithmetic.upperBound..<nl.lowerBound]
                        while let range = value.range(of: " ") {
                            value.replaceSubrange(range, with: "")
                        }

                        val1 += Int(value.description)!
                        begin010 = nl.upperBound

                    }
                }
                print(val1)

                
                for i in 0..<funcArray.count {
                    var begin010 = script[scriptBigBracket].startIndex
                    while let begin01 = script[scriptBigBracket].range(of: funcArray[i].function, options: .caseInsensitive, range: begin010..<script[scriptBigBracket].endIndex) {
                        routine(func0: funcArray[i])
                        begin010 = begin01.upperBound

                    }

                    
                    
                    
                }
                
                
                
            }
            nextRange4 = gr.upperBound..<script.endIndex
        }
        
        
        
        
        
        
        for i in 0..<varArray.count {
            while let begin01 = script.range(of: varArray[i], options: .caseInsensitive, range: begin010..<script.endIndex) {
                guard let arithmetic = script.range(of: "+=", options: .caseInsensitive, range: begin01.upperBound..<script.endIndex) else {break}
                guard let nl = script.range(of: "\n", options: .caseInsensitive, range: arithmetic.upperBound..<script.endIndex) else {return}
                var value = script[arithmetic.upperBound..<nl.lowerBound]
                while let range = value.range(of: " ") {
                    value.replaceSubrange(range, with: "")
                }
                let tmp = Int(valArray[i])
                valArray[i] = (tmp! + Int(value.description)!).description
                begin010 = nl.upperBound
            }
        }

        
        
        
        
        var begin020 = script.startIndex
        while let begin = script.range(of: "print(\"", options: .caseInsensitive, range: begin020..<script.endIndex) {
            let nextRange = begin.upperBound..<script.endIndex
            guard let end = script.range(of: "\"", options: .caseInsensitive, range: nextRange) else {return}
            let wordRange = begin.upperBound..<end.lowerBound
            begin020 = end.upperBound
            print(script[wordRange])
        }

        var begin030 = script.startIndex
        while let begin3 = script.range(of: "print(", options: .caseInsensitive, range: begin030..<script.endIndex) {
            let nextRange3 = begin3.upperBound..<script.endIndex
            guard let end3 = script.range(of: ")", options: .caseInsensitive, range: nextRange3) else {return}
            let printRange = begin3.upperBound..<end3.lowerBound
            let print1 = script[printRange]

            for i in 0..<varArray.count {
                if print1 == varArray[i] {
                    print(valArray[i])
                }
            }
            for i in 0..<func0.argument.count {
                if print1 == func0.argument[i] && func0.argumentValue[i] != "" {
                    print(func0.argumentValue[i])
                }
            }
            for i in 0..<funcArray.count {
                if print1 == (funcArray[i].function + "(") {
                    print(funcArray[i].returnValue)
                }
            }
            begin030 = end3.upperBound
        }
    }
    
    func routineIf(func0: Func) {
//        funcParse(script: func0.script)
        let script = func0.ifScript
        var varArray: [Substring] = []
        var valArray: [Substring] = []

        var begin010 = script.startIndex
        while let begin01 = script.range(of: "var", options: .caseInsensitive, range: begin010..<script.endIndex) {
            guard let end1 = script.range(of: "=", options: .caseInsensitive, range: begin01.upperBound..<script.endIndex) else {return}
            let varRange = begin01.upperBound..<end1.lowerBound
            var variable = script[varRange]

            while let range = variable.range(of: " ") {
                variable.replaceSubrange(range, with: "")
            }
            varArray.append(variable)

            guard let nl1 = script.range(of: "\n", options: .caseInsensitive, range: end1.upperBound..<script.endIndex) else {return}
            let valRange = end1.upperBound..<nl1.lowerBound
            var value = script[valRange]
            while let range = value.range(of: " ") {
                value.replaceSubrange(range, with: "")
            }
            while let range = value.range(of: "\"") {
                value.replaceSubrange(range, with: "")
            }
            valArray.append(value)
            begin010 = nl1.upperBound
        }

        var begin020 = script.startIndex
        while let begin = script.range(of: "print(\"", options: .caseInsensitive, range: begin020..<script.endIndex) {
            let nextRange = begin.upperBound..<script.endIndex
            guard let end = script.range(of: "\"", options: .caseInsensitive, range: nextRange) else {return}
            let wordRange = begin.upperBound..<end.lowerBound
            begin020 = end.upperBound
            print(script[wordRange])
        }

        var begin030 = script.startIndex
        while let begin3 = script.range(of: "print(", options: .caseInsensitive, range: begin030..<script.endIndex) {
            let nextRange3 = begin3.upperBound..<script.endIndex
            guard let end3 = script.range(of: ")", options: .caseInsensitive, range: nextRange3) else {return}
            let printRange = begin3.upperBound..<end3.lowerBound
            let print1 = script[printRange]

            for i in 0..<varArray.count {
                if print1 == varArray[i] {
                    print(valArray[i])
                }
            }
            for i in 0..<func0.argument.count {
                if print1 == func0.argument[i] && func0.argument[i] != "" {
                    print(func0.argumentValue[i])
                }
            }
            for i in 0..<funcArray.count {
                if print1 == (funcArray[i].function + "(") {
                    print(funcArray[i].returnValue)
                }
            }
            begin030 = end3.upperBound
        }
    }
}
