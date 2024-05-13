let getName = function (x: string,y?: string, z:string='你好'): string {
    return x + y + z
}
// 可选参数? 必选参数不能位于可选参数后
// console.log(getName('张'));
// 默认参数 是可以放在必选参数以及可选参数之后
console.log(getName('张三'));
