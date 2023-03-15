// This class ised to display list of Media Types which will be displayed under Admin Tab

public with sharing class displayMediaTypesInAdminTab {
/*
    // Global variables
    public List<Media_Type__c> lstMediaTypes{get;set;}
    public String strMediaType{get;set;}
    // End of Global variables
    
    // Start constructor
    public displayMediaTypesInAdminTab(ApexPages.StandardController controller) 
    {
        lstMediaTypes =new List<Media_Type__c>();
        lstMediaTypes=[Select Id, Name from Media_Type__c Order BY Name LIMIT 10000 ];
    }
    // End of constructor
    
    // This method is called on to handle Delete link on list of Media Type
    public pagereference deleteMediaType()
    {
        Pagereference pg = new Pagereference('/apex/DeleteMediaType?id='+strMediaType);
        pg.setRedirect(true);
        return pg;
    }
    // End of method deleteMediaType
    
    // This method is called on to handle Edit link on list of Media Type
    public pagereference editMediaType()
    { 
        Pagereference pg = new Pagereference('/apex/EditMediaType?id='+strMediaType);
        pg.setRedirect(true);
        return pg;
    }
    // End of method editMediaType
    
    // This method is called on to handle Create New Media Type button
    public pagereference createNewMediaType()
    {
        Pagereference pg = new Pagereference('/apex/CreateNewMediaType');
        pg.setRedirect(true);
        return pg;
    }
    // End of method createNewMediaType
    
    // Start Test Coverage Code
    static testMethod void Test_displayMediaTypesInAdminTab()
    {
       Test.StartTest();
        
        Media_Type__c testMedia = new Media_Type__c(Name = 'Test Media Admin Services 001');
        insert testMedia;
        
        System.assertEquals('Test Media Admin Services 001', testMedia.Name);
        
        ApexPages.currentPage().getParameters().put('strMediaType',testMedia.Id);
        ApexPages.StandardController con=new ApexPages.StandardController(testMedia);    
        displayMediaTypesInAdminTab ext = new displayMediaTypesInAdminTab(con);
        
        ApexPages.Pagereference result1 = ext.editMediaTYpe();
        
        result1 = ext.deleteMediaType();
        
        result1 = ext.createNewMediaType();
        
        Test.StopTest();
        
    }// End of Test Coverage code*/
}// End of class