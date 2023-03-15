// This extension class is used to display GL Departments
public with sharing class displayGLDepartmentsInAdminTab {
/*
    // Global variables
        public List<GL_Department__c> lstGLD{get;set;}
        public String strGLDeptId{get;set;}
      // End of Global variables  
        
    // End of Global variables
    public displayGLDepartmentsInAdminTab(ApexPages.StandardController controller) 
    {
         lstGLD = [Select Id, Name from GL_Department__c Order BY Name Limit 10000];       
    }
    
    // This method is called on to handle Edit link for GLDepartment
    public pagereference editGLDepartment()
    {
        Pagereference pg = new Pagereference('/apex/EditGLDepartment?id='+strGLDeptId);
        pg.setRedirect(true);
        return pg;
    }
    // End of method editGLDepartment
    
    // This method is called on to handle Delete link for GLDepartment
    public pagereference deleteGLDepartment()
    {
        Pagereference pg = new Pagereference('/apex/DeleteGLDepartment?id='+strGLDeptId);
        pg.setRedirect(true);
        return pg;
    }
    // ENd of method delete GLDepartment
    
    // This method is called on to handle Create New GLDepartment
    public pagereference createNewGLDepartment()
    {
        Pagereference pg = new Pagereference('/apex/CreateNewGLDepartment');
        pg.setRedirect(true);
        return pg;
    }
    // End of Method createNewGLDepartment
    
    // Start Test Coverage Code
    static testMethod void Test_displayGLDepartmentsInAdminTab()
    {
        Test.StartTest();
        
        GL_Department__c testGLD = new GL_Department__c(Name = 'Test GLD Admin');
        insert testGLD;
        
        System.assertEquals('Test GLD Admin', testGLD.Name);
        
        ApexPages.currentPage().getParameters().put('strGLDeptId',testGLD.Id);
        ApexPages.StandardController con=new ApexPages.StandardController(testGLD);    
        displayGLDepartmentsInAdminTab ext = new displayGLDepartmentsInAdminTab(con);
        
        ApexPages.Pagereference result1 = ext.editGLDepartment();
        
        result1 = ext.deleteGLDepartment();
        
        result1 = ext.createNewGLDepartment();
        
        Test.StopTest();
        
    }// End of Test Coverage code*/
} // End of Class