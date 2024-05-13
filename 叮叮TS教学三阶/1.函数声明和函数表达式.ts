//  函数声明，命名函数
// function add(a,b){
//     return a+b
// }
// //  函数表达式，匿名函数
// let add2=function(a,b){
//     return a+b
// }

// ts  函数声明，命名函数
// a 和 b 都是number类型
// :number 表示该函数的返回值为number类型
function add(a: number, b: number): number {
    return a + b
}
console.log(add(1, 2));
let c: number = add(1, 2)
console.log(c);

// 函数表达式，匿名函数
let add2 = function (a: number, b: number) {
    return a + b
}
console.log(add2(1,2));
// 函数完整的写法
let add3:(a:number,b:number) =>number= function (a: number, b: number) {
    return a + b
}
