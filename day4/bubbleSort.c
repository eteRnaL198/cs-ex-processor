#include <stdio.h>

void BubbleSort(int array[], int n)
{
    int i, j, temp;
    for (i = 0; i < n - 1; i++)
    {
        for (j = 0; j < n - 1; j++)
        {
            if (array[j + 1] < array[j])
            {
                temp = array[j];
                array[j] = array[j + 1];
                array[j + 1] = temp;
            }
        }
    }
}

void show_array(int array[], int n)
{
	int i;
	for( i = 0; i < n; i++){
		printf("%d ", array[i]);
	}
	printf("\n");
}

int main(void)
{
  int array[100] = {63,86,64,98,44,31,75,90,18,52,14,30,69,23,57,12,9,56,53,35,51,20,61,46,65,43,3,16,34,5,25,68,10,28,32,77,81,97,8,42,99,26,13,1,50,24,15,71,83,22,87,72,54,48,36,19,2,0,66,85,93,89,4,33,67,49,29,62,96,92,41,60,37,79,47,88,38,58,84,6,40,27,82,73,80,74,45,59,55,7,91,70,94,11,17,78,21,39,76,95};
  int i, j;
  
  BubbleSort(array, 100);
  show_array(array, 100);
  
  return 0;
}


