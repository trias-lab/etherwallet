/*beforeEach 用来做测试前的准备工作，
inject利用angular的依赖注入，将需要的模块,服务插入作用域。真正的测试代码在it函数里，*/

describe('第一个angular测试',function(){
　　var scope;

　　//beforeEach 表示在运行所有测试前的准备工作。
　　//这里生成demoApp 的module
　　beforeEach(module('demoApp'));//模拟我们的demoApp模块并注入我们自己的依赖

　　beforeEach(inject(function($rootScope,$controller){//inject解决依赖关系注入到一个函数。
		//模拟生成scope, $rootScope是angular中的顶级scope，angular中每个controller中的 
		//scope都是rootScope new出来的
		scope = $rootScope.$new();//把全局scope等于new出来的scope
		//模拟生成controller并且注入已创建的空的 scope
		$controller('test1Ctrl', {$scope: scope});//把这个全局的scope和测试的angular的controller里面的$scope连通
	}))

　　it("scope里面的 name 为 app", function () {
　　　　 expect(scope.name).toEqual('app');
　　})

　　it('incrementNum执行后，scope内的num变成1',function(){
		scope.incrementNum()//执行scope内的incrementNum函数
		expect(scope.num).toEqual(1);
	})
})