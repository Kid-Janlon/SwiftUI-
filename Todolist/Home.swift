//
//  Home.swift
//  Todolist
//
//  Created by YB on 2019/10/23.
//  Copyright © 2019 YB. All rights reserved.
//
//app主页

import SwiftUI
//定义全局变量，存放当前状态
var editingMode: Bool = false
//ture为编辑已存在的事项，false代表点击添加
var editingTodo: Todo = emptyTodo
//用来存放用户正在编辑的待办事项
var editingIndex: Int = 0
//用户编辑的第几个事项
var detailsShouldUpdateTitle: Bool = false
//用户编辑时，告诉系统要更新

//定义main类
class Main: ObservableObject {
    @Published var todos : [Todo] = []
    //   @Published 实时更新界面。存放待办事项
    @Published var detailsShowing: Bool = false
    //    是否弹出编辑框
    @Published var detailsTitle: String = ""
    //    文本框内容，detailsTitle被更改文本框内容被更改
    @Published var detailsDueDate: Date = Date()
    
    
    //    定义sort方法按日期从远到近排序
    func sort(){
        self.todos.sort(by: { $0.dueDate.timeIntervalSince1970 <
            $1.dueDate.timeIntervalSince1970})
        for i in 0 ..< self.todos.count{
            self.todos[i].i = i
        }
    }
}



struct Home: View {
    @ObservedObject var main: Main
    var body: some View {
        ZStack {
            TodoList(main: main)
        //毛玻璃特效
               .blur(radius: main.detailsShowing ? 10 : 0)
                .animation(.spring())
            //点击按钮弹出输入框
            Button(action: {
                editingMode = false
                editingTodo = emptyTodo
                detailsShouldUpdateTitle = true
                self.main.detailsTitle = ""
                self.main.detailsDueDate = Date()
                self.main.detailsShowing = true
                
            }){
                btnAdd()
            }
//                将按钮移动到右下角
            .blur(radius: main.detailsShowing ? 10 : 0)
            .offset(x: UIScreen.main.bounds.width/2-60, y:UIScreen.main.bounds.height/2 - 80)
            .animation(.spring())
                
            //  显示并判断是否显示
            TodoDetails(main: main)
                .offset(x: 0, y: main.detailsShowing ? 0 : UIScreen.main.bounds.height)
                .animation(.spring())
        }
    }
}

//按钮
//HStack横向 VStack纵向排列 ZStack叠层
struct btnAdd: View {
    var size: CGFloat = 65.0
    var body: some View{
        ZStack {
            Group{
                Circle()
                    .fill(Color("btnAdd-bg"))
            }.frame(width: self.size, height: self.size)
                .shadow(color: Color("btnAdd-shadow"),radius: 10)
            Group {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: size, height: size)
                    .foregroundColor(Color("theme"))
                
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(main: Main())
    }
}
