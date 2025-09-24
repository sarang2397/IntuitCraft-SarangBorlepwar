// Online Java Compiler
// Use this editor to write, compile and run your Java code online
import java.util.*;
class MergeSort {
    public static void main(String[] args) {
        int arr[]={7,6,5,8,9,3,2,99};
        int res[]=mergeSort(arr);
        System.out.println(Arrays.toString(res));
    }
    
    public static int[] mergeSort(int arr[]){
        if(arr.length<=1){
            return arr;
        }
        
        int mid=arr.length/2;
        
        int [] left=mergeSort(Arrays.copyOfRange(arr,0,mid));
        int [] right=mergeSort(Arrays.copyOfRange(arr,mid,arr.length));
        
        return merge(left,right);
    }
    
    public static int[] merge(int []left,int [] right){
        int i=0;
        int j=0;
        int k=0;
        
        int mix[]=new int[left.length+right.length];
        
        while(i<left.length && j<right.length){
            if(left[i]<right[j]){
                mix[k]=left[i];
                i++;
            }else{
                mix[k]=right[j];
                j++;
            }
            k++;
        }
        
        while(i<left.length){
            mix[k]=left[i];
            i++;
            k++;
        }
        
        while(j<right.length){
            mix[k]=right[j];
            j++;
            k++;
        }
        
        return mix;
    }
}