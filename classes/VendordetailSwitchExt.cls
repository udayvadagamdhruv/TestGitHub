public with sharing class VendordetailSwitchExt{

        public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                        }
            }
            
        public string VendorId{get;set;}
        public Vendor_Contact__c vendorContact{get;set;}  


        public VendordetailSwitchExt(ApexPages.StandardController controller) 
        {

             VendorId = controller.getRecord().id;
             vendorContact=[select id,name,Vendor__c from Vendor_Contact__c where id=:VendorId];
        }


       
        
        
        public pageReference Venlistview()
        {
            String VenConid;
            VenConid =  vendorContact.Vendor__c ;
            PageReference p;
             if(isLtng)
             {
                   p =  new Pagereference('/apex/VendorListViewLightning?id='+VenConid);
			 }
             else
             {
                   p =  new Pagereference('/apex/VendorListView?id='+VenConid);
             }
              p.setRedirect(true);
                  return p;
          
        }


}