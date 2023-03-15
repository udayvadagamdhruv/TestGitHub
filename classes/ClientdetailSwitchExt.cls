public with sharing class ClientdetailSwitchExt{

        public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                        }
            }
            
        public string ClientId{get;set;}
        public Client_Contact__c ClientContact{get;set;}  


        public ClientdetailSwitchExt(ApexPages.StandardController controller) 
        {

             ClientId= controller.getRecord().id;
             ClientContact=[select id,name,Client__c from Client_Contact__c where id=:ClientId];
        }


       
        
        
        public pageReference Clientlistview()
        {
            String ClientConid;
            ClientConid =  ClientContact.Client__c;
          
             if(isLtng)
             {
                      PageReference p =  new Pagereference('/apex/ClientViewPageLightning?id='+ClientConid);
                      p.setRedirect(true);
                      return p;
             
             
             }
             else
             {
                  PageReference p =  new Pagereference('/apex/ClientViewPage?id='+ClientConid);
                  p.setRedirect(true);
                  return p;
             
             }
          
        }


}