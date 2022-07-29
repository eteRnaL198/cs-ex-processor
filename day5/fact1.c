#include<stdio.h>

int fact( int n){
		if( n < 1 ) return 1;
		else        return n * fact(n - 1);
}

int main(void){
		int y = fact(6);
		printf("%d\n", y);
		return 0;
}
