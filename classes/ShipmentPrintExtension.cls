public with sharing class ShipmentPrintExtension {
    
    String theID;
    public List<Shipment_Line_Item__c> tempSLI{get;set;} // 
    
    
    public Map<ID,List<Production_Estimate_Spec_Item__c>> PELI_ESI_Map = new Map<ID,List<Production_Estimate_Spec_Item__c>>(); 
    public Set<ID> PELIIds = new Set<ID>();
    
    public list<wrapper> wrapout{get;set;}
    public DateTime today{get;set;}
    public List<Document> lstDoc;
    public String imageBody{get;set;}
    public String imageURL{get;set;}
    public boolean imageNotFound{get;set;}
    public boolean ShowProductionEstimate{get;set;}

    // End of Global variables

    // Start constructor
    public ShipmentPrintExtension (ApexPages.StandardController controller)
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
          tempSLI= [select id,Name,Production_Estimate__c,Estimate_Line_Item__r.name,Qty_Shipped__c ,Job_Name__c ,Job__c, Production_Estimate__r.name from Shipment_Line_Item__c where Shipment__c  =: [Select id from Shipment__c  where id =: theID] WITH SECURITY_ENFORCED Order By Name];
          setupGrouping();
          today=System.NOW();
          
         
     }
     
     Public class wrapper
    {
         public Shipment_Line_Item__c sili{get;set;}
         
         public list<Wrapper3> pesis{get;set;}
         public wrapper()
        {
           if(sili == null)
            {
                sili = new Shipment_Line_Item__c();
            }
           
           if(pesis == null)
           {
                 pesis = new List<Wrapper3>();
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
         for(Shipment_Line_Item__c SILIRecord : tempSLI)
         {  
         
                PELIIds.add(SILIRecord.Production_Estimate__c);
              
         
               
         }
         
         
         
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
         
         
         
  
         for(Shipment_Line_Item__c  SILIRecord1 : tempSLI)
         {
              wrapper tmpWrapper = new wrapper();
              tmpWrapper.sili = SILIRecord1 ;
              
              List<Wrapper3> t3 = new List<Wrapper3>();
              
              
              if(PELI_ESI_Map.containskey(SILIRecord1.Production_Estimate__c))
              {
                   for(Production_Estimate_Spec_Item__c esi3:PELI_ESI_Map.get(SILIRecord1.Production_Estimate__c))
                    { 
                         wrapper3 twrap3 = new Wrapper3();
                         twrap3.pesi = esi3;
                         t3.add(twrap3);
                    }
              }
              tmpWrapper.pesis=t3;
              wrapout.add(tmpWrapper); 
              
             
                
         } 
    } 
    
    
   }