//
//  HomeView.swift
//  PresentationLayer
//
//  Created by Christos Condrea on 9/2/25.
//

import SwiftUI

public struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    @State var isLoadedOnce: Bool = false
    public init() {
        self._viewModel = StateObject(wrappedValue: HomeViewModel())
    }
    
    public var body: some View {
        NavigationStack {
            VStack {
                switch viewModel.state {
                case .loading, .reset:
                    VStack {
                        Text("WAITING")
                            .background(Color.red)
                    }
                case .success(let todoList):
                    NavigationLink {
                        VStack {
                            SecondView()
                        }
                    } label: {
                        VStack {
                            Text(todoList.title)
                            Text(todoList.userId.description)
                        }
                    }
                @unknown default:
                    VStack { Text("FAIL")}
                }
            }.onChange(of: viewModel.state) { oldValue, newValue in
                print("old", oldValue.equatableValue)
                print("new", newValue.equatableValue)
            }
            .task {
              if !isLoadedOnce {
                await viewModel.fetch(at: 1)
                isLoadedOnce = true
              }
            }
        }
        
        
    }
}

#Preview {
    HomeView()
}


struct SecondView: View {
    @StateObject var viewModel = SecondViewModel()
    
    init() {}
    
    var body: some View {
        VStack {
            switch viewModel.state {
            case .loading, .reset:
                VStack {
                    Text("WAITING")
                        .background(Color.red)
                }
            case .success(let todoList):
                NavigationLink {
                    VStack {
                        Text("Second View")
                    }
                } label: {
                    VStack {
                        Text(todoList.title)
                        Text(todoList.userId.description)
                    }
                }
            @unknown default:
                VStack { Text("FAIL")}
            }
        }.onAppear {
            Task {
                await viewModel.fetch(at: 2)
            }
        }
    }
}
