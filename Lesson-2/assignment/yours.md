花费数据:

calculateRunwayGas 1

22966
1694

calculateRunwayGas 2

23747
2475

calculateRunwayGas 3

24528
3256


calculateRunwayGas 4

25309
4037


=====


规律:
calculateRunwayGas(1) = 22966 + 1694
calculateRunwayGas(n) - calculateRunwayGas(n - 1) = 1562

优化前:
calculateRunwayGas(n) = 22966 + 1694 + 1562 * (n -1)

优化后:
optimizedCalculateRunwayGas(n) = 22124 + 852

优化收益:
saving(n) = 1684 + 1562 * (n -1) 
	   	 
