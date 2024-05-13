//  表示取值可以为多种类型中的一种
// flag true,1  false,0  ||
var f = true;
// 只能访问此联合类型的所有类型里共有的属性或方法
f = 123; //再次赋值，走类型推断，给变量定义一个类型
f = '123';
f = true;
console.log(f.toString());
