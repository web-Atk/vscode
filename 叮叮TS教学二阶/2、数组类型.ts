//不常用，理解就可以
interface INewArray{
    [index:number]:number // 任意属性，index表示数组中的下标
}
// [1,2,3,4]  arr[0]-->obj['name']
// 0,1,2,3
let arr:INewArray=[1,2,3,4]