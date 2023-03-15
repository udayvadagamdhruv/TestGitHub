public with sharing class CreateNewClientLightningExt {
/*
    public Client__c objcli;
    
     public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                        }
            }  
    

    public CreateNewClientLightningExt(ApexPages.StandardController controller) 
    {
         this.objcli = (Client__c)controller.getRecord(); 
    }
    
    
    Public PageReference saveme()
    {
        try
        {
             if(string.isNotBlank(objcli.Client_Fax__c))
             {
               
                String FaxNumber = objcli.Client_Fax__c.replaceAll('[^0-9]','');
               
               
                if(FaxNumber.length() == 10 && FaxNumber.isNumeric()) 
                {
                    if(schema.SobjectType.Client__c.Fields.Client_Fax__c.isCreateable()){ 
                        objcli.Client_Fax__c= '(' + FaxNumber.SubString(0,3) + ') ' + FaxNumber.SubString(3, 6) + '-' + FaxNumber.SubString(6);
                    }
                }
                
                else
                {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please Enter 10 digits Number only for Fax Ex: 1234567890'));
                        return null;
                }
                
             } 
             if(Schema.sObjectType.Client__c.isCreateable()){
                 insert  objcli;
             }
        
        }
        
        catch(System.DMLException e)
       {
            return null;
       }
       
       PageReference p;
       
      if(isLtng)
      {
           
            p =  new Pagereference('/apex/ClientViewPageLightning?id='+objcli.id);
           
      }
      else   
      {
          p =  new Pagereference('/apex/ClientViewPage?id='+objcli.id);
             
      }  
       
       p.setRedirect(true);
           return p;
    
    }
   */
         
}