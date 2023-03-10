//
//  ContentView.swift
//  Tic-Tac-Toe
//
//  Created by Ayşenur ÖZBAY on 3.01.2023.
//

import SwiftUI


struct ContentView: View {
    let columns: [GridItem] = [ GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible()) ,

    ]
    
    @State private var moves: [Move?] = Array(Array(repeating: nil, count: 9))
    @State private var isBoardDisable = false
    var body: some View {
        GeometryReader { geometry in
            VStack{
                Spacer()
                LazyVGrid(columns: columns, spacing: 5){
               
                    
                    ForEach(0..<9){ i in
                        ZStack{
                            Circle()
                                .foregroundColor(.purple).opacity(0.5)
                                .frame(width: geometry.size.width/3 - 15,
                                       height: geometry.size.width/3 - 15)
                            Image(systemName: moves[i]?.indicator ?? "")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                        }
                        .onTapGesture {
                            if isCellOccupied(in: moves, forIndex: i){return}
                            moves[i] = Move(player: .human, boardIndex: i)
                            isBoardDisable = true
                            
                            
                            if chechWinCondition(for: .human, in: moves){
                                print("HUMAN WİNS")
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                let computerPos = determineComputerMove(in: moves)
                                moves[computerPos] = Move(player: .computer, boardIndex: computerPos)
                                isBoardDisable = false
                                
                                if chechWinCondition(for: .human, in: moves){
                                    print("HUMAN WİNS");
                                }
                            }
                        }
                        
                    }
                }
                
                Spacer()
            }
            .disabled(isBoardDisable)
            .padding()
        }
       
    }
    
    func isCellOccupied(in moves: [Move?], forIndex index: Int) ->Bool{
        return moves.contains(where: {$0?.boardIndex == index} )
    }
    
    func determineComputerMove(in moves:[Move?]) -> Int {
        var movePosition = Int.random(in: 0..<9)

        while isCellOccupied(in: moves, forIndex: movePosition) {
            movePosition = Int.random(in: 0..<9)

        }
        
        return movePosition
    }
    
    func chechWinCondition(for player: Player , in moves: [Move?]) -> Bool {
        let winPatterns: Set<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
        
        let playerMoves = moves.compactMap{$0}.filter{$0.player == player}
        let playerPositions = Set(playerMoves.map{$0.boardIndex})
        
        
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) {return true }
        
        
        return false
    }
}


enum Player {
    case human , computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator: String{
        return player == .human ? "xmark" : "circle"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
