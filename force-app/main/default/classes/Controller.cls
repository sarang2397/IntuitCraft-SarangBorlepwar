public with sharing class Controller {
   

    @AuraEnabled
    public static List<Contact> getContacts(string firstName){
        try {
            List<Contact> conList=new List<Contact>();
            conList=[Select Id,Name FROM Contact where FirstName Like :firstName+'%'];

            if(!conList.isEmpty()){
                return conList;
            }
            return new List<Contact>();
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}