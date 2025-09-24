// Online Java Compiler
// Use this editor to write, compile and run your Java code online
import java.util.*;

class Main {
    public static void main(String[] args) {
       int arr[]={1,2,3,4,5,6,6};
       int index=0;
      // System.out.print(isSorted(arr,index,6));
       ArrayList<Integer> ans=findAllIndex(arr,index,6,new ArrayList<Integer>());
       System.out.print(ans);
       
    }
    
    public static int isSorted(int arr[],int index,int target){
        if(index==arr.length){
            return -1;
        }
        
        if(arr[index]==target){
            return index;
        }
        
        return isSorted(arr,index+1,target);
    }
    
     public static ArrayList<Integer> findAllIndex(int arr[],int index,int target,ArrayList<Integer> list){
        if(index==arr.length){
            return list;
        }
        
        if(arr[index]==target){
           list.add(index);
        }
        
        return findAllIndex(arr,index+1,target,list);
    }
}