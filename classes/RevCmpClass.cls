public class RevCmpClass {
	@AuraEnabled
    public static list <Job_Task__c>  GetTaskData(string RecId)
    {
        system.debug('===RecId==='+RecId);
        list <Job_Task__c> JobTaskList = [select id , name, Task_Order__c,Task_Name__c,Assigned_Users__c,Days__c,
                                          Revised_Due_Date__c,Completion_Date__c,Marked_Done__c from Job_Task__c  where Job__c =:RecId ];
       return JobTaskList ; 
    }
    
     @AuraEnabled
    public static List<Contact> getContacts() {
        List<Contact> contacts =
                [SELECT Id, Name, Phone, Email FROM Contact];
        //Add isAccessible() check
        return contacts;
    }
   
}