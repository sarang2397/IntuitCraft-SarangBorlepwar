// Online Java Compiler
// Use this editor to write, compile and run your Java code online

class Main {
    public static void main(String[] args) {
       int arr[]={4,5,6,7,0,1,2};
       int start=0;
       int end=arr.length-1;
       int target=0;
       
      int ans= searchInRotated(arr,target,start,end);
      System.out.print(ans);
    }
    
    public static int searchInRotated(int arr[],int target,int start,int end){
        
        if(start>end){
            return -1;
        }
        int mid=(start+end)/2;
        
        if(arr[mid]==target){
            return mid;
        }
        
        if(arr[mid]>= arr[start]){
            if(arr[start]<=target && arr[mid]>= target){
                end=mid-1;
                return searchInRotated(arr,target,start,end);
            }else{
                start=mid+1;
                return searchInRotated(arr,target,start,end);
            }
        }else{
            if(arr[mid]<=target && arr[end]>=target){
                start=mid+1;
                return searchInRotated(arr,target,start,end);
            }else{
                end=mid-1;
                return searchInRotated(arr,target,start,end);
            }
            
        }
    }
}