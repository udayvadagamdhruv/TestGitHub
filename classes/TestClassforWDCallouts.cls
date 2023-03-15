@istest
public class TestClassforWDCallouts {
    
    @testSetup static void SetupWDcallout(){
        
     Client__c testClient = new Client__c(Name='Test Client 9897');
          insert testClient;
        
          Client_Contact__c testCC = new Client_Contact__c(First_Name__c='Test Client', Last_Name__c='Contact' ,Name = 'Test Client Contact', Client__c=testClient.id,Email__c='testClientContact9897@SFDC.com',Salesforce_User__c=true,UserName__c='testClientContact9897@SFDC.com');     
          insert testCC;
        
          Media_Type__c testMedia=new Media_Type__c(Name='TM001');
          insert testMedia;
          
          Schedule_Template__c testST=new Schedule_Template__c(Name='ST001',Media_Types__c=testMedia.Id);
          insert testST;
   
          Schedule_Task__c testSCT1=new Schedule_Task__c(Name='ST001',Schedule_Template__c=testST.Id);
          insert testSCT1;
                 
          Schedule_Task__c testSCT2=new Schedule_Task__c(Name='ST002',Schedule_Template__c=testST.Id);
          insert testSCT2;
                 
          ScheduleTaskRole__c testSTR1=new ScheduleTaskRole__c(Name='R001',Schedule_Task__c=testSCT1.Id);
          insert testSTR1;
                 
          ScheduleTaskRole__c testSTR2=new ScheduleTaskRole__c(Name='R002',Schedule_Task__c=testSCT2.Id);
          insert testSTR2;            
                 
          Specification_Template__c testSpec=new Specification_Template__c(Name='SPT001');
          insert testSpec;
                
          Spec_Item__c testSPI=new Spec_Item__c(Name='SI001',Specification_Template__c=testSpec.Id); 
          insert testSPI;
         
          Campaign__c testCampaign1=new Campaign__c(Name='C001',Active__c=True,Status__c='In Progress',Budgeted_Cost__c=5000,Actual_Cost__c=6000,Workdocs_Folder_Id__c='c767cb690059a008adf66aa93e235ca2c6c1cde2ec4b8a946b406b3ac4dfa5b3');
          insert testCampaign1;
         
         
                
          Job__c testJob1=new Job__c(Name='Job002',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec.Id,Campaign__c=testCampaign1.id,JS_Client__c=testClient.id,JS_Client_Contact__c=testCC.id,Schedule_Calc__c='Start Date',Workdocs_Folder_Id__c='c767cb690059a008adf66aa93e235ca2c6c1cde2ec4b8a946b406b3ac4dfa5b3');
          insert testJob1;  
        
       // Site_Name__c, Workdocs_UserId__c, WD_Org_Id__c, Authorization_Code__c, Refresh_Token__c, Scheduled__c, Access_Token__c, Redirect_Url__c, Application_Id__c FROM Workdocs_Connection__c
        Workdocs_Connection__c jwdc=new Workdocs_Connection__c();
        jwdc.User__c=Userinfo.getUserId();
        jwdc.Workdocs_UserId__c='123456-123456';
        jwdc.State__c='us-west-2';
        jwdc.Access_Token__c='eyJhcHBsaWNhdGlvbklkIjoiNGJhMDhiNDctOTI3Zi00ZGU0LWJjOTQtYzM3NTVmNmU1OWJlIiwiZXh0ZXJuYWxwcm92aWRlciI6IkRJUkVDVE9SWV9TRVJWSUNFIiwiZXh0ZXJuYWx0b2tlbiI6ImV5SmliRzlpSWpvaWUxd2laR0YwWVZ3aU9sd2lRVUZCUVhCdWMybFJSMDV6V1ZoT2VrbHFiMmxaTWpsMFRHMUdkRmxZY0haaWFUVm9aRE5OZFdNeWREVmliVll3VEcxS2MweHRNWFphUjFaelRHdEdkMk5IZUhCWk1rWXdZVmM1ZFZKSGJIbGFWMDR3WWpOS05WVnRWbnBpTTFaNVdUSldTbHBIVm5Wa1IyeHRZVmRXZVVscGQybFpXRUozWWtkc2FsbFlVbkJpTWpWS1drTkpOa2xxUm1sYVZGRXpUbTFSTTB4VVl6Tk9SRVYwVGtSV2EwNXBNV2xOUkVwcFRGZEpNRnBYVW14T1ZHczFUVlJhYlZsVFNYTkpiVkp3WTIxV2FtUkhPWGxsVld4clNXcHZhVnBETURWTmFsa3pUV3BWZDA1NmJHeEpiakJCUVVGQlFVRkJRVUZCUzNwQk5IWTNXVU0yZVd4RGVIQklhMFozUWxWMFJtSnVSWEIyU25WclNVMXJWMUZIY1VGMmFFZzVXblpNWVhGNlZuRTJXRFJ1YlM5allrVndUa1I0VGpFd1pqVTNLekpYT1VwNE1uTlJkRTl1TmtGWlZUZzJPRGhYTUc1SWQyeERiVlZtVm1ReVUxTkpWSGxYVm1KUE1GVkRTbEF2ZWxObVl6aDBMMlUwSzJSTGNVTjNjamtyVUdaWVpraElSMGR6VDFoRFptbGxibTlaTmpSNlIyWkdOVUkxTkhscVYwSjFTemx2Ym1kNmJWVnlSbU0wU1U4dmRtSmhOa3hsZEZadlJtaHRZM1JzZEhSamN5OHpVSGhsZVc4ME1HUXljaXRRYVdKSU5ubGpVemxCZDBsQ1lWWXZTVnB6YVRaRlIzTlJNVXh4WlM5U1RIQk5Xblp2Tmt3NFJVRnJjREpuY0VKaloybFNZbVYwZEdSeFNISTVkRVJSV1VoVVVqSTFVMEpOTjJSWmVXVXZiVzUwV1doM2FtaFpVbXR4U3pSS05td3hORkJtV2tWeGNYTkplbVptU0VoVllsTkJXRzQ0UlRnd1pFTkpRM1ZqUkN0MFJYUTRlVkUwU25aalZYUjJORWhzVTFsVVpEYzRUa2R2ZUVObU1IRTBWMEpsYlVWVVJVd3JaMHQ2TDJOME5DODNkSEUxV2xOSlEwSXZOMWxCUTBOR1RqaFNXSEZNYzB0bmVVRXpTMVZPU3pGUVlsd2lMRndpYldGMFpYSnBZV3hUWlhKcFlXeGNJam94TEZ3aWMybG5ibUYwZFhKbFhDSTZYQ0pZT1RWTFVIUnNkVEJETW5SbGR6UjBSVTh6WmtSbWMydE5MMkZRZG5NMlRUbDFkbnBpY2s1clRYWXhWMmh5TWpSYU1HSjFjM2xOVm5kYWNVVTVTWEJpVDJwR1JtZFNSR1Z4TTBkdFlVTjJURUprWkRnd1NtRkNhMHRwYlVWMlJFRlFOMWsxVEhOT2RHcHVNMFpRWmxvME9IcHBhblZSU25waVNrUXpaVTFWY1RoRVJYSjNia1J6UWxsdmJHeHNTVlV3WjFKRVFVdG5XRk5MZUVWWE5EUldkWGs0Y25GV05XWlBUV3N5UzNkMWNWVXdUV3hHVGtOTVNqVnRlR3BITVRsRGJqZFNabFU0TjJGYU0wSnFXWG81UlVOUGMwVjNWbFZuTVhKNVpVSk1URGgwVDFSU1FVdDVNbkpSWmtVdlRXZFdSRlo1VXpoeWMxSnlXRlV2VmxVeFlXNVRUMVJtWkVsSVRVZFJLMGxJWlhSdmFXSmFWRzVhVG5Zd2JXTnhPVTkzT1RjNFpGZFNZbTh6WlZKNWQwY3ZiRkZOYjBVeFJYSTBaVk52VlVaMmEwaHpXV28zTm1aNGFWbHhlWGhTY0haaVIxcEJLMmM5UFZ3aWZTSXNJblpsY25OcGIyNGlPakY5IiwiaXNGZWRlcmF0ZWQiOmZhbHNlLCJzY29wZXMiOlsid29ya2RvY3MucHJvZmlsZS5yZWFkIiwid29ya2RvY3MuYWN0aXZpdHkucmVhZCIsIndvcmtkb2NzLmNvbnRlbnQud3JpdGUiLCJ3b3JrZG9jcy5jb250ZW50LnJlYWQiLCJ3b3JrZG9jcy5hZG1pbi53cml0ZSJdLCJzaWduYXR1cmUiOiJaMzdMVTNiYUt2NnYyWm4wTDlHTTF5VkpCOXc5MnBLSDlqbDlIenVhSVVFPSIsInVzZXJpZCI6IlMtMS01LTIxLTM3ODAyMTg2MzYtMjAyMTI1NDA3NS03MDU3MTQzNzMtMTExOCZkLTkyNjcyNTA3OWUiLCJ2ZXJzaW9uIjozfQ==';
        jwdc.Application_Id__c='4ba08b47-927f-4de4-bc94-c3755f6e59be';
        jwdc.Authorization_Code__c='WorkDocsAuthCode_w6vDhRv0AXO_VI_1KRePJg8wH0tZDQkYqN7H-KvpAgLc9yjv3kOimLirrlVYRc0EhJWpS8Cm0dDrPRYo6ljypiZDizg3A54plwywKMrROUX8JHDfN8UNNlTJrGeXQ49CS4lLGsHzy-qA3hi49mcr7Q6n6ndQoE0uauxa2Q7RIBbusU2o5FOQ_AdbBRlEl3nK8f1yVZNTQXnvLo2eeK1Ql59c6jMT4Gmfp7ghAW99WkXIbrJAh4jtmQB6VEL89GlJp0kihM3HRJzfPDKENzYOqciWh7jFsekLLi4Jk0lkR6Fx4HvfrIjTbbia-pnwtpM1DCn9G5KNqJpHC3LixCoAqJ5n0-kQhd6IXteEGEO6MoVcRI1spdexjh6A9pKBJnwtmnV_VNA6FJFykdL7bMzqu735zO2jKt8I8wGwL3ScLpR9tb2t60CxfeAS-mxtS_yhRBkyUPTbGTe3HFXSMg3XWF4XsKTxNT3rBrRbvHyeQJKVRwnvpPziBJzmRo-idfZa26PQ6UTcIeDOU4IBnVe-4lkKXS4T_FhPtEsdaQqqaubwcw2laXfsGZMoTpy46w3ji7u7Kp8SOkENT-3sk_hAug..';
        jwdc.Redirect_Url__c='https://jsbaseorg-dev-ed--jobsuite.na7.visual.force.com/apex/workdocs';
        jwdc.Refresh_Token__c='eyJhcHBsaWNhdGlvbklkIjoiNGJhMDhiNDctOTI3Zi00ZGU0LWJjOTQtYzM3NTVmNmU1OWJlIiwiZXh0ZXJuYWxwcm92aWRlciI6IkRJUkVDVE9SWV9TRVJWSUNFIiwiZXh0ZXJuYWx0b2tlbiI6ImV5SmliRzlpSWpvaWUxd2laR0YwWVZ3aU9sd2lRVUZCUVhCdWMybFJSMDV6V1ZoT2VrbHFiMmxaTWpsMFRHMUdkRmxZY0haaWFUVm9aRE5OZFdNeWREVmliVll3VEcxS2MweHRNWFphUjFaelRHdEdkMk5IZUhCWk1rWXdZVmM1ZFZKSGJIbGFWMDR3WWpOS05WVnRWbnBpTTFaNVdUSldTbHBIVm5Wa1IyeHRZVmRXZVVscGQybFpXRUozWWtkc2FsbFlVbkJpTWpWS1drTkpOa2xxUm1sYVZGRXpUbTFSTTB4VVl6Tk9SRVYwVGtSV2EwNXBNV2xOUkVwcFRGZEpNRnBYVW14T1ZHczFUVlJhYlZsVFNYTkpiVkp3WTIxV2FtUkhPWGxsVld4clNXcHZhVnBETURWTmFsa3pUV3BWZDA1NmJHeEpiakJCUVVGQlFVRkJRVUZCUVdGcmFGSkpkREJyV1dSa04wSlRhREE1VXk5QmJrZ3hZaklyWTJGTFZYRk9kVEZ2Y21rMmEwTXZURTkwY25ObVEweElMMFJwT1hscE5uSmphR2w0V1VwbmFXOW9lVVoyVmtacGNVaFpjek42TDNSbGJua3dhSGt5THl0VFdsUkpTelZIUTFkYWJUbFpVM2N2VUVKSWJVaENjVFpzZEd4clJuYzNOVmxFTDBGTE4zZEpNVkV3VjBoVlRqVllSV2hFUVRKNE4wdGhSSGN3TjBJM01FZ3plaXRWU1dwSldEaFRWVGw2TURkcWVsbFdRVXBIVXpkS1dtUlpOVVYxWnpNclkxRmlWVTlDYlhwM2JrSklXR2hTVVdwSmNtcEpPR1J2V1VwRFVVNDBjREJJYlRkMFIwZ3hiMHR2WmtoUlltRmxiMkZIZEd0c1ZDOUVNMFZJVEVVMlVIWm1VRlJaV0M4NVVHUm1kSFJtV1Uwd1dHNUJVMnBPUVhCclJVbGpRMVJvTVc1NU4xWk5TU3RCZEZSS0sxSTRaMmQ2YVVoS2FYRkxhMVJDVXpodU5XNTVlbXhyWW5aUk1HMHZLekU0TjFSdWJFNWxlRmRIUlZSTE9Wb3lhWEJLYUVoa1ZEaFBlak5rYWtvNWJtcHFUbGh3YUcweVVUZFVUazlXYlhsR1NuTkZWR1JHVEZSRVZ6ZG1iV3BWYjAxalZrUk5ZV2xtTlM5bFIzTmhZV28zTmpWM1ltUlJaRTlKUldoWFRscHlkejFjSWl4Y0ltMWhkR1Z5YVdGc1UyVnlhV0ZzWENJNk1TeGNJbk5wWjI1aGRIVnlaVndpT2x3aVJGVnZLMjlNVG1sMlMyaERZbHBNUWlzM09HRXhOME50T1hacldtRk5PRkJLZVRKc2RGUmpjRFpKVUVocU1GTm1TVmQ0TmpCclNVbGFXRmhNY2xnNFJXWlBReXRrYm5OaldGTlFkR3RoUVVSNlMweHBTMEoxVDNwaFNVaEZaVUpUWlM4ck56WTFVMGh4YjJwNGFsa3hXbXR1ZGtJME5XTlpVbXBVU210S1VqZDFhazAyV2xGMU5EaFpTMGxHVDJoVVVqSXZNbXgwUm1semJXNVJVRGxuT1Zrdk15dFNTbUYyUkdndk4xRTNRbm9yY2l0aFVEVk1iREk1VFVaTWIyVlBOVXg1VVdaa1MzcHNlRGxaWVRaQmNXeEtiblJaVjI5YVlrUnJTSFpvVWpocmFWTm5ZMUZYYlVWUk0wMUdhalJEZW0xaU1GY3pMMlF4WWxKcWVtSkhWMlZuY0RoT2JXaG5VWFJIUzI4dlpVVkdORTVUTW5WUGIwOURhRlpwYTJkT2VHdHFOVU5RU0RkNU1Yb3JVMDVwVmxCTk1rNU1URFpGZVVscFZpdENha0pTYzBSUU1rczJjbkpFYWxaMVkyZEZlRkptUlc1M1BUMWNJbjBpTENKMlpYSnphVzl1SWpveGZRPT0iLCJpc0ZlZGVyYXRlZCI6ZmFsc2UsInNjb3BlcyI6WyJ3b3JrZG9jcy5wcm9maWxlLnJlYWQiLCJ3b3JrZG9jcy5hY3Rpdml0eS5yZWFkIiwid29ya2RvY3MuY29udGVudC53cml0ZSIsIndvcmtkb2NzLmNvbnRlbnQucmVhZCIsIndvcmtkb2NzLmFkbWluLndyaXRlIl0sInNpZ25hdHVyZSI6ImQxNXpsTHk2eUhRaEdDUFhYUkZ4c1FlS2crMCtaZ0loVittc251cUtBQ009IiwidXNlcmlkIjoiUy0xLTUtMjEtMzc4MDIxODYzNi0yMDIxMjU0MDc1LTcwNTcxNDM3My0xMTE4JmQtOTI2NzI1MDc5ZSIsInZlcnNpb24iOjJ9';
        jwdc.Scheduled__c=true;
        
       
        insert jwdc;
        Blob attBlob;
        attBlob=EncodingUtil.base64Decode('AA==');
        
        Attachment atc=new Attachment();
        atc.OwnerId = UserInfo.getUserId();
        atc.Name = 'test.pdf';
        atc.ParentId = testJob1.Id; // the record the file is attached to
        atc.Body=attBlob;
        atc.ContentType = 'application/pdf';
        insert atc;      
        
    }
    
    
    
