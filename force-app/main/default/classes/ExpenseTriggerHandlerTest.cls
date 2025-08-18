@isTest
public class ExpenseTriggerHandlerTest {
    @isTest
    static void testExpenseTrigger_NoExistingExpense() {
        // Create a Travel Allowance record
        Travel_Allowance__c ta = new Travel_Allowance__c(Reason_For_Travel__c='Conference', Approval_Status__c='Approved');
        insert ta;

        // Insert Expense__c with no existing open expense for this TA
        Expense__c exp = new Expense__c(
            Travel_Allowance__c = ta.Id,
            Approval_Status__c = 'Pending'
        );
        Test.startTest();
        insert exp;
        Test.stopTest();

        // Should insert successfully, no error
        System.assertNotEquals(null, exp.Id);
    }

    @isTest
    static void testExpenseTrigger_WithExistingOpenExpense() {
        // Create a Travel Allowance record
        Travel_Allowance__c ta = new Travel_Allowance__c(Reason_For_Travel__c='Conference', Approval_Status__c='Approved');
        insert ta;

        // Insert an existing open expense for this TA
        Expense__c existingExp = new Expense__c(
            Travel_Allowance__c = ta.Id,
            Approval_Status__c = 'Pending'
        );
        insert existingExp;

        // Try to insert another expense for the same TA (should fail)
        Expense__c newExp = new Expense__c(
            Travel_Allowance__c = ta.Id,
            Approval_Status__c = 'Pending'
        );
        Test.startTest();
        try {
            insert newExp;
            System.assert(false, 'Expected error was not thrown');
        } catch (DmlException e) {
            System.assert(
                e.getDmlMessage(0).contains('You Already have one expense which is not yet closed or approved or rejected.'),
                'Error message should match'
            );
        }
        Test.stopTest();
    }

    @isTest
    static void testExpenseTrigger_WithExistingClosedExpense() {
        // Create a Travel Allowance record
        Travel_Allowance__c ta = new Travel_Allowance__c(Reason_For_Travel__c='Conference', Approval_Status__c='Approved');
        insert ta;

        // Insert an existing closed/approved/rejected expense for this TA
        Expense__c closedExp = new Expense__c(
            Travel_Allowance__c = ta.Id,
            Approval_Status__c = 'Approved'
        );
        insert closedExp;

        // Try to insert another expense for the same TA (should succeed)
        Expense__c newExp = new Expense__c(
            Travel_Allowance__c = ta.Id,
            Approval_Status__c = 'Pending'
        );
        Test.startTest();
        insert newExp;
        Test.stopTest();

        System.assertNotEquals(null, newExp.Id);
    }
}