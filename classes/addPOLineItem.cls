public with sharing class addPOLineItem 
{
 
   public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            }  
    

    public String poid{get;set;}
    public String INVid{get;set;}
    public List<POLIWrapper> rolewraps{get;set;}
    public List<Invoice_Line_Item__c> lst{get;set;}
    //added by rahul
    public set<id> id_EstLi = new set<id>();
    public set<id> id_PEstLi = new set<id>();
    public map<id,decimal> mp_amnt {get; set;}
    public list<Invoice_Line_Item__c> lst_ILI {get; set;}
    public list<Invoice_Line_Item__c> lst_ILI1 {get; set;}
    list<Estimate_Line_Items__c> lst_Est {get; set;}
    list<Production_Estimate__c > lst_PEst {get; set;}
    Public Boolean ShowProductionEstimate{get;set;}

    
    //added variables ends here
  
    public addPOLineItem()
    {
      ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
      ShowProductionEstimate =activeSettings.Active__c;
    
      INVid = ApexPages.currentPage().getParameters().get('Invid');
      Invoice__c Invoice = [select id,Name,Purchase_Order__c from Invoice__c where id =: INVid];      
      poid = Invoice.Purchase_Order__c;
      
      roleWraps=new List<POLIWrapper>();
      
      List<PO_Line_Item__c> POLI=[Select id,Name,Quantity__c,Quantity_Production__c,Amount__c,Production_Estimate__c ,Production_Estimate__r.name ,Estimate_Line_Item__c,Estimate_Line_Item__r.name,GL_Code__c,Invoice_Created__c,Purchase_Order__c From PO_Line_Item__c where Purchase_Order__c =: poid and Invoice_Created__c = false Order By Name];
      
      //added code by rahul
          for(PO_Line_Item__c e: POLI)
            {   
            if(ShowProductionEstimate ){id_PEstLi.add(e.Production_Estimate__c );}
            else{
                id_EstLi.add(e.Estimate_Line_Item__c);}
            }
            
            
           lst_ILI = [SELECT id, Estimate_Line_Item__c,Estimate_Line_Item__r.name, Amount__c FROM Invoice_Line_Item__c WHERE Estimate_Line_Item__c IN : id_EstLi];
           lst_Est = [SELECT id,Total_Amount__c,Amount__c FROM Estimate_Line_Items__c WHERE id IN : id_EstLi];
           
           lst_ILI1 = [SELECT id, Production_Estimate__c ,Production_Estimate__r.name, Amount__c FROM Invoice_Line_Item__c WHERE Production_Estimate__c IN : id_PEstLi];
           lst_PEst = [SELECT id,Total_Cost__c,Amount__c FROM Production_Estimate__c  WHERE id IN : id_PEstLi];
           
           
           
           mp_amnt = new map<id,decimal>();
           if(ShowProductionEstimate ){
           
           for(Production_Estimate__c s : lst_PEst){
               decimal str = s.Total_Cost__c;
                   for(Invoice_Line_Item__c var_ili : lst_ILI1){
                       if(s.id == var_ili.Production_Estimate__c ){str = str - var_ili.Amount__c ;}
                   }
               mp_amnt.put(s.id ,str );
           }
      //added code ends here
           
           }
           else{
           
           for(Estimate_Line_Items__c s : lst_Est){
               decimal str = s.Total_Amount__c;
                   for(Invoice_Line_Item__c var_ili : lst_ILI){
                       if(s.id == var_ili.Estimate_Line_Item__c ){str = str - var_ili.Amount__c ;}
                   }
               mp_amnt.put(s.id ,str );
           }
      //added code ends here
           
           }
           
           
      
      for(PO_Line_Item__c e: POLI)
      {
         POLIWrapper rw=new POLIWrapper();
         rw.e=e;
         rw.checked=false;
         //added by rahul
         if(ShowProductionEstimate ){rw.Calc_amnt = mp_amnt.get(e.Production_Estimate__c );}
         else{rw.Calc_amnt = mp_amnt.get(e.Estimate_Line_Item__c);}
                
         //added code ends here
         roleWraps.add(rw);        
      }
    } 
  
    // Start Wrapper Class 
    public class POLIWrapper
    {
      public PO_Line_Item__c e{get;set;}
      public Boolean checked{get;set;}
      //added by rahul
      public decimal Calc_amnt{get; set;}
      //added code ends here
    }
    // End of Wrapper Class

    // Save Method
    public pagereference Save()
    {
        integer count = 0;
        string strMsg = '';
        for(POLIWrapper rw:roleWraps)
        {           
          if(rw.checked==true)
            {
                 decimal str = 0;
                 
                 if(ShowProductionEstimate ){
                 
                 for(Invoice_Line_Item__c var_ili : lst_ILI1){
                   if(rw.e.Production_Estimate__c == var_ili.Production_Estimate__c ){str = str + var_ili.Amount__c ;}
                 }
                 
                 }
                 
                 else{
                 for(Invoice_Line_Item__c var_ili : lst_ILI){
                   if(rw.e.Estimate_Line_Item__c == var_ili.Estimate_Line_Item__c ){str = str + var_ili.Amount__c ;}
                 }
                 
                 }
                 
                 str = str + rw.Calc_amnt;
                 system.debug('amount after entering in input text ****************************************** '+str);
                 if(str > rw.e.Amount__c || rw.Calc_amnt == 0){
                     //stRole.Amount__c=rw.Calc_amnt;
                     //flg = true;
                     count = count + 1;
                     if (count == 1){
                     if(ShowProductionEstimate ){strMsg += rw.e.Production_Estimate__r.name+'';}
                     
                     else{strMsg += rw.e.Estimate_Line_Item__r.name+'';}
                      }
                      
                     else{
                     if(ShowProductionEstimate ){strMsg += ', '+rw.e.Production_Estimate__r.name;}
                     else{strMsg += ', '+rw.e.Estimate_Line_Item__r.name;}
                     
                     }
                     //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter correct value'));
                     
                 }
             }
         }
         if(count > 0){
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter correct value for "'+strMsg+'" items'));
                        return null;        
             }
         else{
    
             try
              {
               lst=new List<Invoice_Line_Item__c>();
               List<PO_Line_Item__c> lstWrapper = new List<PO_Line_Item__c>();
               for(POLIWrapper rw:roleWraps)
                {           
                  if(rw.checked==true)
                    {
                      Invoice_Line_Item__c stRole=new Invoice_Line_Item__c();
                      if(ShowProductionEstimate ){stRole.Production_Estimate__c =rw.e.Production_Estimate__c ;}
                      else{stRole.Estimate_Line_Item__c=rw.e.Estimate_Line_Item__c;}
                      

                      //added by rahul
                         decimal str = 0;
                         if(ShowProductionEstimate ){
                         for(Invoice_Line_Item__c var_ili : lst_ILI1){
                           if(rw.e.Production_Estimate__c == var_ili.Production_Estimate__c ){str = str + var_ili.Amount__c ;}
                         }
                         }
                         
                         else{
                         for(Invoice_Line_Item__c var_ili : lst_ILI){
                           if(rw.e.Estimate_Line_Item__c == var_ili.Estimate_Line_Item__c ){str = str + var_ili.Amount__c ;}
                         }
                         
                         }
                         
                         
                         
                         str = str + rw.Calc_amnt;
                         system.debug('amount after entering in input text ****************************************** '+str);
                         if(str <= rw.e.Amount__c){
                             stRole.Amount__c=rw.Calc_amnt;
                         }
                         if(str == rw.e.Amount__c){
                             rw.e.Invoice_Created__c=True;
                         }
                         //added code ends here
                      
                      stRole.Invoice__c=INVid;
                      stRole.GL_Code__c = rw.e.GL_Code__c;
                      
                      if(ShowProductionEstimate ){strole.Quantity__c=rw.e.Quantity_production__c;}
                      
                      else{strole.Quantity__c=rw.e.Quantity__c;}
                      
                      lstWrapper.add(rw.e);
                      lst.add(stRole);
                    }
                 }
                
                 insert lst;
                 update lstWrapper;
                
                 try
                  {
                    List<PO_Line_Item__c> lstPOLI = new List<PO_Line_Item__c>();
                    lstPOLI=[Select id,Name,Amount__c,Estimate_Line_Item__c,Production_Estimate__c ,Invoice_Created__c,Purchase_Order__c From PO_Line_Item__c where Purchase_Order__c =: poid and Invoice_Created__c = false];
                    if(lstPOLI.Size() > 0 )
                     {
                      Purchase_Order__c po = new Purchase_Order__c();
                      po=[select id,Name,Job__c,Vendor__c,Status__c,Invoice_Created__c from Purchase_Order__c where id =: poid];
                      
                      try
                       {
                        po.Invoice_Created__c='Partially';
                        update po;
                       }
                      catch(System.DMLException e)
                       {
                        return null;
                       } 
                     }
                
                    if(lstPOLI.Size() == 0)
                     {
                      Purchase_Order__c po=[select id,Name,Job__c,Vendor__c,Status__c,Invoice_Created__c from Purchase_Order__c where id =: poid];
                      try
                       {
                         po.Invoice_Created__c='Created';
                         update po;
                       }
                      catch(System.DMLException e)
                       {
                         return null;
                       } 
                     }  
                 }
                catch(DMLException e)
                 {
                   return null;
                 }    
      }
      catch(DMLException e)
       {
         return null;
       }
    }
    
    if(isLtng){
    
     PageReference p =  new Pagereference('/apex/InvoicedetailpageLightning?id='+INVid);
     p.setRedirect(true);
     return p;
    
    }
    
    
    else{
     PageReference p =  new Pagereference('/apex/Invoicedetailpage?id='+INVid);
     p.setRedirect(true);
     return p;  
    }
   }
   // End of Save Method
 
   // Method called on to handle Back Button
   public pagereference Back()
    {
      if(isLtng){
    
     PageReference p =  new Pagereference('/apex/InvoicedetailpageLightning?id='+INVid);
     p.setRedirect(true);
     return p;
    
    }
    
    
    else{
     PageReference p =  new Pagereference('/apex/Invoicedetailpage?id='+INVid);
     p.setRedirect(true);
     return p;  
    }
    }
   // End of Back
  
