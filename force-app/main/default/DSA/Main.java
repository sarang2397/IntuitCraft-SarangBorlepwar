// Online Java Compiler
// Use this editor to write, compile and run your Java code online

class Main {
    public static void main(String[] args) {
        //reverseTriangle(4,0);
        //triangle(0,4);
        triangle2(4,0);
    }
    
    public static void reverseTriangle(int r,int c){
        if(r==0){
            return;
        }
        
        if(c<r){
            System.out.print("* ");
            reverseTriangle(r,c+1);
        }
        else{
            System.out.println();
            reverseTriangle(r-1,0);
        }
    }
    
    public static void triangle(int r,int c){
        if(c==0){
            return;
        }
        int count=0;
        while(count<=r){
            System.out.print("* ");
            count++;
        }
         System.out.println();
        triangle(r+1,c-1);
       
    }
    
     public static void triangle2(int r,int c){
        if(r==0){
            return;
        }
        
       if(c<r){
        triangle2(r,c+1);
        System.out.print("* ");

       }else{
         triangle2(r-1,0);
         System.out.println();
       }
       
    }
}