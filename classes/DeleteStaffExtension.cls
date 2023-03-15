// Extension class to Delete Staff 
public with sharing class DeleteStaffExtension 
{
     // Globl Variables
    public Boolean isError{get;set;} 
    private final Staff__c st;
    
    public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                        }
            }  

    public string Staffprefix {set;get;}
    
    
    // End Of Global Variables 
    
    // Standard Controller Constructor
    public DeleteStaffExtension(ApexPages.StandardController controller) 
    {
        isError = False;
        this.st=(Staff__c)controller.getrecord();
        
         Staffprefix =Staff__c.SobjectType.getDescribe().getKeyPrefix();
    }
    // End of Standard Controller Constructor 
    
    // Method called on to delete GL Code
    public PageReference checkDelete()
    {
      try
       {
           if(schema.SobjectType.Staff__c.Fields.IsDeleted__c.isUpdateable()){
               st.IsDeleted__c=True;
           }
           if(Schema.sObjectType.Staff__c.isUpdateable()) {
               update st;
           }
       }
       catch(System.DMLException e)
       {
           isError = True;
           return null;
       }
       
       
           if(isLtng)
            {
                 PageReference p =  new Pagereference('/'+Staffprefix+'/o');
                 p.setRedirect(true);
                 return p; 
            }
            else
            {
                     // After deletion navigate to Staff/User List 
                  PageReference p = new PageReference('/apex/AdminListView?intFocus=5');
                  p.setRedirect(true);
                  return p; 
            }
      
     
    }
    
    
    public pageReference staffview()
    {
  
        if(isLtng)
        {
             //PageReference p =  new Pagereference('/'+Staffprefix+'/o');
             PageReference p =  new Pagereference('/apex/StaffTabLightning');
             p.setRedirect(true);
             return p; 
        }
        else
        {
                 // After deletion navigate to Staff/User List 
              PageReference p = new PageReference('/apex/AdminListView?intFocus=5');
              p.setRedirect(true);
              return p; 
        }
  
    }
    
    // Test Coverage 
        static testMethod void Test_DeleteStaffExtension()
        {
            Staff__c testStaff=new Staff__c(First_Name__c='Test Staff',Last_Name__c='001',Email__c='TestStaff001@SFDC.com',Username__c='TestStaff001@SFDC.com',User_Type__c='Staff');
            insert testStaff;
            
            System.assertEquals('Test Staff',testStaff.First_Name__c);
            
            ApexPages.currentPage().getParameters().put('id',testStaff.id); 
            ApexPages.StandardController con2=new ApexPages.StandardController(testStaff);
        
            //Instantiate the extention instance with the standardcontroller
            
            DeleteStaffExtension ext2=new DeleteStaffExtension(con2);
            ApexPages.Pagereference result=ext2.checkDelete();
        
            delete testStaff;
        
            result=ext2.checkDelete();
            ext2.staffview();
        }
    // End of Test Code
}// End of Class