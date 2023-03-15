// This class is used to create New Schedule Template
public with sharing class CreateNewScheduletemplate 
{

   public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
                            }  
  
   public string STprefix {set;get;}


    // Global variables 

    String MTName;
    public String getMTName() { return MTName; }
    public void setMTName(String s) {  this.MTname = s; }
    private final Schedule_Template__c st;
    String strid;   
    
    // End Global variables 
    
    // Start Constructor 
    public CreateNewScheduletemplate(ApexPages.StandardController controller) 
    {
        this.st=(Schedule_Template__c)controller.getRecord();
        
         Schema.DescribeSObjectResult r=Schedule_Template__c.SObjectType.getDescribe();
         STprefix =r.getKeyPrefix();
        
    }
    // End Constructor
    
    // Populate MediaTypes in Picklist
    public List<selectOption> getMediaTypes() 
    {
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (Media_Type__c a : [SELECT Id, name FROM Media_Type__c order by Name]) 
        {  
            optionList.add(new selectOption(a.Id, a.Name));  
        }
        return optionList;  
    }   
    // End getMediaTypes method
    
    // Method called on to Save Schedule Template
    public PageReference saveme()
    {
        try
        {
            st.Media_Types__c=MTName;

            if(MTName == null)
            {
                String stringMT = Schema.Schedule_Template__c.fields.Media_Types__c.getDescribe().getLabel();
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,stringMT+' : You must select a '+stringMT+'.');
                ApexPages.addMessage(myMsg);
                return null;
            }
            else
            {
                insert st;
                strid=st.Id;
            }
         }
         catch(System.DMLException e)
         {
              return null;
         }
          
         if(isLtng)
           {
              PageReference p=new PageReference('/apex/ScheduleTemplateTabOverrideLightning?id='+strid);
              p.setRedirect(true);
              return p;
           }
           
          else
          {
             PageReference p=new PageReference('/apex/ScheduleTemplateTabOverride?id='+strid);
              p.setRedirect(true);
              return p;
          
          }
    }
    // End Save method
    
    //Start Cancel Method
      Public PageReference cancelme()
              {
              
               if(isLtng)
                  {
                      PageReference p =  new Pagereference('/'+STprefix +'/o');
                      p.setRedirect(true);
                      return p;
                  }
               else
                   {
                    PageReference p =  new Pagereference('/apex/AdminListView?intFocus=2');
                      p.setRedirect(true);
                      return p;
                   
                   }  
              
                    
              
              }
    //End of Cancel Method

    
    // Start Test Coverage Code
     static testMethod void insertST()
     {
          Media_Type__c testMedia=new Media_Type__c(Name='MT007');
          insert testMedia;
       
          Schedule_Template__c testST=new Schedule_Template__c(Name='ST007',Media_Types__c=testMedia.Id);
       
          ApexPages.StandardController con=new ApexPages.StandardController(testST);
          CreateNewScheduletemplate ext=new CreateNewScheduletemplate(con);  
         
          ext.MTName = NULL; // To check Media Type as NULL
          String MTName1 = ext.getMTName();
          ext.setMTName(MTName1);
          List<SelectOption> options1 = ext.getMediaTypes();      
          ApexPages.PageReference result=ext.saveme();  
         
          ext.MTName = testMedia.id;
          String MTName2 = ext.getMTName();
          ext.setMTName(MTName2);
          List<SelectOption> options2 = ext.getMediaTypes();      
          result=ext.saveme();  
          
          System.assertEquals('ST007',testST.Name);
          
          
          Schedule_Template__c testST1=new Schedule_Template__c(Name='ST008',Media_Types__c=testMedia.Id);
          try
          {
                insert testST1;
          }
          catch(System.DMLException e)
          {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
           } 
            
            Schedule_Template__c st=[select id,Name from Schedule_Template__c where id =: testST1.id];
            st.Name='ST007';
            try
            {
                 update st;
            }
            catch(System.DMLException e)
             {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
             } 
            
            delete testST;
            result=ext.saveme();   
            result=ext.cancelme();
     }  
     // End test Coverage
}
// End of Class