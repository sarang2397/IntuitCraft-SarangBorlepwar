trigger ExpenseTrigger on Expense__c (before insert) {

    switch on trigger.operationType{
        when BEFORE_INSERT{
            ExpenseTriggerHandler.beforeInsert(trigger.new);
        }
    }

}