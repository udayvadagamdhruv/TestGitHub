public with sharing class DisplayPEstimateSpecItemsController{


       /* // Global variables 
        
            public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
           }  
        
        
            Public String theID;
            public List<Production_Estimate_Temp_Line_Items__c> CSpecItem{get;set;} 
           // public id strCSpecItem{get;set;}
            
        // End of Global variables
       
       // Start Constructor 
        public DisplayPEstimateSpecItemsController()
        {
           theID = ApexPages.CurrentPage().getParameters().get('id');
           CSpecItem=[select id,Name,of_Pages__c,Calc_Unit__c,Sort_Order__c,Material_Item__c,Production_Estimate_Template__c from Production_Estimate_Temp_Line_Items__c where Production_Estimate_Template__c=: theID ORDER BY Sort_Order__c];
        }
        
        // End constructor
    
        // THis methos is called on to Create 
        public PageReference createSpecitems()
        {
             Pagereference p;
               
            if(isLtng)
            {
                 p = new PageReference('/apex/CreatePETLINewpageLightning?parentid='+theID);
            }
            else
            {
                  p =  new PageReference('/apex/CreatePETLINewpage?parentid='+theID);
            }
           
           p.setRedirect(true);
           return p;
          
          
          
        /*    PageReference p =  new PageReference('/apex/CreatePETLINewpage?parentid='+theID);
            p.setRedirect(true);
           
            return p;*/
//        }
        // End method 
        
       // This is save method
     /*  public PageReference save()
       {
        
           update CSpecItem;
          // After updating specs, navigate to creative template Tab
          
          
           Pagereference p;
               
            if(isLtng)
            {
                 p = new Pagereference('/apex/PETempDetailpageLightning?id='+theID);
            }
            else
            {
                  p = new Pagereference('/apex/ProductionEstimateTempDetailpage?id='+theID);
            }
           
           p.setRedirect(true);
           return p;
          
         
         /* PageReference p =  new Pagereference('/apex/ProductionEstimateTempDetailpage?id='+theID);
          p.setRedirect(true);
          return p; */
    //   }
    
    
     //Method For Cancel button    
    /* public PageReference cancelme()
     {
          Pagereference p;
               
            if(isLtng)
            {
                 p = new Pagereference('/apex/PETempDetailpageLightning?id='+theID);
            }
            else
            {
                  p = new Pagereference('/apex/ProductionEstimateTempDetailpage?id='+theID);
            }
           
           p.setRedirect(true);
           return p;
        
     
       /* PageReference p =  new Pagereference('/apex/ProductionEstimateTempDetailpage?id='+theID);
        p.setRedirect(true);
        return p;    */ 
     //}
       
   

}