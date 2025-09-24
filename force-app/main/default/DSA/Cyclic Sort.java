import java.util.*;
public class Main {
       public static void main(String args[]){
        int arr[]={5,4,3,2,1};
        cyclic(arr);
        System.out.println(Arrays.toString(arr));
    }

     public static void cyclic(int[] arr){
       int i=0;
       while(i<arr.length){
        int correctIndex=arr[i]-1;
        if(arr[i]!=arr[correctIndex]){
            swap(arr,i,correctIndex);
        }else{
            i++;
        }
       }
    }

    public static void swap(int arr[],int first,int second){
        int temp=arr[first];
        arr[first]=arr[second];
        arr[second]=temp;

    }
    
    
}
