public with sharing class ClientInvoicePrintExtension {
    
    String theID;
    public List<Client_Invoice_Line_Item__c> tempCILI{get;set;} // = new List<Client_Invoice_Line_Item__c>();
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
    Public Boolean ShowProductionEstimate{get;set;}
    // End of Global variables
    // Start constructor
    public ClientInvoicePrintExtension(ApexPages.StandardController controller)
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
            imageBody = imageURL+imageId;    imageNotFound = False;
        }    
        else
        {
            imageNotFound = True;
        }
        // End of code to display Subscriber Organization Logo
        wrapout = new List<Wrapper>();
        theID = ApexPages.CurrentPage().getParameters().get('id');
        tempCILI = [select id,Name,Production_Estimate__c,Equipment_Type__c,Production_Estimate__r.name,Billable_Amount__c,Estimate_Line_Item__c,Estimate_Line_Item__r.Name,GL_Code__c,Quantity__c,GL_Code_No__c,GL_Code__r.Name,Unit_Type__c,GL_Code__r.GL_ID__c,Client_Invoice__c from Client_Invoice_Line_Item__c where Client_Invoice__c  =: [Select id from Client_Invoice__c  where id =: theID] WITH SECURITY_ENFORCED Order By Name];
        setupGrouping();
        today=System.NOW();
    }
    Public class wrapper
    {
        public Client_Invoice_Line_Item__c cili{get;set;}
        public list<Wrapper2> esis{get;set;}
        public list<Wrapper3> pesis{get;set;}
        public wrapper()
        {
            if(cili == null)
            {
                cili = new Client_Invoice_Line_Item__c();
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
        for(Client_Invoice_Line_Item__c CILIRecord : tempCILI)
        {  
            if(ShowProductionEstimate){
                PELIIds.add(CILIRecord.Production_Estimate__c);
            }
            else{
                ELIIds.add(CILIRecord.Estimate_Line_Item__c);
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
        for(Client_Invoice_Line_Item__c CILIRecord1 : tempCILI)
        {
            wrapper tmpWrapper = new wrapper();
            tmpWrapper.cili = CILIRecord1;
            List<Wrapper2> t2 = new List<Wrapper2>();
            List<Wrapper3> t3 = new List<Wrapper3>();
            if(ShowProductionEstimate){
                
                if(PELI_ESI_Map.containskey(CILIRecord1.Production_Estimate__c))
                {
                    for(Production_Estimate_Spec_Item__c esi3:PELI_ESI_Map.get(CILIRecord1.Production_Estimate__c))
                    { 
                        wrapper3 twrap3 = new Wrapper3();
                        twrap3.pesi = esi3;    t3.add(twrap3);
                    }
                }
                tmpWrapper.pesis=t3;
                wrapout.add(tmpWrapper); 
            }
            else{
                if(ELI_ESI_Map.containskey(CILIRecord1.Estimate_Line_Item__c))
                {
                    for(Estimate_Spec_Item__c esi2:ELI_ESI_Map.get(CILIRecord1.Estimate_Line_Item__c))
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
}