// This class ised to display list of Tag Template which will be displayed under Admin Tab

public with sharing class displayTagTemplateInAdminTab {

    // Global variables
   /* public List<Tag_Template__c> lstTagTemplate{get;set;}
    public String strTagTemplate{get;set;}
    // End of Global variables
    
    // Start constructor
    public displayTagTemplateInAdminTab(ApexPages.StandardController controller) 
    {
        lstTagTemplate = [Select Id, Name from Tag_Template__c Order BY Name LIMIT 10000 ];
    }
    // End of constructor
    
    // This method is called on to handle Delete link on list of Tag Template
    public pagereference deleteTagTemplate()
    {
        Pagereference pg = new Pagereference('/apex/DeleteTagTemplate?id='+strtagtemplate);
        pg.setRedirect(true);
        return pg;
    }
    // End of method deleteTagTemplate
    
    // This method is called on to handle Edit link on list of TagTemplate
    public pagereference editTagTemplate()
    { 
        Pagereference pg = new Pagereference('/apex/EditTagTemplate?id='+strtagtemplate);
        pg.setRedirect(true);
        return pg;
    }
    // End of method editTagTemplate
    
    // This method is called on to handle Create New TagTemplate button
    public pagereference createNewTagTemplate()
    {
        Pagereference pg = new Pagereference('/apex/CreateNewTagTemplate');
        pg.setRedirect(true);
        return pg;
    }
    // End of method createNewTagTemplate
    
    // Start Test Coverage Code
    static testMethod void Test_displayTagTemplateInAdminTab()
    {
       Test.StartTest();
        
        Tag_Template__c testtag = new Tag_Template__c(Name = 'Test Tag Admin Services 001');
        insert testtag;
        
        System.assertEquals('Test Tag Admin Services 001', testtag.Name);
        
        ApexPages.currentPage().getParameters().put('strTagType',testtag.Id);
        ApexPages.StandardController con=new ApexPages.StandardController(testtag);    
        displayTagTemplateInAdminTab ext = new displayTagTemplateInAdminTab(con);
        
        ApexPages.Pagereference result1 = ext.editTagTemplate();
        
        result1 = ext.deleteTagTemplate();
        
        result1 = ext.createNewTagTemplate();
        
        Test.StopTest();
        
    }// End of Test Coverage code*/
}// End of class