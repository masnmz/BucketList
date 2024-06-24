//
//  ContentView.swift
//  BucketList
//
//  Created by Mehmet Alp Sönmez on 21/06/2024.
//

import SwiftUI
struct LoadingView: View {
    var body: some View {
        Text("Loading")
    }
    
}

struct SuccessView: View {
    var body: some View {
        Text("Success")
    }
}

struct FailedView: View {
    var body: some View {
        Text("Failed")
    }
}
struct ContentView: View {
    enum LoadingState {
        case loading, success, failed
    }
    
    @State private var loadingState = LoadingState.loading
    
    var body: some View {
        switch loadingState {
        case .loading:
            LoadingView()
        case .success:
            SuccessView()
        case .failed:
            FailedView()
        }
        Button("Read and Write") {
            let data = Data("Test Message".utf8)
            let url = URL.documentsDirectory.appending(path: "message.txt")
            
            do {
                try data.write(to: url, options: [.atomic, .completeFileProtection])
                let input = try String(contentsOf: url)
                print(input)
            } catch {
                print(error.localizedDescription)
            }
            
        }
        if Bool.random() {
            Rectangle()
        } else {
            Circle()
        }
    }
    
}

#Preview {
    ContentView()
}
