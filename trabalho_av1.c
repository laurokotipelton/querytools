#include <stdio.h>
#include <stdlib.h>

void insertionSort(int* vetor, int tamanho) {
      int i, j, tmp;
      for (i = 1; i < tamanho; i++) {
            j = i;
            while (j > 0 && vetor[j - 1] > vetor[j]) {
                  tmp = vetor[j];
                  vetor[j] = vetor[j - 1];
                  vetor[j - 1] = tmp;
                  j--;
            }
      }
}

void merge(int vetor[], int comeco, int meio, int fim) {
    
    int com1 = comeco, com2 = meio+1, comAux = 0, tam = fim-comeco+1;
    int *vetAux;
    vetAux = (int*)malloc(tam * sizeof(int));
  
    while(com1 <= meio && com2 <= fim){
        if(vetor[com1] < vetor[com2]) {
            vetAux[comAux] = vetor[com1];
            com1++;
        } else {
            vetAux[comAux] = vetor[com2];
            com2++;
        }
        comAux++;
     }
 
    while(com1 <= meio){  //Caso ainda haja elementos na primeira metade
        vetAux[comAux] = vetor[com1];
        comAux++;
        com1++;
    }
 
    while(com2 <= fim) {   //Caso ainda haja elementos na segunda metade
        vetAux[comAux] = vetor[com2];
        comAux++;
        com2++;
    }
 
    for(comAux = comeco; comAux <= fim; comAux++){    //Move os elementos de volta para o vetor original
        vetor[comAux] = vetAux[comAux-comeco];
    }
     
    free(vetAux);
}
 
void mergeSort(int* vetor, int comeco, int fim){
    if (comeco < fim) {
        int meio = (fim+comeco)/2;
 
        mergeSort(vetor, comeco, meio);
        mergeSort(vetor, meio+1, fim);
        merge(vetor, comeco, meio, fim);
    }
}

void selectionSort(int* vetor, int tamanho) { 
  int i, j, min, aux;
  for (i = 0; i < (tamanho-1); i++) 
  {
     min = i;
     for (j = (i+1); j < tamanho; j++) {
       if(vetor[j] < vetor[min]) 
         min = j;
     }
     if (vetor[i] != vetor[min]) {
       aux = vetor[i];
       vetor[i] = vetor[min];
       vetor[min] = aux;
     }
  }
}

int main(){

    int* vetor,inicio,tamanho, ordem;
    
    printf("Entre com o número de termos...: ");
    scanf("%d", &tamanho);

    vetor = (int *)malloc(tamanho * sizeof(int));
    
    do {
        printf("Escolha o metodo de ordenação: \n1 - Insertion Sort \n2 - Merge Sort \n3 - Selection Sort\n");
        scanf("%d",&ordem); 
    }while(ordem > 3 || ordem == 0);

    switch (ordem){
        case 1:
            printf("Entre com os elementos do vetor...:\n");
                for(int i = 0; i < tamanho;i++){
                    printf("Digite o %dº número: ",i+1);
                    scanf("%d",&vetor[i]);
                }
            insertionSort(vetor,tamanho);
            printf("vetor em ordem crescente: ");
            
            for(int i=0; i<tamanho; i++){
                printf("%d ", vetor[i]);
            }
        break;
        case 2:
            printf("Entre com os elementos do vetor...:\n");
                for(int i = 0; i < tamanho;i++){
                    printf("Digite o %dº número: ",i+1);
                    scanf("%d",&vetor[i]);
                }
            inicio = 1;
            mergeSort(vetor,inicio,tamanho);
            printf("vetor em ordem crescente: ");

            for(int i=0; i<tamanho; i++){
                printf("%d ", vetor[i]);
            }
        break;
        case 3:
            printf("Entre com os elementos do vetor...:\n");
                for(int i = 0; i < tamanho;i++){
                    printf("Digite o %dº número: ",i+1);
                    scanf("%d",&vetor[i]);
                }
            selectionSort(vetor,tamanho);
            printf("vetor em ordem crescente: ");
            
            for(int i=0; i<tamanho; i++){
                printf("%d ", vetor[i]);
            }
        break;
   }
   free(vetor);
    return 0;
}