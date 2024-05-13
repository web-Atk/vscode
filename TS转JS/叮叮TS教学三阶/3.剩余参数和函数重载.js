// 剩余参数
function fn(x, y) {
    var args = [];
    for (var _i = 2; _i < arguments.length; _i++) {
        args[_i - 2] = arguments[_i];
    }
    console.log(x, y, args);
}
fn('', '', 1, 2, 3, 4, 5);
// 函数重载 ：函数名相同，形参不同的多个函数
// 数字 相加，字符串 拼接  ... 联合类型
function newAdd(x, y) {
    if (typeof x == 'string' && typeof y == "string") {
        // ...
        return x + y; //字符串拼接
    }
    else if (typeof x == "number" && typeof y == "number") {
        // ...
        return x + y; //数字相加
    }
}
console.log(newAdd(1, 2));
console.log(newAdd('张', '三'));
