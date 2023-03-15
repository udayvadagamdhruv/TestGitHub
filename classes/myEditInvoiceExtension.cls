public with sharing class myEditInvoiceExtension{

    public boolean isLtng{private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
            }  
            
    
    
    Public  string vgl;
    public string ILIid{get;set;}
    public Invoice_Line_Item__c ILIobj {get; set;}
    public id jiobj {get; set;}
    public id invpg {get; set;}
    public string getvgl() { return vgl;}
    public void setvgl(string v){this.vgl=v; }
    private final Invoice_Line_Item__c oldobj;

//used standard controller 
    public myEditInvoiceExtension(ApexPages.StandardController controller) {
        
        this.oldobj =  (Invoice_Line_Item__c )controller.getrecord();
          Invoice_Line_Item__c  abc = [select id,Name,GL_Code__c from Invoice_Line_Item__c  where id =: oldobj.id Limit 1];
          vgl = abc.GL_Code__c;
          system.debug('vgl'+vgl);
        ILIid = ApexPages.currentPage().getParameters().get('id');
        ILIobj = [SELECT id, Name, Invoice__r.Vendor__c, Invoice__c, Invoice__r.Purchase_Order__c,Invoice__r.Invoice_Status__c,Quantity__c , Amount__c, GL_Code__c, GL_Code__r.name, Estimate_Line_Item__c FROM Invoice_Line_Item__c WHERE Id =: ILIid];
        jiobj = ILIobj.Invoice__r.Vendor__c;
        invpg = ILIobj.Invoice__c;
    }   
    

 //   public Invoice_Line_Item__c ILIobj2 {get; set;}
   
    public list<selectOption> getGLcode(){
        system.debug('vendor code @@@@@@@@@@@@@@@ '+jiobj);
        string query = 'select GL_Code__r.name,GL_Code__r.GL_ID__c, Vendor__c ,id,name from Vendor_GL_Code__c where Vendor__c =: jiobj';
        list<Vendor_GL_Code__c> lst = database.query(query);
        
        List<selectOption> options = new List<selectOption>(); 
        for (Vendor_GL_Code__c vglc : lst) 
        { 
             options.add(new selectOption(vglc.id, vglc.GL_Code__r.name));  
        }
        return options; //return the picklist options
    }
//added this function for cancel and save button    
    public pageReference cancl(){
       
        if(isLtng)
        {
            PageReference newpg = new PageReference('/apex/InvoiceDetailPageLightning?id='+invpg );
            return newpg;
        }
        else
        {
            PageReference newpg = new PageReference('/apex/InvoiceDetailPage?id='+invpg );
            return newpg;
        }
       
        
        
    }
    
    public pageReference savbtn(){
    
         system.debug('vgl+++++++++'+vgl);
         
        Vendor_GL_Code__c obj = [select id,GL_Code__r.name, name from Vendor_GL_Code__c where id = : vgl]; 
        GL_Code__c gl=[Select Id,Name from GL_Code__c where Id=:obj.GL_Code__c];
        
        string qq1 = 'select id, GL_Code__c ,GL_Code__r.name, Vendor__c ,name from Vendor_GL_Code__c where id =: vgl limit 1';
        Vendor_GL_Code__c jvgl = database.Query(qq1);
        system.debug('jvgl <<------------>> '+jvgl.GL_Code__r.name);
        ILIobj.GL_Code__c = gl.Id;//jvgl.GL_Code__r.name;
        system.debug('vgl after save ------------------>>>> '+ILIobj.GL_Code__r.name);
        update ILIobj;
        
        if(isLtng)
        {
           PageReference newpg = new PageReference('/apex/InvoiceDetailPageLightning?id='+invpg );
            return newpg;
        }
        else
        {
            PageReference newpg = new PageReference('/apex/InvoiceDetailPage?id='+invpg );
            return newpg;
        }
       
        
        
        
    }

    // Start Test Coverage Code
     /** static testMethod void DisplayInvoiceWhenApproved()
     {
            Job_Number_Setting__c customSetting1 = new  Job_Number_Setting__c(Name= 'yy');
            insert customSetting1;
     
            Media_Type__c testMedia=new Media_Type__c(Name='TM02Mar');
               insert testMedia;
             
           Schedule_Template__c testST=new Schedule_Template__c(Name='TST02Mar',Media_Types__c=testMedia.Id);
               insert testST;
                 
           Specification_Template__c testSpec=new Specification_Template__c(Name='TST02Mar');
               insert testSpec;
           
           Job__c testJob1=new Job__c(Name='TJ02Mar',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id);
            try
             {
                   insert testJob1;
             }
            catch(System.DMLException e)
             {
                 System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION',e.getDmlStatusCode(0));
             }
           
           System.assertEquals('TJ02Mar',testJob1.Name);  
     
           GL_Department__c GLD = new GL_Department__c(Name='test GL');
           insert GLD;
           
           GL_Code__c GLC = new GL_Code__c(Name = 'abc', GL_Department__c = GLD.id, GL_ID__c = 'abc123', Unit_Type__c = 'Days');
           insert GLC;
     
           Vendor__c ven = new Vendor__c(Name = 'ven1');
           insert ven;
           
           Vendor_GL_Code__c venGL = new Vendor_GL_Code__c(GL_Code__c = GLC.id, Vendor__c = ven.id);
           insert venGL;
           
           Invoice__c ESI = new Invoice__c(Name='INV01March',Job__c=testJob1.id, Vendor__c = ven.id);
           insert ESI;
           
           Invoice_Line_Item__c invli = new Invoice_Line_Item__c(Invoice__c = ESI.id,GL_Code__c = GLC.id);
           insert invli;
           
            ApexPages.currentPage().getParameters().put('id',invli.Id);

            ApexPages.StandardController con = new ApexPages.StandardController(invli);
            myEditInvoiceExtension ext = new myEditInvoiceExtension(con);
            
            ext.ILIid = invli.id;
            ext.vgl = GLC.id;
            ApexPages.PageReference result1=ext.cancl();
            result1 = ext.savbtn();
            list<selectOption> result2 = ext.getGLcode();

// Instantiate the extention instance with the Custom Controller
           myEditInvoiceExtension ext1=new myEditInvoiceExtension();
           
// Invoke the primary method on the extension
           //ApexPages.PageReference result1=ext1.cancl();
//  System.assertEquals(ESI.id,ext.theID);
           //result1 = ext1.savbtn();

      } **/
     // End of test Method
      
}