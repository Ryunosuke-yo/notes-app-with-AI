//
//  DynamicHeightTextEditor.swift
//  Notes
//
//  Created by Ryunosuke Yokokawa on 2023-05-19.
//

import SwiftUI

struct DynamicHeightTextEditor: View {
    @Binding var text: String
    let placeholder: String
    let maxHeight: CGFloat
    var body: some View {
                ZStack(alignment: .leading) {
                    // プレースホルダー
                    if text.isEmpty {
                        Text(placeholder)
                            .foregroundColor(.gray)
                            .padding(.leading, 5)
                    }

                    // テキストエディター
                    HStack {
                        Text(text.isEmpty ? " " : text)
                        Spacer(minLength: 0)
                    }
                    .allowsHitTesting(false)
                    .foregroundColor(.clear)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 10)
                    .background(TextEditor(text: $text).offset(y: 1.8))
                }
                .padding(.horizontal, 10)
                .frame(maxHeight: maxHeight) // テキストエディタの最大サイズを設定する
                .fixedSize(horizontal: false, vertical: true) // テキストエディタの最大サイズを設定する
                .scrollContentBackground(.hidden)
                .mask(RoundedRectangle(cornerRadius: 18).padding(.vertical, 3))
//                .background(RoundedRectangle(cornerRadius: 18).stroke(lineWidth: 1).padding(.vertical, 3))
                .onAppear {
                    UITextView.appearance().backgroundColor = .clear // TextEditor の背景色を clear にする
                }
                .onDisappear {
                    UITextView.appearance().backgroundColor = nil
                }
            
        
    }
}

//struct DynamicHeightTextEditor_Previews: PreviewProvider {
//    static var previews: some View {
//        DynamicHeightTextEditor(text: "ss", placeholder: <#String#>, maxHeight: <#CGFloat#>)
//    }
//}