/*  
   // Start Test Method
   static testMethod void AddPOLineItem()
     {
        Job_Number_Setting__c cs1999 = new  Job_Number_Setting__c(Name= 'yy');
        insert cs1999;
        
        Media_Type__c testMedia=new Media_Type__c(Name='TM 2999');
        try
         {
          insert testMedia;
         }
        catch(System.DMLException e)
         {
          System.assertEquals('FIELD_CUSTOM_VALIDATION',e.getDmlStatusCode(0));
         }
           
        Schedule_Template__c testST=new Schedule_Template__c(Name='TST2999',Media_Types__c=testMedia.Id);
        insert testST;
                 
        Specification_Template__c testSpec=new Specification_Template__c(Name='TST2999');
        insert testSpec;
                
        Job__c testJob1=new Job__c(Name='TJ2999',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
        try
         {
          insert testJob1;
         }
        catch(System.DMLException e)
         {
          System.assertEquals('FIELD_CUSTOM_VALIDATION',e.getDmlStatusCode(0));
         }
        System.assertEquals('TJ2999',testJob1.Name);
           
        GL_Department__c testGLD = new GL_Department__c(Name='TGLD2999');
         try
          {
           insert testGLD;
          }
         catch(System.DMLException e)
          {
           System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
          }   
                    
        Vendor__c testVendor=new Vendor__c(Name='TV2999');
        insert testVendor;
             
        GL_Code__c testGL1=new GL_Code__c();
          testGL1.Name='TGLC2999';
          testGL1.GL_Id__c='GL 2999';
          testGL1.GL_Department__c=testGLD.id;
          testGL1.Unit_Cost__c=2500;
          testGL1.Unit_Type__c='Days';
             
        try
         {
          insert testGL1;
         }
        catch(System.DMLException e)
         {
          System.assert(e.getMessage().contains('Record already exist with same GLCode'));
         }
             
        Estimate_Line_Items__c testELI=new Estimate_Line_Items__c(Name='ELI 2999',Job__c=testjob1.Id,GL_Department__c=testGLD.id,Vendor__c=testVendor.Id,Amount__c=500,Quantity__c=120,GL_Code__c =testGL1.Id);   
        insert testELI;
          
        Purchase_Order__c testPO=new Purchase_Order__c(Job__c=testjob1.Id,Issue_Date__c=System.Today(),Due_Date__c=System.Today(),Invoice_Created__c='No',Status__c='Sent',Vendor__c=testVendor.Id,GL_Code__c=testGL1.Id);
        insert testPO;
          
        PO_Line_Item__c POLI = new PO_Line_Item__c(Invoice_Created__c=False,Amount__c=5000,Purchase_Order__c=testPO.Id,Estimate_Line_Item__c=testELI.Id);
        insert POLI;
           
        PO_Line_Item__c POLI1 = new PO_Line_Item__c(Invoice_Created__c=True,Amount__c=5000,Purchase_Order__c=testPO.Id,Estimate_Line_Item__c=testELI.Id);
        insert POLI1;
              
        Invoice__c testI=new Invoice__c(Job__c=testjob1.Id,Date_Received__c=System.Today(),Vendor__c=testVendor.Id,Purchase_Order__c=testPO.id);  
        insert testI;
              
        ApexPages.currentPage().getParameters().put('Invid', testI.Id);    
      
       // Invoke the primary method on the extension 
       addPOLineItem ext=new addPOLineItem();
           
       ApexPages.PageReference result1=ext.Save();
       result1=ext.Back();
       result1=ext.Save();

     }
   // End Test Coverage
*/
}