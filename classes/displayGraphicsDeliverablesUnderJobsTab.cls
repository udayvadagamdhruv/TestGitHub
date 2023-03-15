// This class is used to as controller for VF page : displayGraphicsDeliverablesUnderJobsTab

public with sharing class displayGraphicsDeliverablesUnderJobsTab 
{
    // Global variables
  /*  
    public boolean isLtng{private set; get{
        String theme = UserInfo.getUITheme();
        return (theme=='Theme4d')?true:false;
    }
                         }  
    public Id jobId{get;set;}
    public String editGDId{get;set;}
    public String deleteGDId{get;set;}
    public String dupGDId{get;set;}
    public List<Graphics_Deliverables__c> lstGD{get;set;}
    //added by Rahul
    public string orgId{get; set;}
    public string strOrganizationName{get; set;}
    public String queryString{get;set;}
    
    private String sortDirection = 'ASC';
    private String sortExp = 'Name'; 
    
    // End of Global variables
    
    
    
    public String sortExpression
    {
        get
        {
            return sortExp;
        }
        set
        {
            // if the columns is clicked on then switch between ascending and descending modes
            if( value == sortExp)
            {
                sortDirection = (sortDirection== 'ASC')?'DESC' : 'ASC';
            }
            else
            {
                sortDirection='ASC';
            } 
            sortExp=value;
        }
    }
    
    public string getSortDirection()
    {
        // if not columns is selected
        if(sortExpression==NULL || sortExpression=='')
        {
            return 'ASC';
        }
        else
        {
            return sortDirection;
        }
    }
    
    public void setSortDirection(String value)
    {
        sortDirection=value;
    }
    
    
    // Start constructor
    public displayGraphicsDeliverablesUnderJobsTab()
    {
        jobId=ApexPages.CurrentPage().getParameters().get('id');
        orgId = UserInfo.getOrganizationId();
        system.debug('org id --------->'+orgId);
        LoadGraphics();
    }
    // End of constructor
    
    // Retrieve GraphicsDeliverables associated with selected Job
    public void LoadGraphics()
    {
        
        jobId=ApexPages.CurrentPage().getParameters().get('id');
        //  lstGD=[Select Id, Name, Graphics_Type__c, Graphics_Description__c, Graphics_Note__c From Graphics_Deliverables__c where Job__c =: jobId ORDER BY Name];
        
        string sortFullExp = sortExpression  + ' ' + sortDirection;
        system.debug('>>>>>>>>>>>>>>>>>>>>'+sortFullExp);  
        
        system.debug('>>>>>>>>>>>sortExpression  >>>>>>>>>'+sortExpression);  
        
        
        queryString = 'select id';
        for(Schema.FieldSetMember fld :SObjectType.Graphics_Deliverables__c.FieldSets.Job_List_GD.getFields()) {
            queryString += ', ' + fld.getFieldPath();
        }
        queryString += ' From Graphics_Deliverables__c where Job__c =: jobId ORDER BY '+ sortFullExp+'';
        
        lstGD= Database.query(queryString);
        
        
        /*  PageReference p;
if(isLtng)
{
p =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&section=GD');
}
else
{
p =  new Pagereference('/apex/JobListView?id='+jobId+'&intFocus=11');
}


//    Pagereference p = new Pagereference('/apex/JobListView?id='+jobId+'&intFocus=11');
p.setRedirect(true);
return p;
        //  return null;
        
        
    }
    // End of method LoadGraphics
    
    // This method is called on to save inline edited data
    public PageReference saveGraphics()
    {
        try
        {
            update lstGD;
            LoadGraphics();
        }
        catch(DMLException e)
        {
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.Error,''+e.getMessage()));
            return null;
        }
        
        PageReference p;
        if(isLtng)
        {
            p =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&section=GD');
        }
        else
        {
            p =  new Pagereference('/apex/JobListView?id='+jobId+'&intFocus=11');
        }
        
        
        //    Pagereference p = new Pagereference('/apex/JobListView?id='+jobId+'&intFocus=11');
        p.setRedirect(true);
        return p;
        
    }
    // End of method saveGraphics
    
    // This method is called on to open the form to Create New Graphics Deliverable record
    public pagereference createNewGraphics()
    {
        // jobId=ApexPages.CurrentPage().getParameters().get('id');
        
        PageReference p;
        if(isLtng)
        {
            p = Page.CreateNewGraphicsDeliverableLightning;
        }
        else
        {
            p = Page.createNewGraphicsDeliverable;
        }
        
        //  Pagereference p= Page.createNewGraphicsDeliverable;
        p.setRedirect(true);
        p.getParameters().put('jobId',jobId);
        return p;
    }
    // End of method createNewGraphics
    
    // This method is called on to avoid inline edit save
    public pagereference cancelGraphics()
    {
        PageReference p;
        if(isLtng)
        {
            p =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&section=GD');
        }
        else
        {
            p =  new Pagereference('/apex/JobListView?id='+jobId+'&intFocus=11');
        }
        
        
        //    Pagereference p = new Pagereference('/apex/JobListView?id='+jobId+'&intFocus=11');
        p.setRedirect(true);
        return p;
    }
    // End of method cancelGraphics
    
    // This method is called on edit Graphics Deliverable record
    public pagereference editGraphics()
    {
        System.debug('GD Id to be edited : '+ editGDId);
        
        PageReference p;
        if(isLtng)
        {
            p = new Pagereference('/apex/EditGraphicsDeliverablesLightning?id='+editGDId);
        }
        else
        {
            p = new Pagereference('/apex/EditGraphicsDeliverables?id='+editGDId);
        }
        
        
        // Pagereference p=new Pagereference('/apex/EditGraphicsDeliverables?id='+editGDId);
        p.setRedirect(true);
        return p;
    }
    // End of method editGraphics
    
    // This method is called on to delete Graphics Deliverable record
    
    public void deleteGraphics()
    {
        System.debug('GD Id to be deleted : '+deleteGDId);
        
        Graphics_Deliverables__c del=new Graphics_Deliverables__c(Id=deleteGDId);
        if(Graphics_Deliverables__c.sObjectType.getDescribe().isDeletable()){
            delete del;}
        loadGraphics();
        
        
        /*  Pagereference p=new Pagereference('/apex/DeleteGraphicsDeliverable?id='+deleteGDId);
p.setRedirect(true);
return p; 
        
    }
    // End of deleteGraphics method 
    
    
    public void duplicateGD()
    {
        try
        {
            List<Graphics_Deliverables__c> insertGD=new List<Graphics_Deliverables__c>();
            
            List<Graphics_Deliverables__c> abc = [select id,Job__c,Name,Deliverable_Date__c,Graphics_Description__c,Graphics_Note__c,Graphics_Type__c,
                                                  Dummy_Date_1__c,Dummy_Date_2__c,Dummy_Date_3__c,Dummy_Date_4__c,Dummy_Date_5__c,
                                                  Dummy_Picklist_1__c,Dummy_Picklist_2__c,Dummy_Picklist_3__c,Dummy_Picklist_4__c,Dummy_Picklist_5__c,
                                                  Dummy_Text_1__c,Dummy_Text_2__c,Dummy_Text_3__c,Dummy_Text_4__c,Dummy_Text_5__c,
                                                  Dummy_Text_6__c,Dummy_Text_7__c,Dummy_Text_8__c,Dummy_Text_9__c,Dummy_Text_10__c,Dummy_Text_11__c,
                                                  Dummy_Text_12__c,Dummy_Text_13__c,Dummy_Text_14__c,Dummy_Text_15__c from Graphics_Deliverables__c where id =: dupGDId Limit 1];
            
            for(Graphics_Deliverables__c GD:abc) 
            {
                Graphics_Deliverables__c objGD=new Graphics_Deliverables__c();
                if(schema.SobjectType.Graphics_Deliverables__c.Fields.name.isCreateable()){ 
                    objGD.name=GD.Name;
                }
                if(schema.SobjectType.Graphics_Deliverables__c.Fields.Job__c.isCreateable()){ 
                    objGD.Job__c=GD.Job__c;
                }
                if(schema.SobjectType.Graphics_Deliverables__c.Fields.Deliverable_Date__c.isCreateable()){ 
                    objGD.Deliverable_Date__c=GD.Deliverable_Date__c;
                }
                if(schema.SobjectType.Graphics_Deliverables__c.Fields.Graphics_Description__c.isCreateable()){ 
                    objGD.Graphics_Description__c=GD.Graphics_Description__c;
                }
                if(schema.SobjectType.Graphics_Deliverables__c.Fields.Graphics_Note__c.isCreateable()){ 
                    objGD.Graphics_Note__c=GD.Graphics_Note__c;
                }
                if(schema.SobjectType.Graphics_Deliverables__c.Fields.Graphics_Type__c.isCreateable()){ 
                    objGD.Graphics_Type__c=GD.Graphics_Type__c;
                }
                if(schema.SobjectType.Graphics_Deliverables__c.Fields.Dummy_Date_1__c.isCreateable()){ 
                    objGD.Dummy_Date_1__c=GD.Dummy_Date_1__c;
                }
                if(schema.SobjectType.Graphics_Deliverables__c.Fields.Dummy_Date_2__c.isCreateable()){ 
                    objGD.Dummy_Date_2__c=GD.Dummy_Date_2__c;
                }
                if(schema.SobjectType.Graphics_Deliverables__c.Fields.Dummy_Date_3__c.isCreateable()){ 
                    objGD.Dummy_Date_3__c=GD.Dummy_Date_3__c;
                }
                if(schema.SobjectType.Graphics_Deliverables__c.Fields.Dummy_Date_4__c.isCreateable()){ 
                    objGD.Dummy_Date_4__c=GD.Dummy_Date_4__c;
                }
                if(schema.SobjectType.Graphics_Deliverables__c.Fields.Dummy_Date_5__c.isCreateable()){ 
                    objGD.Dummy_Date_5__c=GD.Dummy_Date_5__c;
                }
                if(schema.SobjectType.Graphics_Deliverables__c.Fields.Dummy_Picklist_1__c.isCreateable()){ 
                    objGD.Dummy_Picklist_1__c=GD.Dummy_Picklist_1__c;
                }
                if(schema.SobjectType.Graphics_Deliverables__c.Fields.Dummy_Picklist_2__c.isCreateable()){ 
                    objGD.Dummy_Picklist_2__c=GD.Dummy_Picklist_2__c;
                }
                if(schema.SobjectType.Graphics_Deliverables__c.Fields.Dummy_Picklist_3__c.isCreateable()){ 
                    objGD.Dummy_Picklist_3__c=GD.Dummy_Picklist_3__c;
                }
                if(schema.SobjectType.Graphics_Deliverables__c.Fields.Dummy_Picklist_4__c.isCreateable()){ 
                    objGD.Dummy_Picklist_4__c=GD.Dummy_Picklist_4__c;
                }
                if(schema.SobjectType.Graphics_Deliverables__c.Fields.Dummy_Picklist_5__c.isCreateable()){ 
                    objGD.Dummy_Picklist_5__c=GD.Dummy_Picklist_5__c;
                }
                if(schema.SobjectType.Graphics_Deliverables__c.Fields.Dummy_Text_1__c.isCreateable()){ 
                    objGD.Dummy_Text_1__c=GD.Dummy_Text_1__c;
                }
                if(schema.SobjectType.Graphics_Deliverables__c.Fields.Dummy_Text_2__c.isCreateable()){ 
                    objGD.Dummy_Text_2__c=GD.Dummy_Text_2__c;
                }
                if(schema.SobjectType.Graphics_Deliverables__c.Fields.Dummy_Text_3__c.isCreateable()){ 
                    objGD.Dummy_Text_3__c=GD.Dummy_Text_3__c;
                }
                if(schema.SobjectType.Graphics_Deliverables__c.Fields.Dummy_Text_4__c.isCreateable()){ 
                    objGD.Dummy_Text_4__c=GD.Dummy_Text_4__c;
                }
                if(schema.SobjectType.Graphics_Deliverables__c.Fields.Dummy_Text_5__c.isCreateable()){ 
                    objGD.Dummy_Text_5__c=GD.Dummy_Text_5__c;
                }
                if(schema.SobjectType.Graphics_Deliverables__c.Fields.Dummy_Text_6__c.isCreateable()){ 
                    objGD.Dummy_Text_6__c=GD.Dummy_Text_6__c;
                }
                if(schema.SobjectType.Graphics_Deliverables__c.Fields.Dummy_Text_7__c.isCreateable()){ 
                    objGD.Dummy_Text_7__c=GD.Dummy_Text_7__c;
                }
                if(schema.SobjectType.Graphics_Deliverables__c.Fields.Dummy_Text_8__c.isCreateable()){ 
                    objGD.Dummy_Text_8__c=GD.Dummy_Text_8__c;
                }
                if(schema.SobjectType.Graphics_Deliverables__c.Fields.Dummy_Text_9__c.isCreateable()){ 
                    objGD.Dummy_Text_9__c=GD.Dummy_Text_9__c;
                }
                if(schema.SobjectType.Graphics_Deliverables__c.Fields.Dummy_Text_10__c.isCreateable()){ 
                    objGD.Dummy_Text_10__c=GD.Dummy_Text_10__c;
                }
                if(schema.SobjectType.Graphics_Deliverables__c.Fields.Dummy_Text_11__c.isCreateable()){ 
                    objGD.Dummy_Text_11__c=GD.Dummy_Text_11__c;
                }
                if(schema.SobjectType.Graphics_Deliverables__c.Fields.Dummy_Text_12__c.isCreateable()){ 
                    objGD.Dummy_Text_12__c=GD.Dummy_Text_12__c;
                }
                if(schema.SobjectType.Graphics_Deliverables__c.Fields.Dummy_Text_13__c.isCreateable()){ 
                    objGD.Dummy_Text_13__c=GD.Dummy_Text_13__c;
                }
                if(schema.SobjectType.Graphics_Deliverables__c.Fields.Dummy_Text_14__c.isCreateable()){ 
                    objGD.Dummy_Text_14__c=GD.Dummy_Text_14__c;
                }
                if(schema.SobjectType.Graphics_Deliverables__c.Fields.Dummy_Text_15__c.isCreateable()){ 
                    objGD.Dummy_Text_15__c=GD.Dummy_Text_15__c;
                }
                
                insertGD.add(objGD);
            }
            if(Schema.sObjectType.Job__c.isCreateable()){
                insert insertGD;
            }
            LoadGraphics();
        }
        
        
        catch(System.DMLException e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            //return null;
        }
        
        
        /*   PageReference p;
if(isLtng)
{
p =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&section=GD');
}
else
{
p =  new Pagereference('/apex/JobListView?id='+jobId+'&intFocus=11');
}


//    Pagereference p = new Pagereference('/apex/JobListView?id='+jobId+'&intFocus=11');
p.setRedirect(true);
return p;
        
        
    }
    
    
    
    
    /*       // Start Test Coverage
static testMethod void Test_displayGraphicsDeliverablesUnderJobsTab()
{
Job_Number_Setting__c customSetting1777 = new  Job_Number_Setting__c(Name='NO');

insert customSetting1777;

Media_Type__c testMedia1=new Media_Type__c(Name='Test Media 1666');

insert testMedia1;

Schedule_Template__c testST1=new Schedule_Template__c(Name='Test Schedule Template 1777',Media_Types__c=testMedia1.Id);

insert testST1;

Specification_Template__c testSpec1=new Specification_Template__c(Name='Testing Spcification Template 1777');

insert testSpec1;

Job__c testJob1=new Job__c(Flag__c=True,Job_Auto_Number__c='J 1777',Name='Test Job 1777',Start_Date__c=System.Today(),Media_Types__c=testMedia1.Id,Schedule_Template__c=testST1.Id,Specification_Template__c=testSpec1.Id);

insert testJob1;

System.assertEquals('Test Job 1777',testJob1.Name);       

Graphics_Deliverables__c testGD1=new Graphics_Deliverables__c(Name='Test Graphics 1777',Job__c=testJob1.Id,Graphics_Description__c='Test Graphics Desc 1777',Graphics_Note__c='Test Graphics Note 1777',Graphics_Type__c='Test Graphics Type 1777');   
insert testGD1;

Graphics_Deliverables__c testGD2=new Graphics_Deliverables__c(Name='Test Graphics 1888',Job__c=testJob1.Id,Graphics_Description__c='Test Graphics Desc 1777',Graphics_Note__c='Test Graphics Note 1777',Graphics_Type__c='Test Graphics Type 1777');   
insert testGD2;   


// Instantiate the extention instance with the Custom Controller
displayGraphicsDeliverablesUnderJobsTab ext=new displayGraphicsDeliverablesUnderJobsTab();

// Invoke primary method using extension instance

ext.LoadGraphics();

ApexPages.Pagereference result=ext.createNewGraphics();

result=ext.cancelGraphics();   

result=ext.saveGraphics();

result=ext.editGraphics();

ext.deleteGDId=testGD1.id;

result=ext.deleteGraphics();

delete testGD2;

delete testJob1;

result=ext.saveGraphics();

}// End of Test Coverage*/
}// End of Class