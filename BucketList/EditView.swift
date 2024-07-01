//
//  EditView.swift
//  BucketList
//
//  Created by Mehmet Alp Sönmez on 27/06/2024.
//

import SwiftUI

struct EditView: View {
    
    
    @Environment(\.dismiss) var dismiss
    
    @State private var viewModel : EditViewModel
    
    var onSave: (Location) -> Void
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Place name", text: $viewModel.name)
                    TextField("Description", text: $viewModel.description)
                }
                
                Section("Nearby...") {
                    switch viewModel.loadingState {
                    case .loading:
                        Text("Loading")
                    case .loaded:
                        ForEach(viewModel.pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ") +
                            Text(page.description)
                                .italic()
                        }
                    case .failed:
                        Text("PLease Try Again Later")
                    }
                }
            }
            .navigationTitle("Place Details")
            .toolbar {
                Button("Save") {
                    var newLocation = viewModel.location
                    newLocation.id = UUID()
                    newLocation.name = viewModel.name
                    newLocation.description = viewModel.description
                    
                    onSave(newLocation)
                    dismiss()
                }
            }
            
        }
    }
    init(location: Location, onSave: @escaping (Location) -> Void) {
        _viewModel = State(initialValue: EditViewModel(location: location))
        self.onSave = onSave
    }
    
   
}

#Preview {
    EditView(location: .example) { _ in }
}