    @isTest static void testCallout1() {
        // Set mock callout class 
 
        Job__c jb1=[select id,name,Workdocs_Folder_Id__c from Job__c Where name='Job002' limit 1];
        Attachment at1=[select id,Name,ContentType,Body from Attachment limit 1];
        
       //list<Workdocs_Connection__c>    wdcListAll = [select id, Access_Token__c, Application_Id__c, Site_Name__c, Redirect_Url__c,WD_Org_Id__c, State__c, user__c from Workdocs_Connection__c where State__c != null order by createddate asc limit 1];
       //list<Workdocs_Connection__c>   wdcListUser = [select id, Access_Token__c, Application_Id__c, Site_Name__c, Redirect_Url__c,WD_Org_Id__c, State__c, user__c  from Workdocs_Connection__c where State__c != null and User__c = :userinfo.getuserid() order by createddate asc limit 1];
        
        
        ApexPages.currentPage().getParameters().put('id',jb1.Id);
        Apexpages.currentPage().getParameters().put('WdDocumentId','1234123412341234123412341231412');
        Apexpages.currentPage().getParameters().put('SubFolderId','1234123412341234123412341231412');

        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
       WorkdocsSectionInJobDetailPageController aa=new WorkdocsSectionInJobDetailPageController();  
         aa.deleteWorkDoc();
         aa.createWorkDocsFolder();
         aa.SubFolderPopUpAction();
         aa.CreateSubFolder();
         aa.SubFolderPopUpActionClose();
        aa.deltesubFolderContent();
         WorkdocsSectionInJobDetailPageController.doUploadAttachment(at1.Name,'Work Document',at1.ContentType,jb1.Workdocs_Folder_Id__c);
       test.stopTest();
    }
    
