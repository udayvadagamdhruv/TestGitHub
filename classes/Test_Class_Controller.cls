public class Test_Class_Controller{
    public Graphics_Deliverables__c obj{get;set;}

    public Test_Class_Controller(ApexPages.StandardController sc)
    {
        this.obj = (Graphics_Deliverables__c)sc.getRecord(); 
        //obj = sc.getRecord();
    }

    //Alternatively, if there is no extra logic in customSave, you could remove this, and call
    //The StandardController's save method instead.
    public PageReference save(){
        upsert obj Id;
        return null;
    }
}