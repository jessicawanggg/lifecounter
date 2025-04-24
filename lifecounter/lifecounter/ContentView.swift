//
//  ContentView.swift
//  lifecounter
//
//  Created by Jessica Wang on 4/21/25.
//

import SwiftUI

struct Player: Identifiable {
    let id = UUID()
    var name: String
    var life: Int
    var isAlive: Bool { life > 0 }
}

struct ContentView: View {
    @State private var players: [Player] = (1...4).map { Player(name: "Player \($0)", life: 20) }
    @State private var history: [String] = []
    @State private var loser: String?
    @State private var gameStarted = false
    @State private var showGameOver = false
    @State private var winner: String?

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button("Add Player") {
                        let newNumber = players.count + 1
                        players.append(Player(name: "Player \(newNumber)", life: 20))
                    }
                    .disabled(gameStarted || players.count >= 8)
                    .padding()

                    Button("Reset") {
                        resetGame()
                    }
                    .padding()

                    NavigationLink(destination: HistoryView(history: history)) {
                        Text("History")
                    }
                    .padding()
                }

                ScrollView {
                    VStack(spacing: 20) {
                        ForEach($players) { $player in
                            PlayerView(
                                player: $player,
                                onLifeChange: {
                                    gameStarted = true
                                    logAndCheck(player: player)
                                },
                                history: $history
                            )
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                }

                if let loser = loser {
                    Text("\(loser) LOSES!")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                        .bold()
                        .padding(.top, 20)
                }
            }
            .padding()
            .alert("Game Over!", isPresented: $showGameOver) {
                Button("OK", role: .cancel) {
                    resetGame()
                }
            } message: {
                if let winner = winner {
                    Text("\(winner) is the last one standing!")
                }
            }
        }
    }

    private func logAndCheck(player: Player) {
        if player.life <= 0 {
            loser = player.name
        } else {
            loser = nil
        }

        let alivePlayers = players.filter { $0.isAlive }
        if alivePlayers.count == 1, let last = alivePlayers.first {
            winner = last.name
            showGameOver = true
        }
    }

    private func resetGame() {
        players = (1...4).map { Player(name: "Player \($0)", life: 20) }
        history = []
        loser = nil
        winner = nil
        showGameOver = false
        gameStarted = false
    }
}

struct PlayerView: View {
    @Binding var player: Player
    var onLifeChange: () -> Void
    @Binding var history: [String]
    @State private var customChange: String = "5"
    @State private var showNameEditor = false
    @State private var editedName: String = ""

    var body: some View {
        VStack(spacing: 8) {
            Button(action: {
                editedName = player.name
                showNameEditor = true
            }) {
                Text(player.name)
                    .font(.headline)
                    .bold()
            }

            Text("\(player.life)")
                .font(.system(size: 32))
                .padding(4)

            HStack(spacing: 6) {
                Button("-") {
                    player.life -= 1
                    history.append("\(player.name) lost one life.")
                    onLifeChange()
                }

                Button("+") {
                    player.life += 1
                    history.append("\(player.name) gained one life.")
                    onLifeChange()
                }

                TextField("N", text: $customChange)
                    .keyboardType(.numberPad)
                    .frame(width: 36)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(.roundedBorder)

                Button("-N") {
                    if let change = Int(customChange) {
                        player.life -= change
                        history.append("\(player.name) lost \(change) life.")
                        onLifeChange()
                    }
                }

                Button("+N") {
                    if let change = Int(customChange) {
                        player.life += change
                        history.append("\(player.name) gained \(change) life.")
                        onLifeChange()
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.small)
        }
        .padding(10)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .alert("Edit Name", isPresented: $showNameEditor, actions: {
            TextField("Player Name", text: $editedName)
            Button("OK") {
                player.name = editedName
            }
            Button("Cancel", role: .cancel) {}
        })
    }
}

struct HistoryView: View {
    var history: [String]

    var body: some View {
        List(history.indices, id: \.self) { index in
            Text(history[index])
        }
        .navigationTitle("Game History")
    }
}
