// 剩余参数
function fn(x: string, y: string, ...args: number[]) {
    console.log(x, y, args);

}
fn('', '', 1, 2, 3, 4, 5)
// 函数重载 ：函数名相同，形参不同的多个函数
// 数字 相加，字符串 拼接  ... 联合类型
function newAdd(x:string|number,y:string|number):string|number{
    if(typeof x=='string' && typeof y=="string"){
        // ...
        return x+y //字符串拼接
    }else if(typeof x=="number" && typeof y=="number"){
        // ...
        return x+y //数字相加
    }
}
console.log(newAdd(1,2));
console.log(newAdd('张','三'));

