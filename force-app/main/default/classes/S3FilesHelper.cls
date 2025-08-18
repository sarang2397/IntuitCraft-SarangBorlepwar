public with sharing class S3FilesHelper {
    //Get configuration for AWS SDK
    
    @AuraEnabled
    public static Config getConfig(Id recordId) {
        try {
            if (recordId == null) {
                throw new AuraHandledException('Invalid record Id provided');
            }

            String obj = recordId.getSObjectType().getDescribe().getName();

            // Validate record existence
            String query = 'SELECT Id FROM ' + String.escapeSingleQuotes(obj) + ' WHERE Id = :recordId LIMIT 1';
            sObject sob = Database.query(query);

            String s3Prefix = obj + '/' + recordId;

            Amazon_S3__mdt metadata = [
                SELECT Id, 
                    Bucket_Sandbox__c,
                    Bucket__c,
                    Access_Key_Id__c,
                    Secret_Access_Key__c,
                    Region__c,
                    Region_Sandbox__c
                FROM Amazon_S3__mdt 
                WHERE DeveloperName = 'Amazon_S3_Integration'
                LIMIT 1
            ];

            Organization org = [SELECT IsSandbox FROM Organization LIMIT 1];

            if (
                String.isBlank(s3Prefix) ||
                String.isBlank(metadata.Bucket__c) ||
                String.isBlank(metadata.Bucket_Sandbox__c)
            ) {
                throw new AuraHandledException('Missing S3 configuration. Please check custom metadata.');
            }

            return new Config(
                metadata.Access_Key_Id__c,
                metadata.Secret_Access_Key__c,
                org.IsSandbox ? metadata.Region_Sandbox__c : metadata.Region__c,
                org.IsSandbox ? metadata.Bucket_Sandbox__c : metadata.Bucket__c,
                s3Prefix
            );

        } catch (QueryException qe) {
            throw new AuraHandledException('Record or Metadata not found: ' + qe.getMessage());
        } catch (Exception e) {
            // Generic fallback — don’t expose internals
            throw new AuraHandledException('Unexpected error while fetching S3 config. Please contact admin.');
        }
    }

    public class Config {
        @AuraEnabled
        public String accessKeyId {get;set;}
        @AuraEnabled
        public String secretAccessKey {get;set;}
        @AuraEnabled
        public String region {get;set;}
        @AuraEnabled
        public String bucket {get;set;}
        @AuraEnabled
        public String prefix {get;set;}
    
        config(
            String accessKey,
            String secretKey,
            String r,
            String b,
            String pre
        ) {
            accessKeyId = accessKey;
            secretAccessKey = secretKey;
            region = r;
            bucket = b;
            prefix  = pre;
        }
        config() {}
    }
}