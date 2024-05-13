// 它是对行为的抽象，用于对 [对象的形状(Shape)] 进行描述,理解为一种约束
// 接口一般首字母大写，
// 定义的变量比接口少了一些属性是不允许的，不能多出其他的属性
// ?表示可选属性，定义对象?的属性可有可无
// [propName:string]:any 任意属性和任意属性值
// [propName:string]:string 需要注意的是，一旦定义了任意属性，那么确定属性和可选属性的类型都必须是它的子集
// 一个接口中只能定义一个任意属性。如果接口中有多个类型的属性，则可以在任意属性中使用联合类型
// 可以用 readonly 定义只读属性
// 定义接口
interface IPerson{
    readonly id:number,
    name:string,
    age:number,
    sex?:string,
    // [propName:string]:any
    [propName:string]:string|number|boolean
}
let p:IPerson={
    id:10,
    name:'张三',
    age:18,
    // sex:'男'
    width:123,//报错
}
// p.id=11