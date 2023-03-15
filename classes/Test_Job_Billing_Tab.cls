@IsTest
public class Test_Job_Billing_Tab {
    public static testMethod void Test_Job_Billing_Tab(){   
        
        Client__c Cl=new Client__c(Name='test Client');
        insert Cl;
        
        Invoice_Allocation_Template__c Iat= new Invoice_Allocation_Template__c(Name='Test IAt');
        insert Iat;
        
        Invoice_Allocation_Template_Line_Item__c IATLI=new Invoice_Allocation_Template_Line_Item__c(Invoice_Allocation_Template__c=Iat.id,Client__c=Cl.id,Allocation_Qty__c=20);
        insert IATLI;
        
        Invoice_Allocation_Template_Line_Item__c IATLI1=new Invoice_Allocation_Template_Line_Item__c(Invoice_Allocation_Template__c=Iat.id,Client__c=Cl.id,Allocation_Qty__c=30);
        insert IATLI1;
        
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
        
        Client_Invoice__c testClientInv = new Client_Invoice__c (Name='INV01March',Job__c=testJob1.Id,Client_Name__c=Cl.Id);
        insert testClientInv;
        
        GL_Department__c testGLD = new GL_Department__c(Name='TestGLD1101');
        insert testGLD;
        
        GL_Code__c testGL=new GL_Code__c(Name='GL Code 1101',GL_ID__c='TestGL9988',GL_Department__c = testGLD.id);
        insert testGL;
        Material_Item__c mi=new Material_Item__c(GL_Department__c=testGLD.id,GL_Code__c=testGL.id,Calc_Unit__c='Each',name='1 Hour Free');
        insert mi;
           
        Vendor__c v = new Vendor__c(Name = 'Tset');
        insert v;
        Invoice_Allocation_Line_Item__c ina= new Invoice_Allocation_Line_Item__c(Client_Invoice__c =testClientInv.id,Client_Name__c=Cl.id,Allocation_Qty__c=20);
        insert ina;
        
        Invoice_Allocation_Line_Item__c ina1= new Invoice_Allocation_Line_Item__c(Client_Invoice__c =testClientInv.id,Client_Name__c=Cl.id,Allocation_Qty__c=20);
        insert ina1;
        
        Invoice_Allocation_Line_Item__c InvALL= new Invoice_Allocation_Line_Item__c(Client_Invoice__c =testClientInv.id,Client_Name__c=Cl.id,Allocation_Qty__c=20);
        insert InvALL;
        
        
        Estimate_Line_Items__c eli = new Estimate_Line_Items__c(Name = 'Test Eli', GL_Department__c = testGLD.Id, GL_Code__c = testGL.Id,Job__c = testJob1.Id,Quantity__c = 12,Vendor__c = v.Id,Approved__c=True);
        insert eli;
        
        Production_Estimate__c peli = new Production_Estimate__c(Name = 'Test PEli', GL_Department__c = testGLD.Id, GL_Code__c = testGL.Id,Job__c = testJob1.Id,Quantity__c = 12,Approved__c=True);
        insert peli;
        
        Client_Invoice_Line_Item__c CiLi= new Client_Invoice_Line_Item__c(GL_Code__c = testGL.Id,Quantity__c = 12,Billable_Amount__c=200,Client_Invoice__c=testClientInv.Id,Estimate_Line_Item__c=eli.Id);
        insert CiLi;
        
        list<Client_Invoice__c> ClinvList = [select id from Client_Invoice__c];
        
        list<Estimate_Line_Items__c> EstList = [Select id,Name,Amount__c,Vendor__c,Job__c,Approved__c,Total_Amount__c,GL_Code__c,GL_Code__r.Name, Quantity__c, Unit_Type__c from Estimate_Line_Items__c where Approved__c = true];
        
        Test.startTest(); 
        Job_Billing_Tab.getisAccessable();
        Job_Billing_Tab.importIATLI(testClientInv.id,Iat.Id);
        Job_Billing_Tab.importIATLI(testClientInv.id,Iat.Id);
        Job_Billing_Tab.getCLIrecords(testJob1.Id);
        Job_Billing_Tab.updateCLI(ClinvList);
        Job_Billing_Tab.getClients();
        Job_Billing_Tab.getHelpTextrecords();
        Job_Billing_Tab.getFieldsforObject('Client_Invoice__c');
        Job_Billing_Tab.FetchObjectType(new list<string>{'Client_Invoice__c'});        
        Job_Billing_Tab.geLabelforObject('Account');
        Job_Billing_Tab.showProductionEstimate();
        
        List <Client_Invoice_Line_Item__c> ClinvLi=[select id from Client_Invoice_Line_Item__c];
        Job_Billing_Tab.getClientInvLI(testClientInv.Id);
        Job_Billing_Tab.updateCLInvLI(ClinvLi);
      

        Job_Billing_Tab.getAddEstLIinCLInvLI(testClientInv.Id);
        
        Job_Billing_Tab.insertEstLI_PELI(testClientInv.Id,EstList);
        List<Invoice_Allocation_Line_Item__c> ClinvALi=[select id from Invoice_Allocation_Line_Item__c];
        Job_Billing_Tab.getInvALIrecords(testClientInv.Id);
        Job_Billing_Tab.updateInvALI(ClinvALi);
        
        Job_Billing_Tab.getSumQuant(testClientInv.Id);
        Job_Billing_Tab.getSumCash(testClientInv.Id);
        Job_Billing_Tab.getInvAllocationTemplates();
        insert new ProductionEstimate__c(Active__c = true);

        Job_Billing_Tab.getAddEstLIinCLInvLI(testClientInv.Id);
        Job_Billing_Tab.insertEstLI_PELI(testClientInv.Id,new list<Production_Estimate__c>{peli});
        Job_Billing_Tab.deleteCLInvLI(CiLi.id);
        Job_Billing_Tab.deleteIALI(InvALL.Id);
        Job_Billing_Tab.DeleteCLI(testClientInv.Id); 
          ApexPages.StandardController stanSetCon=new ApexPages.StandardController(peli);
        EditProductionEstimate es=new EditProductionEstimate(stanSetCon);
         es.getMIName();
        es.setMIName(mi.id);
        es.getGLDName();
            es.setGLDName(testGLD.id);
            es.getGLCName();
            es.setGLCName(testGL.id);
            es.getVName();
            es.setVName(v.id);
        es.getMaterialItems();
        es.getMaterialItems2();
        es.getGLDepartments();
        es.getGLCodes();
        es.getVendors();
        es.saveme();
        es.cancelme();
        es.setVName(null);
         es.saveme();
         es.setGLDName(null);
         es.saveme();
         es.setGLCName(null);
         es.saveme();
       
        Test.stopTest();
        
    }
}