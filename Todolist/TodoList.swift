//
//  TodoList.swift
//  Todolist
//
//  Created by YB on 2019/10/23.
//  Copyright © 2019 YB. All rights reserved.
//

import SwiftUI

//创建一个列表
var exampleTodos: [Todo] = [
    Todo(title: "写作业", dueDate: Date()),
    Todo(title: "看视频", dueDate: Date().addingTimeInterval(200000)),
    Todo(title: "看书", dueDate: Date()),
    Todo(title: "听歌", dueDate: Date()),
    Todo(title: "打球", dueDate: Date()),
]


struct TodoList: View {
    @ObservedObject var main: Main
    var body: some View {
        NavigationView {
//            滚动查看
            ScrollView {
//             foreach遍历一遍事项
                ForEach(main.todos) { todo in
                    VStack {
                        //日期分类栏
                        if todo.i == 0 || formatter.string(from: self.main.todos[todo.i].dueDate) != formatter.string(from: self.main.todos[todo.i - 1].dueDate) {
                            HStack {
                                Spacer()
                                    .frame(width: 30)
//             data2word将日期转换为中文
                                Text(date2Word(date: self.main.todos[todo.i].dueDate))
                                Spacer()
                            }
                        }
//                        显示待办事项
                        HStack {
                            Spacer().frame(width: 20)
                            ToodoItem(main: self.main, todoIndex: .constant(todo.i))
                                .cornerRadius(10.0)
                                .clipped()
                                .shadow(color: Color("todoItemShadow"), radius: 5)
                            Spacer().frame(width: 25)
                        }
                        Spacer().frame(height: 20)
                    }
                }
                Spacer()
                    .frame(height: 150)
            }
                //ForEach遍历main.todos 每次遍历都有当前todo
                //日期分类栏，todo.i表示排行第几。如果当前待办事项日期等于当前待办事项的上一个待办事项的日期，则显示文本
                //date2Word日期转换为中文洗澡
                //显示待办事项：将main传进去。.clipped让上两个是一个整体
                //.shadow阴影
                .edgesIgnoringSafeArea(.bottom)
                //          适配iPhone
                .navigationBarTitle(Text("待办事项"))
                .foregroundColor(Color("theme"))
                //          生成一个文本
                // 当显示时更新数据。从UserDefaults“todos”获取数据变成date数据类型
                //          如果获取成功则加载数据，否则空
//                每次显示更新数据
                .onAppear{
//                    读取数据，转成data数据类型。
                    if let data = UserDefaults.standard.object(forKey: "todos") as?
                        Data {
//                        若成功获取数据，则加载此数据，否则为空
                        let todolist = NSKeyedUnarchiver.unarchiveObject(with: data)
                            as? [Todo] ?? []
                        //   将数据放在页面，若todo没有打勾则显示
                        for todo in todolist {
                            if !todo.checked {
                                self.main.todos.append(todo)
                            }
                        }
                        self.main.sort()
                    }else{
                        self.main.todos = exampleTodos
                        self.main.sort()
                        //            若没有成功解压则返回exampleTodos内容
                    }
            }
        }
    }
}

struct TodoList_Previews: PreviewProvider {
    static var previews: some View {
        TodoList(main: Main())
    }
}
