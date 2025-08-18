public with sharing class ExpenseTriggerHandler {
    public static void beforeInsert(List<Expense__c> newExpenses){
        Set<Id> expTAIds=new Set<Id>();
        for(Expense__c exp:newExpenses){
            if(exp.Travel_Allowance__c!=null ){
                expTAIds.add(exp.Travel_Allowance__c);
            }
            // if(exp.Travel_Allowance__r.Approval_Status__c!='Approved'){
            //     exp.addError('You can’t create expenses until your Travel Allowance request has been approved.');
            // }
        }

        if(!expTAIds.isEmpty()){
            ExpenseTriggerHepler.findExistingExpense(expTAIds,newExpenses);
            ExpenseTriggerHepler.checkIfTAApproved(expTAIds,newExpenses);
        }
    }
}