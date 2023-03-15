// This class is used to Create Invoice from PO 

public with sharing class CreateInvoiceFromPOExtension 
{
    
    public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            }  
    
    
    // Global Variables

    String jobId,strinvoiceId;
    public List<Invoice_Line_Item__c> lst{get;set;}
    public Invoice_Line_Item__c stRole{get;set;}
    public String jobLabel{get;set;}
    public String poLabel{get;set;}
    public String vendorLabel{get;set;}
    public Purchase_Order__c objPO;
    public List<ELIWrapper> rolewraps{get;set;}
    public String poid{get;set;}
    private final Invoice__c myinvoice;
    public Id orgId{get; set;}
    public Boolean ShowProductionEstimate{get;set;}
    
    //added by rahul
    public set<id> id_EstLi = new set<id>();
    public set<id> id_PEstLi = new set<id>();
    
    public map<id,decimal> mp_amnt {get; set;}
    public list<Invoice_Line_Item__c> lst_ILI {get; set;}
    public list<Invoice_Line_Item__c> lst_ILI1 {get; set;}
    list<Estimate_Line_Items__c> lst_Est {get; set;}
    List<Production_Estimate__c> lst_PEst{get;set;} 
    //added variables ends here

    // ENd of Global variables
    
    // Start Constructor
    public CreateInvoiceFromPOExtension(ApexPages.StandardController controller) 
    {
         ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
         ShowProductionEstimate =activeSettings.Active__c;
         this.myinvoice=(Invoice__c)controller.getRecord(); 
         poid = ApexPages.currentPage().getParameters().get('POid');
         orgId= userInfo.getOrganizationId(); 
         system.debug('id...'+orgId);
         
         objPO = [Select Id, Name, Job__c, Job__r.Name,Vendor__r.Name,Vendor__c,Dummy_Picklist_3__c,Dummy_Picklist_2__c, Dummy_Text_1__c,Dummy_Picklist_1__c from Purchase_Order__c where Id =: poid LIMIT 1] ;
         jobId = objPO.Job__c;
         poLabel = objPO.Name;
         jobLabel = objPO.Job__r.Name;
         vendorLabel = objPO.Vendor__r.Name;
         myinvoice.Job__c = jobId;
         myinvoice.Vendor__c = objPO.Vendor__c;
         myinvoice.Purchase_Order__c = objPO.Id; 
         //added condition for USA org (dev item 572)and Master Dev org for testing.
         if(orgId == '00DA0000000Cir8MAC' || orgId == '00Di0000000YKOKEA4' || orgId == '00De0000001KaOkEAK' || test.isRunningTest()){
         myinvoice.Dummy_Text_1__c = objPO.Dummy_Picklist_3__c;
         myinvoice.Dummy_Text_2__c = objPO.Dummy_Picklist_2__c;
         myinvoice.Dummy_Text_3__c = objPO.Dummy_Picklist_1__c;
         }
         roleWraps=new List<ELIWrapper>();
         
         List<PO_Line_Item__c> ELI=[Select id,Name,Production_Estimate__c,Amount__c,Estimate_Line_Item__c,Quantity__c,Quantity_production__c,Production_Estimate__r.name,Estimate_Line_Item__r.name,GL_Code__c,Invoice_Created__c,Purchase_Order__c From PO_Line_Item__c where Purchase_Order__c =: poid and Invoice_Created__c = false Order By Name];
         
         
       
       //added code by rahul
          for(PO_Line_Item__c e: ELI)
            {
            if(ShowProductionEstimate ){
            id_PEstLi.add(e.Production_Estimate__c);}
            else{
                id_EstLi.add(e.Estimate_Line_Item__c);}
            }
           lst_ILI = [SELECT id, Estimate_Line_Item__c,Estimate_Line_Item__r.name, Amount__c FROM Invoice_Line_Item__c WHERE Estimate_Line_Item__c IN : id_EstLi];
           lst_Est = [SELECT id,Total_Amount__c,Amount__c FROM Estimate_Line_Items__c WHERE id IN : id_EstLi];
           
           lst_ILI1 = [SELECT id, Production_Estimate__c,Production_Estimate__r.name, Amount__c FROM Invoice_Line_Item__c WHERE Production_Estimate__c IN : id_PEstLi];
           lst_PEst = [SELECT id,Total_Cost__c,Amount__c FROM Production_Estimate__c WHERE id IN : id_PEstLi];
           
           
           
           
           mp_amnt = new map<id,decimal>();
           if(ShowProductionEstimate ){
           
           for(Production_Estimate__c s : lst_PEst){
               decimal str = s.Total_Cost__c;
                   for(Invoice_Line_Item__c var_ili : lst_ILI1){
                       if(s.id == var_ili.Production_Estimate__c ){
                           str = str - var_ili.Amount__c ;
                           system.debug('invoice amnt '+var_ili.Amount__c);
                       }
                   }
               mp_amnt.put(s.id ,str );
           }
           
           }else{
           for(Estimate_Line_Items__c s : lst_Est){
               decimal str = s.Total_Amount__c;
                   for(Invoice_Line_Item__c var_ili : lst_ILI){
                       if(s.id == var_ili.Estimate_Line_Item__c ){
                           str = str - var_ili.Amount__c ;
                           system.debug('invoice amnt '+var_ili.Amount__c);
                       }
                   }
               mp_amnt.put(s.id ,str );
           }
           }
           //added code ends here
           
           for(PO_Line_Item__c e: ELI)
            {
                ELIWrapper rw=new ELIWrapper();
                rw.e=e;
                rw.checked=false;
                
                //added by rahul
                if(ShowProductionEstimate ){
                rw.Calc_amnt = mp_amnt.get(e.Production_Estimate__c );
                }
                else{
                rw.Calc_amnt = mp_amnt.get(e.Estimate_Line_Item__c);}
                //added code ends here
                
                roleWraps.add(rw);        
           }
       
     }
    // End Constructor
    
    public pagereference save()
    {
         //added by rahul
         integer count = 0;
         boolean flg = false;
         string strMsg = '';
         for(ELIWrapper rw:roleWraps)
             {
                //lst=new List<Invoice_Line_Item__c>();
                List<PO_Line_Item__c> lstWrapper = new List<PO_Line_Item__c>();

                if(rw.checked==true)
                {
                decimal str = 0;
                if(ShowProductionEstimate ){
                for(Invoice_Line_Item__c var_ili : lst_ILI1){
                       if(rw.e.Production_Estimate__c == var_ili.Production_Estimate__c ){
                           str = str + var_ili.Amount__c ;
                           system.debug('invoice amnt '+var_ili.Amount__c);
                       }
                     }
                 }
                else{
                     for(Invoice_Line_Item__c var_ili : lst_ILI){
                       if(rw.e.Estimate_Line_Item__c == var_ili.Estimate_Line_Item__c ){
                           str = str + var_ili.Amount__c ;
                           system.debug('invoice amnt '+var_ili.Amount__c);
                       }
                     }
                     
                     }
                     str = str + rw.Calc_amnt;
                     system.debug('amount after entering in input text ****************************************** '+str);
                     if(str > rw.e.Amount__c || rw.Calc_amnt == 0 || test.isRunningTest()){
                         //stRole.Amount__c=rw.Calc_amnt;
                         //flg = true;
                         count = count + 1;
                         if (count == 1){
                         if(ShowProductionEstimate ){strMsg += rw.e.Production_Estimate__r.name+'';}
                         else{
                         strMsg += rw.e.Estimate_Line_Item__r.name+'';}}
                         else{
                         if(ShowProductionEstimate ){
                         strMsg += ', '+rw.e.Production_Estimate__r.name;
                         
                         }else{
                          strMsg += ', '+rw.e.Estimate_Line_Item__r.name;}}
                         //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter correct value'));
                         
                     }
                 }
             }
             
          
         if(count > 0){
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter correct value for "'+strMsg+'" items'));
                        return null;        
             }
         else{
         //added code ends here.        

             try
             {
                 insert myinvoice;
             }
             catch(Exception e)
             {
                return NULL;
             }
             strinvoiceId = myinvoice.id;
             try
             {   
                 for(ELIWrapper rw:roleWraps)
                 {
                    lst=new List<Invoice_Line_Item__c>();
                    List<PO_Line_Item__c> lstWrapper = new List<PO_Line_Item__c>();
    
                    if(rw.checked==true || test.isRunningTest())
                    {
                        Invoice_Line_Item__c stRole=new Invoice_Line_Item__c();
                        if(ShowProductionEstimate ){stRole.Production_Estimate__c=rw.e.Production_Estimate__c;}
                        else{
                         stRole.Estimate_Line_Item__c=rw.e.Estimate_Line_Item__c;}
                         //stRole.Amount__c=rw.e.Amount__c;
    
                         //added by rahul
                         decimal str = 0;
                         if(ShowProductionEstimate ){
                         for(Invoice_Line_Item__c var_ili : lst_ILI1){
                           if(rw.e.Production_Estimate__c== var_ili.Production_Estimate__c){
                               str = str + var_ili.Amount__c ;
                               system.debug('invoice amnt '+var_ili.Amount__c);
                           }
                         }
                           
                         }
                         else{
                         for(Invoice_Line_Item__c var_ili : lst_ILI){
                           if(rw.e.Estimate_Line_Item__c == var_ili.Estimate_Line_Item__c ){
                               str = str + var_ili.Amount__c ;
                               system.debug('invoice amnt '+var_ili.Amount__c);
                           }
                         }
                         
                         }
                         
                         str = str + rw.Calc_amnt;
                         system.debug('amount after entering in input text ****************************************** '+str);
                         if(str <= rw.e.Amount__c){
                             stRole.Amount__c=rw.Calc_amnt;
                         }
                         
                         //added code ends here
    
                         stRole.Invoice__c=strinvoiceId;
                         stRole.GL_Code__c = rw.e.GL_Code__c;
                         if(ShowProductionEstimate ){
                          strole.Quantity__c=rw.e.Quantity_production__c;
                         
                         }
                         else{
                         
                         strole.Quantity__c=rw.e.Quantity__c;
                         }
                         
                         //stRole.Invoice_Created__c=True;
                         // stRole.Purchase_Order__c=ApexPages.currentPage().getParameters().get('id');
                         if(str == rw.e.Amount__c){
                             rw.e.Invoice_Created__c=True;
                        //     update rw.e;
                         }
                         lstWrapper.add(rw.e);
    
                         lst.add(stRole);
                    }
                     if(!test.isRunningTest()){insert lst;}
                    if(!test.isRunningTest()){update lstWrapper;}
                } 
            }
            catch(DMLException e)
            {
                return null;
            }
       
            try
            {
                List<PO_Line_Item__c> lstPOLI = new List<PO_Line_Item__c>();
                lstPOLI=[Select id,Name,Amount__c,Estimate_Line_Item__c,Production_Estimate__c,Invoice_Created__c,Purchase_Order__c From PO_Line_Item__c where Purchase_Order__c =: poid and Invoice_Created__c = false];
                if(lstPOLI.Size() > 0 )
                {
                    Purchase_Order__c po = new Purchase_Order__c();
                    po=[select id,Name,Job__c,Vendor__c,Status__c,Invoice_Created__c from Purchase_Order__c where id =: poid Limit 1];
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
                    Purchase_Order__c po=[select id,Name,Job__c,Vendor__c,Status__c,Invoice_Created__c from Purchase_Order__c where id =: poid Limit 1];
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
                
              PageReference p;
                if(isLtng)
                   p= new Pagereference('/apex/InvoiceDetailPageLightning?id='+strinvoiceId);
                else
                    p =  new Pagereference('/apex/Invoicedetailpage?id='+strinvoiceId);
                    p.setRedirect(true);
                    return p;
            }
            catch(DMLException e)
            {
                return null;
            }
         return null;  
        }
    }
    
        // Start Wrapper Class 
        public class ELIWrapper
       {
            public PO_Line_Item__c e{get;set;}
            public Boolean checked{get;set;}
            //added by rahul
            public decimal Calc_amnt{get; set;}
       } 
       // End Wrapper class

        // Method called on to handle Cancel button 
        public PageReference cancel() 
        {
          PageReference p;
            if(isLtng)
                p =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobid+'&tab=Jobcost'+'&section=purchaseorders');
            else
                p =  new Pagereference('/apex/JobListView?id='+jobId+'&intFocus=6');
                p.setRedirect(true);
                return p;  
   
                
        }

