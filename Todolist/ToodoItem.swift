//
//  ToodoItem.swift
//  Todolist
//
//  Created by YB on 2019/10/23.
//  Copyright © 2019 YB. All rights reserved.
//
//TodoItem类所做的是显示待办事项，并提供操作
import SwiftUI

//定义一个Todo的类
//继承NSObject, NSCoding
class Todo: NSObject, NSCoding, Identifiable {
    var title: String = ""
    //    定义标题变量
    var dueDate : Date = Date()
    //   swift自带的日期，什么时候要做
    var checked:Bool = false
    //   定义checked变量bool值（有没有打勾）
    var i: Int = 0
    //   定义代办事项是第几个
    
    //初始化函数
    init(title: String,dueDate: Date){
        self.title = title
        self.dueDate = dueDate
    }
    //    解压缩
    required init(coder: NSCoder) {
        self.title = coder.decodeObject(forKey: "title") as? String ?? ""
        self.dueDate = coder.decodeObject(forKey: "dueDate") as? Date ?? Date()
        self.checked = coder.decodeBool(forKey: "checked")
    }
    //    解压缩东西，as?类型转换，不成功返回null，成功返回可选类型值
//    压缩，打包成swift可以存的东西
    func encode(with coder: NSCoder) {
        coder.encode(self.title, forKey: "title")
        coder.encode(self.dueDate,forKey: "dueDate")
        coder.encode(self.checked, forKey: "checked")
    }
}

//通过使用 @State 修饰器我们可以关联出 View 的状态. SwiftUI 将会把使用过 @State 修饰器的属性存储到一个特殊的内存区域，并且这个区域和 View struct 是隔离的. 当 @State 装饰过的属性发生了变化，SwiftUI 会根据新的属性值重新创建视图
//有时候我们会把一个视图的属性传至子节点中，但是又不能直接的传递给子节点，因为在 Swift 中值的传递形式是值类型传递方式，也就是传递给子节点的是一个拷贝过的值。但是通过 @Binding 修饰器修饰后，属性变成了一个引用类型，传递变成了引用传递，这样父子视图的状态就能关联起来了
//@ObservedObject 的用处和 @State 非常相似，从名字看来它是来修饰一个对象的，这个对象可以给多个独立的 View 使用。如果你用 @ObservedObject 来修饰一个对象，那么那个对象必须要实现 ObservableObject 协议，然后用 @Published 修饰对象里属性，表示这个属性是需要被 SwiftUI 监听的
var emptyTodo: Todo = Todo(title: "", dueDate: Date())
//建立一个以Todo作为类型的数据变量
//建立一个空的待办事项
struct ToodoItem: View {
    @ObservedObject var main: Main
    @Binding var todoIndex: Int
    @State var checked: Bool = false
    var body: some View {
//  Hstack左右按钮，点击左边弹出编辑页面，右边打勾
        HStack {
            Button(action: {
                editingMode = true
                editingTodo = self.main.todos[self.todoIndex]
                editingIndex = self.todoIndex
                self.main.detailsTitle = editingTodo.title
                self.main.detailsDueDate = editingTodo.dueDate
                self.main.detailsShowing = true
                detailsShouldUpdateTitle = true
            }){
// 按钮界面，hstack分水平左边是点击编辑页面，右边是d选中打勾
                HStack{
                    VStack{
                        Rectangle()
                            .fill(Color("theme"))
                            .frame(width:8)
                    }
                    Spacer()
                        .frame(width:10)
                    VStack{
                        Spacer()
                            .frame(height:12)
                        HStack{
                            Text(main.todos[todoIndex].title)
                                .font(.headline)
                            Spacer()
                        }
                        .foregroundColor(Color("todoItemTitle"))
                        Spacer()
                            .frame(height:4)
                        HStack{
                            Image(systemName: "clock")
                                .resizable()
                                .frame(width:12, height: 12)
                            Text(formatter.string(from: main.todos[todoIndex].dueDate))
                                .font(.subheadline)
                            Spacer()
                        }.foregroundColor(Color("todoItemSubTitle"))
                        Spacer()
                            .frame(height: 12)
                    }
                }
            }
//            右边按钮
            Button(action:{
                self.main.todos[self.todoIndex].checked.toggle()
                self.checked = self.main.todos[self.todoIndex].checked
                do{
                    let archivedDate = try
                        NSKeyedArchiver.archivedData(withRootObject: self.main.todos, requiringSecureCoding: false)
                    UserDefaults.standard.set(archivedDate, forKey: "todos")
                }catch{
                    print("error")
                }
            }){
                HStack{
                    Spacer()
                        .frame(width: 12)
                    VStack{
                        Spacer()
                        Image(systemName: self.checked ? "checkmark.square.fill" : "square")
                        Spacer()
                    }
                    Spacer()
                        .frame(width: 14)
                }
            }.onAppear {
                self.checked = self.main.todos[self.todoIndex].checked
            }
        }.background(Color(self.checked ? "todoItem-bg-checked" : "todoItem-bg"))
            .animation(.spring())
    }
}

struct ToodoItem_Previews: PreviewProvider {
    static var previews: some View {
        ToodoItem(main: Main(), todoIndex: .constant(0))
    }
}
