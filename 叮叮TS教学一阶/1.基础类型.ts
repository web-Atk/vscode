let num: Number = 10
num = 11
function abc(a: string) {
    console.log(a);
}
abc('123')
// 类型声明 指定ts变量（参数，形参）的类型 ts编译器，自动检查
// 类型声明给变量设置了类型，使用变量只能存储某种类型的值

// 布尔类型  boolean

let flag: boolean = true
// flag=123 报错
flag = false

// 数字类型
let a: number = 10 //十进制
let a1: number = 0b1010 //二进制
let a2: number = 0o12 //八进制
let a3: number = 0xa //十六进制
a = 11

// 字符串类型 string
let str: string = '123'
//   str=123
str = ''

// undefined和null,用的不多
let u: undefined = undefined
let n: null = null
console.log(u)
console.log(n)

// u=123
// undefined和null 还可以作为其他类型的子类型
// 可以把undefined和null 赋值给其他类型的变量
let b:number=undefined
let str1:string=null
console.log(b)
console.log(str)