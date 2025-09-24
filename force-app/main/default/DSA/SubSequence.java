import java.util.ArrayList;
import java.util.List;

public class SubSequence {

    public static void main(String args[]){
        
        ArrayList<String> list= subseqWithRet("", "abc");
        System.out.println(list);
    }

    public static void subseq(String p,String up){
        if(up.isEmpty()){
            System.out.println(p);
            return;
        }
        char ch=up.charAt(0);

        subseq(p+ch,up.substring(1));
        subseq(p,up.substring(1));
    }
    
     public static ArrayList<String> subseqWithRet(String p,String up){
        if(up.isEmpty()){
           
            ArrayList<String> list=new ArrayList<>();
            if (!p.isEmpty()) {  
            list.add(p);
            }
           
            return list;
        }
        char ch=up.charAt(0);
        
         ArrayList<String> left=subseqWithRet(p+ch,up.substring(1));
        ArrayList<String> right=subseqWithRet(p,up.substring(1));
        
        left.addAll(right);
        return left;
    }

}
