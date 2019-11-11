//
//  TodoDetails.swift
//  Todolist
//
//  Created by YB on 2019/10/23.
//  Copyright © 2019 YB. All rights reserved.
//

import SwiftUI

struct TodoDetails: View {
    @ObservedObject var main: Main
    @State var confirmingCancel: Bool = false
    var body: some View {
        VStack{
            Spacer().frame(height: 20)
            HStack{
                Button(action: {
                    //  若点击取消按钮则把键盘忽略
                    UIApplication.shared.keyWindow?.endEditing(true)
                    self.main.detailsShowing = false
                }){
                    Text("取消").padding()
                }
                Spacer()
                Button(action: {
                    UIApplication.shared.keyWindow?.endEditing(true)
                    if editingMode{
                        // 每次完成后更新标题日期
                        self.main.todos[editingIndex].title =
                            self.main.detailsTitle
                        self.main.todos[editingIndex].dueDate =
                            self.main.detailsDueDate
                        // 不在编辑，创建新事项后，添加进去
                    } else{
                        let newTodo = Todo(title: self.main.detailsTitle, dueDate: self.main.detailsDueDate)
                        self.main.todos.append(newTodo)
                    }
                    self.main.sort()
                    // 保存
                    do{
                        let archivedDate = try
                            NSKeyedArchiver.archivedData(withRootObject: self.main.todos, requiringSecureCoding: false)
                        UserDefaults.standard.set(archivedDate, forKey: "todos")
                    }catch{
                        print("error")
                    }
                    //  添加后关闭
                    self.main.detailsShowing = false
                }){
                //  若为编辑页面则为‘完成’若不是则为‘添加’
                    Text(editingMode ? "完成" : "添加").padding()
                }.disabled(main.detailsTitle == "")
            }
            // 添加文本框
            SATextField(tag: 0, text: editingTodo.title, placeholder: "写点什么",  changeHandler: { (newString)in
                self.main.detailsTitle = newString
            } ){
            }
            .padding(8)
            .foregroundColor(.white)
            //        选择截止日期
            //        日期选择器更改后变量也更改
            
            DatePicker(selection: $main.detailsDueDate,displayedComponents: .date, label: {() -> EmptyView in})
                .padding()
            Spacer()
        }
        .padding()
        .background(Color("todoDetails-bg"))
        .edgesIgnoringSafeArea(.all)
    }
}

struct TodoDetails_Previews: PreviewProvider {
    static var previews: some View {
        TodoDetails(main: Main())
    }
}
