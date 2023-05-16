//
//  ContentView.swift
//  SongView
//
//  Created by Ishaan Solipuram on 15/05/23.
//

import SwiftUI

struct TrackView: View {
    let tracks = [
        Track(id: "1", imageURL: "https://skateparkoftampa.com/spot/headshots/4322.jpg", songName: "Track 1", artistName: "Artist 1"),
        Track(id: "2", imageURL: "https://skateparkoftampa.com/spot/headshots/4322.jpg", songName: "Track 2", artistName: "Artist 2"),
        Track(id: "3", imageURL: "https://example.com/track3.jpg", songName: "Track 3", artistName: "Artist 3"),
        Track(id: "4", imageURL: "https://example.com/track4.jpg", songName: "Track 4", artistName: "Artist 4"),
        Track(id: "5", imageURL: "https://example.com/track5.jpg", songName: "Track 5", artistName: "Artist 5")
    ]
    
    var body: some View {
        SongView(tracks: tracks)
    }
}

import SwiftUI

struct SongView: View {
    let tracks: [Track]
    @State private var selectedTrackIds = Set<String>()
    
    var body: some View {
        VStack {
            List(tracks, id: \.id) { track in
                TrackRow(track: track, isSelected: selectedTrackIds.contains(track.id)) {
                    if selectedTrackIds.contains(track.id) {
                        selectedTrackIds.remove(track.id)
                    } else {
                        selectedTrackIds.insert(track.id)
                    }
                }
            }
            Button("Submit") {
                let selectedIds = Array(selectedTrackIds)
                print("Selected track ids: \(selectedIds)")
            }
            .disabled(selectedTrackIds.isEmpty)
        }
    }
}

struct TrackRow: View {
    let track: Track
    let isSelected: Bool
    let toggleSelection: () -> Void
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: track.imageURL)) { image in
                image.resizable()
                    .scaledToFit()
            } placeholder: {
                Image(systemName: "music.note")
                    .foregroundColor(.gray)
                    .frame(width: 50, height: 50)
            }
            .frame(width: 50, height: 50)
            
            VStack(alignment: .leading) {
                Text(track.songName)
                    .font(.headline)
                Text(track.artistName)
                    .font(.subheadline)
            }
            
            Spacer()
            
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isSelected ? .green : .gray)
                .onTapGesture {
                    toggleSelection()
                }
        }
    }
}

