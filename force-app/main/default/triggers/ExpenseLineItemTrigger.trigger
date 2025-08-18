trigger ExpenseLineItemTrigger on Expense_Line_Item__c (before insert) {

    switch on trigger.operationType{
        when BEFORE_INSERT{
            ExpenseLineItemTriggerHandler.beforeInsert(trigger.new);
        }
    }

}