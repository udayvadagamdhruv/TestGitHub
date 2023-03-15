public with sharing class EditClientExt 
{
  /*  public Client__c objcli;
    
    public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                        }
            }  

  //  private final Client__c objV;
    public EditClientExt(ApexPages.StandardController con) 
    {
       
    
        list<string> FSetFields = new list<string>();
        for(Schema.FieldSetMember f:sObjectType.Client__c.FieldSets.getMap().get('n').getFields()){
            FSetFields.add(f.getFieldPath());
        }
        
         if(!Test.isRunningTest()) con.addFields(FSetFields);
        
        
        
         this.objcli = (Client__c)con.getRecord(); 
        
       // this.objV=(Client__c)con.getrecord();
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
                    if(schema.SobjectType.Client__c.Fields.Client_Fax__c.isUpdateable()){
                        objcli.Client_Fax__c= '(' + FaxNumber.SubString(0,3) + ') ' + FaxNumber.SubString(3, 6) + '-' + FaxNumber.SubString(6);
                    }
                }
                
                else
                {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please Enter 10 digits Number only for Fax Ex: 1234567890'));
                        return null;
                }
                
             } 
             
             update objcli;
        
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
    
    }*/
   

}