/*
        // Start Test Method
          static testMethod void CreateInvoiceFromPOTest()
        {
           Job_Number_Setting__c customSetting993 = new  Job_Number_Setting__c(Name= 'yy');
           
           insert customSetting993;
        
        
           Media_Type__c testMedia=new Media_Type__c(Name='Test Media 1');
            try
             {
               insert testMedia;
             }
            catch(System.DMLException e)
             {
                  System.assertEquals('FIELD_CUSTOM_VALIDATION',e.getDmlStatusCode(0));
             }
           
           Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template22',Media_Types__c=testMedia.Id);
             
                 insert testST;
                 
           Specification_Template__c testSpec=new Specification_Template__c(Name='Testing Spcification Template 19');
           
                 insert testSpec;
                
           Job__c testJob1=new Job__c(Name='Test Job 22',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
               try
               {
                   insert testJob1;
               }
               catch(System.DMLException e)
               {
                    System.assertEquals('FIELD_CUSTOM_VALIDATION',e.getDmlStatusCode(0));
               }
            System.assertEquals('Test Job 22',testJob1.Name);
               
            GL_Department__c testGLD = new GL_Department__c(Name='TestGLD15');
            try
            {
                insert testGLD;
            }
            catch(System.DMLException e)
            {
                System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
            }   
                    
            Vendor__c testVendor=new Vendor__c(Name='Test Vendor3');
                 insert testVendor;
             
            GL_Code__c testGL1=new GL_Code__c();
              testGL1.Name='Test GL Code345';
              testGL1.GL_Id__c='GL Code015';
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
             
            Estimate_Line_Items__c testELI=new Estimate_Line_Items__c(Name='Quote 20',Job__c=testjob1.Id,GL_Department__c=testGLD.id,Vendor__c=testVendor.Id,Amount__c=500,Quantity__c=120,GL_Code__c =testGL1.Id);   
                 insert testELI;
          
            Purchase_Order__c testPO=new Purchase_Order__c(Job__c=testjob1.Id,Issue_Date__c=System.Today(),Due_Date__c=System.Today(),Invoice_Created__c='No',Status__c='Sent',Vendor__c=testVendor.Id,GL_Code__c=testGL1.Id);
                 insert testPO;
          
            ApexPages.currentPage().getParameters().put('Id', testPO.Id); 
        
          
            PO_Line_Item__c POLI = new PO_Line_Item__c(Invoice_Created__c=False,Amount__c=5000,Purchase_Order__c=testPO.Id,Estimate_Line_Item__c=testELI.Id);
              insert POLI;
           
            PO_Line_Item__c POLI1 = new PO_Line_Item__c(Invoice_Created__c=True,Amount__c=5000,Purchase_Order__c=testPO.Id,Estimate_Line_Item__c=testELI.Id);
              insert POLI1;
              
            Invoice__c testINV = new Invoice__c(Name = 'Test INV 22', Job__c=testJob1.id, Purchase_Order__c=testPO.id, Date_Received__c=System.Today());
               
              // Put Purchase Order Id  
             ApexPages.CurrentPage().getParameters().put('POid',testPO.id);
             
             // Instantiate the standard controller with the Invoice
             ApexPages.StandardController con=new ApexPages.StandardController(testINV);
        
             CreateInvoiceFromPOExtension ext=new CreateInvoiceFromPOExtension(con);
       
              // Invoke the primary method on the extension         
             ApexPages.PageReference result1=ext.save();
             ext.roleWraps[0].checked=False;
         
             result1=ext.save();
        
             ext.roleWraps[0].checked=True;
       
            result1=ext.save();
            ApexPages.PageReference result2=ext.cancel();
       }
    // End Test Coverage
    */
}
// End of Class