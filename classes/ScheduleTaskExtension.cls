// This class is used to create Schedule Task 

public with sharing class ScheduleTaskExtension 
{
    /*// Global Variables
        String GLCName;
        public String getGLCName() { return GLCName; }
        public void setGLCName(String s) {  this.GLCname = s; }
        private final Schedule_Task__c sc; 
        // End of Global variables
        
        // Standard Controller Constructor 
        public ScheduleTaskExtension(ApexPages.StandardController controller)
        {
        this.sc=(Schedule_Task__c)controller.getrecord();
        }
        // End Constructor
        
        // Method called to populate GLCodes into picklist 
        public List<selectOption> getGLCodes() 
        {
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (GL_Code__c a : [SELECT Id, name FROM GL_Code__c order by Name]) 
        {  
        optionList.add(new selectOption(a.Id, a.Name));  
        }
        return optionList;  
        }
        // End getGLCodes method 
        
        // Method called to save Schedule Task   
        Public PageReference saveme()
        {
        try
        {
        String strid;
        if (Schema.sObjectType.Schedule_Task__c.fields.GL_Code__c.isCreateable()) {   
        sc.GL_Code__c=GLCName;}
        
        if(GLCName == null)
        {
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'GL Code: You must select a GL Code.');
        ApexPages.addMessage(myMsg);
        return null;
        }
        
        else
        {
        if(Schema.sObjectType.Schedule_Task__c.isCreateable()){  insert sc;}
        strid = sc.Schedule_Template__c;        
        PageReference p =  new Pagereference('/apex/ScheduleTemplateTabOverride?id='+strid);
        p.setRedirect(true);
        return p;
        }
        }
        catch(System.DMLException e)
        {
        return null;
        }
        }
        // End save method
        
        // Test Coverage 
        static testMethod void Test_ScheduleTaskExtension()
        {
        Media_Type__c testMedia=new Media_Type__c(Name='Test Media 10');
        insert testMedia;
        
        Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 10',Media_Types__c=testMedia.Id);
        
        insert testST;
        
        
        GL_Department__c testGLD=new GL_Department__c(Name='Test GLD 10');
        insert testGLD;
        
        GL_Code__c testGL=new GL_Code__c(Name='Test GL Code',GL_ID__c='Test GL001',GL_Department__c=testGLD.id);
        insert testGL;
        
        Schedule_Task__c testSCT=new Schedule_Task__c(Name='Test Schedule Task 10',Schedule_Template__c=testST.Id,Days__c=5,GL_Code__c=testGL.Id);
        
        // Instantiate the standard controller with the  Schedule Task object 
        
        ApexPages.currentPage().getParameters().put('id',testSCT.id);
        ApexPages.StandardController con=new ApexPages.StandardController(testSCT);
        
        // Instantiate the extention instance with the standardcontroller 
        ScheduleTaskExtension ext=new ScheduleTaskExtension(con);
        
        // Invoke the primary method on the extension
        ApexPages.PageReference result=ext.saveme();
        
        System.assertEquals('Test Schedule Task 10',testSCT.Name);
        
        ext.GLCName = NULL; // to check GL Code as NULL
        String GLCName1 = ext.getGLCName();
        ext.setGLCName(GLCName1);
        List<SelectOption> options1 = ext.getGLCodes();
        
        result=ext.saveme();
        
        ext.GLCName = testGL.id;
        String GLCName2 = ext.getGLCName();
        ext.setGLCName(GLCName2);
        List<SelectOption> options2 = ext.getGLCodes();
        
        result=ext.saveme();
        
        // To Cover catch block
        
        delete testSCT;
        result=ext.saveme();
        }
        // Test Coverage*/
}
// End of class