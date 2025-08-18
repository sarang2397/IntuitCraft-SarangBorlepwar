@isTest
public with sharing class ExpenseLineItemTriggerTest {

    @TestSetup
    static void makeData(){
        // Create Travel Allowance record first
        Travel_Allowance__c ta = new Travel_Allowance__c(
            Reason_For_Travel__c = 'Conference',
            Approval_Status__c='Approved'
        );
        insert ta;
        
        // Create Expense records with different approval statuses
        List<Expense__c> expenses = new List<Expense__c>();
        
        // Approved Expense
        expenses.add(new Expense__c(
            Travel_Allowance__c = ta.Id,
            Approval_Status__c = 'Approved'
        ));
        
        // Rejected Expense  
        expenses.add(new Expense__c(
            Travel_Allowance__c = ta.Id,
            Approval_Status__c = 'Rejected'
        ));
        
        // Pending Expense
        expenses.add(new Expense__c(
            Travel_Allowance__c = ta.Id,
            Approval_Status__c = 'Pending'
        ));
        
        insert expenses;
    }
    
    @isTest
    static void testBeforeInsertApprovedExpenseShouldFail() {
        // Get the approved expense
        Expense__c approvedExp = [SELECT Id FROM Expense__c WHERE Approval_Status__c = 'Approved' LIMIT 1];
        
        // Try to create line item for approved expense
        Expense_Line_Item__c lineItem = new Expense_Line_Item__c(
            Expense__c = approvedExp.Id
            // Add other required fields if any
        );
        
        Test.startTest();
        try {
            insert lineItem;
            System.assert(false, 'Expected DML exception was not thrown');
        } catch (DmlException e) {
            System.assert(
                e.getDmlMessage(0).contains('You cannot create line items once your expense is Approved/Rejected'),
                'Error message should match expected message. Actual: ' + e.getDmlMessage(0)
            );
        }
        Test.stopTest();
    }
    
    @isTest
    static void testBeforeInsertRejectedExpenseShouldFail() {
        // Get the rejected expense
        Expense__c rejectedExp = [SELECT Id FROM Expense__c WHERE Approval_Status__c = 'Rejected' LIMIT 1];
        
        // Try to create line item for rejected expense
        Expense_Line_Item__c lineItem = new Expense_Line_Item__c(
            Expense__c = rejectedExp.Id
        );
        
        Test.startTest();
        try {
            insert lineItem;
            System.assert(false, 'Expected DML exception was not thrown');
        } catch (DmlException e) {
            System.assert(
                e.getDmlMessage(0).contains('You cannot create line items once your expense is Approved/Rejected'),
                'Error message should match expected message. Actual: ' + e.getDmlMessage(0)
            );
        }
        Test.stopTest();
    }
    
    @isTest
    static void testBeforeInsertPendingExpenseShouldSucceed() {
        // Get the pending expense
        Expense__c pendingExp = [SELECT Id FROM Expense__c WHERE Approval_Status__c = 'Pending' LIMIT 1];
        
        // Create line item for pending expense
        Expense_Line_Item__c lineItem = new Expense_Line_Item__c(
            Expense__c = pendingExp.Id
        );
        
        Test.startTest();
        insert lineItem;
        Test.stopTest();
        
        // Verify line item was created successfully
        List<Expense_Line_Item__c> insertedLineItems = [
            SELECT Id, Expense__c 
            FROM Expense_Line_Item__c 
            WHERE Expense__c = :pendingExp.Id
        ];
        System.assertEquals(1, insertedLineItems.size(), 'Line item should be created successfully');
        System.assertEquals(pendingExp.Id, insertedLineItems[0].Expense__c, 'Line item should be associated with correct expense');
    }
    
  
    
    @isTest
    static void testBeforeInsertBulkInsertMixedScenarios() {
        // Get test expenses
        List<Expense__c> expenses = [
            SELECT Id, Approval_Status__c 
            FROM Expense__c 
            ORDER BY Approval_Status__c
        ];
        
        Expense__c approvedExp = null;
        Expense__c pendingExp = null;
        
        for (Expense__c exp : expenses) {
            if (exp.Approval_Status__c == 'Approved') {
                approvedExp = exp;
            } else if (exp.Approval_Status__c == 'Pending') {
                pendingExp = exp;
            }
        }
        
        // Create bulk line items
        List<Expense_Line_Item__c> lineItems = new List<Expense_Line_Item__c>();
        
        // Valid line item for pending expense
        lineItems.add(new Expense_Line_Item__c(
            Expense__c = pendingExp.Id
        ));
        
        // Invalid line item for approved expense
        lineItems.add(new Expense_Line_Item__c(
            Expense__c = approvedExp.Id
        ));
        
        Test.startTest();
        try {
            insert lineItems;
            System.assert(false, 'Expected DML exception was not thrown');
        } catch (DmlException e) {
            // Should fail because one of the records has validation error
            System.assert(
                e.getDmlMessage(0).contains('You cannot create line items once your expense is Approved/Rejected') ||
                e.getDmlMessage(1).contains('You cannot create line items once your expense is Approved/Rejected'),
                'Error message should contain expected validation message'
            );
        }
        Test.stopTest();
    }
    
   
}