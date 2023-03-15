public with sharing class DisplayProductionEstimateJobTab {

   // Global variables
  /*  public string strPEstID{get;set;}
    public string strPEstID1{get;set;}
    public List<Production_Estimate__c> vq{get;set;}
    public List<Production_Estimate__c> vq1{get;set;} 
    Public Set<Material_Item__c> Materialids{get;set;}
    public List<Production_Estimate__c> peli{get;set;}
    public String str{get;set;}
    Public String theID;
    public String PETempName{get;set;}
    public map<string,list<Production_Estimate__c>> MapPE{get;set;}
    public string strPEID{get;set;}
    
     public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            }  
            
            
     public boolean ViewAll{get; set;}
     public boolean ShowLess{get; set;}

  // End of Global variables
  
  
  
  
   public List<selectOption> getPETemplate() 
    {
        Production_Estimate__c testPro = new Production_Estimate__c();
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new SelectOption('','-None-'));
        for (Production_Estimate_Template__c  a : [SELECT Id, name FROM Production_Estimate_Template__c ORDER BY Name]) 
        {  
            optionList.add(new selectOption(a.Id, a.Name));  
        }
        return optionList;  
    }
  
  
  

  // Start constructor
    public DisplayProductionEstimateJobTab() 
    {
        
         ViewAll=True;
         ShowLess=False;
        
         theID = ApexPages.CurrentPage().getParameters().get('id');
  
         Production_Estimate__c testPro = new Production_Estimate__c();
         vq=[select id,Name,Approved__c,Material_Item__c,PE_Template__c,Qty_Used__c,Lf_Used__c,Material_Item__r.name,Material_Item__r.Qty_On_Hand__c,PO_Created__c,GL_Code__r.Name,Calc_Unit__c,Restrict__c,Quantity__c,Vendor__c,Vendor__r.Name,Amount__c,Total_Cost__c,Job__c,PO__c,Job__r.name,Job__r.Job_Auto_Number__c from Production_Estimate__c where Job__c =: [Select id from Job__c where id =: theID] Order By Sort_Order__c];
     //    vq1=[select id,Name,Approved__c,Material_Item__c,PE_Template__c,Qty_Used__c,Lf_Used__c,Material_Item__r.name,Material_Item__r.Qty_On_Hand__c,PO_Created__c,GL_Code__r.Name,Calc_Unit__c,Restrict__c,Quantity__c,Vendor__c,Vendor__r.Name,Amount__c,Total_Cost__c,Job__c,PO__c,Job__r.name,Job__r.Job_Auto_Number__c from Production_Estimate__c where Job__c =: [Select id from Job__c where id =: theID] Order By Sort_Order__c  Limit 5];
         peli=[select id,Name,Approved__c,PO_Created__c,PE_Template__c,GL_Code__r.Name,Qty_Used__c,Lf_Used__c,Calc_Unit__c,Restrict__c,Quantity__c,Vendor__c,Vendor__r.Name,Amount__c,Total_Cost__c,Job__c,PO__c from Production_Estimate__c where Job__c =: [Select id from Job__c where id =: theID] and Approved__c = true ];
    
    
           MapPE = new map<string,list<Production_Estimate__c>>();
           
       /*    if(isLtng)
           {
               vq=vq1;
           }*
           
         
         for(Production_Estimate__c JS:vq)
         {
               if(MapPE.containsKey(js.PE_Template__c))
               {
                  List <Production_Estimate__c> PElist =  MapPE .get(js.PE_Template__c);
                  PElist.add(js);
                  MapPE.put(js.PE_Template__c,PElist);  
                }
                else
                {
                  MapPE.put(js.PE_Template__c, new List<Production_Estimate__c>{js}) ;
                }   
         
         }
    
    
    }
    // End Constructor
    
    
    
    
     Public void ViewAllPE()
    {
        ViewAll=False;
        ShowLess=True;
        
        vq=[select id,Name,Approved__c,Material_Item__c,PE_Template__c,Qty_Used__c,Lf_Used__c,Material_Item__r.name,Material_Item__r.Qty_On_Hand__c,PO_Created__c,GL_Code__r.Name,Calc_Unit__c,Restrict__c,Quantity__c,Vendor__c,Vendor__r.Name,Amount__c,Total_Cost__c,Job__c,PO__c,Job__r.name,Job__r.Job_Auto_Number__c from Production_Estimate__c where Job__c =: [Select id from Job__c where id =: theID] Order By Sort_Order__c];
    
           MapPE = new map<string,list<Production_Estimate__c>>();
           
          
         
         for(Production_Estimate__c JS:vq)
         {
               if(MapPE.containsKey(js.PE_Template__c))
               {
                  List <Production_Estimate__c> PElist =  MapPE .get(js.PE_Template__c);
                  PElist.add(js);
                  MapPE.put(js.PE_Template__c,PElist);  
                }
                else
                {
                  MapPE.put(js.PE_Template__c, new List<Production_Estimate__c>{js}) ;
                }   
         
         }

    }
    
    Public void ShowLessPE()
    {
        ViewAll=True;
        ShowLess=False;
        
        vq1=[select id,Name,Approved__c,Material_Item__c,PE_Template__c,Qty_Used__c,Lf_Used__c,Material_Item__r.name,Material_Item__r.Qty_On_Hand__c,PO_Created__c,GL_Code__r.Name,Calc_Unit__c,Restrict__c,Quantity__c,Vendor__c,Vendor__r.Name,Amount__c,Total_Cost__c,Job__c,PO__c,Job__r.name,Job__r.Job_Auto_Number__c from Production_Estimate__c where Job__c =: [Select id from Job__c where id =: theID] Order By Sort_Order__c  Limit 5];
    
    
           MapPE = new map<string,list<Production_Estimate__c>>();
         
         
         for(Production_Estimate__c JS:vq1)
         {
               if(MapPE.containsKey(js.PE_Template__c))
               {
                  List <Production_Estimate__c> PElist =  MapPE .get(js.PE_Template__c);
                  PElist.add(js);
                  MapPE.put(js.PE_Template__c,PElist);  
                }
                else
                {
                  MapPE.put(js.PE_Template__c, new List<Production_Estimate__c>{js}) ;
                }   
         
         }
    }
    
    
    
    
    
    
    

    Sobject sumCash; 
    public double getSumCash()
    { 
       Production_Estimate__c testPro = new Production_Estimate__c();
       sumCash = [SELECT SUM(Total_Cost__c) sum FROM Production_Estimate__c  WHERE Approved__c=:true and Job__c =: [Select id from Job__c where id =: theID] ];   
       return double.valueOf(sumCash.get('sum')); 
    }  

    // This method is called on to new PELI  
    public PageReference createPELI()
    {
       Production_Estimate__c testPro = new Production_Estimate__c();
       String jobid;
       String theId=ApexPages.CurrentPage().getParameters().get('id');
       Production_Estimate__c pest = new Production_Estimate__c ();
       Job__c job = [Select Id from Job__c where id =: theID];
       jobid=job.Id;
       
     
       
        PageReference p;
        if(isLtng)
         {
            p = Page.CreateProductionEstimateLightning;
         }
         else
         {
             p = Page.CreateProductionEstimate;
         }
         p.setredirect(true);
         p.getParameters().put('jobid',theID); 
         return p;
       
    }
    // End method createPELI
    
    
    
    public void Approve()
    {
    
         List<Production_Estimate__c> updatePELI=new List<Production_Estimate__c>();
         
         List<Production_Estimate__c> App= [select id,Job__c,Quantity__c,Amount__c,Name,GL_Code__c,GL_Department__c,Vendor__c from Production_Estimate__c where id =: strPEID Limit 1];
            
         for(Production_Estimate__c PELI:App)
         {
             if(schema.SobjectType.Production_Estimate__c.Fields.Approved__c.isUpdateable()){
                 PELI.Approved__c=True;
             }
            updatePELI.add(PELI);
         }
         
         if(updatePELI.size() > 0) 
         {   
        
              try
              {
                 if(!test.isRunningTest())
                 {
                     if(Schema.sObjectType.Production_Estimate__c.isUpdateable()) {
                         update updatePELI;
                     }
                 }
                 
                 
                  vq=[select id,Name,Approved__c,Material_Item__c,PE_Template__c,Qty_Used__c,Lf_Used__c,Material_Item__r.name,Material_Item__r.Qty_On_Hand__c,PO_Created__c,GL_Code__r.Name,Calc_Unit__c,Restrict__c,Quantity__c,Vendor__c,Vendor__r.Name,Amount__c,Total_Cost__c,Job__c,PO__c,Job__r.name,Job__r.Job_Auto_Number__c from Production_Estimate__c where Job__c =: [Select id from Job__c where id =: theID] Order By Sort_Order__c];
              //   vq1=[select id,Name,Approved__c,Material_Item__c,PE_Template__c,Qty_Used__c,Lf_Used__c,Material_Item__r.name,Material_Item__r.Qty_On_Hand__c,PO_Created__c,GL_Code__r.Name,Calc_Unit__c,Restrict__c,Quantity__c,Vendor__c,Vendor__r.Name,Amount__c,Total_Cost__c,Job__c,PO__c,Job__r.name,Job__r.Job_Auto_Number__c from Production_Estimate__c where Job__c =: [Select id from Job__c where id =: theID] Order By Sort_Order__c  Limit 5];
                 peli=[select id,Name,Approved__c,PO_Created__c,PE_Template__c,GL_Code__r.Name,Qty_Used__c,Lf_Used__c,Calc_Unit__c,Restrict__c,Quantity__c,Vendor__c,Vendor__r.Name,Amount__c,Total_Cost__c,Job__c,PO__c from Production_Estimate__c where Job__c =: [Select id from Job__c where id =: theID] and Approved__c = true ];
            
            
                   MapPE = new map<string,list<Production_Estimate__c>>();
                   
               /*    if(isLtng)
                   {
                       vq=vq1;
                   }*
                   
                 
                 for(Production_Estimate__c JS:vq)
                 {
                       if(MapPE.containsKey(js.PE_Template__c))
                       {
                          List <Production_Estimate__c> PElist =  MapPE .get(js.PE_Template__c);
                          PElist.add(js);
                          MapPE.put(js.PE_Template__c,PElist);  
                        }
                        else
                        {
                          MapPE.put(js.PE_Template__c, new List<Production_Estimate__c>{js}) ;
                        }   
                 
                 }
                 
                 
                 
              }
              catch(System.DMLException e)
              {
                  apexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
              }
         }
          
    }
    
    
    
    public void UnApprove()
    {
      try
      {
         List<Production_Estimate__c> updatePELI=new List<Production_Estimate__c>();
         List<Material_Usage_line_item__c > UpadteRestMI=new List<Material_Usage_line_item__c >();
         
         List<Production_Estimate__c> UnApp= [select id,Job__c,Quantity__c,Amount__c,Name,GL_Code__c,GL_Department__c,Vendor__c,Material_Item__c,Qty_Used__c,Lf_Used__c from Production_Estimate__c where id =: strPEID Limit 1];
         
           system.debug('>>>>>>>>>>>>UnApp>>>>>>>>>>>>>>>'+UnApp);
       
                 for(Production_Estimate__c objPELI:UnApp)
                 {
                     if(schema.SobjectType.Production_Estimate__c.Fields.Approved__c.isUpdateable()){
                         objPELI.Approved__c=False;
                     }
                   // updatePELI.add(objPELI);
                    
                    system.debug('>>>>>>>>>>>>updatePELI>>>>>>>>>>>>>>>'+updatePELI);
                    
                      Material_Usage_line_item__c[]  mu=[select id,name,Production_Estimate__c,Material_Item__c,createddate  from Material_Usage_line_item__c where Production_Estimate__c =:objPELI.id];
                        
                       if (mu.size() > 0)     
                       for(Material_Usage_line_item__c m:[Select id,name,Qty_On_Hand__c,createddate,Material_Item__c  from Material_Usage_line_item__c  where Material_Item__c=:mu[0].Material_Item__c AND createddate >:mu[0].createddate order by createddate DESC])
                       {
                           if(objPELI.Calc_Unit__c=='Size'){
                               if(schema.SobjectType.Material_Usage_line_item__c.Fields.Qty_On_Hand__c.isUpdateable()){
                                   m.Qty_On_Hand__c+=objPELI.Lf_Used__c;
                               }
                           }
                           else{
                               if(schema.SobjectType.Material_Usage_line_item__c.Fields.Qty_On_Hand__c.isUpdateable()){
                                   m.Qty_On_Hand__c+=objPELI.Qty_Used__c;
                               }
                           }
                             
                              UpadteRestMI.add(m);
                            
                       }
                     if(Material_Usage_line_item__c.sObjectType.getDescribe().isDeletable()){Delete mu; }
                       updatePELI.add(objPELI); 
                        
                       if (mu.size() > 0) {
                       
                       Material_Item__c  mit=[Select id,name,Qty_On_Hand__c from Material_Item__c  where id =:objPELI.Material_Item__c];
                       
                           if(objPELI.Calc_Unit__c=='Size'){
                               
                               if(schema.SobjectType.Material_Item__c.Fields.Qty_On_Hand__c.isUpdateable()){
                                   mit.Qty_On_Hand__c +=objPELI.Lf_Used__c; 
                               }
                           }
                           else{
                               
                               if(schema.SobjectType.Material_Item__c.Fields.Qty_On_Hand__c.isUpdateable()){
                                   mit.Qty_On_Hand__c +=objPELI.Qty_Used__c; 
                               }
                           }
                       
                           
                           if(Schema.sObjectType.Material_Item__c.isUpdateable()) {
                               
                               update mit;
                           }
                     }   
            
            
                 }
            
             if(UpadteRestMI.size()>0)  
             {
                 if(Schema.sObjectType.Material_Usage_line_item__c.isUpdateable()) {
                     Update UpadteRestMI;
                 }
             }  
             
             system.debug('>>>>>>>>>>>>updatePELI Size1>>>>>>>>>>>>>>>'+updatePELI.size());
              system.debug('>>>>>>>>>>>>updatePELI val>>>>>>>>>>>>>>>'+updatePELI);
             if(updatePELI.size()>0) 
             {   
                    system.debug('>>>>>>>>>>>>updatePELI Size11>>>>>>>>>>>>>>>'+updatePELI.size());
                 if(!test.isRunningTest()){
                     if(Schema.sObjectType.Production_Estimate__c.isUpdateable()) {
                         update updatePELI;
                     }
                 } 
             }     
              
              
                 vq=[select id,Name,Approved__c,Material_Item__c,PE_Template__c,Qty_Used__c,Lf_Used__c,Material_Item__r.name,Material_Item__r.Qty_On_Hand__c,PO_Created__c,GL_Code__r.Name,Calc_Unit__c,Restrict__c,Quantity__c,Vendor__c,Vendor__r.Name,Amount__c,Total_Cost__c,Job__c,PO__c,Job__r.name,Job__r.Job_Auto_Number__c from Production_Estimate__c where Job__c =: [Select id from Job__c where id =: theID] Order By Sort_Order__c];
              //   vq1=[select id,Name,Approved__c,Material_Item__c,PE_Template__c,Qty_Used__c,Lf_Used__c,Material_Item__r.name,Material_Item__r.Qty_On_Hand__c,PO_Created__c,GL_Code__r.Name,Calc_Unit__c,Restrict__c,Quantity__c,Vendor__c,Vendor__r.Name,Amount__c,Total_Cost__c,Job__c,PO__c,Job__r.name,Job__r.Job_Auto_Number__c from Production_Estimate__c where Job__c =: [Select id from Job__c where id =: theID] Order By Sort_Order__c  Limit 5];
                 peli=[select id,Name,Approved__c,PO_Created__c,PE_Template__c,GL_Code__r.Name,Qty_Used__c,Lf_Used__c,Calc_Unit__c,Restrict__c,Quantity__c,Vendor__c,Vendor__r.Name,Amount__c,Total_Cost__c,Job__c,PO__c from Production_Estimate__c where Job__c =: [Select id from Job__c where id =: theID] and Approved__c = true ];
            
            
                   MapPE = new map<string,list<Production_Estimate__c>>();
                   
              /*     if(isLtng)
                   {
                       vq=vq1;
                   }*
                   
                 
                 for(Production_Estimate__c JS:vq)
                 {
                       if(MapPE.containsKey(js.PE_Template__c))
                       {
                          List <Production_Estimate__c> PElist =  MapPE .get(js.PE_Template__c);
                          PElist.add(js);
                          MapPE.put(js.PE_Template__c,PElist);  
                        }
                        else
                        {
                          MapPE.put(js.PE_Template__c, new List<Production_Estimate__c>{js}) ;
                        }   
                 
                 }
        }
        
         catch(System.DMLException e)
        {
            apexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
           
        }    
         
          
     }
        
  

   // This method is called on to handle Save button (Inline Editing Save)
     public PageReference save()
     {
         
         
          try
          {
             List<Production_Estimate__c > updatePELI=new List<Production_Estimate__c >();
            
             List<Material_Usage_line_item__c > UpadteRestMI=new List<Material_Usage_line_item__c >();
             
             
            for(Production_Estimate__c objPELI:vq)
            {
                  
            if(objPELI.Approved__c == True)
            {
                
                   updatePELI.add(objPELI); 
                   
            }
            else 
             {
               
                
             
             
               Material_Usage_line_item__c[]  mu=[select id,name,Production_Estimate__c,Material_Item__c,createddate  from Material_Usage_line_item__c where Production_Estimate__c =:objPELI.id];
                
               if (mu.size() > 0)     
               for(Material_Usage_line_item__c m:[Select id,name,Qty_On_Hand__c,createddate,Material_Item__c  from Material_Usage_line_item__c  where Material_Item__c=:mu[0].Material_Item__c AND createddate >:mu[0].createddate order by createddate DESC])
               {
                   if(objPELI.Calc_Unit__c=='Size'){
                       if(schema.SobjectType.Material_Usage_line_item__c.Fields.Qty_On_Hand__c.isUpdateable()){
                           m.Qty_On_Hand__c+=objPELI.Lf_Used__c;
                       }
                   }
                   else{
                       if(schema.SobjectType.Material_Usage_line_item__c.Fields.Qty_On_Hand__c.isUpdateable()){
                           m.Qty_On_Hand__c+=objPELI.Qty_Used__c;
                       }
                   }
                     
                      
                      UpadteRestMI.add(m);
                    
               }
                if(Material_Usage_line_item__c.sObjectType.getDescribe().isDeletable()){
                    Delete mu; }
               updatePELI.add(objPELI); 
                
               if (mu.size() > 0) {
               
               Material_Item__c  mit=[Select id,name,Qty_On_Hand__c from Material_Item__c  where id =:objPELI.Material_Item__c];
               
                   if(objPELI.Calc_Unit__c=='Size'){
                       
                       if(schema.SobjectType.Material_Item__c.Fields.Qty_On_Hand__c.isUpdateable()){
                           mit.Qty_On_Hand__c +=objPELI.Lf_Used__c; 
                       }
                   }
                   else{
                       
                       if(schema.SobjectType.Material_Item__c.Fields.Qty_On_Hand__c.isUpdateable()){
                           mit.Qty_On_Hand__c +=objPELI.Qty_Used__c; 
                       }
                   }
                   if(Schema.sObjectType.Material_Item__c.isUpdateable()) {
                       update mit;
                   }
               }    
                
               
                  
                  /* if(!mu.isEmpty() && objPELI.id == mu[0].Production_Estimate__c){
                    
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,+' you cannot unapprove this item until you delete the material usage item ');
                    ApexPages.addMessage(myMsg);
                    return null;
                    }
                    else{
                    updatePELI.add(objPELI); }*
                }
                
               
                
            }
            
            if(UpadteRestMI.size()>0)
            {
                if(Schema.sObjectType.Material_Usage_line_item__c.isUpdateable()) {
                    Update UpadteRestMI;
                }
            }
           
            update updatePELI;
            
           
          
            
          }
          catch(System.DMLException e)
          {
                 return null;
          }
      
         PageReference p =  new Pagereference('/apex/JobListView?id='+theid+'&intFocus=14');
         p.setRedirect(true);
         return p;     
    }
    // End of method Save
    
    
    // THis method is called on to handle Cancel button (Cancel inline Editing)
     public PageReference cancelme()
     {
        PageReference p =  new Pagereference('/apex/JobListView?id='+theid+'&intFocus=14');
        p.setRedirect(true);
        return p;     
     }
     // End of method Cancel
    
    // This method is called on to handle CreatePO button
    public Pagereference createPO()
    {
       PageReference p;
         if(isLtng)
         {
          p = Page.CreateNewPurchaseOrderLightning;

         }
         else
         {
          p = Page.CreateNewPurchaseOrder;
         }
         p.setredirect(true);
         p.getParameters().put('jobid',theID); 
         return p;
          
    }  
    // End of method CreatePO 
    
    
    
     // This method is called on to Import Specs
    public void importSpecs()
    {
        List<Production_Estimate__c > insertProdEstLineItems=new List<Production_Estimate__c >();    
        
        if((PETempName==NULL || PETempName=='-None-' ) )
        {
           ApexPages.Message msg1 = new ApexPages.Message(ApexPages.Severity.ERROR,'Production Estimate Temp : You must select a Template.');
           ApexPages.addMessage(msg1);
        }
        else
        {
            try
            {
                List<Production_Estimate_Temp_Line_Items__c> lstSpecs=[Select id,Name,Calc_Unit__c,Sort_Order__c,SheetQtyUpforUsed__c,EachQtyUpforUsed__c,GL_Code__c,GL_Department__c,Vendor__c,Material_Item__c,Qty_Up__c,Production_Estimate_Template__r.name,Quantity__c,Color__c,Sided__c,of_Pages__c,Width_in_Inches__c,Divide_Sheets_By_Two__c,Equipment_Type__c,Length_in_Inches__c,Commission__c from Production_Estimate_Temp_Line_Items__c where Production_Estimate_Template__c =:PETempName order by Sort_Order__c];
                for(Production_Estimate_Temp_Line_Items__c sp:lstSpecs)
                {
                  Production_Estimate__c js=new Production_Estimate__c(Name=sp.Name,Calc_Unit__c=sp.Calc_Unit__c,Quantity__c=sp.Quantity__c,Sort_Order__c=sp.Sort_Order__c,Qty_Up__c=sp.Qty_Up__c,Material_Item__c=sp.Material_Item__c,Job__c = theID,PE_Template__c = sp.Production_Estimate_Template__r.name,Vendor__c=sp.Vendor__c,GL_Department__c=sp.GL_Department__c,GL_Code__c=sp.GL_Code__c,Color__c= sp.Color__c,Sided__c= sp.Sided__c,of_Pages__c= sp.of_Pages__c,Width_in_Inches__c= sp.Width_in_Inches__c,Divide_Sheets_By_Two__c= sp.Divide_Sheets_By_Two__c,Equipment_Type__c= sp.Equipment_Type__c,Length_in_Inches__c= sp.Length_in_Inches__c,Commission__c = sp.Commission__c,SheetQtyUpforUsed__c = sp.SheetQtyUpforUsed__c,EachQtyUpforUsed__c = sp.EachQtyUpforUsed__c);
                 
       
                  insertProdEstLineItems.add(js);
                }
                insert insertProdEstLineItems;
                PETempName='';
        
                     vq=[select id,Name,Approved__c,Material_Item__c,PE_Template__c,Qty_Used__c,Lf_Used__c,Material_Item__r.name,Material_Item__r.Qty_On_Hand__c,PO_Created__c,GL_Code__r.Name,Calc_Unit__c,Restrict__c,Quantity__c,Vendor__c,Vendor__r.Name,Amount__c,Total_Cost__c,Job__c,PO__c,Job__r.name,Job__r.Job_Auto_Number__c from Production_Estimate__c where Job__c =: [Select id from Job__c where id =: theID] Order By Sort_Order__c];
                  //   vq1=[select id,Name,Approved__c,Material_Item__c,PE_Template__c,Qty_Used__c,Lf_Used__c,Material_Item__r.name,Material_Item__r.Qty_On_Hand__c,PO_Created__c,GL_Code__r.Name,Calc_Unit__c,Restrict__c,Quantity__c,Vendor__c,Vendor__r.Name,Amount__c,Total_Cost__c,Job__c,PO__c,Job__r.name,Job__r.Job_Auto_Number__c from Production_Estimate__c where Job__c =: [Select id from Job__c where id =: theID] Order By Sort_Order__c  Limit 5];
                     peli=[select id,Name,Approved__c,PO_Created__c,PE_Template__c,GL_Code__r.Name,Qty_Used__c,Lf_Used__c,Calc_Unit__c,Restrict__c,Quantity__c,Vendor__c,Vendor__r.Name,Amount__c,Total_Cost__c,Job__c,PO__c from Production_Estimate__c where Job__c =: [Select id from Job__c where id =: theID] and Approved__c = true ];
                
                
                       MapPE = new map<string,list<Production_Estimate__c>>();
                       
                    
                     
                     for(Production_Estimate__c JS:vq)
                     {
                           if(MapPE.containsKey(js.PE_Template__c))
                           {
                              List <Production_Estimate__c> PElist =  MapPE .get(js.PE_Template__c);
                              PElist.add(js);
                              MapPE.put(js.PE_Template__c,PElist);  
                            }
                            else
                            {
                              MapPE.put(js.PE_Template__c, new List<Production_Estimate__c>{js}) ;
                            }   
                     
                     }
                
                
             }
             catch(System.DMLException e)
             {
               Apexpages.addMessage(New Apexpages.Message(Apexpages.Severity.Error,''+e.getMessage()));
             }
        }   
     
    }
    // End of method Import Specs
    
    
    Public PageReference Del()
    {
        List<Production_Estimate__c> DelPEST= [Select id,Name,Job__c,Amount__c,Divide_Sheets_By_Two__c,Lf_Used__c,Quote__c,Restrict__c,Shippment_status__c,PE_Template__c,Calc_Unit__c,Color__c,Commission__c,Equipment_Type__c,GL_Department__c,GL_Code__c,of_Pages__c,
            
            Length_in_Inches__c,Material_Item__c,EachQtyUpforUsed__c,Quantity__c,Qty_Up__c,SheetQtyUpforUsed__c,Sided__c,Vendor__c,Width_in_Inches__c  from Production_Estimate__c where id =: strPEID Limit 1];
        try
        {
             if(Production_Estimate__c.sObjectType.getDescribe().isDeletable()){
                 Database.delete(DelPEST);  }
        }
        
         catch(System.DMLException e)
             {
               Apexpages.addMessage(New Apexpages.Message(Apexpages.Severity.Error,''+e.getMessage()));
             }
        
         if(isLtng)
         {
             PageReference p =  new Pagereference('/apex/JobdetailpageLightening07?id='+theid+'&tab=Jobcost'+'&section=PE');  p.setRedirect(true);  return p;
         }
         else
         {
                PageReference p =  new Pagereference('/apex/JobListView?id='+theid+'&intFocus=14');
                p.setRedirect(true);
                return p;
         }
        
        
    }
    
    
    
    
    Public Void duplicatePE()
    {
          List<Production_Estimate__c> insertProdEstimate=new List<Production_Estimate__c>();
            List<Production_Estimate__c> lstProdEstimate=[Select id,Name,Job__c,Amount__c,Divide_Sheets_By_Two__c,Lf_Used__c,Quote__c,Restrict__c,Shippment_status__c,PE_Template__c,Calc_Unit__c,Color__c,Commission__c,Equipment_Type__c,GL_Department__c,GL_Code__c,of_Pages__c,
            
            Length_in_Inches__c,Material_Item__c,EachQtyUpforUsed__c,Quantity__c,Qty_Up__c,SheetQtyUpforUsed__c,Sided__c,Vendor__c,Width_in_Inches__c  from Production_Estimate__c where id =: strPEID Limit 1];
              
             for(Production_Estimate__c p:lstProdEstimate)
             {
                  Production_Estimate__c  objJPE=new Production_Estimate__c  (name='Dup : '+p.Name,Job__c=p.Job__c,Calc_Unit__c=p.Calc_Unit__c,Color__c=p.Color__c,Commission__c=p.Commission__c,GL_Department__c=p.GL_Department__c,GL_Code__c=p.GL_Code__c,of_Pages__c=p.of_Pages__c,Length_in_Inches__c=p.Length_in_Inches__c,Material_Item__c=p.Material_Item__c,Quantity__c=p.Quantity__c,Qty_Up__c=p.Qty_Up__c,SheetQtyUpforUsed__c=p.SheetQtyUpforUsed__c,EachQtyUpforUsed__c=p.EachQtyUpforUsed__c ,Sided__c=p.Sided__c,Vendor__c=p.Vendor__c,Width_in_Inches__c  =p.Width_in_Inches__c  ,Equipment_Type__c=p.Equipment_Type__c,PE_Template__c=p.PE_Template__c,Amount__c=p.Amount__c,Divide_Sheets_By_Two__c=p.Divide_Sheets_By_Two__c,Quote__c=p.Quote__c,Restrict__c=p.Restrict__c,Shippment_status__c=p.Shippment_status__c);
                  
                  
                 
                  insertProdEstimate.add(objJPE);
             }
             insert insertProdEstimate;
     
     
                     vq=[select id,Name,Approved__c,Material_Item__c,PE_Template__c,Qty_Used__c,Lf_Used__c,Material_Item__r.name,Material_Item__r.Qty_On_Hand__c,PO_Created__c,GL_Code__r.Name,Calc_Unit__c,Restrict__c,Quantity__c,Vendor__c,Vendor__r.Name,Amount__c,Total_Cost__c,Job__c,PO__c,Job__r.name,Job__r.Job_Auto_Number__c from Production_Estimate__c where Job__c =: [Select id from Job__c where id =: theID] Order By Sort_Order__c];
                    // vq1=[select id,Name,Approved__c,Material_Item__c,PE_Template__c,Qty_Used__c,Lf_Used__c,Material_Item__r.name,Material_Item__r.Qty_On_Hand__c,PO_Created__c,GL_Code__r.Name,Calc_Unit__c,Restrict__c,Quantity__c,Vendor__c,Vendor__r.Name,Amount__c,Total_Cost__c,Job__c,PO__c,Job__r.name,Job__r.Job_Auto_Number__c from Production_Estimate__c where Job__c =: [Select id from Job__c where id =: theID] Order By Sort_Order__c  Limit 5];
                     peli=[select id,Name,Approved__c,PO_Created__c,PE_Template__c,GL_Code__r.Name,Qty_Used__c,Lf_Used__c,Calc_Unit__c,Restrict__c,Quantity__c,Vendor__c,Vendor__r.Name,Amount__c,Total_Cost__c,Job__c,PO__c from Production_Estimate__c where Job__c =: [Select id from Job__c where id =: theID] and Approved__c = true ];
                
                
                       MapPE = new map<string,list<Production_Estimate__c>>();
                       
                     
                     
                     for(Production_Estimate__c JS:vq)
                     {
                           if(MapPE.containsKey(js.PE_Template__c))
                           {
                              List <Production_Estimate__c> PElist =  MapPE .get(js.PE_Template__c);
                              PElist.add(js);
                              MapPE.put(js.PE_Template__c,PElist);  
                            }
                            else
                            {
                              MapPE.put(js.PE_Template__c, new List<Production_Estimate__c>{js}) ;
                            }   
                     
                     }
    
    
    }*/


}