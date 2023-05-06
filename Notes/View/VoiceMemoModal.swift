//
//  VoiceMemoModal.swift
//  Notes
//
//  Created by Ryunosuke Yokokawa on 2023-05-05.
//

import SwiftUI

struct VoiceMemoModal: View {
    var body: some View {
        ZStack {
            Color.primaryGray.ignoresSafeArea()
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Spacer()
                    Image(systemName: "xmark")
                          .resizable()
                          .frame(width: 15, height: 15)
                          .foregroundColor(.primaryWhite)
                }
                .padding(.trailing, 20)
              
                   
                
                Text("New Voice Memo")
                    .font(Font.mainFont(30))
                    .foregroundColor(.primaryWhite)
                    .tracking(1)
                    .bold()
                
                Text("01:23:32")
                    .font(Font.mainFont(18))
                    .foregroundColor(.primaryWhite)
                    .tracking(1)
                    .padding(.top, 10)
                
                Image(systemName: "waveform")
                    .resizable()
                    .frame(width: 80, height: 90)
                    .foregroundColor(.primaryWhite)
                    .padding(.top, 20)
                
                Circle()
                    .foregroundColor(.recordRed)
                    .frame(width: 90, height: 90)
                    .padding(.top, 20)
                
                Spacer()
                    
            }
            
          
            .padding(.top, 20)
            
            
        }
        
       
    }
    
}

struct VoiceMemoModal_Previews: PreviewProvider {
    static var previews: some View {
        VoiceMemoModal()
    }
}