    @isTest static void testCallout1Campaign() {
        // Set mock callout class 
 
        Campaign__c cmp1=[select id,name,Workdocs_Folder_Id__c from Campaign__c Where name='C001' limit 1];
        Attachment cat1=[select id,Name,ContentType,Body from Attachment limit 1];
        
       //list<Workdocs_Connection__c>    wdcListAll = [select id, Access_Token__c, Application_Id__c, Site_Name__c, Redirect_Url__c,WD_Org_Id__c, State__c, user__c from Workdocs_Connection__c where State__c != null order by createddate asc limit 1];
       //list<Workdocs_Connection__c>   wdcListUser = [select id, Access_Token__c, Application_Id__c, Site_Name__c, Redirect_Url__c,WD_Org_Id__c, State__c, user__c  from Workdocs_Connection__c where State__c != null and User__c = :userinfo.getuserid() order by createddate asc limit 1];
        
        
        ApexPages.currentPage().getParameters().put('id',cmp1.Id);
        Apexpages.currentPage().getParameters().put('WdDocumentId','1234123412341234123412341231412');
        Apexpages.currentPage().getParameters().put('SubFolderId','1234123412341234123412341231412');

        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
       WorkdocsSectionInCampaignDetailPageCon aaC=new WorkdocsSectionInCampaignDetailPageCon();  
         aaC.deleteWorkDoc();
         aaC.createWorkDocsFolder();
         aaC.SubFolderPopUpAction();
         aaC.CreateSubFolder();
         aaC.SubFolderPopUpActionClose();
        aaC.deltesubFolderContent();
         WorkdocsSectionInCampaignDetailPageCon.doUploadAttachment(cat1.Name,'Campaign Work Document',cat1.ContentType,cmp1.Workdocs_Folder_Id__c);
       test.stopTest();
    }
    
    
    
