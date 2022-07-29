#include "stdio.h"

int arr[4] = {4, 3, 2, 1};

int* bubbleSort(int* arr) {
  int i, j, temp;
  for (i = 0; i < 4; i++) {
    // for (j = 0; j < 3; j++) {
    for (j = 0; j < 3-i; j++) {
      if (arr[j] > arr[j + 1]) {
        temp = arr[j];
        arr[j] = arr[j + 1];
        arr[j + 1] = temp;
      }
      // for (int i = 0; i < 4; i++) {
      //   printf("%d", arr[i]);
      // }
      // printf("\n");
    }
  }
  return arr;
}

int main() {
  int* sortedArr = bubbleSort(arr);
  for (int i = 0; i < 4; i++) {
    printf("%d ", sortedArr[i]);
  }
}

// int insertionSort() {
//   int i, j, temp;
//   for (i = 1; i < 4; i++) {
//     temp = arr[i];
//     j = i - 1;
//     while (j >= 0 && arr[j] > temp) {
//       arr[j + 1] = arr[j];
//       j = j - 1;
//     }
//     arr[j + 1] = temp;
//   }
//   return 0;
// }

// quickSort() {
//   int i, j, temp;
//   i = 0;
//   j = 9;
//   temp = arr[0];
//   while (i < j) {
//     while (arr[i] < temp) {
//       i++;
//     }
//     while (arr[j] > temp) {
//       j--;
//     }
//     if (i < j) {
//       temp = arr[i];
//       arr[i] = arr[j];
//       arr[j] = temp;
//     }
//   }
//   arr[0] = arr[j];
//   arr[j] = temp;
//   if (j > 1) {
//     quickSort(arr, 0, j - 1);
//   }
//   if (j < 9) {
//     quickSort(arr, j + 1, 9);
//   }
//   return 0;
// }

// selectionSort() {
//   int i, j, min, temp;
//   for (i = 0; i < 10; i++) {
//     min = i;
//     for (j = i + 1; j < 10; j++) {
//       if (arr[j] < arr[min]) {
//         min = j;
//       }
//     }
//     temp = arr[i];
//     arr[i] = arr[min];
//     arr[min] = temp;
//   }
//   return 0;
// }
