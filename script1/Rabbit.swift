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
    init() {
        function = ""
        argument = []
        argumentValue = []
        script = ""
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
            
        } catch let error as NSError {
            print("エラー: \(error)")
            return
        }
    }
    func onTouchDown(p: Float) {
        for i in 0..<funcArray.count {
            if funcArray[i].function == "onTouchDown" {
                let func0: Func = funcArray[i]
                func0.argumentValue.append(p.description)
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
    func searchFunc(script: String) {
        var nextRange0 = script.startIndex..<script.endIndex
        while let begin0 = script.range(of: "func", options: .caseInsensitive, range: nextRange0) {

            nextRange0 = begin0.upperBound..<script.endIndex
            guard let end0 = script.range(of: "(", options: .caseInsensitive, range: nextRange0) else {break}

            let funcRange = begin0.upperBound..<end0.lowerBound
            var function = script[funcRange]

            while let range = function.range(of: " ") {
                function.replaceSubrange(range, with: "")
            }

            let func0: Func = Func()
            func0.function = function.description

            nextRange0 = end0.upperBound..<script.endIndex

            guard let closeBracket = script.range(of: ")", options: .caseInsensitive, range: nextRange0) else {break}
            let argumentRange = end0.upperBound..<closeBracket.lowerBound
            let argument = script[argumentRange]
            
            var argumnetBegin = argument.startIndex
            var flag: Bool = true
            while let argumentEnd = argument.range(of: ",", options: .caseInsensitive, range: argumnetBegin..<argument.endIndex) {
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

            guard let bracket0 = script.range(of: "{", options: .caseInsensitive, range: nextRange0) else {break}
            guard let bracket1 = script.range(of: "}", options: .caseInsensitive, range: nextRange0) else {break}
            let bracketRange = bracket0.upperBound..<bracket1.lowerBound

            func0.script = script[bracketRange].description
            
            funcArray.append(func0)
        }

    }
    func funcParse(script:String) {
        var nextRange1 = script.startIndex..<script.endIndex
        for i in 0..<funcArray.count {
            while let end1 = script.range(of: funcArray[i].function + "(", options: .caseInsensitive, range: nextRange1 ) {
                guard let closeBracket = script.range(of: ")", options: .caseInsensitive, range: end1.upperBound..<script.endIndex) else {break}
                let argumentRange = end1.upperBound..<closeBracket.lowerBound
                var argument = script[argumentRange]
                
                var argumnetBegin = argument.startIndex
                var flag: Bool = true
                while let argumentEnd = argument.range(of: ",", options: .caseInsensitive, range: argumnetBegin..<argument.endIndex) {
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
//                while let range = argument.range(of: " ") {
//                    argument.replaceSubrange(range, with: "")
//                }

//                funcArray[i].argumentValue.append(argument)
                routine(func0: funcArray[i])
                nextRange1 = argumentRange.upperBound..<script.endIndex
            }
        }

    }
    func routine(func0: Func) {
        let script = func0.script
        funcParse(script: script)

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

            begin030 = end3.upperBound
        }
    }
}
