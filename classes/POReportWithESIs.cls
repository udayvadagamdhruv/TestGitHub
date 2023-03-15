public with sharing class POReportWithESIs
{
    // Start Global variables
    String theID;
    public List<PO_Line_Item__c> tempPOLI{get;set;} // = new List<PO_Line_Item__c>();
    public Map<ID,List<Estimate_Spec_Item__c>> ELI_ESI_Map = new Map<ID,List<Estimate_Spec_Item__c>>(); 
    public Set<ID> ELIIds = new Set<ID>();
    public Map<ID,List<Production_Estimate_Spec_Item__c>> PELI_ESI_Map = new Map<ID,List<Production_Estimate_Spec_Item__c>>(); 
    public Set<ID> PELIIds = new Set<ID>();
    public list<wrapper> wrapout{get;set;}
    public DateTime today{get;set;}
    public List<Document> lstDoc;
    public String imageBody{get;set;}
    public String imageURL{get;set;}
    public boolean imageNotFound{get;set;}
    public List<Vendor_Contact__c> vContacts {get;set;}
    Public Boolean ShowProductionEstimate{get;set;}
    // End of Global variables

    // Start constructor
    public POReportWithESIs(ApexPages.StandardController controller)
    {
          ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
          ShowProductionEstimate =activeSettings.Active__c;
         
          
          // Code to display Subsriber Organization Logo
          
          // If subscriber deletes the Document : JobSuite_OrganizationLogo from their Org then JobSuite App logo will be displayed

        imageURL = '/servlet/servlet.FileDownload?file='; 
        lstDoc = [Select Id, Name, Body from Document where Name =: 'JobSuite_OrganizationLogo' WITH SECURITY_ENFORCED LIMIT 1];
        if(!lstDoc.isEmpty())
        {
           String imageId =  lstDoc[0].Id;
           imageBody = imageURL+imageId; 
           imageNotFound = False;
        }    
        else
        {
           imageNotFound = True;
        }

        // End of code to display Subscriber Organization Logo
        
          wrapout = new List<Wrapper>();
          theID = ApexPages.CurrentPage().getParameters().get('id');
          tempPOLI = [select id,Name,Amount__c,Production_Estimate__c,Production_Estimate__r.name,Estimate_Line_Item__c,Estimate_Line_Item__r.Name,GL_Code__c,GL_Code__r.Name,Unit_Type__c,Invoice_Created__c,Purchase_Order__c,Quantity__c,GL_Code__r.GL_ID__c from PO_Line_Item__c where Purchase_Order__c  =: [Select id from Purchase_Order__c  where id =: theID] WITH SECURITY_ENFORCED Order By Name];
          setupGrouping();
          today=System.NOW();
          
          //added by yogini on 22-aug-12
          vContacts = new List<Vendor_Contact__c>();
          
          //vContacts = [select Name from Vendor_Contact__c where Vendor__c =: [select Vendor__c from Purchase_Order__c  where id =: theID limit 1].Vendor__c  Order By Name Limit 1];
          vContacts = [select Name from Vendor_Contact__c  where Id =: [select Id,Vendor_Contact__c from Purchase_Order__c where id =: theID limit 1].Vendor_Contact__c WITH SECURITY_ENFORCED limit 1 ];
          //end
          
          //Added by yogini on 23-aug-12
          
          //end
     }
 
    Public class wrapper
    {
         public PO_Line_Item__c poli{get;set;}
         public list<Wrapper2> esis{get;set;}
         public list<Wrapper3> pesis{get;set;}
         public wrapper()
        {
           if(poli == null)
            {
                poli = new PO_Line_Item__c();
            }
           if(esis == null)
           {
                 esis = new List<Wrapper2>();
           }  
           if(pesis == null)
           {
                 pesis = new List<Wrapper3>();
           } 
           
              
        }
     }
 
   Public class wrapper2
   {
         public Estimate_Spec_Item__c esi{get;set;}
         public wrapper2()
        {
           if(esi == null)
           {
                esi = new Estimate_Spec_Item__c();
           }
       }
    }  
     Public class wrapper3
   {
         public Production_Estimate_Spec_Item__c pesi{get;set;}
         public wrapper3()
        {
           if(pesi == null)
           {
                pesi = new Production_Estimate_Spec_Item__c ();
           }
       }
    }  
    
    
    

    Public void setupGrouping()
    {
         for(PO_Line_Item__c POLIRecord : tempPOLI)
         {
               if(ShowProductionEstimate){
                PELIIds.add(POLIRecord.Production_Estimate__c);
               
               }
               
               else{
               ELIIds.add(POLIRecord.Estimate_Line_Item__c);
               }
               
               
         }
         if(ShowProductionEstimate){
         
         for(Production_Estimate_Spec_Item__c pesiRecord : [select id,Name,Production_Estimate__c,Description__c from Production_Estimate_Spec_Item__c where Production_Estimate__c=: PELIIds WITH SECURITY_ENFORCED order by CreatedDate])
         {
           if(PELI_ESI_Map.containskey(PesiRecord.Production_Estimate__c))
            {
                 PELI_ESI_Map.get(PesiRecord.Production_Estimate__c).add(PesiRecord);
            }
            else
            {
                PELI_ESI_Map.put(PesiRecord.Production_Estimate__c,new List<Production_Estimate_Spec_Item__c>{PesiRecord});
            } 
         }
         
         
         }
         
         
         else{
         
         for(Estimate_Spec_Item__c esiRecord : [select id,Name,Estimates__c,Description__c from Estimate_Spec_Item__c where Estimates__c =: ELIIds WITH SECURITY_ENFORCED order by CreatedDate])
         {
           if(ELI_ESI_Map.containskey(esiRecord.Estimates__c))
            {
                 ELI_ESI_Map.get(esiRecord.Estimates__c).add(esiRecord);
            }
            else
            {
                ELI_ESI_Map.put(esiRecord.Estimates__c,new List<Estimate_Spec_Item__c>{esiRecord});
            } 
         }
         
         }
         
         

         
  
         for(PO_Line_Item__c POLIRecord1 : tempPOLI)
         {
              wrapper tmpWrapper = new wrapper();
              tmpWrapper.poli = POLIRecord1;
              List<Wrapper2> t2 = new List<Wrapper2>();
              List<Wrapper3> t3 = new List<Wrapper3>();
              
               if(ShowProductionEstimate){
               
               if(PELI_ESI_Map.containskey(POLIRecord1.Production_Estimate__c))
              {
                   for(Production_Estimate_Spec_Item__c esi3:PELI_ESI_Map.get(POLIRecord1.Production_Estimate__c))
                    { 
                         wrapper3 twrap3 = new Wrapper3();
                         twrap3.pesi = esi3;
                         t3.add(twrap3);
                    }
              }
              tmpWrapper.pesis=t3;
              wrapout.add(tmpWrapper); 
               
               }
               
               else{
               if(ELI_ESI_Map.containskey(POLIRecord1.Estimate_Line_Item__c))
              {
                   for(Estimate_Spec_Item__c esi2:ELI_ESI_Map.get(POLIRecord1.Estimate_Line_Item__c))
                    { 
                         wrapper2 twrap2 = new Wrapper2();
                         twrap2.esi = esi2;
                         t2.add(twrap2);
                    }
              }
              tmpWrapper.esis=t2;
              wrapout.add(tmpWrapper);
               
               
               
               }
              
                 
         } 
    } 

    /*  Positive Test Case
    private static testMethod void Test_POReportWithESIsExtension()
     {
      
      Job_Number_Setting__c customSetting001 = new  Job_Number_Setting__c(Name= 'yy');
      insert customSetting001; 
     
      Media_Type__c testMedia=new Media_Type__c(Name='TM32444');
      insert testMedia;
             
      Schedule_Template__c testST=new Schedule_Template__c(Name='TST32444',Media_Types__c=testMedia.Id);
      insert testST;
               
      Specification_Template__c testSpec=new Specification_Template__c(Name='TSPT32444');
      insert testSpec;
            
      Job__c testJob1=new Job__c(Flag__c=True,Job_Auto_Number__c='Job32444',Name='TestJobByDeveloper32444',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
       try
        {
            insert testJob1;
        }
       catch(System.DMLException e)
        {
         System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
        }
       
      System.assertEquals('TestJobByDeveloper32444',testJob1.Name);    
            
      GL_Department__c testGLD = new GL_Department__c(Name='TestGLD32444');
       try
        {
            insert testGLD;
        }
       catch(System.DMLException e)
        {
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
        }
              
      GL_Code__c testGL=new GL_Code__c(Name='GLC32444',GL_ID__c='TestGL32444',GL_Department__c = testGLD.id,Unit_Type__c='Project');
       try
        {
            insert testGL;
        }
       catch(System.DMLException e)
        {
            System.debug(e.getMessage());
        }
             
      Vendor__c testVendor=new Vendor__c(Name='TestV32444',Email__c='abcd@gmail.com',Zip__c='12345');
       try
        {
            insert testVendor;
        }
       catch(System.DMLException e)
        {
            System.assert(e.getMessage().contains('Vendor with same name Exists'));
        }
        
      Estimate_Line_Items__c testELI=new Estimate_Line_Items__c(Name='ELI0 361',Job__c=testjob1.Id,GL_Department__c=testGLD.id,GL_Code__c = testGL.id,Vendor__c = testVendor.id,Amount__c=100,Quantity__c=10);
       try
        {
            insert testELI;
        }
       catch(System.DMLException e)
        {
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
        }
               
       Estimate_Spec_Item__c testESI = new Estimate_Spec_Item__c(Name='Spec Item 361',Estimates__c=testELI.Id);
        try
         {
            insert testESI;
         }
        catch(System.DMLException e)
         {
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
         }       
        
        
        Purchase_Order__c PO=new Purchase_Order__c(GL_Code__c=testGL.id,Job__c=testJob1.id,Vendor__c=testVendor.id);    
        try
        {
            insert PO;
        }
         catch(DMLException e)
        {
        System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
        } 
        
        
        PO_Line_Item__c POLI=new PO_Line_Item__c(Purchase_Order__c=PO.id,Estimate_Line_Item__c=testELI.id,GL_Code__c=testGL.id,Amount__c=100);    
        try
        {
            insert POLI;
        }
         catch(DMLException e)
        {
        System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
        } 
        
      ApexPages.CurrentPage().getParameters().put('id',PO.id);
      ApexPages.StandardController con=new ApexPages.StandardController(POLI);    
      POReportWithESIs ext=new POReportWithESIs(con); 
      ext.setupGrouping();
       
    }  
   End of Test Coverage Code **/
}