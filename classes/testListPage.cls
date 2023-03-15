public class testListPage {
    public String keyPrefix {get;set;}
    public testListPage (){
        Schema.DescribeSObjectResult r = Job__c.sObjectType.getDescribe();
        keyPrefix = URL.getSalesforceBaseUrl().toExternalForm();
    }

}