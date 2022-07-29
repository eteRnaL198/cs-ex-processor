#include<stdio.h>

int mul( int a, int b )
{
	int y = 0;
	while( b != 0 ){
		if( b & 1 == 1 ){
			y += a;
		}
		b = b >> 1;
		a = a << 1;
	}
	return y;
}

int main(void)
{
	int a = 13;
	int b = 11;
	int y = 0;

	y = mul( a, b );

	printf( "%d %d %d\n", a, b, y );

	return 0;
}
