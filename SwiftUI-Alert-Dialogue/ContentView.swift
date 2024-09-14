//
//  ContentView.swift
//  SwiftUI-Alert-Dialogue
//
//  Created by Seungsub Oh on 9/14/24.
//

import SwiftUI

struct ContentView: View {
    @State private var showPopup = false
    @State private var showAlert = false
    @State private var isWrongPassword = false
    @State private var isTryigAgain = false
    
    var body: some View {
        NavigationStack {
            Button("Show Popup") {
                showPopup.toggle()
            }
            .navigationTitle("Documents")
        }
        .popView(isPresented: $showPopup, onDismiss: {
            showAlert = isWrongPassword
            isWrongPassword = false
        }, content: {
            CustomAlertWithTextField(
                show: $showPopup) { password in
                    isWrongPassword = password != "iJustine"
                }
        })
        .popView(isPresented: $showAlert) {
            showPopup = isTryigAgain
            isTryigAgain = false
        } content: {
            CustomAlert(show: $showAlert) {
                isTryigAgain = true
            }
        }

    }
}

struct CustomAlertWithTextField: View {
    @Binding var show: Bool
    var onUnlock: (String) -> Void
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "person.badge.key.fill")
                .font(.title)
                .foregroundStyle(.white)
                .frame(width: 65, height: 65)
                .background {
                    Circle()
                        .fill(.blue.gradient)
                        .background {
                            Circle()
                                .fill(.background)
                                .padding(-5)
                        }
                }
            
            Text("Locked File")
                .fontWeight(.semibold)
            
            Text("This file has been locked by the user, please enter the password to continue.")
                .multilineTextAlignment(.center)
                .font(.caption)
                .foregroundStyle(.gray)
                .padding(.top, 5)
            
            SecureField("Password", text: $password)
                .padding(.vertical, 10)
                .padding(.horizontal, 15)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.bar)
                }
                .padding(.vertical, 10)
            
            HStack(spacing: 10) {
                Button {
                    show = false
                } label: {
                    Text("Cancel")
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 25)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.red.gradient)
                        }
                }
                
                Button {
                    show = false
                    onUnlock(password)
                } label: {
                    Text("Unlock")
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 25)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.blue.gradient)
                        }
                }
            }
        }
        .frame(width: 250)
        .padding([.horizontal, .bottom], 25)
        .background {
            RoundedRectangle(cornerRadius: 25)
                .fill(.background)
                .padding(.top, 25)
        }
    }
}

struct CustomAlert: View {
    @Binding var show: Bool
    var onTryAgain: () -> Void
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "lock.trianglebadge.exclamationmark.fill")
                .font(.title)
                .foregroundStyle(.white)
                .frame(width: 65, height: 65)
                .background {
                    Circle()
                        .fill(.red.gradient)
                        .background {
                            Circle()
                                .fill(.background)
                                .padding(-5)
                        }
                }
            
            Text("Wrong Password")
                .fontWeight(.semibold)
            
            Text("Please enter the correct password to unlock the file.")
                .multilineTextAlignment(.center)
                .font(.caption)
                .foregroundStyle(.gray)
                .padding(.top, 5)
            
            HStack(spacing: 10) {
                Button {
                    show = false
                } label: {
                    Text("Cancel")
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 25)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.red.gradient)
                        }
                }
                
                Button {
                    show = false
                    onTryAgain()
                } label: {
                    Text("Try again")
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 25)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.blue.gradient)
                        }
                }
            }
        }
        .frame(width: 250)
        .padding([.horizontal, .bottom], 25)
        .background {
            RoundedRectangle(cornerRadius: 25)
                .fill(.background)
                .padding(.top, 25)
        }
    }
}

#Preview {
    ContentView()
}
