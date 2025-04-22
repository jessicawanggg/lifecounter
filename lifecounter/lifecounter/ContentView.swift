//
//  ContentView.swift
//  lifecounter
//
//  Created by Jessica Wang on 4/21/25.
//

import SwiftUI

struct ContentView: View {
    @State private var player1Life = 20
    @State private var player2Life = 20
    @State private var loser: String?

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 20) {
                PlayerView(playerName: "Player 1", lifeTotal: $player1Life, onLifeChange: checkForLoser)
                PlayerView(playerName: "Player 2", lifeTotal: $player2Life, onLifeChange: checkForLoser)

                if let loser = loser {
                    Text("\(loser) LOSES!")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                        .bold()
                        .padding(.top, 20)
                }
            }
            .padding()
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }

    private func checkForLoser() {
        if player1Life <= 0 {
            loser = "Player 1"
        } else if player2Life <= 0 {
            loser = "Player 2"
        } else {
            loser = nil
        }
    }
}

struct PlayerView: View {
    var playerName: String
    @Binding var lifeTotal: Int
    var onLifeChange: () -> Void

    var body: some View {
        VStack {
            Text(playerName)
                .font(.title)
                .bold()

            Text("\(lifeTotal)")
                .font(.system(size: 50))
                .padding()

            HStack(spacing: 10) {
                Button(action: {
                    lifeTotal -= 5
                    onLifeChange()
                }) {
                    Text("-5")
                }

                Button(action: {
                    lifeTotal -= 1
                    onLifeChange()
                }) {
                    Text("-")
                }

                Button(action: {
                    lifeTotal += 1
                    onLifeChange()
                }) {
                    Text("+")
                }

                Button(action: {
                    lifeTotal += 5
                    onLifeChange()
                }) {
                    Text("+5")
                }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}
