public with sharing class ExpenseTriggerHepler {
   public static void findExistingExpense(Set<Id> expTAIds,List<Expense__c> newExpenses){
    Set<Id> existingExpIds=new Set<Id>();
    Map<Id,List<Expense__c>> taExpMap=new Map<Id,List<Expense__c>>();
    List<Expense__c> expenseList=[Select Id,Travel_Allowance__c FROM Expense__c WHERE  Travel_Allowance__c IN:expTAIds AND Approval_Status__c NOT IN ('Approved','Rejected')];
    List<Expense__c> tempExpenseList=new List<Expense__c>();



    for(Expense__c exp:expenseList){
        if(!taExpMap.containsKey(exp.Travel_Allowance__c)){
            taExpMap.put(exp.Travel_Allowance__c,new List<Expense__c>());

        }
        taExpMap.get(exp.Travel_Allowance__c).add(exp);

    }
     for(Expense__c exp:newExpenses){
        if(taExpMap.containsKey(exp.Travel_Allowance__c)){
            tempExpenseList=taExpMap.get(exp.Travel_Allowance__c);
            if(tempExpenseList.size()>0){
                exp.addError('You Already have one expense which is not yet closed or approved or rejected.');
            }
        }
    }
   }


   public static void checkIfTAApproved(Set<Id> expTAIds,List<Expense__c> newExpenses){
     Map<Id, Travel_Allowance__c> taMap = new Map<Id, Travel_Allowance__c>(
        [SELECT Id, Approval_Status__c 
         FROM Travel_Allowance__c 
         WHERE Id IN :expTAIds]
     );

    for (Expense__c exp : newExpenses) {
        if (exp.Travel_Allowance__c != null) {
            Travel_Allowance__c ta = taMap.get(exp.Travel_Allowance__c);
            if (ta != null && ta.Approval_Status__c != 'Approved') {
                exp.addError('You can’t create expenses until your Travel Allowance request has been approved.');
            }
        }
    }

   }

   
}
