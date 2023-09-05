//
//  main.swift
//  aoct
//
//  Created by Yaroslav Petryk on 03.09.2023.
//



import Foundation

struct Day6 {
    static func run() throws {
        func checkUnique(_ string: Substring) -> Bool {
            guard let first = string.first else { return true }
            let next = string.dropFirst()
            if next.contains(first) { return false }
            return checkUnique(next)
        }
        
        let input = try String(contentsOfFile: "day6.txt")
        //    let input = "mjqjpqmgbljsphdztnvjfqwrcgsmlb"
        
        for (i, strIdx) in input.indices.enumerated().dropFirst(13) {
            let start = input.index(strIdx, offsetBy: -13)
            if checkUnique(input[start...strIdx]) {
                print("Index = \(i + 1)")
                break
            }
        }
    }
}

struct Day7 {
    // cd | ls
    enum Command {
        case cd(CD)
        case ls(output: [FSItem])
    }
    
    // cd / | cd .. | cd <dirname>
    enum CD {
        case root
        case up
        case dir(dirname: String)
    }
    
    // dir <dirname> | <size> <filename>
    enum FSItem {
        case file(size: Int, name: String)
        case dir(name: String)
    }
    
    /*
     [
        .cd(.root),
        .ls([.dir("a"), .file(...), .file(...), .dir("d")]),
        .cd(.dir("a")),
        .ls([.dir("e"), .file(...), .file(...), .file(...)]),
        ...
     ]
     */
    
    static func parse(input: String) -> [Command] {
        input.split(separator: "$" ).map { commandStr in
            parse(command: commandStr.trimmingCharacters(in: .whitespacesAndNewlines))
        }
    }
    
    static func parse(command: String) -> Command {
        if let cdMatch = try! #/^cd (?<path>.+)$/#.wholeMatch(in: command) {
            return .cd(parse(cdPath: cdMatch.output.path))
        }
        if let lsMatch = try! #/^ls\n(?<output>(.|\n)+)$/#.wholeMatch(in: command) {
            return .ls(output: parse(lsOutput: lsMatch.output.output))
        }
        fatalError("Tried to parse a command that is neither cd, nor ls: \(String(reflecting: command))")
    }
    
    static func parse(cdPath path: Substring) -> CD {
        switch path {
        case "/": return .root
        case "..": return .up
        default: return .dir(dirname: String(path))
        }
    }
    
    static func parse(lsOutput output: Substring) -> [FSItem] {
        output.split(separator: "\n").map{ parse(fsItem: $0) }
    }
    
    static func parse(fsItem: Substring) -> FSItem {
        if let match = try! #/dir (?<name>.+)/#.wholeMatch(in: fsItem) {
            return .dir(name: String(match.output.name))
        }
        if let match = try! #/(?<size>\d+) (?<name>.+)/#.wholeMatch(in: fsItem) {
            return .file(size: Int(match.output.size)!, name: String(match.output.name))
        }
        fatalError()
    }
    
    static let testInput = """
    $ cd /
    $ ls
    dir a
    14848514 b.txt
    8504156 c.dat
    dir d
    $ cd a
    $ ls
    dir e
    29116 f
    2557 g
    62596 h.lst
    $ cd e
    $ ls
    584 i
    $ cd ..
    $ cd ..
    $ cd d
    $ ls
    4060174 j
    8033020 d.log
    5626152 d.ext
    7214296 k
    """
    

    
    static func run() throws {
//        let input = try String(contentsOfFile: "day7.txt")
        pprint(parse(input: testInput))
    }
}

func pprint<T>(_ array: [T]) {
    if array.isEmpty { print("[]") }
    else {
        print("[\n\t\(array.map { String(describing: $0) }.joined(separator: ",\n\t"))\n]")
    }
}

try Day7.run()
