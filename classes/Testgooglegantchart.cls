@isTest
public class Testgooglegantchart {
	static TestMethod void Testgooglegantchart  (){
        Job__c testJob1=new Job__c(Name='Job858',Start_Date__c=System.Today());
        insert testJob1;
      //  googlegantchart controller = new googlegantchart (new ApexPages.StandardController(testJob1));
       
      googlegantchart.loadrecords(testJob1.id);
    }
    
}