@isTest
public with sharing class S3FilesHelperTest {
    
    @TestSetup
    static void makeData(){
        
        Contact c = new Contact();
            c.FirstName = 'Tokyo';
            c.LastName  = 'Efford';
        insert c;
    }

    @isTest
    private static void GetConfigTest() {

        Contact c = [SELECT Id FROM Contact LIMIT 1];

       S3FilesHelper.Config response= S3FilesHelper.getConfig(c.Id);
        System.assertNotEquals(null, response, 'Response should not be null');
    }
}