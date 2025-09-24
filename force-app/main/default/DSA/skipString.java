// Online Java Compiler
// Use this editor to write, compile and run your Java code online

class Main {
    public static void main(String[] args) {
        System.out.println(skipString("bccaddah"));
        System.out.println(skipWord("bccappleddah"));
    }
    
    public static String skipString(String ans){
        if(ans.isEmpty()){
            return "";
        }
        
        if(ans.charAt(0)=='a'){
            return skipString(ans.substring(1));
        }else{
            return ans.charAt(0) +skipString(ans.substring(1));
        }
    }
    
    public static String skipWord(String ans){
        if(ans.isEmpty()){
            return "";
        }
        
        if(ans.startsWith("apple")){
            return skipWord(ans.substring(5));
            
        }else{
            return ans.charAt(0)+skipWord(ans.substring(1));
        }
    }
}