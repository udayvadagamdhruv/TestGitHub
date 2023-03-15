public with sharing class addPELineItemToCILineItem {
    //Global variables
    public String CIid {
        get;
        set;
    }
    public List < ELIWrapper > rolewraps {
        get;
        set;
    }
    Public Set < String > ELINameELI = new Set < String > ();
    public List < Client_Invoice_Line_Item__c > lstCLI {
        get;
        set;
    }
    public List < Client_Invoice_Line_Item__c > lst {
        get;
        set;
    }
    public List < Production_Estimate__c > ELIlst {
        get;
        set;
    }
    public ScheduleTaskRole__c stc;
    String strSTId, strid;
    Client_Invoice__c C = new Client_Invoice__c();
    Map<String, Client_Invoice_Line_Item__c > CLIMap = new Map < String, Client_Invoice_Line_Item__c > ();
    public List< Client_Invoice_Line_Item__c > AddCLIList;
    
    Public Map<String,List<ELIWrapper>> ELIGropuMap{get;set;}
    // End of Global variables

    // Start Constructor 
    public addPELineItemToCILineItem() 
    {
        	lst = new List < Client_Invoice_Line_Item__c >();
            ELIlst = new List < Production_Estimate__c >();
            CIid = ApexPages.currentPage().getParameters().get('id');
            roleWraps = new List < ELIWrapper > ();
            ELIGropuMap = new Map <String,List<ELIWrapper>> ();
            
            C = [Select id, Name, Job__c from Client_Invoice__c where id = : CIid];

            lstCLI = [Select Id, name, Production_Estimate__c, Equipment_Type__c, Production_Estimate__r.name from Client_Invoice_Line_Item__c where Client_Invoice__c = : CIid order by CreatedDate];
            system.debug('============' + lstCLI.size());
            List < Production_Estimate__c > ELI = [Select id, PE_Template__c,Sort_Order__c, Name, Amount__c, Vendor__c, Job__c, Equipment_Type__c, Approved__c, Total_Cost__c, GL_Code__c, Quantity__c From Production_Estimate__c where Job__c = : C.Job__c and Approved__c = true Order By Sort_Order__c];

            if(!ELI.isEmpty()) 
            {
                Set < string > ELINameSet = new Set < String > ();
                for (Client_Invoice_Line_Item__c ClientLI: lstCLI)
                {
                    ELINameSet.add(ClientLI.Production_Estimate__r.name);
                    CLIMap.put(ClientLI.Production_Estimate__r.name, ClientLI);
                }

                for (Production_Estimate__c e: ELI) 
                {
                    if (!ELINameSet.contains(e.name))
                    {
                        roleWraps.add(new ELIWrapper(e));
                    }
                    else 
                    {

                        ELIWrapper rw = new ELIWrapper(e);
                        rw.checked = True;
                        roleWraps.add(rw);
                        ELINameELI.add(e.name);
                    }
                    //rw.e=e;
                 }
                 
                 for(ELIWrapper ew:roleWraps)   
                 {   
                   if(ELIGropuMap.containsKey(ew.e.PE_Template__c))
                   {
                      List<ELIWrapper> rolewrapsList = ELIGropuMap.get(ew.e.PE_Template__c);
                      rolewrapsList.add(ew);
                      ELIGropuMap.put(ew.e.PE_Template__c,rolewrapsList);  
                    }
                    else
                    {
                      ELIGropuMap.put(ew.e.PE_Template__c, new List<ELIWrapper>{ew}) ;
                    }  
                    
                    
                 
                }

            }
        }
        // End Constructor 

    // Start Wrapper Class 
    public class ELIWrapper 
    {
        public Production_Estimate__c e {get;set;}
        public Boolean checked {get;set;}
        //public string PE{get;set;}
        public ELIWrapper(Production_Estimate__c e) 
        {
            this.e = e;
            //this.PE = PE;
            checked = false;
        }
    }
    // End of Wrapper Class

    // Save Method
    public pagereference Save() {
            /* 
              lst=new List<Client_Invoice_Line_Item__c>();
              for(ELIWrapper rw:roleWraps)
               {

                  if(rw.checked==true)
                  {
                      Client_Invoice_Line_Item__c stRole=new Client_Invoice_Line_Item__c();
                      stRole.Estimate_Line_Item__c=rw.e.id;
                      stRole.Billable_Amount__c=rw.e.Total_Amount__c;
                      stRole.GL_Code__c=rw.e.GL_Code__c;
                      stRole.Client_Invoice__c=ApexPages.currentPage().getParameters().get('id');
                      lst.add(stRole);
                  }
               }
               System.debug('Inserted value @@@ '+lst);
               insert lst;

              PageReference p =  new Pagereference('/apex/ClientInvoiceDetailPage?id='+CIid);
              p.setRedirect(true);
              return p; */

            if (!roleWraps.isEmpty()) {
                AddCLIList = new List < Client_Invoice_Line_Item__c > ();
                List < Client_Invoice_Line_Item__c > deleteCLIList = new List < Client_Invoice_Line_Item__c > ();
                for (ELIWrapper apw: roleWraps) {
                    boolean existing = ELINameELI.contains(apw.e.name);
                    if (apw.checked == True) {
                        if (!existing) AddCLIList.add(new Client_Invoice_Line_Item__c(Client_Invoice__c = ApexPages.currentPage().getParameters().get('id'),Sort_Order__c=apw.e.Sort_Order__c, PE_Template__c = apw.e.PE_Template__c , GL_Code__c = apw.e.GL_Code__c, Quantity__c = apw.e.Quantity__c, Billable_Amount__c = apw.e.Total_cost__c, Production_Estimate__c = apw.e.id, Equipment_Type__c = apw.e.Equipment_Type__c));
                    } else if (existing) {
                        if (CLIMap.containsKey(apw.e.name)) {
                            Client_Invoice_Line_Item__c objJTR = CLIMap.get(apw.e.name);
                            deleteCLIList.add(objJTR);
                        }
                    }

                }
                if (!AddCLIList.isEmpty()) {
                    if (!Client_Invoice_Line_Item__c.sObjectType.getDescribe().isCreateable()) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Insufficient access'));
                    } else {
                        insert AddCLIList;
                    }
                }

                if (!deleteCLIList.isEmpty()) {
                    if (!Client_Invoice_Line_Item__c.sObjectType.getDescribe().isDeletable()) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Insufficient access'));
                    } else {
                        delete deleteCLIList;
                    }
                }
            }

            PageReference p = new Pagereference('/apex/ClientInvoiceDetailpageSwitchPage?id=' + CIid);
            p.setRedirect(true);
            return p;
        }
        // End of Save Method

    // Method called on to handle Back Button
    public pagereference Back() {
            PageReference p = new Pagereference('/apex/ClientInvoiceDetailpageSwitchPage?id=' + CIid);
            p.setRedirect(true);
            return p;
        }
        // End of Back

}