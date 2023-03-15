public with sharing class DailyHotSheetByStaffController1 {
    
    // Start Global Variables
    public Date today{get;set;}
    public List<Document> lstDoc;
    public String imageBody{get;set;}
    public String imageURL{get;set;}
    public boolean imageNotFound{get;set;}
    public map<string,list<Job_Task__c>> mapStaffTask {get; set;}
    integer listSize{get; set;}
    // End of Global Variables

    public DailyHotSheetByStaffController1(){
        // Code to display Subscriber Logo
        
        // If subscriber deletes the Document : JobSuite_OrganizationLogo from their Org then JobSuite App logo will be displayed
         today = System.Today();
         imageURL = '/servlet/servlet.FileDownload?file='; 
         lstDoc = [Select Id, Name, Body from Document where Name =: 'JobSuite_OrganizationLogo' WITH SECURITY_ENFORCED LIMIT 1];
         if(!lstDoc.isEmpty())
         {
               String imageId =  lstDoc[0].Id;
               imageBody = imageURL+imageId; 
               imageNotFound = False;
         }    
         else
         {
               imageNotFound = True;
         }
         // End of code to diplay Subscriber Logo
         
         // Code to get tasks due by staff.
        listSize = 0;
        List<Job_Task__c> lstTasks =[Select Id, Name, Revised_Due_Date__c, Due_Date__c, Assigned_Users__c, Job__r.Name, Job__r.Job_Auto_Number__c, Job__r.Status__c FROM Job_Task__c WHERE Revised_Due_Date__c =: System.Today() AND Job__r.Status__c =:'Active' AND Status__c =:'Active' AND Assigned_Users__c != NULL WITH SECURITY_ENFORCED ORDER BY Assigned_Users__c];
        listSize = lstTasks.size();
        
        set<String> strStaff = new set<String>();
        for(Job_Task__c jtr : lstTasks)
        {
            string s1 = jtr.Assigned_Users__c;
            list<string> s2 = s1.split('\\,');
            for(string ls : s2){
               strStaff.add(ls.trim());
               System.debug('string after split --> ' + ls);
            }
        }
        
        List<Job_Task__c> tempTasks = [SELECT Id, Name, Assigned_Users__c, Revised_Due_Date__c, Due_Date__c, Job__r.Name, Job__r.Job_Auto_Number__c FROM Job_Task__c WHERE Revised_Due_Date__c =: System.Today() AND Job__r.Status__c =:'Active' AND Status__c =:'Active' AND Assigned_Users__c != NULL WITH SECURITY_ENFORCED ORDER BY Job__r.Job_Auto_Number__c desc];        
        mapStaffTask = new map<string,list<Job_Task__c>>();
        List<Job_Task__c> tempListTask = new List<Job_Task__c>();
        for(string staffName : strStaff){
            tempListTask = new List<Job_Task__c>();
            for(Job_Task__c varTasks : tempTasks){
                string s1 = varTasks.Assigned_Users__c;
                list<string> s2 = s1.split('\\,');
                for(string ls : s2){
                    if(staffName == ls.trim()){
                        tempListTask.add(varTasks);
                    }
                }
            }
            mapStaffTask.put(staffName,tempListTask);
        }
        //End of code to get tasks due.
    }
    // End of Constructor

    public integer getListSize() {
        return ListSize;
    }
}