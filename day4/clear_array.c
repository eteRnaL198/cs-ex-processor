#include<stdio.h>

void clear_array(int* x, int n)
{
	int i, j, tmp;
	i = 0;
	do{
		x[i] = 0;
		i++;
	} while(i <= n);

	return;
}

void show_array(int *x, int n){
	int i;
	for( i = 0; i <= n; i++){
		printf("%d ", x[i]);
	}
	printf("\n");
}

int main(void)
{
	int array[11] ={5,8,1,7,2,0,10,9,3,4,6};
	int i;

	show_array(array, 10);
	clear_array(array, 10);
	show_array(array, 10);

	return 0;
}

