//@istest
public class TestCampaignTemplate {
    
   /* @isTest static void TestCampaignTemplateMethod(){
        
        Campaign_Template__c ct1=new Campaign_Template__c();  
        Campaign_Jobs__c  cjob1=new Campaign_Jobs__c();
        
        Campaign_Template__c ct=new Campaign_Template__c(name='Campaign Template');
        insert ct;
        
        Media_Type__c MT=new Media_Type__c(Name='Test Media 301');
        insert MT;
        
        Schedule_Template__c ScTemp=new Schedule_Template__c(Name='Test Schedule Template 301',Media_Types__c=MT.Id);
        insert ScTemp;
        
        
        Campaign_Jobs__c Cjobs=new Campaign_Jobs__c(name='Campaign Job',Campaign_Template__c=ct.id,Media_Type__c=MT.id,Schedule_Template__c=ScTemp.id);
        insert Cjobs;
        
        
        
        // CreateCT
        Apexpages.StandardController aa=new  Apexpages.StandardController(ct1);
        CreateCT ext=new CreateCT(aa);
         Apexpages.Pagereference p0=ext.saveme();
        p0=ext.cancelme();
       
        //editcampaigntemplateExt        
        Apexpages.StandardController aa1=new  Apexpages.StandardController(ct);
        editcampaigntemplateExt ext1=new editcampaigntemplateExt(aa1);
        Apexpages.Pagereference p1=ext1.saveme();
        p1=ext1.cancelme();
        
        //editcampaignTemplateSwitchExt
        editcampaignTemplateSwitchExt ext2=new editcampaignTemplateSwitchExt(aa1);
        
        //CampaignTemplateListViewSwitchExt
        CampaignTemplateListViewSwitchExt ext3=new CampaignTemplateListViewSwitchExt(aa1);
        Apexpages.pageReference p3=ext3.CTListview();
        
       //JobsUnderCampaignTemplateController 
        JobsUnderCampaignTemplateController ext4 =new JobsUnderCampaignTemplateController();
        Apexpages.pagereference p4=ext4.NewCampaignJob();
        
        //NewCampaignJobExt
         Apexpages.currentPage().getParameters().put('CTempId',ct.id);
         Apexpages.StandardController aa3=new  Apexpages.StandardController(cjob1);
         NewCampaignJobExt ext5=new NewCampaignJobExt(aa3);
         List<selectOption> lo=ext5.getMediaTypes();
         List<selectOption> lo1=ext5.getScheduleTemplates();
          ext5.MTName=MT.id;
          Apexpages.pagereference p5=ext5.SaveCampaignJob();
          ext5.ScheduleTemp=ScTemp.id;
         
          p5=ext5.SaveCampaignJob();
          p5=ext5.cancel();
        
       // EditCampaignJobExt
        ApexPages.StandardController con6=new  ApexPages.StandardController(Cjobs);
        EditCampaignJobExt  ext6=new EditCampaignJobExt(con6);
        List<selectOption> lo6=ext6.getMediaTypes();
        List<selectOption> l066=ext6.getScheduleTemplates();
        Apexpages.pagereference p6=ext6.EditSaveCampJob();
        p6=ext6.Cancel();
        
       // EditCampaignJobSwitchExt
        EditCampaignJobSwitchExt ext7=new EditCampaignJobSwitchExt(con6);
        
       // CampaignTemplateDetailSwitchExt
         CampaignTemplateDetailSwitchExt ext9=new CampaignTemplateDetailSwitchExt(con6);
          Apexpages.pagereference p9=ext9.CTDetailview();
        
        //DeleteCampaignJobExt
        DeleteCampaignJobExt ext8=new DeleteCampaignJobExt(con6);
        Apexpages.pagereference p8=ext8.checkDelete();
        
       //DeleteCampaignTempExt
        DeleteCampaignTempExt ext10=new DeleteCampaignTempExt(aa1);
         Apexpages.pagereference p10=ext10.checkDelete();
        
        
    }*/

}