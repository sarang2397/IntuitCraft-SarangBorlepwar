public with sharing class ExpenseLineItemTriggerHandler {
    public static void beforeInsert(List<Expense_Line_Item__c> expLineItems){
        Set<Id> expIds=new Set<Id>();
        for(Expense_Line_Item__c expL:expLineItems){
            if(expL.Expense__c!=null ){
                expIds.add(expL.Expense__c);
            }
        }

        if(!expIds.isEmpty()){
            List<Expense__c> expenseList=[Select Id,Approval_Status__c  FROM Expense__c WHERE Id IN: expIds];

            Map<Id,Boolean> ExpenseStatusMap=new Map<Id,Boolean>();

            for(Expense__c exp: expenseList){
                if(exp.Approval_Status__c=='Approved' || exp.Approval_Status__c=='Rejected'){
                    ExpenseStatusMap.put(exp.Id,true);
                }else{
                     ExpenseStatusMap.put(exp.Id,false);
                }
            }

            for(Expense_Line_Item__c expL:expLineItems){
            if(expL.Expense__c!=null && ExpenseStatusMap.containsKey(expL.Expense__c)){
                if(ExpenseStatusMap.get(expL.Expense__c)){
                    expL.addError('You cannot create line items once your expense is Approved/Rejected');
                }
            }
        }

        }
    }
}