import java.util.*;
public class Main {

     public static void main(String args[]){
        int arr[]={4,0,2,1};
        int missing=missingCyclic(arr);
        System.out.println(missing);
     }

      public static int missingCyclic(int[] arr){
      int i=0;
      while(i<arr.length){
        int correct=arr[i];
        if(arr[i]<arr.length && arr[correct]!=arr[i] ){
            swap(arr,correct,i);
        }else{
            i++;
        }
      }
      
      for(int j=0;j<arr.length;j++){
          if(arr[j]!=j){
              return j;
          }
      }
      return -1;

     
    }


        public static void swap(int arr[],int first,int second){
        int temp=arr[first];
        arr[first]=arr[second];
        arr[second]=temp;

    }
    
    
}
