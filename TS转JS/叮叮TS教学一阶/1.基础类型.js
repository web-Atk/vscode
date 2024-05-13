var num = 10;
num = 11;
function abc(a) {
    console.log(a);
}
abc('123');
// 类型声明 指定ts变量（参数，形参）的类型 ts编译器，自动检查
// 类型声明给变量设置了类型，使用变量只能存储某种类型的值
// 布尔类型  boolean
var flag = true;
// flag=123 报错
flag = false;
// 数字类型
var a = 10; //十进制
var a1 = 10; //二进制
var a2 = 10; //八进制
var a3 = 0xa; //十六进制
a = 11;
// 字符串类型 string
var str = '123';
//   str=123
str = '';
// undefined和null,用的不多
var u = undefined;
var n = null;
console.log(u);
console.log(n);
// u=123
// undefined和null 还可以作为其他类型的子类型
// 可以把undefined和null 赋值给其他类型的变量
var b = undefined;
var str1 = null;
console.log(b);
console.log(str);
