// Extension Class for Edit Schedule Template 
public with sharing class EditScheduleTemplateExtensions
{

  public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
                            }  
  
   public string STprefix {set;get;}




    // Global Variables
    String MTName;
    public String getMTName() { return MTName; }
    public void setMTName(String s) {  this.MTname = s; }
    private final Schedule_Template__c objST;
    // End of Global Variables
    
    // Standard Controller Extension
    public EditScheduleTemplateExtensions(ApexPages.StandardController controller) 
    {
        this.objST=(Schedule_Template__c)controller.getrecord();
        Schedule_Template__c abc = [select id,Name,Media_Types__c from Schedule_Template__c  where id =: objST.id Limit 1];
        MTName = abc.Media_Types__c;
        
        STprefix =Schedule_Template__c.SobjectType.getDescribe().getKeyPrefix();
    }
    // End of Standard Controller EXtension 
    
    // Method called on populate Media Types into picklist 
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
    
    // Method called on to update Schedule Template
    Public PageReference saveme()
    {
        try
        { 
            System.debug('MT Name is :'+MTName);
            if(MTName == null)
            {
                String stringMT = Schema.Schedule_Template__c.fields.Media_Types__c.getDescribe().getLabel();
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,stringMT+' : You must select a '+stringMT+'.');
                ApexPages.addMessage(myMsg);
                return null;
            }
            else
            {    
                Media_Type__c mt=[Select Id,Name from Media_Type__c where Id=:MTName];
                objST.Media_Types__c=mt.Id;
                update objST;
            }
        }
        catch(System.DMLException e)
        {
            return null;
        }
        
          if(isLtng)
               {         
                 PageReference p=new PageReference('/apex/ScheduleTemplateTabOverridelightning?id='+objST.id);
                  p.setRedirect(true);
                  return p; 
                }
        
          else
                {
                PageReference p=new PageReference('/apex/ScheduleTemplateTabOverride?id='+objST.id);
                p.setRedirect(true);
                return p; 
                }
   }
   // End Of Update Method 
   
   // Cancel Method
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
   //End of cancel method

   
   // Test Coverage
  static testMethod void UpdateST()
     {
          Media_Type__c testMedia=new Media_Type__c(Name='MT012');
          insert testMedia;
       
          Schedule_Template__c testST=new Schedule_Template__c(Name='ST012',Media_Types__c=testMedia.Id);
          insert testST;
          
          System.assertEquals('ST012',testST.Name);
          
          Schedule_Template__c testST1=new Schedule_Template__c(Name='ST00009',Media_Types__c=testMedia.Id);
          try
           {
            insert testST1;
           }
          catch(DMLException e)
           {
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
           }
           
          Schedule_Template__c st = [select id,Name from Schedule_Template__c where id =: testST.id];
          st.Name = 'ST012';
          try
           {
            update st;
           }
          catch(DMLException e)
           {
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
           }
               
       
          ApexPages.StandardController con=new ApexPages.StandardController(testST);
          EditScheduleTemplateExtensions ext=new EditScheduleTemplateExtensions(con);  
         
          ext.MTName = testMedia.id;
          String MTName = ext.getMTName();
          ext.setMTName(MTName);
          List<SelectOption> options = ext.getMediaTypes();      
          ApexPages.PageReference result=ext.saveme();  
          
          ext.MTName = NULL;
          String MTName1 = ext.getMTName();
          ext.setMTName(MTName1);
          List<SelectOption> options1 = ext.getMediaTypes();      
          result=ext.saveme();  
          
          Delete testMedia;  
          Delete testST;
          result=ext.saveme();  
          result=ext.cancelme();  
     }  
   // End of Positive Test Case
}// End of Class