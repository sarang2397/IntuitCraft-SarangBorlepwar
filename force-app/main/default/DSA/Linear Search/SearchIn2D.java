import java.util.*;

public class SearchIn2D {
    public static void main(String[] args) {
      int arr[][]={
        {23,45,12},
        {98,54,67},
        {89,87,22,10}
      };
      int target=98;
      
      int ans[]=search(arr,target);
      System.out.println(Arrays.toString(ans));
      System.out.println(max(arr));
  }
  
  static int[] search(int arr[][],int target){
    for (int row=0;row<arr.length ;row++){
      for (int col=0;col<arr[row].length ;col++){
        if(arr[row][col]==target){
          return new int[]{row,col};
        }
      } 
    } 
    return new int[]{-1,-1};
  }
  
  static int max(int arr[][]){
    int max=Integer.MIN_VALUE;
    
    for(int subarray[]:arr){
      for(int element:subarray){
        if(element>max){
          max=element;
        }
      }
    }
    
    return max;
    
  }
  
  
  
  
  
  
  
}