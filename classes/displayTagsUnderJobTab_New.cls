// This class is used as a extension to display tag template line item under job tab 
public with sharing class displayTagsUnderJobTab_New{

    // Global variables
     public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
     } 
  
    
    
    public Id jobId{get;set;}
    public List<Tag__c> lstJobTag{get;set;}    
    public Job__c job{get;set;}
    public String tagId{get;set;}
    public String TagTempName{get;set;}
    public String queryString{get;set;}
     public String queryStringcopy{get;set;}
     public List<Tag__c> lstJobTagcopy{get;set;}
    // End of Global variables
    
    
    /* Sort */  
    
     private String sortDirection = 'ASC';
       private String sortExp = 'name';
    
       public String sortExpression
       {
         get
         {
            return sortExp;
         }
         set
         {
           //if the column is clicked on then switch between Ascending and Descending modes
           if (value == sortExp)
             sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
           else
             sortDirection = 'ASC';
           sortExp = value;
         }
       }
    
     public String getSortDirection()
     {
        //if not column is selected 
        if (sortExpression == null || sortExpression == '')
          return 'ASC';
        else
         return sortDirection;
     }
    
     public void setSortDirection(String value)
     {  
       sortDirection = value;
     }
  
    
    
    // Sort order
    
    
    
    
    
    // Start Constructor
    public displayTagsUnderJobTab_New(ApexPages.StandardController st)
    {
        job = (Job__c)st.getRecord();
        jobId = ApexPages.currentPage().getParameters().get('id');  
        LoadTags();
    }
    // End Constructor
    
    public PageReference  LoadTags()
    
    {
    
        string sortFullExp = sortExpression  + ' ' + sortDirection;
    
         jobId = ApexPages.currentPage().getParameters().get('id');       
       //  lstJobTag=[Select id,Name,job__c,Tag_Program_Title__c,Tag_Start_Date__c, Tag_End_Date__c, Tag_Due_Date__c, Tag_Air_Time__c, Tag_Lengths__c, Tag_Air_Date__c from Tag__c where Job__c =: jobId ORDER BY CreatedDate];   
          
        queryString = 'select id';
        for(Schema.FieldSetMember fld :SObjectType.Tag__c.FieldSets.TagsFieldsets.getFields()) {
         queryString += ', ' + fld.getFieldPath();
        }
        queryString += ' from Tag__c where Job__c =: jobId ORDER BY ' + sortFullExp + ' limit 100';
         
        lstJobTag= Database.query(queryString);
       
        system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Show Air LoadTags>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+Tag__c.Tag_Air_Date__c )  ;
          return null;
       
    }
    
    // This method is called on to handle Save button
    public PageReference save()
    {
          try
          {   
              system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Show Air save >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+Tag__c.Tag_Air_Date__c )  ;
         
              update lstJobTag;
              
              system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Show Air after save >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+Tag__c.Tag_Air_Date__c )  ;
          }
          catch(System.DMLException e)
          {
                     return null;
          }
          
          PageReference p;
          if(isLtng)
          {
             p =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&section=Tag');
          }
          else
          {
             p =  new Pagereference('/apex/JobListView?id='+Jobid+'&intFocus=9');
          }
          
          
       //   PageReference p =  new Pagereference('/apex/JobListView?id='+jobId);
          p.setRedirect(true);
          return p;     
    }
    // End of method Save
    
    // This method is called on to handle Cancel button
     Public PageReference cancelme()
     {
        PageReference p;
        if(isLtng)
        {
             p =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&section=Tag');
        }
        else
        {
             p =  new Pagereference('/apex/JobListView?id='+Jobid+'&intFocus=9');
        }
       
       
       // PageReference p =  new Pagereference('/apex/JobListView?id='+jobId);
        p.setRedirect(true);
        return p;     
       }
    // End Cancel method
    
    // This method is called on to edit Job Spec
    public Pagereference editJobTag()
    {
          
          
        PageReference p;
        if(isLtng)
        {
             p =  new Pagereference('/apex/editTagLightning?id='+tagId);
        }
        else
        {
             p =  new Pagereference('/apex/editTag?id='+tagId);
        }
          
          
         //  Pagereference p=new Pagereference('/apex/editTag?id='+tagId);
           p.setRedirect(true);
           return p;
    }
    // End method editJobSpec
    
    // This method is called on to DeleteJobSpec
     public void deleteJobTag()
    {    
       
            Tag__c del=new Tag__c(Id=tagId);
            delete del;
            LoadTags();
       
       
       /*
         Pagereference p=new Pagereference('/apex/DeleteTag?id='+tagId);
         p.setRedirect(true);
         return p;*/
    }
    // End method DeleteJobSpec
    
    // This method is called on to add New Job Spec
    public pagereference addNewJobTag()
    {
         jobId = ApexPages.currentPage().getParameters().get('id');       
        
         PageReference p;
        if(isLtng)
        {
             p=Page.CreateNewTagLightning;
        }
        else
        {
            p=Page.CreateNewTag;
        }
        
        
        
       //  Pagereference p=Page.CreateNewTag;
         p.setRedirect(true);
         p.getParameters().put('jobId',jobId);
         return p;
    }
    // End of method addNewJobSpec
    
     // This method is called on to Import Specs
    public void importTags()
    {
        List<Tag__c> insertJobTags=new List<Tag__c>();    
        
        if(TagTempName==NULL || TagTempName=='-None-')
        {
           ApexPages.Message msg1 = new ApexPages.Message(ApexPages.Severity.ERROR,'Tag Template : You must select a Template.');
           ApexPages.addMessage(msg1);
        }
        else
        {
            try
            {
            List<Tag_Template_Item__c> lstTags=[Select id,Name,Description__c,Air_Time__c, Show_Air_Date__c, Promo_End_Date__c, Promo_Due_Date__c, Air_Date__c, Lengths__c from Tag_Template_Item__c where TagTemplate__c=:TagTempName Order By CreatedDate ];
            for(Tag_Template_Item__c tg:lstTags)
            {              
              Tag__c js=new Tag__c();
              js.Name=tg.Name;
              js.Tag_Program_Title__c=tg.Description__c;
              js.Job__c = jobId;
              //Yogini - following fields added on 03May13
              js.Tag_Air_Time__c = tg.Air_Time__c;
              js.Tag_Start_Date__c = tg.Show_Air_Date__c;
              js.Tag_End_Date__c = tg.Promo_End_Date__c;
              js.Tag_Due_Date__c = tg.Promo_Due_Date__c;
              js.Tag_Air_Date__c = tg.Air_Date__c;
              js.Tag_Lengths__c = tg.Lengths__c;
              insertJobTags.add(js);
            }
            insert insertJobTags;
            }
            catch(System.DMLException e)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
             // return NULL;
            }
        }   
        LoadTags();
        
      /*  PageReference p;
        if(isLtng)
        {
             p =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&section=Tag');
        }
        else
        {
             p =  new Pagereference('/apex/JobListView?id='+Jobid+'&intFocus=9');
        }
        
        
       // PageReference p =  new Pagereference('/apex/JobListView?id='+jobId);
        p.setRedirect(true);
        return p;*/
    }
    // End of method Import Specs
    
    // This method is called on to populate all Specification Template into drop down list
    public List<selectOption> getTagTemplates() 
    {        
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new SelectOption('','-None-'));
        for (Tag_Template__c a : [SELECT Id, name FROM Tag_Template__c ORDER BY Name limit 100]) 
        {  
            optionList.add(new selectOption(a.Id, a.Name));  
        }
        return optionList;  
    }
    // End of method getSpecificationTemplates
    
    //Added by yogini on 18-Sep-13
    public Void DuplicateTag(){
        string tagName;
        jobId = ApexPages.currentPage().getParameters().get('id');        
        Tag__c objTag = new Tag__c();
            
       
        /*queryStringcopy = 'select id';
        for(Schema.FieldSetMember fld :SObjectType.Tag__c.FieldSets.TagsFieldsets.getFields()) {
         queryStringcopy += ', ' + fld.getFieldPath();
        }
        queryStringcopy += ' from Tag__c where ID=:tagId limit 1';
        lstjobTagcopy= Database.query(queryStringcopy);
       */
       
         For(Tag__c objTemp:[Select Name,Dummy_Date_2__c,Dummy_Date_1__c,Dummy_Date_3__c,Dummy_Date_4__c,Dummy_Text_1__c,Dummy_Text_2__c,Dummy_Text_3__c,Dummy_Text_4__c,Dummy_Picklist_1__c,Dummy_Picklist_2__c,Dummy_Picklist_3__c,Dummy_Picklist_4__c, Tag_Air_Date__c, Tag_Air_Time__c, Job__c, Tag_Lengths__c, Tag_Due_Date__c, Tag_End_Date__c, Tag_Start_Date__c, Tag_Program_Title__c from Tag__c where ID=:tagId limit 1]) 
         {
            tagName = 'Dup : '+DateTime.Now()+' '+objTemp.Name;
            if(tagName.length() > 80)
            {
               tagName = tagName.substring(0,80);
            }        
            objTag.Name = tagName;
            objTag.Tag_Air_Date__c = objTemp.Tag_Air_Date__c;
            objTag.Tag_Air_Time__c = objTemp.Tag_Air_Time__c;
            objTag.Job__c = jobId;
            objTag.Tag_Lengths__c = objTemp.Tag_Lengths__c;
            objTag.Tag_Due_Date__c = objTemp.Tag_Due_Date__c;
            objTag.Tag_End_Date__c = objTemp.Tag_End_Date__c;
            objTag.Tag_Start_Date__c = objTemp.Tag_Start_Date__c;
            objTag.Tag_Program_Title__c = objTemp.Tag_Program_Title__c;
            objTag.Dummy_Date_1__c = objTemp.Dummy_Date_1__c;
            objTag.Dummy_Date_2__c = objTemp.Dummy_Date_2__c;
            objTag.Dummy_Date_3__c = objTemp.Dummy_Date_3__c;
            objTag.Dummy_Date_4__c = objTemp.Dummy_Date_4__c;
            objTag.Dummy_Text_1__c= objTemp.Dummy_Text_1__c;
            objTag.Dummy_Text_2__c= objTemp.Dummy_Text_2__c;
            objTag.Dummy_Text_3__c= objTemp.Dummy_Text_3__c;
            objTag.Dummy_Text_4__c= objTemp.Dummy_Text_4__c;
            objTag.Dummy_Picklist_1__c= objTemp.Dummy_Picklist_1__c;
            objTag.Dummy_Picklist_2__c= objTemp.Dummy_Picklist_2__c;
            objTag.Dummy_Picklist_3__c= objTemp.Dummy_Picklist_3__c;
            objTag.Dummy_Picklist_4__c= objTemp.Dummy_Picklist_4__c;
            
            
        }  
        
        try{
            Insert objTag; 
            
            LoadTags();
            
          /*  PageReference p;
            if(isLtng)
            {
                 p =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&section=Tag');
            }
            else
            {
                 p =  new Pagereference('/apex/JobListView?id='+Jobid+'&intFocus=9');
            }
            
             
         //   PageReference p =  new Pagereference('/apex/JobListView?id='+jobId);
            p.setRedirect(true);    return p;     */         
        }
        catch(System.DMLException e){        
            ApexPages.Message msg1 = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(msg1);
        //    return null;
        } 
    }
    //end
    
    /*
    // Start Test Coverage - created separate testclass
    static testMethod void Test_RetrieveJobTags()
    {
        Job_Number_Setting__c customSetting1310 = new  Job_Number_Setting__c(Name='NO');

            insert customSetting1310;
            
        Media_Type__c testMedia=new Media_Type__c(Name='Test Media 1310');
             
                insert testMedia;
             
        Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 1310',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
        Specification_Template__c testSpec1=new Specification_Template__c(Name='Testing Spcification Template 1310');
                insert testSpec1;
                
        Spec_Item__c testSPI1=new Spec_Item__c(Name='Test SPI 1310',Description__c='Test Desc 1310',Specification_Template__c=testSpec1.id);
             insert testSPI1;     
             
         Specification_Template__c testSpec2=new Specification_Template__c(Name='Testing Spcification Template 1311');
                insert testSpec2;
                
        Spec_Item__c testSPI2=new Spec_Item__c(Name='Test SPI 1311',Description__c='Test Desc 1310',Specification_Template__c=testSpec2.id);
             insert testSPI2;            
        
        Tag_Template__c testTagTemp = new Tag_Template__c(Name='Test tag temp 5Apr13');
            insert testTagTemp;
            
        Tag_Template_Item__c testTagTempItem = new Tag_Template_Item__c(Name='Test temp Item 5Apr13',TagTemplate__c=testTagTemp.id,Air_Time__c='150', Show_Air_Date__c=date.today(), Promo_End_Date__c=date.today(), Promo_Due_Date__c=date.today(), Air_Date__c=date.today(),Lengths__c='200');
            insert testTagTempItem;
            
        Job__c testJob1=new Job__c(Name='Test Job 1310',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec1.Id);
         
                 insert testJob1;
                 
        System.assertEquals('Test Job 1310',testJob1.Name);        
                 
        Job_Spec__c testJobSpec=new Job_Spec__c(Name='Job Spec 1310',Job__c=testJob1.id);        
             
                 insert testJobSpec;
        
        Tag__c testJobTag = new Tag__c(Name='Test temp Item 5Apr13', Job__c=testJob1.id);
                 insert testJobTag;
                 
        ApexPages.currentPage().getParameters().put('id',testJob1.Id); 
       
       // Instantiate the standard controller with the Job
        ApexPages.StandardController con=new ApexPages.StandardController(testJob1);
       
        // Instantiate the extention instance with the standard controller 
        
        displayTagsUnderJobTab_New ext1=new displayTagsUnderJobTab_New(con);
       
        ext1.tagId=testJobTag.id;
       
        // Invoke the primary method on the extension
        
        ApexPages.Pagereference result=ext1.editJobTag();
       
        result=ext1.save();
        result=ext1.importTags();
        
        ext1.TagTempName=testTagTemp.Id;
        result=ext1.importTags();
        result=ext1.addNewJobTag();
        
        List<SelectOption> lst=ext1.getTagTemplates();
       
        result=ext1.cancelme();
       
        result=ext1.deleteJobTag();
        
        List<Job_Spec__c> lstJobTag=[Select id from Job_Spec__c where Job__r.Name=:'Test Job 1310'];
        delete lstJobTag;
        result=ext1.save();
        
        Job__c obj=[Select Id from Job__c where Name=:'Test Job 1310'];
        delete obj;
        
        Specification_Template__c specTemp1=[Select id from Specification_Template__c where Name=:'Testing Spcification Template 1310'];
        delete specTemp1;
        
        Specification_Template__c specTemp2=[Select id from Specification_Template__c where Name=:'Testing Spcification Template 1311'];
        delete specTemp2;
        
        result=ext1.importTags();
    }
    // End Test Coverage
    */
}
// End of Class