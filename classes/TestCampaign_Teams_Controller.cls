@isTest
public class TestCampaign_Teams_Controller {
    
    @testSetup public static void SetupData(){
        
        Staff__c testStaff1=new Staff__c(First_Name__c='Manikanta',Last_Name__c='Kurella',Role__c='Designer',Email__c='mani@test.com',UserName__c='mani@test.com');
        insert testStaff1;
        
        Vendor__c testVendor=new Vendor__c(Name='Test Vendor9901',Email__c='abc@gmail.com',Zip__c='12345');
        insert testVendor;
        
        Vendor_Contact__c testVC=new Vendor_Contact__c(Vendor__c=testVendor.Id,First_Name__c='Harinath',Last_Name__c='Sri',Email__c='Hari@test.com');
        insert testVC;
        
        Client__c TestClnt=new Client__c(Name='Test Cllient',Active__c=true);
        insert TestClnt;
        
        Client_Contact__c testCC = new Client_Contact__c(First_Name__c='Sunil', Last_Name__c='Khanna', Name='Sunil Khanna', Client__c=TestClnt.id, Email__c='Sunil@test.com');     
        insert testCC;
        
        Campaign__c testCampaign1=new Campaign__c(Name='C1232',Active__c=True,Status__c='Active',Budgeted_Cost__c=5000,Actual_Cost__c=6000);
        insert testCampaign1;
        
        Campaign_Template__c CampTemp=new Campaign_Template__c(Name='testCampTemp');
        insert CampTemp;
        
        Campaign_Team__c testCampteam=new Campaign_Team__c(staff__c='Manikanta Kurella', Role__c='Designer', email__c='mani@test.com', Campaign_Template__c=CampTemp.id);
        insert testCampteam;
        
        Campaign_Team__c testCampteam1 = new Campaign_Team__c(staff__c='Harinath Sri', Role__c='Designer', email__c='Hari@test.com',Campaign_Template__c=CampTemp.id);
        insert testCampteam1;
        
        Campaign_Team__c testCampteam2 = new Campaign_Team__c(staff__c='Sunil Khanna', Role__c='Project Manager', email__c='Sunil@test.com',Campaign_Template__c=CampTemp.id);
        insert testCampteam2;
        
        Campaign_Team__c testCampteam3 = new Campaign_Team__c(staff__c='Steve', Role__c='Project Manager', email__c='Steve@test.com',Campaign_Template__c=CampTemp.id);
        insert testCampteam3;
        
    }
    
    @isTest static void TestCampaign_Teams_Controller1(){
        test.startTest();
        Campaign_Template__c testCampTemp=[select id,name from Campaign_Template__c where name='testCampTemp'];
        String selectedStaff='[{"selection":true,"staff":{"Staff__c":"Manikanta","Role__c":"Designer","Email__c":"mani@test.com"}},{"selection":false,"staff":{"Staff__c":"Harinath","Role__c":"Designer","Email__c":"Hari@test.com"}},{"selection":false,"staff":{"Staff__c":"Sunil Khanna","Role__c":"Project Manager","Email__c":"Sunil@test.com"}}]';
        Campaign_Teams_Controller.getTeamPhotos(testCampTemp.id);
        Campaign_Teams_Controller.AddstafftoJobTeam(testCampTemp.id,selectedStaff);
        Campaign_Teams_Controller.JobTeamAddEditStaffCont(testCampTemp.id);
        Campaign_Teams_Controller.SerachStaffforCampaignTeam(testCampTemp.id,'All');
        test.stoptest();
    }
    
     @isTest static void TestCampaign_Teams_Controller2(){
        test.startTest();
        Campaign_Template__c testCampTemp=[select id,name from Campaign_Template__c where name='testCampTemp'];
        String selectedStaff='[{"selection":true,"staff":{"Staff__c":"Manikanta","Role__c":"Designer","Email__c":"mani@test.com"}},{"selection":false,"staff":{"Staff__c":"Harinath","Role__c":"Designer","Email__c":"Hari@test.com"}},{"selection":false,"staff":{"Staff__c":"Sunil Khanna","Role__c":"Project Manager","Email__c":"Sunil@test.com"}}]';
        Campaign_Teams_Controller.SerachStaffforCampaignTeam(testCampTemp.id,'Staff');
        test.stoptest();
    }
    
    @isTest static void TestCampaign_Teams_Controller3(){
        test.startTest();
        Campaign_Template__c testCampTemp=[select id,name from Campaign_Template__c where name='testCampTemp'];
        String selectedStaff='[{"selection":true,"staff":{"Staff__c":"Manikanta","Role__c":"Designer","Email__c":"mani@test.com"}},{"selection":false,"staff":{"Staff__c":"Harinath","Role__c":"Designer","Email__c":"Hari@test.com"}},{"selection":false,"staff":{"Staff__c":"Sunil Khanna","Role__c":"Project Manager","Email__c":"Sunil@test.com"}}]';
        Campaign_Teams_Controller.SerachStaffforCampaignTeam(testCampTemp.id,'Vendor Contact');
        test.stoptest();
    }
    
}