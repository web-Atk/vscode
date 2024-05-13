var getName = function (x, y, z) {
    if (z === void 0) { z = '你好'; }
    return x + y + z;
};
// 可选参数? 必选参数不能位于可选参数后
// console.log(getName('张'));
// 默认参数 是可以放在必选参数以及可选参数之后
console.log(getName('张三'));
