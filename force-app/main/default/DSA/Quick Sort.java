import java.util.*;
public class QuickSort {

    public static void main(String args[]){
        int arr[]={5,4,3,2,1};
        sort(arr,0,arr.length-1);
        System.out.println(Arrays.toString(arr));


    }

    public static void sort(int nums[],int low,int high){

        if(low>=high){
            return;
        }

        int s=low;
        int e=high;
        int m= (s+e)/2;
        

        while(s<=e){

            while(nums[s]<=nums[m]){
                s++;
            }
            while(nums[e]>nums[m]){
                e--;
            }

            if(s<=e){
                int temp=nums[s];
                nums[s]=nums[e];
                nums[e]=temp;
            }

        }
        sort(nums,low,e);
        sort(nums,s,high);

    }
    
}
