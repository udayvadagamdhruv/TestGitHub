// This class is used to create New Tag Template
public with sharing class createTagTemp 
{
    // Global variables 
   /* private final Tag_Template__c objTag; 
    
     public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
                            }  
     public string TagTempprefix {set;get;}  
     // Start Constructor
    public createTagTemp(ApexPages.StandardController controller) 
    {
       this.objTag = (Tag_Template__c)controller.getRecord(); 
        TagTempprefix  = Tag_Template__c.SobjectType.getDescribe().getKeyPrefix();
    }
    // End Constructor
    
    //Save Method
    Public PageReference saveme()
    {
     try 
       { 
            insert objTag;
       }
       Catch(System.DMLException e)
       {
           return null;
       }
      //PageReference p =  new Pagereference('/apex/AdminListView?intFocus=11');     
      
       PageReference p;
            if(isLtng)
            {
               p = new Pagereference('/apex/TagTemplatedetailpageLightning?id='+objTag.id);
            }
            else
            {
               p =  new Pagereference('/apex/TagTemplatedetailpage?id='+objTag.id);
            }
       
    //  PageReference p =  new Pagereference('/apex/TagTemplatedetailpage?id='+objTag.id);      //added by yogini on 02-May-13
      p.setRedirect(true);
      return p;
    }
    //End of Save Method
    
    //Cancel Method
      Public PageReference cancelme()
      {
             PageReference p;   
             if(isLtng)
             {
                p =  new Pagereference('/'+TagTempprefix+'/o');
             }
            
            else
             {
               p = new Pagereference('/apex/AdminListView?intFocus=11');
             }
               p.setRedirect(true);
               return p; 
            
            
            /*  PageReference p =  new Pagereference('/apex/AdminListView?intFocus=11');
              p.setRedirect(true);
              return p; 
      }
    //End of cancel Method
   
   //test method 
   static testMethod void insertTagTemp()
     {
         Tag_Template__c testtag=new Tag_Template__c(Name='TT002');
         ApexPages.StandardController con=new ApexPages.StandardController(testtag);
         createTagTemp ext=new createTagTemp(con);        
         ApexPages.PageReference result=ext.saveme();
         System.assertEquals('TT002',testtag.Name);
        
        Tag_Template__c testTagT=new Tag_Template__c(Name='TT003');
           try
            {
                insert testTagT;
            }
            catch(System.DMLException e)
            {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
            }
         Tag_Template__c tt=[select id,Name from Tag_Template__c where id =: testTagT.id];
         tt.Name = 'TT002';
            try
            {
                update tt;
            }
            catch(System.DMLException e)
            {
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
            }
            
            Delete testtag;
            result=ext.saveme();   
            result=ext.cancelme();
     }  */
    //End of test Method 
}
// End of class