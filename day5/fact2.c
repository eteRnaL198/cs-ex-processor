#include<stdio.h>

int fact( int n, int a ){
		if( n < 1 ) return a;
		else        return fact(n - 1, a * n);
}

int main(void){
		int y = fact(6, 1);
		printf("%d\n", y);
		return 0;
}
