interface ISearchFunc {
    // (参数:类型,....):  返回值的类型
    (a: string, b: string): boolean
}
// 参数，返回值
const fun2: ISearchFunc = function (a: string, b: string): boolean {
    return a.search(b) !==-1
}
console.log(fun2('123','1') );