    @istest static void testCallout2(){
        
    // list<Workdocs_Connection__c>   wdcListAll = [select id, Access_Token__c, Application_Id__c, Site_Name__c, Redirect_Url__c,WD_Org_Id__c, State__c, user__c from Workdocs_Connection__c where State__c != null order by createddate asc limit 1];
     //list<Workdocs_Connection__c>   wdcListUser = [select id, Access_Token__c, Application_Id__c, Site_Name__c, Redirect_Url__c,WD_Org_Id__c, State__c, user__c  from Workdocs_Connection__c where State__c != null and User__c = :userinfo.getuserid() order by createddate asc limit 1];
           
         Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
         ApexPages.currentPage().getParameters().put('region','us-west-2');
         Apexpages.currentPage().getParameters().put('auth_code','123412341234123412341234');
         WorcDocsController wdc=new WorcDocsController();
            pagereference p311=wdc.connect();
            pagereference p322=wdc.save();
        
         test.stopTest();
    }
    
      @isTest static void testCallout3() {   
          
     list<Workdocs_Connection__c>    wdcListAll = [select id, Access_Token__c, Application_Id__c, Site_Name__c, Redirect_Url__c,WD_Org_Id__c, State__c, user__c from Workdocs_Connection__c where State__c != null order by createddate asc limit 1];
     list<Workdocs_Connection__c>   wdcListUser = [select id, Access_Token__c, Application_Id__c, Site_Name__c, Redirect_Url__c,WD_Org_Id__c, State__c, user__c  from Workdocs_Connection__c where State__c != null and User__c = :userinfo.getuserid() order by createddate asc limit 1];
        
         Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
              
        workdocsSetupPageController wsetup=new workdocsSetupPageController();
        pagereference p2=wsetup.SaveSettings(); 
        delete wdcListUser;
        workdocsSetupPageController wsetup1=new workdocsSetupPageController();
        Test.stopTest();
      }
}